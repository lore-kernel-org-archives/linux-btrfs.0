From: David Sterba <dsterba@suse.cz>
Subject: Re: kernel BUG at fs/btrfs/inode.c:1163
Date: Mon, 24 Oct 2011 13:39:30 +0200
Message-ID: <20111024113930.GF26547@ds.suse.cz>
References: <4E9DDBB1.2050007@tuxadero.com>
 <20111019094925.GA29468@ds.suse.cz>
 <4E9EC9C1.4030901@tuxadero.com>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
To: Martin Mailand <martin@tuxadero.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <4E9EC9C1.4030901@tuxadero.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 19, 2011 at 02:59:45PM +0200, Martin Mailand wrote:
> Am 19.10.2011 11:49, schrieb David Sterba:
> >It would be interesting what's the value of 'extent_type' at the time of
> >crash, if it's eg -1 that could point to a real bug, some unhandled
> >corner case in truncate, for example.
> >
> 
> How can I do that?

something like that would print the type information during runtime

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1160,6 +1160,11 @@ next_slot:
                                btrfs_file_extent_inline_len(leaf, fi);
                        extent_end = ALIGN(extent_end, root->sectorsize);
                } else {
+                       printk(KERN_CRIT "btrfs: unhandled extent type %d, key=[%llu,%u,%llu]",
+                                       (unsigned long long)found_key.objecitd,
+                                       (unsigned)found_key.tyep,
+                                       (unsigned long long)found_key.offset,
+                                       extent_type);
                        BUG_ON(1);
                }
 out_check:
---

the key seems to be a relevant iformation to print as well, but the rest
stored in the leaf item could be just garbage.

The btrfs-debug-tree utility prints the whole tree items, but as I saw just now
in the case of extent, it skips an unknown type (the same where kernel
BUGs), which means that other extent data are glued to previous output
and thus cannot be spotted easily. To fix that, apply these changes to
progs' print-tree.c:

--- a/print-tree.c
+++ b/print-tree.c
@@ -138,7 +138,7 @@ static void print_file_extent_item(struct extent_buffer *eb,
                  btrfs_file_extent_inline_len(eb, fi),
                  btrfs_file_extent_compression(eb, fi));
                return;
-       }
+       } else
        if (extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
                printf("\t\tprealloc data disk byte %llu nr %llu\n",
                  (unsigned long long)btrfs_file_extent_disk_bytenr(eb, fi),
@@ -147,6 +147,8 @@ static void print_file_extent_item(struct extent_buffer *eb,
                  (unsigned long long)btrfs_file_extent_offset(eb, fi),
                  (unsigned long long)btrfs_file_extent_num_bytes(eb, fi));
                return;
+       } else {
+               printf("*** ERROR unknown extent type %d\n", extent_type);
        }
        printf("\t\textent data disk byte %llu nr %llu\n",
                (unsigned long long)btrfs_file_extent_disk_bytenr(eb, fi),
---

and run the utility on your fs.


david
