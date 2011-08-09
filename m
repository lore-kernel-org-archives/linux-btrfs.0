From: Sage Weil <sage@newdream.net>
Subject: clone ioctl bug with inline extents
Date: Tue, 9 Aug 2011 11:29:01 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1108091102240.9871@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I'm hitting a problem cloning inline extents that I haven't had much 
success tracking down.  It's simple enough to reproduce:

 echo 1111111111111111111111111111 > src
 echo 2 > dst
 clone_range src 0 29 dst 0
 cmp src dst       # fails! dst is size 29 but contains "2\n\0\0\0\0..."

where clone_range comes from 

 http://ceph.newdream.net/git/?p=ceph.git;a=blob;f=qa/btrfs/clone_range.c;h=0a88e16013104c27aa87e7cd0d75e4d292419a19;hb=HEAD

The file size is adjusted for the target, and debug-tree shows an inline 
data extent of length 29, but it has the old data in it.  I'm not sure why

				ret = btrfs_insert_empty_item(trans, root, path,
							      &new_key, size);
				BUG_ON(ret);

				[...]

				leaf = path->nodes[0];
				slot = path->slots[0];
				write_extent_buffer(leaf, buf,
					    btrfs_item_ptr_offset(leaf, slot),
					    size);
				inode_add_bytes(inode, datal);

is working when cloning to a new file but not over an existing one.  
Hopefully this is something silly I'm missing...

sage
