Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21802 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751956AbaGAGu1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 02:50:27 -0400
Message-ID: <53B25931.2030200@cn.fujitsu.com>
Date: Tue, 1 Jul 2014 14:46:09 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <sandeen@redhat.com>, <rm@romanrm.net>,
        <koen@dominion.thruhere.net>
Subject: Re: [PATCH v5] btrfs: label should not contain return char
References: <1400519071-5580-1-git-send-email-anand.jain@oracle.com> <1400813402-27474-1-git-send-email-anand.jain@oracle.com> <53B245AA.6060209@jp.fujitsu.com>
In-Reply-To: <53B245AA.6060209@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Satoru and all,

I think there maybe a leftover issue.
That is if we don't set label, in default it will output a blank line.

Steps to reproduce:

# mkfs.btrfs -f /dev/sdb
# mount /dev/sdb
# cat /sys/fs/btrfs/<uuid>/label -->an extra line will be outputed.

This is because in btrfs_label_show(), we did something like this directly:

return snprintf(buf, PAGE_SIZE, "%s\n", fs_info->super_copy->label);

Maybe we can have a check whether label is NULL before we output?
otherwise,the
extra blank line is outputed, IMO this is not so nice thing!

Thanks,
Wang

On 07/01/2014 01:22 PM, Satoru Takeuchi wrote:
> Although Anand once sent the following two patches,
>
>  - [PATCH 1/2 v4] btrfs: label should not contain return char
>  - [PATCH 2/2 v4] btrfs: usage error should not be logged into system log
>
> only the latter patch was merged to mason/for-linus and 3.16-rc3
> as 402a0f4 (by accident?). It results in that the former patch can't
> be cleanly applied to 3.16-rc3.
>
> I fixed this problem, wrote a reproducer, and tested it.
>
> Test Result:
> 3.16-rc3 w/o this patch: fail
> 3.16-rc3 w/ this patch:  pass
>
>
>
> Subject: [PATCH v5] btrfs: label should not contain return char
>
> From: Anand Jain <Anand.Jain@oracle.com>
>
> generally if you use
>   echo "test" > /sys/fs/btrfs/<fsid>/label
> it would introduce return char at the end and it can not
> be part of the label. The correct command is
>   echo -n "test" > /sys/fs/btrfs/<fsid>/label
>
> This patch will check for this user error
>
> reproducer.sh:
> ===============================================================================
> #!/bin/bash
>
> TEST_DEV=/dev/vdb
> TEST_DIR=/home/sat/mnt
>
> umount /home/sat/mnt
>
> mkfs.btrfs -f $TEST_DEV
> UUID=$(btrfs fi show $TEST_DEV | head -1 | sed -e 's/.*uuid: \([-0-9a-z]*\)$/\1/')
> mount $TEST_DEV $TEST_DIR
> LABELFILE=/sys/fs/btrfs/$UUID/label
>
> echo testlabel >$LABELFILE
> LINES="$(cat $LABELFILE | wc -l | awk '{print $1}')"
>
> RET=1
> if [ $LINES -eq 1 ] ; then
>     echo '[PASS] Trailing \n is removed correctly.' >&2
>     RET=0
> else
>     echo '[FAIL] Trailing \n still exists.' >&2
> fi
>
> exit $RET
> ===============================================================================
>
> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> Tested-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> ---
>  v5: tweak to be able to apply on the top of 402a0f4.
>      add test program.
>  v4: used memcpy and memset. Thanks David again
>  v3: accepts review comments. Thanks David and Eric again
>  v2: accepts review comments. Thanks Eric and Roman
>
> ---
>  fs/btrfs/sysfs.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index df39458..dcae61a 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -374,8 +374,15 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
>  	struct btrfs_trans_handle *trans;
>  	struct btrfs_root *root = fs_info->fs_root;
>  	int ret;
> +	size_t p_len;
>  
> -	if (len >= BTRFS_LABEL_SIZE)
> +	/*
> +	 * p_len is the len until the first occurrence of either
> +	 * '\n' or '\0'
> +	 */
> +	p_len = strcspn(buf, "\n");
> +
> +	if (p_len >= BTRFS_LABEL_SIZE)
>  		return -EINVAL;
>  
>  	trans = btrfs_start_transaction(root, 0);
> @@ -383,7 +390,8 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
>  		return PTR_ERR(trans);
>  
>  	spin_lock(&root->fs_info->super_lock);
> -	strcpy(fs_info->super_copy->label, buf);
> +	memset(fs_info->super_copy->label, 0, BTRFS_LABEL_SIZE);
> +	memcpy(fs_info->super_copy->label, buf, p_len);
>  	spin_unlock(&root->fs_info->super_lock);
>  	ret = btrfs_commit_transaction(trans, root);
>  

