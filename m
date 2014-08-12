Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59294 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaHLCZN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 22:25:13 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 4436B3EE0ED
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 11:25:11 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 484ABAC0508
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 11:25:10 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id ED0B71DB803B
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 11:25:09 +0900 (JST)
Message-ID: <53E97AFC.4060404@jp.fujitsu.com>
Date: Tue, 12 Aug 2014 11:25:00 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>, Liu Bo <bo.li.liu@oracle.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix regression of btrfs device replace
References: <1406632179-17747-1-git-send-email-bo.li.liu@oracle.com> <27C52EC9-CF6E-4FB7-9504-316A25D45DFB@colorremedies.com>
In-Reply-To: <27C52EC9-CF6E-4FB7-9504-316A25D45DFB@colorremedies.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu,

(2014/08/12 6:41), Chris Murphy wrote:
>
> On Jul 29, 2014, at 5:09 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>
>> Commit 49c6f736f34f901117c20960ebd7d5e60f12fcac(
>> btrfs: dev replace should replace the sysfs entry) added the missing sysfs entry
>> in the process of device replace, but didn't take missing devices into account,
>> so now we have
>>
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000088
>> IP: [<ffffffffa0268551>] btrfs_kobj_rm_device+0x21/0x40 [btrfs]
>> ...
>>
>> To reproduce it,
>> 1. mkfs.btrfs -f disk1 disk2
>> 2. mkfs.ext4 disk1
>> 3. mount disk2 /mnt -odegraded
>> 4. btrfs replace start -B 1 disk3 /mnt
>> --------------------------
>>
>> This fixes the problem.
>>
>> Reported-by: Chris Murphy <lists@colorremedies.com>
>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>> ---
>> fs/btrfs/sysfs.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
>> index 7869936..12e5355 100644
>> --- a/fs/btrfs/sysfs.c
>> +++ b/fs/btrfs/sysfs.c
>> @@ -614,7 +614,7 @@ int btrfs_kobj_rm_device(struct btrfs_fs_info *fs_info,
>> 	if (!fs_info->device_dir_kobj)
>> 		return -EINVAL;
>>
>> -	if (one_device) {
>> +	if (one_device && one_device->bdev) {
>> 		disk = one_device->bdev->bd_part;
>> 		disk_kobj = &part_to_dev(disk)->kobj;
>>
>
>
> Applied to 3.16.0 and tested, problem is fixed.
>
>
> Chris Murphy

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Tested-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

I confirmed both

  - This problem happens with 3.16, and
  - This problem doesn't happen with 3.16 + your patch.

Thanks,
Satoru

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

