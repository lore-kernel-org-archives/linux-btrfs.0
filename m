Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:50017 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbaDPKHG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 06:07:06 -0400
Received: from /spool/local
	by e28smtp02.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 16 Apr 2014 15:37:02 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 630313940057
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 15:36:58 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s3GA6qp47471604
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 15:36:53 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s3GA6uJB003931
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 15:36:57 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>,
        linuxpatches@star.c10r.facebook.com
Subject: Re: [PATCH] Btrfs: implement inode_operations callback tmpfile
Date: Wed, 16 Apr 2014 15:30:51 +0630
Message-ID: <1468801.p0fTO3mgjp@localhost.localdomain>
In-Reply-To: <1396392799-9858-1-git-send-email-fdmanana@gmail.com>
References: <1396392799-9858-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 01 Apr 2014 11:53:19 PM Filipe David Borba Manana wrote:
> +static int btrfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
> +{
> +	struct btrfs_trans_handle *trans;
> +	struct btrfs_root *root = BTRFS_I(dir)->root;
> +	struct inode *inode = NULL;
> +	u64 objectid;
> +	u64 index;
> +	int ret = 0;
> +
> +	/*
> +	 * 2 for inode item and ref
> +	 * 2 for dir items
> +	 * 1 for xattr if selinux is on
> +	 */
> +	trans = btrfs_start_transaction(root, 5);
> +	if (IS_ERR(trans))
> +		return PTR_ERR(trans);
> +

Hello,

Any particular reason to reserve space for 5 items? For the O_TMPFILE
case we seem to allocate and use just the one inode item and none of
the associated 'inode ref', 'dir item' and 'dir index item' since
there is no directory entry associated with the file. I am not
sure about the xattr item though.

Thanks,
chandan.

