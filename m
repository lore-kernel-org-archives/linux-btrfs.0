From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] NFS Support
Date: Mon, 30 Jun 2008 14:46:00 -0400
Message-ID: <20080630184600.GA28679@infradead.org>
References: <200806290505.31641.balajirrao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Balaji Rao <balajirrao@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200806290505.31641.balajirrao@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 29, 2008 at 05:05:31AM +0530, Balaji Rao wrote:
> 	len  = 5;
> 	fh[0] = cpu_to_le32((u32)(objectid >> 32));
> 	fh[1] = cpu_to_le32((u32)(objectid & 0xffffffff));
> 	fh[2] = cpu_to_le32((u32)(root_objectid >> 32));
> 	fh[3] = cpu_to_le32((u32)(root_objectid & 0xffffffff));
> 	fh[4] = cpu_to_le32(generation);

Please use C struct types for the file handles.  Take a look at
fs/xfs/linux-2.6/xfs_export.[ch] for an example.

> static struct dentry * btrfs_get_dentry(struct super_block *sb,
> 			u64 objectid, u64 root_objectid, u32 generation)
> {
> 	struct inode *inode;
> 	struct dentry *result;
> 
> 	inode = btrfs_ilookup(sb, objectid, root_objectid);
> 	if (IS_ERR(inode))
> 		return (void *)inode;

This one will only find inodes when they already are in memory.  You
need to something similar to btrfs_lookup minus the btrfs_inode_by_name
call here.  In fact it would make a lot of sense to factor that part
of btrfs_lookup out into a btrfs_iget helper that takes a struct
btrfs_key pointer and returns the inode for you.

