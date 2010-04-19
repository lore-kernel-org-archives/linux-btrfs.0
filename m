From: Abhinav Duggal <abhinav@cs.sunysb.edu>
Subject: Memory barrier not required in cached_block_group
Date: Mon, 19 Apr 2010 14:46:18 -0400
Message-ID: <l2j3d81e70e1004191146sd3b7feeevc183e7c3e705c773@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
It seems like memory barrier is not required in cached_block_group.I
am looking at kernel 2.6.34-rc2.
cache_block_group(struct btrfs_block_group_cache *cache)
{
smp_mb();
  if (cache->cached != BTRFS_CACHE_NO)
    return 0;
....
}
This function is called from btrfs_alloc_logged_file_extent and
find_free_extent.
In btrfs_alloc_logged_file_extent the code snippet is as follows

block_group = btrfs_lookup_block_group(root->fs_info, ins->objectid);
  cache_block_group(block_group);

btrfs_lookup_block_group releases a spin_lock at the end so the writes
in spin_lock cannot get out. Another thing is that block_group is
returned from this function which is being passed to
cache_block_group.This means there is a causal relationship between
cache->cached variable and the block_group returned.So x86 or x86-64
should not reorder it.However,Alpha might reorder it.So memory barrier
maybe required in Alpha case.

Again,in function find_free_extent the code snippet is

 if (loop > LOOP_CACHING_NOWAIT ||
          (loop > LOOP_FIND_IDEAL &&
           atomic_read(&space_info->caching_threads) < 2)) {
        ret = cache_block_group(block_group);
        BUG_ON(ret);
      }

In this code also I believe the architecture should not reorder the
read with atomic_read of caching_threads because of if condition and
x86-64 not doing read reordering from software point of view.Also,any
writes that happened before the if condition should not probably
remain in the write buffer because the there should not be reordering
done with anything inside the 'if' condition.
I am also not sure of the barrier block_group_cache_done.Any reasoning
for that would also be helpful.
Am I missing something here?Please clarify.I am doing some dynamic
analysis to find out possible barrier synchronization problems in
btrfs, if any?Any help would be great.
Thanks.
Abhinav.
