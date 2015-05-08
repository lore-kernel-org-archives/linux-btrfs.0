Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47362 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbbEHIbJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 May 2015 04:31:09 -0400
Message-ID: <554C73A8.1030406@oracle.com>
Date: Fri, 08 May 2015 16:28:24 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs-progs: improve troubleshooting avoid duplicate
 error strings
References: <1428928621-8001-1-git-send-email-anand.jain@oracle.com> <20150414131444.GQ25622@twin.jikos.cz>
In-Reply-To: <20150414131444.GQ25622@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>





On 04/14/2015 09:14 PM, David Sterba wrote:
> On Mon, Apr 13, 2015 at 08:37:01PM +0800, Anand Jain wrote:
>> my troubleshooting experience says have unique error string per module.
>>
>> In the below eg, its one additional step to know error line,
>>
>> cat -n cmds-device.c | egrep "error removing the device"
>>     185	"ERROR: error removing the device '%s' - %s\n",
>>     190	"ERROR: error removing the device '%s' - %s\n",
>>
>> which is completely avoidable.
>
> It is, we can merge both branches into one.



>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   cmds-device.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/cmds-device.c b/cmds-device.c
>> index 1c72e90..1c32771 100644
>> --- a/cmds-device.c
>> +++ b/cmds-device.c
>> @@ -187,7 +187,7 @@ static int cmd_rm_dev(int argc, char **argv)
>>   			ret++;
>>   		} else if (res < 0) {
>>   			fprintf(stderr,
>> -				"ERROR: error removing the device '%s' - %s\n",
>> +				"ERROR: ioctl error removing the device '%s' - %s\n",
>
> The only difference is the strerror vs btrfs_err_str. As both ret > 0
> and ret < 0 report some kind of error, the wording would be very similar
> so I think that one error message would fit better. I'll fix that.

You means res not ret (above) ?
--------------------------------------------------------------
diff --git a/cmds-device.c b/cmds-device.c
index cbb3243..1022656 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -183,7 +183,7 @@ static int cmd_rm_dev(int argc, char **argv)
                 if (res) {
                         const char *msg;

-                       if (ret > 0)
+                       if (res > 0)
                                 msg = btrfs_err_str(res);
                         else
                                 msg = strerror(e);
--------------------------------------------------------------

Thanks, Anand


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
