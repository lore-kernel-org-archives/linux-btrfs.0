Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42849 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaGBHG2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 03:06:28 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id B0C7D3EE0AE
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Jul 2014 16:06:27 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id BA2A4AC0371
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Jul 2014 16:06:26 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 6B5D31DB8032
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Jul 2014 16:06:26 +0900 (JST)
Message-ID: <53B3AF67.9080906@jp.fujitsu.com>
Date: Wed, 2 Jul 2014 16:06:15 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>, <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: Re: [PATCH 1/2 v2] btrfs: device add must be sysloged
References: <1404147537-19873-1-git-send-email-Anand.Jain@oracle.com> <1404265052-29424-1-git-send-email-Anand.Jain@oracle.com> <53B3AE6F.4070009@jp.fujitsu.com>
In-Reply-To: <53B3AE6F.4070009@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/07/02 16:02), Satoru Takeuchi wrote:
> (2014/07/02 10:37), Anand Jain wrote:
>> when we add a new disk to the mounted btrfs we don't record it
>> as of now, disk add is a critical change of btrfs configuration,
>> it must be recorded in the syslog to help offline investigations
>> of customer problems when reported.
>>
>> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
>> Reviewed-by: David Sterba <dsterba@suse.cz>
> 
> Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> Tested-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> test result:
>    3.16-rc3: failed
>    3.16-rc3 with this patch: success

Please let me correct.

> 
> ===============================================================================
> #!/bin/sh
> 
> TEST_DEV1=/dev/vdb
> TEST_DEV2=/dev/vdc
> TEST_MNT=/home/sat/mnt
> 
> umount $TEST_MNT
> mkfs.btrfs -f $TEST_DEV1
> dmesg >dmesg.old
> 
> mount $TEST_DEV1 $TEST_MNT
> btrfs dev add -f $TEST_DEV2 $TEST_MNT
> if [ $? -ne 0 ] ; then
>      echo "[ERROR] failed to btrfs dev add." >&2
>      exit 1
> fi
> 
> btrfs dev del $TEST_DEV2 $TEST_MNT
> if [ $? -ne 0 ] ; then
>      echo "[ERROR] failed to btrfs dev delete" >&2
>      exit 1
> fi
> 
> dmesg >dmesg.new
> diff dmesg.old dmesg.new | grep '^>' >dmesg.diff
> 
> RET=0
> TEST_DEV1_BASE=$(basename $TEST_DEV1)
> if grep -q "BTRFS info (device $TEST_DEV1_BASE): device added $TEST_DEV2" dmesg.diff ; then
>      echo "[PASS] btrfs device add is logged." >&2
> else
>      echo "[FAIL] btrfs device add is not logged." >&2
>      RET=1
> fi

[PASS] here,

>      
> if grep -q "BTRFS info (device $TEST_DEV1_BASE): device deleted $TEST_DEV2" dmesg.diff ; then
>      echo "[PASS] btrfs device delete is logged." >&2
> else
>      echo "[FAIL] btrfs device delete is not logged." >&2
>      RET=1
> fi

And [FAIL] here since 2/2 is not applied yet at this test.

Thanks,
Satoru

> 
> rm dmesg.{new,old,diff}
> umount $TEST_MNT
> 
> exit $RET
> ===============================================================================
> 
> Thanks,
> Satoru
> 
>> ---
>>    v2: Accepts David's review comment, thanks
>>
>>    fs/btrfs/ioctl.c | 4 ++++
>>    1 file changed, 4 insertions(+)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 86d5474..4e10259 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -2488,6 +2488,10 @@ static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
>>    	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
>>    	ret = btrfs_init_new_device(root, vol_args->name);
>>    
>> +	if (!ret)
>> +		btrfs_info(root->fs_info, "device added %s",
>> +						vol_args->name);
>> +
>>    	kfree(vol_args);
>>    out:
>>    	mutex_unlock(&root->fs_info->volume_mutex);
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

