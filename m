From: Dan Carpenter <error27@gmail.com>
Subject: unhandled kmallocs remaining
Date: Thu, 26 Mar 2009 16:54:44 +0300 (EAT)
Message-ID: <Pine.LNX.4.64.0903261650260.31773@usbsys.site>
References: <Pine.LNX.4.64.0903261633260.31773@usbsys.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0903261633260.31773@usbsys.site>
List-ID: <linux-btrfs.vger.kernel.org>

There are only 4 remaining kmallocs that don't have error handling in 
btrfs.

fs/btrfs/inode.c +277 add_async_extent() 'async_extent'
        async_extent = kmalloc(sizeof(*async_extent), GFP_NOFS);
        async_extent->start = start;

fs/btrfs/inode.c +866 cow_file_range_async() 'async_cow'
                async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
                async_cow->inode = inode;

fs/btrfs/compression.c +355 btrfs_submit_compressed_write() 'cb'
        cb = kmalloc(compressed_bio_size(root, compressed_len), GFP_NOFS);
        atomic_set(&cb->pending_bios, 0);

fs/btrfs/compression.c +605 btrfs_submit_compressed_read() 'cb'
        cb = kmalloc(compressed_bio_size(root, compressed_len), GFP_NOFS);
        atomic_set(&cb->pending_bios, 0);

For this kernel release I'm fishing for reported by tags.
Reported-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter
