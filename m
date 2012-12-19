Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22913 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab2LSDmb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 22:42:31 -0500
Message-ID: <50D13797.10900@oracle.com>
Date: Wed, 19 Dec 2012 11:42:15 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: kreijack@inwind.it
CC: Goffredo Baroncelli <kreijack@gmail.com>, miaox@cn.fujitsu.com,
        linux-btrfs@vger.kernel.org, anand.jain@oracle.com
Subject: Re: [RFC PATCH V6 2/2] Btrfs: Add a new ioctl to change the label
 of a mounted file system
In-Reply-To: <50D0AF50.3090503@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <50CFDD9F.2080706@oracle.com>
 <50CFE3AC.9000705@cn.fujitsu.com>
 <50D0AF50.3090503@gmail.com>

Hi Goffredo,

Thanks for your review.

On 12/19/2012 02:00 AM, Goffredo Baroncelli wrote:
> Hi Jeff,
> 
> On 12/18/2012 04:31 AM, Miao Xie wrote:
> [...]
>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> [...]
> 
>>> +static int btrfs_ioctl_set_fslabel(struct file *file, void __user *arg)
>>> +{
>>> +	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
>>> +	struct btrfs_super_block *super_block = root->fs_info->super_copy;
>>> +	struct btrfs_trans_handle *trans;
>>> +	char label[BTRFS_LABEL_SIZE];
>>> +	int ret;
>>> +
>>> +	if (!capable(CAP_SYS_ADMIN))
>>> +		return -EPERM;
>>> +
>>> +	if (copy_from_user(label, arg, sizeof(label)))
>>> +		return -EFAULT;
>>> +
>>> +	if (strnlen(label, BTRFS_LABEL_SIZE) == BTRFS_LABEL_SIZE)
>>> +		return -EINVAL;
>>> +
>>> +	ret = mnt_want_write_file(file);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	mutex_lock(&root->fs_info->volume_mutex);
>>> +	trans = btrfs_start_transaction(root, 1);
>>> +	if (IS_ERR(trans)) {
>>> +		ret = PTR_ERR(trans);
>>> +		goto out_unlock;
>>> +	}
>>> +
>>> +	strcpy(super_block->label, label);
> 
> I think that you removed for mistake the following line
> 
> +	label[BTRFS_LABEL_SIZE - 1] = '\0';
I removed it since it was used to cut the label string off the max array
size but now we have the previous strnlen().
> 
> In the V5 patch it was present.
> 
> May be we could replace strcpy() with strlcpy(super_block->label, label,
> BTRFS_LABEL_SIZE-1) ?
That is ok to me. However, it should be strlcpy(super_block->label,
label, BTRFS_LABEL_SIZE) ranther than 'BTRFS_LABREL_SIZE -1' because
strlcpy() does "size - 1" internally. i.e.

strlcpy(char *d, const char *s, size_t size)
{	
	size_t ret = strlen(s);

	.....
	size_t len = (ret >= size) ? size - 1 : ret;
	....
}

But does the current implementation make anything wrong? :)

Thanks,
-Jeff
> 
> BR
> G.Baroncelli
> 

