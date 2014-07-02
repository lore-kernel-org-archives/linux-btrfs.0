Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42499 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaGBHDk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 03:03:40 -0400
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id C12E73EE0C0
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Jul 2014 16:03:38 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.nic.fujitsu.com [10.0.50.91])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id CC662AC0865
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Jul 2014 16:03:37 +0900 (JST)
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 82487E08005
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Jul 2014 16:03:37 +0900 (JST)
Message-ID: <53B3AEC0.4060407@jp.fujitsu.com>
Date: Wed, 2 Jul 2014 16:03:28 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>, <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: Re: [PATCH 2/2 v2] btrfs: device delete must be sysloged
References: <1404147537-19873-1-git-send-email-Anand.Jain@oracle.com> <1404265052-29424-1-git-send-email-Anand.Jain@oracle.com> <1404265052-29424-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1404265052-29424-2-git-send-email-Anand.Jain@oracle.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/07/02 10:37), Anand Jain wrote:
> as in the disk add patch, disk detached from the volume must be
> recorded in the syslog as well for the same reason.
> 
> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
> Reviewed-by: David Sterba <dsterba@suse.cz>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Tested-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

test result:
  3.16-rc3: failed
  3.16-rc3 with these patches: success

===============================================================================
#!/bin/sh

TEST_DEV1=/dev/vdb
TEST_DEV2=/dev/vdc
TEST_MNT=/home/sat/mnt

umount $TEST_MNT
mkfs.btrfs -f $TEST_DEV1
dmesg >dmesg.old

mount $TEST_DEV1 $TEST_MNT
btrfs dev add -f $TEST_DEV2 $TEST_MNT
if [ $? -ne 0 ] ; then
    echo "[ERROR] failed to btrfs dev add." >&2
    exit 1
fi

btrfs dev del $TEST_DEV2 $TEST_MNT
if [ $? -ne 0 ] ; then
    echo "[ERROR] failed to btrfs dev delete" >&2
    exit 1
fi

dmesg >dmesg.new
diff dmesg.old dmesg.new | grep '^>' >dmesg.diff

RET=0
TEST_DEV1_BASE=$(basename $TEST_DEV1)
if grep -q "BTRFS info (device $TEST_DEV1_BASE): device added $TEST_DEV2" dmesg.diff ; then
    echo "[PASS] btrfs device add is logged." >&2
else
    echo "[FAIL] btrfs device add is not logged." >&2
    RET=1
fi
    
if grep -q "BTRFS info (device $TEST_DEV1_BASE): device deleted $TEST_DEV2" dmesg.diff ; then
    echo "[PASS] btrfs device delete is logged." >&2
else
    echo "[FAIL] btrfs device delete is not logged." >&2
    RET=1
fi

rm dmesg.{new,old,diff}
umount $TEST_MNT

exit $RET
===============================================================================

Thanks,
Satoru



> ---
>   v2: Accepts David's review comments, thanks
> 
>   fs/btrfs/ioctl.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 4e10259..016a5eb 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2531,6 +2531,10 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
>   	mutex_unlock(&root->fs_info->volume_mutex);
>   	atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
>   
> +	if (!ret)
> +		btrfs_info(root->fs_info, "device deleted %s",
> +							vol_args->name);
> +
>   out:
>   	kfree(vol_args);
>   	mnt_drop_write_file(file);
> 

