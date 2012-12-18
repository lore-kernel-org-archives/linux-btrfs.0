Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:63530 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2LRSEf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 13:04:35 -0500
Received: by mail-bk0-f44.google.com with SMTP id w11so515707bku.17
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2012 10:04:34 -0800 (PST)
Message-ID: <50D0AF50.3090503@gmail.com>
Date: Tue, 18 Dec 2012 19:00:48 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
CC: miaox@cn.fujitsu.com, Jeff Liu <jeff.liu@oracle.com>,
        linux-btrfs@vger.kernel.org, anand.jain@oracle.com
Subject: Re: [RFC PATCH V6 2/2] Btrfs: Add a new ioctl to change the label
 of a mounted file system
In-Reply-To: <50CFE3AC.9000705@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <50CFDD9F.2080706@oracle.com>
 <50CFE3AC.9000705@cn.fujitsu.com>

Hi Jeff,

On 12/18/2012 04:31 AM, Miao Xie wrote:
[...]
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
[...]

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

I think that you removed for mistake the following line

+	label[BTRFS_LABEL_SIZE - 1] = '\0';

In the V5 patch it was present.

May be we could replace strcpy() with strlcpy(super_block->label, label,
BTRFS_LABEL_SIZE-1) ?

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
