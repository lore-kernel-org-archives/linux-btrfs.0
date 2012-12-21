Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:10928 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab2LUItt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Dec 2012 03:49:49 -0500
Message-ID: <50D422BB.3080204@giantdisaster.de>
Date: Fri, 21 Dec 2012 09:50:03 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Jeff Liu <jeff.liu@oracle.com>
CC: kreijack@inwind.it, linux-btrfs@vger.kernel.org, anand.jain@oracle.com,
        miaox@cn.fujitsu.com, dsterba@suse.cz
Subject: Re: [RFC PATCH v7 1/2] Btrfs: Add a new ioctl to get the label of
 a mounted file system
In-Reply-To: <50D404B8.2000102@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <50D2CF98.6010806@oracle.com>
 <50D372A5.4090906@inwind.it>
 <50D404B8.2000102@oracle.com>

On 12/21/2012 07:42, Jeff Liu wrote:
> On 12/21/2012 04:18 AM, Goffredo Baroncelli wrote:
>> On 12/20/2012 09:43 AM, Jeff Liu wrote:
>>> +static int btrfs_ioctl_get_fslabel(struct file *file, void __user *arg)
>>> +{
>>> +	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
>>> +	const char *label = root->fs_info->super_copy->label;
>>> +	int ret;
>>> +
>>> +	mutex_lock(&root->fs_info->volume_mutex);
>>> +	ret = copy_to_user(arg, label, strlen(label));
>>
>> Sorry for pointing out my doubt too late, but should we trust
>> super_copy->label ?
>> An user could insert a usb-key with a btrfs filesystem with a label
>> without zero. In this case strlen() could access outside
>> super_copy->label[].
> Thank you for letting me be aware of this situation.
>
> First of all, if the user set label via btrfs tools, he can not make it
> length exceeding BTRFS_LABLE_SIZE - 1.
>
> If the user does that through codes wrote by himself like:
> btrfslabel.c->set_label_unmounted(), he can do that.
> However, it most likely he did that for evil purpose or any other reasons?
>>
>> I think that it should be quite easy to alter artificially a filesystem
>> to crash the kernel. So I not consider this as big problem. However *in
>> case* of a further cycle of this patch I suggest to replace strlen()
>> with strnlen().
> I don't think we should replace strlen() with strnlen() since it's
> totally wrong if the length of label is more than BTRFS_LABEL_SIZE -1,
> we can not just truncating the label and return it in this case.
> Add BUG_ON(strlen(label) > BTRFS_LABEL_SIZE - 1) is reasonable instead.

Don't allow users to attack the kernel! This would add a severe security 
issue. A BUG_ON() is something that you can use before the code would 
crash anyway, to prevent any additional damage and to help in debugging. 
A BUG() is not a method to report or handle user errors.

A Linux system is supposed to run until it is shutdown by the 
administrator, not until somebody inserts an USB stick.

