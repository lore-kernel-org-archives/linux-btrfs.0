From: Balaji Rao <balajirrao@gmail.com>
Subject: [RFC] NFS Support
Date: Sun, 29 Jun 2008 05:05:31 +0530
Message-ID: <200806290505.31641.balajirrao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Here's a quick implementation of NFS support for btrfs. It works mostly. But
its still a bit buggy. I suspect it has to do something with inode locking.
When I unmount and mount a couple of times, it stops working i.e, when I do an 
'ls', it keeps waiting indefinitely. This is seen when accessing the filesystem
from a local mount point as well.

Can anybody please review and tell me what stupid mistake I'm committing ? 

Thanks and Regards,
Balaji Rao
National Institute of Technology, Karnataka
---

#include <linux/fs.h>
#include <linux/types.h>
#include "ctree.h"
#include "disk-io.h"
#include "btrfs_inode.h"
#include "print-tree.h"
#include "export.h"

static int btrfs_encode_fh(struct dentry *dentry, u32 *fh_in, int *max_len,
			int connectable)
{	struct inode *inode = dentry->d_inode;
	int len = *max_len;
	u64 objectid, root_objectid;
	u32 generation;
	__le32 *fh = (__force __le32 *) fh_in;

	if ((len < 5 )|| (connectable && len < 8)) {
		return 255;
	}
	
	objectid = BTRFS_I(inode)->location.objectid;
	root_objectid = BTRFS_I(inode)->root->objectid;
	generation = inode->i_generation;

	len  = 5;
	fh[0] = cpu_to_le32((u32)(objectid >> 32));
	fh[1] = cpu_to_le32((u32)(objectid & 0xffffffff));
	fh[2] = cpu_to_le32((u32)(root_objectid >> 32));
	fh[3] = cpu_to_le32((u32)(root_objectid & 0xffffffff));
	fh[4] = cpu_to_le32(generation);

	if (connectable && !S_ISDIR(inode->i_mode)) {
		struct inode *parent;

		spin_lock(&dentry->d_lock);

		parent = dentry->d_parent->d_inode;
		objectid = BTRFS_I(parent)->location.objectid;
		generation = parent->i_generation;

		fh[5] = cpu_to_le32((u32)(objectid >> 32));
		fh[6] = cpu_to_le32((u32)(objectid & 0xffffffff));
		fh[7] = cpu_to_le32(generation);

		spin_unlock(&dentry->d_lock);

		len += 3;
	}
	
	*max_len = len;
	return len;

}

static struct dentry * btrfs_get_dentry(struct super_block *sb,
			u64 objectid, u64 root_objectid, u32 generation)
{
	struct inode *inode;
	struct dentry *result;

	inode = btrfs_ilookup(sb, objectid, root_objectid);
	if (IS_ERR(inode))
		return (void *)inode;

	if(generation != inode->i_generation) {
		iput(inode);
		return ERR_PTR(-ESTALE);
	}

	result = d_alloc_anon(inode);
	if(!result) {
		iput(inode);
		return ERR_PTR(-ENOMEM);
	}

	return result;
}

static struct dentry *btrfs_fh_to_parent(struct super_block *sb,
		struct fid *fid, int fh_len, int fh_type)
{
	u64 objectid, root_objectid;
	u32 generation;

	if (fh_len < 8 || fh_type != 8) {
		return NULL;
	}


	root_objectid = (u64)le32_to_cpu(fid->raw[2]) << 32;
	root_objectid |= (u64)le32_to_cpu(fid->raw[3]);
	objectid = (u64)le32_to_cpu(fid->raw[5]) << 32;
	objectid |= (u64)le32_to_cpu(fid->raw[6]);	
	generation = le32_to_cpu(fid->raw[7]);

	return btrfs_get_dentry(sb, objectid, root_objectid, generation);
}

static struct dentry *btrfs_fh_to_dentry(struct super_block *sb,
		struct fid *fid, int fh_len, int fh_type)
{
	u64 objectid, root_objectid;
	u32 generation;

	if (fh_len < 5 || fh_type > 5) {
		return NULL;
	}

	objectid = (u64)le32_to_cpu(fid->raw[0]) << 32;
	objectid |= (u64)le32_to_cpu(fid->raw[1]);	
	root_objectid = (u64)le32_to_cpu(fid->raw[2]) << 32;
	root_objectid |= (u64)le32_to_cpu(fid->raw[3]);
	generation = le32_to_cpu(fid->raw[4]);

	return btrfs_get_dentry(sb, objectid, root_objectid, generation);
}

static struct dentry *btrfs_get_parent(struct dentry *child)
{
	struct inode *dir = child->d_inode;
	struct inode *inode;
	struct dentry *parent;
	struct btrfs_root *root = BTRFS_I(dir)->root;
	struct btrfs_key key;
	struct btrfs_path *path;
	struct extent_buffer *leaf;	
	u32 nritems;
	int slot;
	u64 objectid;
	int ret;

	path = btrfs_alloc_path();

	key.objectid = dir->i_ino;
	btrfs_set_key_type(&key, BTRFS_INODE_REF_KEY);
	key.offset = 0;
	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
	BUG_ON(ret == 0);
	ret = 0;

	leaf = path->nodes[0];
	slot = path->slots[0];
	nritems = btrfs_header_nritems(leaf);
	if (slot >= nritems)
		return ERR_PTR(-EINVAL);

	btrfs_item_key_to_cpu(leaf, &key, slot);
	if (key.objectid != dir->i_ino ||
	    key.type != BTRFS_INODE_REF_KEY) {
		return ERR_PTR(-EINVAL);
	}

	btrfs_free_path(path);
	objectid = key.offset;
	inode = btrfs_iget_locked(root->fs_info->sb, objectid, root);
	
	parent = d_alloc_anon(inode);
	if (!parent) {
		iput(inode);
		parent = ERR_PTR(-ENOMEM);
	}
	
	return parent;	
}

const struct export_operations btrfs_export_ops = {
	.encode_fh	= btrfs_encode_fh,
	.fh_to_dentry	= btrfs_fh_to_dentry,
	.fh_to_parent	= btrfs_fh_to_parent,
	.get_parent	= btrfs_get_parent,
};
