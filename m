Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19441 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab2LTIT3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Dec 2012 03:19:29 -0500
Message-ID: <50D2C9D1.90408@oracle.com>
Date: Thu, 20 Dec 2012 16:18:25 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org, anand.jain@oracle.com, miaox@cn.fujitsu.com,
        Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [RFC PATCH V6 2/2] Btrfs: Add a new ioctl to change the label
 of a mounted file system
References: <50CFDD9F.2080706@oracle.com> <20121219142156.GL14116@twin.jikos.cz>
In-Reply-To: <20121219142156.GL14116@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/19/2012 10:21 PM, David Sterba wrote:
> On Tue, Dec 18, 2012 at 11:06:07AM +0800, Jeff Liu wrote:
>> +static int btrfs_ioctl_set_fslabel(struct file *file, void __user *arg)
>> +{
>> +	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
>> +	struct btrfs_super_block *super_block = root->fs_info->super_copy;
>> +	struct btrfs_trans_handle *trans;
>> +	char label[BTRFS_LABEL_SIZE];
>> +	int ret;
>> +
>> +	if (!capable(CAP_SYS_ADMIN))
>> +		return -EPERM;
>> +
>> +	if (copy_from_user(label, arg, sizeof(label)))
>> +		return -EFAULT;
>> +
>> +	if (strnlen(label, BTRFS_LABEL_SIZE) == BTRFS_LABEL_SIZE)
>> +		return -EINVAL;
>> +
>> +	ret = mnt_want_write_file(file);
>> +	if (ret)
>> +		return ret;
>> +
>> +	mutex_lock(&root->fs_info->volume_mutex);
>> +	trans = btrfs_start_transaction(root, 1);
>> +	if (IS_ERR(trans)) {
>> +		ret = PTR_ERR(trans);
>> +		goto out_unlock;
>> +	}
>> +
>> +	strcpy(super_block->label, label);
>> +	btrfs_end_transaction(trans, root);
> 
> If this fails, eg. with EIO, it will not be reported back to the user
> 
>         ret = btrfs_end_transaction(trans, root);
> 
> should fix it.
Thank you, I'll send out a revised version after a little while.

-Jeff
> 
>> +
>> +out_unlock:
>> +	mutex_unlock(&root->fs_info->volume_mutex);
>> +	mnt_drop_write_file(file);
>> +	return ret;
>> +}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

