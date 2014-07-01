Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17119 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755515AbaGAIde (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 04:33:34 -0400
Message-ID: <53B2715C.5070708@cn.fujitsu.com>
Date: Tue, 1 Jul 2014 16:29:16 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <sandeen@redhat.com>, <rm@romanrm.net>,
        <koen@dominion.thruhere.net>
Subject: Re: [PATCH v6] btrfs: label should not contain return char
References: <1400519071-5580-1-git-send-email-anand.jain@oracle.com> <1400813402-27474-1-git-send-email-anand.jain@oracle.com> <53B245AA.6060209@jp.fujitsu.com> <53B25931.2030200@cn.fujitsu.com> <53B26A87.4080800@jp.fujitsu.com>
In-Reply-To: <53B26A87.4080800@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Satoru,

On 07/01/2014 04:00 PM, Satoru Takeuchi wrote:
> Hi Wang,
>
> (2014/07/01 15:46), Wang Shilong wrote:
>> Hi Satoru and all,
>>
>> I think there maybe a leftover issue.
>> That is if we don't set label, in default it will output a blank line.
>>
>> Steps to reproduce:
>>
>> # mkfs.btrfs -f /dev/sdb
>> # mount /dev/sdb
>> # cat /sys/fs/btrfs/<uuid>/label -->an extra line will be outputed.
>>
>> This is because in btrfs_label_show(), we did something like this directly:
>>
>> return snprintf(buf, PAGE_SIZE, "%s\n", fs_info->super_copy->label);
>>
>> Maybe we can have a check whether label is NULL before we output?
>> otherwise,the
>> extra blank line is outputed, IMO this is not so nice thing!
> OK, how about it is? I also add a test for empty-label case.
>
>
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
> echo "Test for empty label..." >&2
> LINES="$(cat $LABELFILE | wc -l | awk '{print $1}')"
> RET=0
>
> if [ $LINES -eq 0 ] ; then
>     echo '[PASS] Trailing \n is removed correctly.' >&2
> else
>     echo '[FAIL] Trailing \n still exists.' >&2
>     RET=1
> fi
>
> echo "Test for non-empty label..." >&2
>
> echo testlabel >$LABELFILE
> LINES="$(cat $LABELFILE | wc -l | awk '{print $1}')"
>
> if [ $LINES -eq 1 ] ; then
>     echo '[PASS] Trailing \n is removed correctly.' >&2
> else
>     echo '[FAIL] Trailing \n still exists.' >&2
>     RET=1
> fi
>
> exit $RET 
> ===============================================================================
>
> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> Tested-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Thanks for pushing this patch, Now it Looks good to me.

Reviewed-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>


> ---
>  v6: fix empty-label case
>  v5: tweak to be able to apply on the top of 402a0f4.
>      add test program.
>  v4: used memcpy and memset. Thanks David again
>  v3: accepts review comments. Thanks David and Eric again
>  v2: accepts review comments. Thanks Eric and Roman
> ---
>  fs/btrfs/sysfs.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index df39458..68d1f63 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -363,7 +363,8 @@ static ssize_t btrfs_label_show(struct kobject *kobj,
>  				struct kobj_attribute *a, char *buf)
>  {
>  	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
> -	return snprintf(buf, PAGE_SIZE, "%s\n", fs_info->super_copy->label);
> +	char *label = fs_info->super_copy->label;
> +	return snprintf(buf, PAGE_SIZE, label[0] ? "%s\n" : "%s", label);
>  }
>  
>  static ssize_t btrfs_label_store(struct kobject *kobj,
> @@ -374,8 +375,15 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
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
> @@ -383,7 +391,8 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
>  		return PTR_ERR(trans);
>  
>  	spin_lock(&root->fs_info->super_lock);
> -	strcpy(fs_info->super_copy->label, buf);
> +	memset(fs_info->super_copy->label, 0, BTRFS_LABEL_SIZE);
> +	memcpy(fs_info->super_copy->label, buf, p_len);
>  	spin_unlock(&root->fs_info->super_lock);
>  	ret = btrfs_commit_transaction(trans, root);
>  

