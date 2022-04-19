locals{
    ec2_list = flatten([
        for i in var.instance: [
            for a in var.alarm_configs_ec2: {
                evaluation_periods = a.evaluation_periods
                metric_name = a.metric_name
                comparison_operator = a.comparison_operator
                namespace = a.namespace
                period = a.period
                statistic = a.statistic
                threshold = a.threshold
                alarm_for = a.alarm_for
                name_suffix = a.name_suffix
                id = i.id
                key = a.key
                ip = i.ip
            }
        ]
    ])
}

 resource "aws_cloudwatch_metric_alarm" "ec2_alarm" {
     for_each                  = {for alarm in local.ec2_list: alarm.key => alarm}
     alarm_name                = "Vb-${var.project}-${each.value.name_suffix}${each.value.threshold}"
     comparison_operator       = each.value.comparison_operator
     evaluation_periods        = each.value.evaluation_periods
     metric_name               = each.value.metric_name
     namespace                 = each.value.namespace
     period                    = each.value.period
     statistic                 = each.value.statistic
     threshold                 = each.value.threshold
     #alarm_description         = "${each.value.alarm_for} instance ${each.value.id} : ${each.value.metric_name} ${each.value.threshold} or Higher"
     insufficient_data_actions = []
     alarm_actions             = []
    
     dimensions                = {       
         InstanceId = each.value.metric_name != "mem_used_percent" && each.value.metric_name != "disk_used_percent" ? "${each.value.id}" : null
         host       = each.value.metric_name == "mem_used_percent" || each.value.metric_name == "disk_used_percent" ? "ip-${replace("${each.value.ip}", ".", "-")}" : null
         path       = each.value.metric_name == "disk_used_percent" ? "/" : null
         device     = each.value.metric_name == "disk_used_percent" ? "xvda1" : null
         fstype     = each.value.metric_name == "disk_used_percent" ? "ext4" : null
     }
 }