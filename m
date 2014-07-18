Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:48115 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaGRHZe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 03:25:34 -0400
Received: from /spool/local
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 18 Jul 2014 12:55:29 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id F21B63940048
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Jul 2014 12:55:25 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s6I7Pjhr12648746
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Jul 2014 12:55:46 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s6I7PO18019680
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Jul 2014 12:55:24 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: Call mount_subtree() even 'subvolid=' mount option is given.
Date: Fri, 18 Jul 2014 12:55:22 +0630
Message-ID: <1765714.GbaOmBTt1L@localhost.localdomain>
In-Reply-To: <1405483631-23037-2-git-send-email-quwenruo@cn.fujitsu.com>
References: <1405483631-23037-1-git-send-email-quwenruo@cn.fujitsu.com> <1405483631-23037-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 16 Jul 2014 12:07:10 Qu Wenruo wrote:
> +/* Find the path for given subvol_objectid.
> + * Caller needs to readlock the root tree and kzalloc PATH_MAX for
> + * subvol_name and namebuf */
> +static char *find_subvol_by_id(struct btrfs_root *root, u64 subvol_objectid)
> +{
> +	struct btrfs_key key;
> +	struct btrfs_key found_key;
> +	struct btrfs_root_ref *ref;
> +	struct btrfs_path *path;
> +	char *namebuf = NULL;
> +	char *new_buf = NULL;
> +	char *subvol_ret = NULL;
> +	int ret = 0;
> +	u16 namelen = 0;
> +
> +	path = btrfs_alloc_path();
> +	/* Alloc 1 byte for later strlen() calls */
> +	subvol_ret = kzalloc(1, GFP_NOFS);
> +	if (!path || !subvol_ret) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	key.objectid = subvol_objectid;
> +	key.type = BTRFS_ROOT_BACKREF_KEY;
> +	key.offset = 0;
> +	/* We don't need to lock the tree_root,
> +	 * if when we do the backref walking, some one deleted/moved
> +	 * the subvol, we just return -ENOENT or let mount_subtree
> +	 * return -ENOENT and no disaster will happen.
> +	 * User should not modify subvolume when trying to mount it */
> +	while (key.objectid != BTRFS_FS_TREE_OBJECTID) {
> +		ret = btrfs_search_slot_for_read(root, &key, path, 1, 1);
> +		if (ret < 0)
> +			goto out;
> +		if (ret) {
> +			ret = -ENOENT;
> +			goto out;
> +		}
> +		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
> +				      path->slots[0]);
> +		if (found_key.objectid != key.objectid ||
> +		    found_key.type != BTRFS_ROOT_BACKREF_KEY) {
> +			ret = -ENOENT;
> +			goto out;
> +		}
> +		key.objectid = found_key.offset;
> +		ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
> +				     struct btrfs_root_ref);
> +		namelen = btrfs_root_ref_name_len(path->nodes[0], ref);
> +		/* One for ending '\0' One for '/' */
> +		new_buf = krealloc(namebuf, namelen + 2, GFP_NOFS);
> +		if (!new_buf) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +		namebuf = new_buf;
> +		read_extent_buffer(path->nodes[0], namebuf,
> +				   (unsigned long)(ref + 1), namelen);
> +		btrfs_release_path(path);
> +		*(namebuf + namelen) = '/';
> +		*(namebuf + namelen + 1) = '\0';
> +
> +		new_buf = krealloc(subvol_ret, strlen(subvol_ret) + namelen + 2,
> +				   GFP_NOFS);
> +		if (!new_buf) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +		subvol_ret = new_buf;
> +		str_append_head(subvol_ret, namebuf);
> +	}
> +out:
> +	kfree(namebuf);
> +	btrfs_free_path(path);
> +	if (ret < 0) {
> +		kfree(subvol_ret);
> +		return ERR_PTR(ret);
> +	} else
> +		return subvol_ret;
> +
> +}

Hello Qu Wenruo,

If the subvolume being mounted exists in a sub-directory of the parent's
subvolume, then the find_subvol_by_id() fails to contruct the correct
path to the subvolume. Hence mount would fail.

For e.g.

[root@guest0 ~]# btrfs subvolume list /mnt/btrfs/
ID 257 gen 7 top level 5 path dir1/sub1
[root@guest0 ~]# umount /mnt/btrfs
[root@guest0 ~]# mount -o subvolid=257 /dev/loop0 /mnt/btrfs/
mount: mount(2) failed: No such file or directory

-- 
chandan

