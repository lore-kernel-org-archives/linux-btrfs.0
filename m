Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:31626 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751156AbdJKCIb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 22:08:31 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id A69EEAC0116
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 11:08:23 +0900 (JST)
Subject: Re: [PATCH] btrfs-progs: doc: update help/document of btrfs device
 remove
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <ea8188b9-539c-cf62-3201-25521ea45386@jp.fujitsu.com>
 <87bmleaeai.wl-satoru.takeuchi@gmail.com>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <6630e922-6409-c1a2-5e0a-0d3c0fcc6f76@jp.fujitsu.com>
Date: Wed, 11 Oct 2017 11:07:55 +0900
MIME-Version: 1.0
In-Reply-To: <87bmleaeai.wl-satoru.takeuchi@gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017/10/11 6:22, Satoru Takeuchi wrote:
> At Tue, 3 Oct 2017 17:12:39 +0900,
> Misono, Tomohiro wrote:
>>
>> This patch updates help/document of "btrfs device remove" in two points:
>>
>> 1. Add explanation of 'missing' for 'device remove'. This is only
>> written in wikipage currently.
>> (https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices)
>>
>> 2. Add example of device removal in the man document. This is because
>> that explanation of "remove" says "See the example section below", but
>> there is no example of removal currently.
>>
>> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
>> ---
>>  Documentation/btrfs-device.asciidoc | 19 +++++++++++++++++++
>>  cmds-device.c                       | 10 +++++++++-
>>  2 files changed, 28 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/btrfs-device.asciidoc b/Documentation/btrfs-device.asciidoc
>> index 88822ec..dc523a9 100644
>> --- a/Documentation/btrfs-device.asciidoc
>> +++ b/Documentation/btrfs-device.asciidoc
>> @@ -75,6 +75,10 @@ The operation can take long as it needs to move all data from the device.
>>  It is possible to delete the device that was used to mount the filesystem. The
>>  device entry in mount table will be replaced by another device name with the
>>  lowest device id.
>> ++
>> +If device is mounted as degraded mode (-o degraded), special term "missing"
>> +can be used for <device>. In that case, the first device that is described by
>> +the filesystem metadata, but not presented at the mount time will be removed.
>>  
>>  *delete* <device>|<devid> [<device>|<devid>...] <path>::
>>  Alias of remove kept for backward compatibility
>> @@ -206,6 +210,21 @@ data or the block groups occupy the whole first device.
>>  The device size of '/dev/sdb' as seen by the filesystem remains unchanged, but
>>  the logical space from 50-100GiB will be unused.
>>  
>> +==== REMOVE DEVICE ====
> 
> It's a part of "TYPICAL USECASES" section. So it's also necessary to modify
> the following sentence
> 
> ===
> See the example section below.
> ===
> 
> to as follow.
> 
> ===
> See the *TYPICAL USECASES* section below.
> ===
> 
> Or just removing the above mentioned sentence is also OK since there is
> "See the section *TYPICAL USECASES* for some examples." in "DEVICE MANAGEMENT"
> section.
> 
>> +
>> +Device removal must satisfy the profile constraints, otherwise the command
>> +fails. For example:
>> +
>> + $ btrfs device remove /dev/sda /mnt
>> + $ ERROR: error removing device '/dev/sda': unable to go below two devices on raid1
> 
> s/^$  ERROR/ERROR/
> 
>> +
>> +
>> +In order to remove a device, you need to convert profile in this case:
>> +
>> + $ btrfs balance start -mconvert=dup /mnt
>> + $ btrfs balance start -dconvert=single /mnt
> 
> It's simpler to convert both the RAID configuration of data and metadata
> by the following one command.
> 
> $ btrfs balance -mconvert=dup -dconvert=single /mnt
> 
>> + $ btrfs device remove /dev/sda /mnt
>> +
>>  DEVICE STATS
>>  ------------
>>  
>> diff --git a/cmds-device.c b/cmds-device.c
>> index 4337eb2..6cb53ff 100644
>> --- a/cmds-device.c
>> +++ b/cmds-device.c
>> @@ -224,9 +224,16 @@ static int _cmd_device_remove(int argc, char **argv,
>>  	return !!ret;
>>  }
>>  
>> +#define COMMON_USAGE_REMOVE_DELETE \
>> +	"", \
>> +	"If 'missing' is specified for <device>, the first device that is", \
>> +	"described by the filesystem metadata, but not presented at the", \
>> +	"mount time will be removed."
>> +
>>  static const char * const cmd_device_remove_usage[] = {
>>  	"btrfs device remove <device>|<devid> [<device>|<devid>...] <path>",
>>  	"Remove a device from a filesystem",
>> +	COMMON_USAGE_REMOVE_DELETE,
>>  	NULL
>>  };
>>  
>> @@ -237,7 +244,8 @@ static int cmd_device_remove(int argc, char **argv)
>>  
>>  static const char * const cmd_device_delete_usage[] = {
>>  	"btrfs device delete <device>|<devid> [<device>|<devid>...] <path>",
>> -	"Remove a device from a filesystem",
>> +	"Remove a device from a filesystem (alias of \"btrfs device remove\")",
>> +	COMMON_USAGE_REMOVE_DELETE,
>>  	NULL
>>  };
> 
> This snippet is not related to the description of this patch.
> Dividing this patch is better.
> 
> Thanks,
> Satoru

Thanks for the review and I will follow the advice.
I think there should be 'missing-all' too to remove all the missing devices,
and will send the patches again.

Regards,
Tomohiro

> 
>>  
>> -- 
>> 2.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

