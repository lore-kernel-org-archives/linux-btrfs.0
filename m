Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45239 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab2LaKYg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Dec 2012 05:24:36 -0500
Message-ID: <50E167AA.7000603@oracle.com>
Date: Mon, 31 Dec 2012 18:23:38 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org, anand.jain@oracle.com, miaox@cn.fujitsu.com,
        Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [RFC PATCH v8 2/2] Btrfs: Add a new ioctl to set/change the label
 of a mounted file system
References: <50DD1530.5020308@oracle.com> <20121228120333.GV14116@twin.jikos.cz>
In-Reply-To: <20121228120333.GV14116@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/28/2012 08:03 PM, David Sterba wrote:
> On Fri, Dec 28, 2012 at 11:42:40AM +0800, Jeff Liu wrote:
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
> 
> I would expect a message if this happens, similar to the 'get_fslabel'
> one, otherwise it's difficult to find out the reason.
That's sounds make sense.
> 
>> +		return -EINVAL;
>> +
>> +	ret = mnt_want_write_file(file);
>> +	if (ret)
>> +		return ret;
>> +
>> +	mutex_lock(&root->fs_info->volume_mutex);
>> +	trans = btrfs_start_transaction(root, 1);
> 
> Do we need to reserve 1 unit here? This does not touch any
> non-superblock metadata, modifies superblock in place. This could lead
> to an ENOSPC (changing label on a full fs), altghouh it need not happen.
Don't need, I can not recalled why I did that before, will fix it.

Thanks,
-Jeff
> 
>> +	if (IS_ERR(trans)) {
>> +		ret = PTR_ERR(trans);
>> +		goto out_unlock;
>> +	}
>> +
>> +	strcpy(super_block->label, label);
>> +	ret = btrfs_end_transaction(trans, root);
>> +
>> +out_unlock:
>> +	mutex_unlock(&root->fs_info->volume_mutex);
>> +	mnt_drop_write_file(file);
>> +	return ret;
>> +}

