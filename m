Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:40518 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab2KPGcs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Nov 2012 01:32:48 -0500
Message-ID: <50A5DE20.7080600@cn.fujitsu.com>
Date: Fri, 16 Nov 2012 14:33:04 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Anand jain <Anand.Jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: add label to snapshot and subvol
References: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com> <1353041547-10088-1-git-send-email-Anand.Jain@oracle.com> <1353041547-10088-3-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1353041547-10088-3-git-send-email-Anand.Jain@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Anand

On fri, 16 Nov 2012 12:52:25 +0800, Anand jain wrote:
> +static int btrfs_ioctl_subvol_getlabel(struct btrfs_root *root,
> +						void __user *arg)
> +{
> +	char *label;
> +
> +	label = btrfs_root_label(&root->root_item);
> +	if (copy_to_user(arg, label, BTRFS_SUBVOL_LABEL_SIZE))
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static int btrfs_ioctl_subvol_setlabel(struct btrfs_root *root,
> +						void __user *arg)
> +{
> +	char label[BTRFS_SUBVOL_LABEL_SIZE+1];
> +	struct btrfs_trans_handle *trans;
> +
> +	if (copy_from_user(label, arg, BTRFS_SUBVOL_LABEL_SIZE))
> +		return -EFAULT;
> +	trans = btrfs_join_transaction(root);
> +	if (IS_ERR(trans))
> +		return PTR_ERR(trans);
> +	btrfs_root_set_label(&root->root_item, label);
> +	btrfs_end_transaction(trans, root);

We need a lock to protect the label, and besides that, we need to get the write
access before we set the label for the subvolume.

Thanks
Miao

