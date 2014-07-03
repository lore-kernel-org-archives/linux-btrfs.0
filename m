Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35002 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753153AbaGCAXP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 20:23:15 -0400
Message-ID: <53B4A2AD.2010506@cn.fujitsu.com>
Date: Thu, 3 Jul 2014 08:24:13 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs: fix nossd and ssd_spread mount option regression
References: <1404274747-20036-1-git-send-email-quwenruo@cn.fujitsu.com> <53B42F8B.8090600@redhat.com>
In-Reply-To: <53B42F8B.8090600@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH v2] btrfs: fix nossd and ssd_spread mount option 
regression
From: Eric Sandeen <sandeen@redhat.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Date: 2014年07月03日 00:12
> On 7/1/14, 11:19 PM, Qu Wenruo wrote:
>> From: Eric Sandeen <sandeen@redhat.com>
>>
>> The commit
>>
>> 0780253 btrfs: Cleanup the btrfs_parse_options for remount.
>>
>> broke ssd options quite badly; it stopped making ssd_spread
>> imply ssd, and it made "nossd" unsettable.
>>
>> Put things back at least as well as they were before
>> (though ssd mount option handling is still pretty odd:
>>
>> Reported-by: Roman Mamedov <rm@romanrm.net>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>> v2(By Qu):
>>    Make nossd disable ssd and ssd_spread.
>>    Add notes in Documentation/btrfs.txt
> Ok, thanks for fixing up a little bit more.
>
> But option handling is still strange even with your changes:
>
> # mount -o ssd /dev/sdc3 /mnt/test; grep sdc3 /proc/mounts
> /dev/sdc3 /mnt/test btrfs rw,seclabel,relatime,ssd,space_cache 0 0
>
> # mount -o remount,nossd /dev/sdc3 /mnt/test; grep sdc3 /proc/mounts
> /dev/sdc3 /mnt/test btrfs rw,seclabel,relatime,nossd,space_cache 0 0
>
> # mount -o remount,ssd_spread /dev/sdc3 /mnt/test; grep sdc3 /proc/mounts
> /dev/sdc3 /mnt/test btrfs rw,seclabel,relatime,nossd,ssd_spread,space_cache 0 0
>
> # mount -o remount,ssd /dev/sdc3 /mnt/test; grep sdc3 /proc/mounts
> /dev/sdc3 /mnt/test btrfs rw,seclabel,relatime,nossd,ssd_spread,space_cache 0 0
>
> I'd rather just commit my first patch to fix the regression ASAP, and
> fix the ssd option mess with a second patch which has received careful testing.
>
> -Eric
OK, please merge the v1 patch only.
I'll fix the ssd dependency things later.
>
>> ---
>>   Documentation/filesystems/btrfs.txt | 3 +++
>>   fs/btrfs/super.c                    | 4 +++-
>>   2 files changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
>> index d11cc2f..f7d0878 100644
>> --- a/Documentation/filesystems/btrfs.txt
>> +++ b/Documentation/filesystems/btrfs.txt
>> @@ -201,6 +201,9 @@ Options with (*) are default options and will not show in the mount options.
>>   	of unused space, and may perform better on low-end ssds.  ssd_spread
>>   	implies ssd, enabling all other ssd heuristics as well.
>>   
>> +	Option nossd removes all ssd allocation heuristics, disabling
>> +	ssd_spread or ssd mount option.
>> +
>>     subvol=<path>
>>   	Mount subvolume at <path> rather than the root subvolume.  <path> is
>>   	relative to the top level subvolume.
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 4662d92..cfe377a 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -522,10 +522,12 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>>   		case Opt_ssd_spread:
>>   			btrfs_set_and_info(root, SSD_SPREAD,
>>   					   "use spread ssd allocation scheme");
>> +			btrfs_set_opt(info->mount_opt, SSD);
>>   			break;
>>   		case Opt_nossd:
>> -			btrfs_clear_and_info(root, NOSSD,
>> +			btrfs_set_and_info(root, NOSSD,
>>   					     "not using ssd allocation scheme");
>> +			btrfs_clear_opt(info->mount_opt, SSD_SPREAD);
>>   			btrfs_clear_opt(info->mount_opt, SSD);
>>   			break;
>>   		case Opt_barrier:
>>

