Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35653 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbcCQD2v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 23:28:51 -0400
Subject: Re: [PATCH v2 RESEND] btrfs: maintain consistency in logging to help
 debugging
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1457583778-4042-1-git-send-email-anand.jain@oracle.com>
 <20160316161852.GO21722@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56EA246C.3090400@oracle.com>
Date: Thu, 17 Mar 2016 11:28:44 +0800
MIME-Version: 1.0
In-Reply-To: <20160316161852.GO21722@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




On 03/17/2016 12:18 AM, David Sterba wrote:
> On Thu, Mar 10, 2016 at 12:22:58PM +0800, Anand Jain wrote:
>> Optional Label may or may not be set, or it might be set at some time
>> later. However while debugging to search through the kernel logs the
>> scripts would need the logs to be consistent, so logs search key words
>> shouldn't depend on the optional variables, instead fsid is better.
>
> I think the label is a useful information, as it's set by the user. So
> if I'm looking to the log, I'll recognize the labels, not the device or
> fsid.
>
> It would be better to show all of them, ie. label, fsid, device and
> transid. The line will get longer, but I hope it's ok.
>
> Proposed order of the fields:
> - device PATH
> - devid ID
> - fsid UUID
> - transid TID

(I am not too particular about the below but just my opinion.)

The patch titled in the ML:
   Btrfs: fix fs logging for multi device

Would prefix
   BTRFS: <fsid>:
to most of the logs in dmesg.

So I guess if we have following then
   BTRFS: <fsid>: <devid ID> (<device UUID>*) <transid> <device PATH>
is better.

For end users, I hope we provide all those requisites through
btrfs-progs cli, and they wouldn't have to review dmesg. Further,
'btrfs fi show' provides the FSID to label mapping. So I hope the
next set of targeted community, the troubleshooters will be familiar
with the FSID, and they could do

  dmesg | grep "BTRFS: <fsid>:"

To filter to get logs of one btrfs which they want to troubleshoot.
(as there may be more than one btrfs in the system).

[*] May be in future.
  (There is a bug that we might fails to know / assemble right set
  devices as per last assembled-volume and to fix this, its better
  create a new device UUID for the replace target device instead of
  copying the device UUID of source device (bit vague of now). If
  this is successful, then device UUID will be useful to printk here).

Thanks, Anand

>> -		if (disk_super->label[0]) {
>> -			printk(KERN_INFO "BTRFS: device label %s ", disk_super->label);
>> -		} else {
>> -			printk(KERN_INFO "BTRFS: device fsid %pU ", disk_super->fsid);
>> -		}
>> -
>> -		printk(KERN_CONT "devid %llu transid %llu %s\n", devid, transid, path);
>> +		printk(KERN_INFO "BTRFS: device fsid %pU devid %llu transid %llu %s\n",
>> +						disk_super->fsid, devid, transid, path);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
