From: Josef Bacik <josef@redhat.com>
Subject: Re: 2.6.33 high cpu usage
Date: Tue, 2 Mar 2010 14:53:23 -0500
Message-ID: <20100302195322.GA3201@localhost.localdomain>
References: <m3hboy3726.fsf@lugabout.jhcloos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: James Cloos <cloos@jhcloos.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3hboy3726.fsf@lugabout.jhcloos.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 02, 2010 at 01:35:21PM -0500, James Cloos wrote:
> With the ATI bug I was hitting earlier fixed, only my btrfs partition
> continues to show high cpu usage for some operations.
> 
> Rsync, git pull, git checkout and svn up are typicall operations which
> trigger the high cpu usage.
> 
> As an example, this perf report is from using git checkout to change to
> a new branch; the change needed to checkout 208 files out of about 1600
> total files.  du(1) reports that the checkout is about 14 megs; the
> alternates for that tree have about 60 megs of git packs.
> 
> As you can see btrfs_find_space_cluster(), find_next_bit() and
> find_next_zero_bit() use most of the sys cpu.  That patterns seems to
> hold whenever I run perf top during such operations.
> 
> Box is x86_32, pentium3m.
> 

Ok well thats a bummer.  Would you mind trying this completely untested and
uncompiled patch :)?  I think we should probably not be trying to use a bitmap
unless theres quite a bit more free space in it than what we need, since they
can span 128mb, and instead of cycling through the extent entries we should
probably just search for the next bitmap to make it simpler.  Let me know if
this helps or not.  Like I said I've not tested it or anything, so it could make
things blow up, but I don't think it will.  Thanks,

Josef

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index cb2849f..9032f74 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1227,8 +1227,8 @@ again:
 	while (entry->bitmap || found_bitmap ||
 	       (!entry->bitmap && entry->bytes < min_bytes)) {
 		struct rb_node *node = rb_next(&entry->offset_index);
-
-		if (entry->bitmap && entry->bytes > bytes + empty_size) {
+		u64 old_offset = entry->offset;
+		if (entry->bitmap && entry->bytes > (bytes + empty_size) * 4) {
 			ret = btrfs_bitmap_cluster(block_group, entry, cluster,
 						   offset, bytes + empty_size,
 						   min_bytes);
@@ -1240,7 +1240,16 @@ again:
 			ret = -ENOSPC;
 			goto out;
 		}
+
 		entry = rb_entry(node, struct btrfs_free_space, offset_index);
+		if (found_bitmap && !entry->bitmap) {
+			old_offset += BITS_PER_BITMAP * block_group->sectorsize;
+			entry = tree_search_offset(block_group, old_offset, 1, 1);
+			if (!entry) {
+				ret = -ENOSPC;
+				goto out;
+			}
+		}
 	}
 
 	/*
