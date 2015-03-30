Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35340 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbbC3Vg3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 17:36:29 -0400
Message-ID: <5519C1D8.6050404@suse.com>
Date: Mon, 30 Mar 2015 17:36:24 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: fdmanana@gmail.com
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: add missing discards when unpinning extents with,
 -o discard
References: <5519A022.9090804@suse.com> <CAL3q7H6zDd1O3n+PqBMueDOsyuTo6rP7rqGzpD7+ZTckzUba7g@mail.gmail.com>
In-Reply-To: <CAL3q7H6zDd1O3n+PqBMueDOsyuTo6rP7rqGzpD7+ZTckzUba7g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 3/30/15 3:29 PM, Filipe David Manana wrote:
> On Mon, Mar 30, 2015 at 8:12 PM, Jeff Mahoney <jeffm@suse.com> 
> wrote:
>> The block group removal patch adds an alternate path to forget 
>> extents other than btrfs_finish_extent_commit. As a result, any 
>> extents that would be freed when the block group is removed 
>> aren't discarded. In my test run, with a large copy of mixed 
>> sized files followed by removal, it left nearly 2/3 of extents 
>> undiscarded.
>> 
>> As part of the extent removal review, I also added the discard 
>> call to btrfs_destroy_pinned_extent.
>> 
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com> --- 
>> fs/btrfs/disk-io.c     | 7 +++++++ fs/btrfs/extent-tree.c | 9 
>> +++++++++ 2 files changed, 16 insertions(+)
>> 
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c index 
>> 639f266..f7dfcf8 100644 --- a/fs/btrfs/disk-io.c +++ 
>> b/fs/btrfs/disk-io.c @@ -4167,6 +4167,13 @@ again: if (ret) 
>> break;
>> 
>> +               if (btrfs_test_opt(root, DISCARD)) { + ret =
>> btrfs_discard_extent(root, start, + end + 1 - start, NULL); +
>> if (ret) + break; +               } +
> 
> Jeff we can't do a discard here, specially if unpin == 
> fs_info->pinned_extents, as explained in:
> 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit
/?id=678886bdc6378c1cbd5072da2c5a3035000214e3
>
>
> 
> 
> 
>> clear_extent_dirty(unpin, start, end, GFP_NOFS); 
>> btrfs_error_unpin_extent_range(root, start, end); cond_resched();
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 0bf45b8..6a7ff46 100644 --- a/fs/btrfs/extent-tree.c +++
>> b/fs/btrfs/extent-tree.c @@ -9630,6 +9630,15 @@ void
>> btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info) * a
>> BUG_ON() at btrfs_unpin_extent_range(). */ 
>> mutex_lock(&fs_info->unused_bg_unpin_mutex); +               if 
>> (btrfs_test_opt(root, DISCARD)) { +                       ret = 
>> btrfs_discard_extent(root, start, end + 1 - start, + NULL); +
>> if (ret) { + mutex_unlock(&fs_info->unused_bg_unpin_mutex); + 
>> btrfs_set_block_group_rw(root, block_group); + goto end_trans; +
>> } +               }
> 
> This isn't safe either for the similar reason as above. For 
> example, transaction N running, metadata bg X becomes empty and 
> it's added to fs_info->unused_bgs, cleaner kthread running and
> gets bg X from fs_info->unused_bgs (running
> btrfs_delete_unused_bgs), does the discard, power failure, reboot,
> superblock points to metadata extents in the physical location of
> bg X that are now full of zeroes.
> 
> thanks
> 
>> ret = clear_extent_bits(&fs_info->freed_extents[0], start, end, 
>> EXTENT_DIRTY, GFP_NOFS); if (ret) {

Thanks for the review, Filipe. I think I understand what you mean.
btrfs_finish_extent_commit is effectively the only safe place to
perform the discards, since we know the transaction is finished. I'll
need to rework block group deletions a bit since the clearing of the
dirty bits for the whole block group mean that
btrfs_finish_extent_commit never sees those blocks as eligible for
discard.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJVGcHYAAoJEB57S2MheeWy1AYP/ixGoegmr2xACfFRmtlOvI9q
Wajf/9PiNbgr7kZ9pe5mWIi/Ab9X38OqPXPfnu7rx6qf/kBJ5ltHFsflCHEQazte
/5n+dSClhn7dAjWvL36UbIhH+uqaD5kL2rkmU7D72j5l26TwlYxF7vTUIxE891mR
0DN/BjQ58dOY8vsQRU4ZY6cHoX5jpMU2b7tje/Uk+PrctNjFkiTJFR8NApetTV6d
eebTomEoWGqSe8RCsZK9PvaRc1qdpuNl8XqdNppEapA9QOuWXaVr7hjYmVMwCAWi
01AVDd6NKwu6dQ2i7rt9+/o4GJrFORptBAtAZgHeTyd99WKFYbxPsWm3aBHrfGU2
4h/s5EEDbLcDV0p/5jojp3c/JdI9hOVL8LzCAI97LGZL9FNqx8CV1m2//TFYqRKk
2K1cmFVmzI+RwZ/Reo6/qW5CcwIeZJnmIZOAAHHnD97PZH69UHW+3RqRDUlcy7Mx
srzTNLiA+R25MEEnv2qHNUcPduGmkjaENqq2TufQHsqpR8sIwpaavXNJKR2X128Y
q+JwELlGi0XYqa9jgRjFwiX/Y+/nvjh1MQ/GZfArxZjooUpdfPMYrUUOCt4/djUG
f0xkExvHr62t9IMdmaQkOhABb5HZ34lnJ6R3v2+p/RdAWIzhWtz6dd+M3x8s4ufZ
a1eDIAuFL/wfl18QElBh
=DQ57
-----END PGP SIGNATURE-----
