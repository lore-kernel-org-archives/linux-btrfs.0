Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084AbbFJAFq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Jun 2015 20:05:46 -0400
Message-ID: <55777F56.3060303@suse.com>
Date: Tue, 09 Jun 2015 20:05:42 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: fdmanana@gmail.com
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] btrfs: add missing discards when unpinning extents
 with -o discard
References: <1433342874-7099-1-git-send-email-jeffm@suse.com>	<1433342874-7099-4-git-send-email-jeffm@suse.com> <CAL3q7H6OOP+CYwYc9tjb7brSYtbkLmYwqipv7grFkAULh8SXaw@mail.gmail.com> <55775116.1080201@suse.com>
In-Reply-To: <55775116.1080201@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 6/9/15 4:48 PM, Jeff Mahoney wrote:
> On 6/8/15 10:12 AM, Filipe David Manana wrote:
>> On Wed, Jun 3, 2015 at 3:47 PM,  <jeffm@suse.com> wrote:
>>> From: Jeff Mahoney <jeffm@suse.com>
>>> 
>>> When we clear the dirty bits in btrfs_delete_unused_bgs for 
>>> extents in the empty block group, it results in 
>>> btrfs_finish_extent_commit being unable to discard the freed 
>>> extents.
>>> 
>>> The block group removal patch added an alternate path to
>>> forget extents other than btrfs_finish_extent_commit.  As a
>>> result, any extents that would be freed when the block group is
>>> removed aren't discarded.  In my test run, with a large copy of
>>> mixed sized files followed by removal, it left nearly 2/3 of
>>> extents undiscarded.
>>> 
>>> To clean up the block groups, we add the removed block group
>>> onto a list that will be discarded after transaction commit.
>>> 
>>> v1->v2: - Fix ordering to ensure that we don't discard extents 
>>> freed in an uncommitted transaction.
>>> 
>>> v2->v3: - Factor out get/put block_group->trimming to ensure
>>> that cleanup always happens at the last reference drop. -
>>> Cleanup the free space cache on the last reference drop. - Use
>>> list_move instead of list_add in case of multiple adds.  We
>>> still issue a warning, but we shouldn't fall over.
>>> 
>>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> 
>> Hi Jeff,
> 
>> The changes look good from eyeballing, and I gave it a try 
>> together with the previous 2 patches in the corresponding series.
>>  However, this patch in the series fails tests btrfs/065 to 
>> btrfs/072.
> 
>> Running the following in a loop until it returns failure ($? !=
>> 0) triggers an apparent corruption issue most of the time:
> 
> Ok, I didn't have my test environment set up to do the multidevice 
> tests by default, and definitely didn't have it set up to do 065, 
> since that requires 5+ devices of identical size. Now that I do
> have that set up, I see this:
> 
> 8,37   2     1442    22.727796582 15400  D   D 419434496 + 8192
> [umoun t]
> 
> 419434496 is the start of /dev/sdc5 and we're blowing away 4 MB.
> That happens to coincide with the system (single) block group.  In
> my testing, I found (IIRC) that system (single) and metadata
> (single) were always in the unused list but were getting skipped by
> the cleaner thread.  It looks like the cleanup block groups on
> close_ctree is misbehaving.  Whatever condition that was causing
> those to be skipped must be unset for 065.  It wasn't a problem
> during normal runtime, but now that it's called in close_ctree,
> it's introducing a problem.  I'll start digging.
> 
> Thanks for the review!

<...>-5472  [014] ....   390.430881: btrfs_chunk_free: root =
3(CHUNK_TREE), offset = 0, size = 4194304, num_stripes = 1,
sub_stripes = 0, type = SYSTEM

That'd do it. If I do a btrfs-debug-tree on the file system without
discard, it works fine because the superblock doesn't get discarded.
That 0-4MB chunk _is_ released and unused.

- -Jeff

> -Jeff
> 
>> root 17:16:48 /home/fdmanana/git/hub/xfstests (up_master_2)> 
>> MKFS_OPTIONS="-O skinny-metadata" MOUNT_OPTIONS="-o discard" 
>> ./check btrfs/065 FSTYP         -- btrfs PLATFORM      -- 
>> Linux/x86_64 debian3 4.1.0-rc5-btrfs-next-10+ MKFS_OPTIONS  --
>> -O skinny-metadata /dev/sdc MOUNT_OPTIONS -- -o discard /dev/sdc 
>> /home/fdmanana/btrfs-tests/scratch_1
> 
>> btrfs/065 130s ... [failed, exit status 1] - output mismatch (see
>>  /home/fdmanana/git/hub/xfstests/results//btrfs/065.out.bad) --- 
>> tests/btrfs/065.out 2014-11-17 20:59:51.282203001 +0000 +++ 
>> /home/fdmanana/git/hub/xfstests/results//btrfs/065.out.bad 
>> 2015-06-07 17:37:40.841293317 +0100 @@ -1,2 +1,3 @@ QA output 
>> created by 065 Silence is golden +_check_btrfs_filesystem: 
>> filesystem on /dev/sdc is inconsistent (see 
>> /home/fdmanana/git/hub/xfstests/results//btrfs/065.full) ...
>> (Run 'diff -u tests/btrfs/065.out 
>> /home/fdmanana/git/hub/xfstests/results//btrfs/065.out.bad'  to 
>> see the entire diff) Ran: btrfs/065 Failures: btrfs/065 Failed 1
>> of 1 tests
> 
>> root 17:37:41 /home/fdmanana/git/hub/xfstests (up_master_2)> 
>> btrfsck /dev/sdc No valid Btrfs found on /dev/sdc Couldn't open 
>> file system root 17:37:43 /home/fdmanana/git/hub/xfstests 
>> (up_master_2)>
> 
> 
>> With only patches 1 and 2 in the series (or without them) this 
>> never happens (well, at least not in ~50 iterations when running 
>> btrfs/065). And I've never seen this before testing this patch.
> 
>> It also makes generic/251 "never" finish apparently - it didn't 
>> finish here after 9h running, and without any of these patches
>> in the series it used to finish in less than half an hour.
> 
>> Maybe the apparent corruption is due to some interaction with 
>> device replace or scrub, I haven't had the time to 
>> analyze/determine what it could be.
> 
>> thanks
> 
> 
> 
> 
>>> --- fs/btrfs/ctree.h            |  3 ++ fs/btrfs/extent-tree.c 
>>> | 69 ++++++++++++++++++++++++++++++++++++++++++--- 
>>> fs/btrfs/free-space-cache.c | 57 
>>> +++++++++++++++++++++---------------- fs/btrfs/super.c |  2 +-
>>> fs/btrfs/transaction.c      |  2 ++ fs/btrfs/transaction.h
>>> |  2 ++ 6 files changed, 106 insertions(+), 29 deletions(-)
>>> 
>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h index 
>>> 6f364e1..780acf1 100644 --- a/fs/btrfs/ctree.h +++ 
>>> b/fs/btrfs/ctree.h @@ -3438,6 +3438,8 @@ int 
>>> btrfs_remove_block_group(struct btrfs_trans_handle *trans,
>>> struct btrfs_root *root, u64 group_start, struct extent_map
>>> *em); void btrfs_delete_unused_bgs(struct btrfs_fs_info
>>> *fs_info); +void btrfs_get_block_group_trimming(struct
>>> btrfs_block_group_cache *cache); +void
>>> btrfs_put_block_group_trimming(struct btrfs_block_group_cache
>>> *cache); void btrfs_create_pending_block_groups(struct
>>> btrfs_trans_handle *trans, struct btrfs_root *root); u64 
>>> btrfs_get_alloc_profile(struct btrfs_root *root, int data); @@ 
>>> -4068,6 +4070,7 @@ __printf(5, 6) void
>>> __btrfs_std_error(struct btrfs_fs_info *fs_info, const char
>>> *function, unsigned int line, int errno, const char *fmt,
>>> ...);
>>> 
>>> +const char *btrfs_decode_error(int errno);
>>> 
>>> void __btrfs_abort_transaction(struct btrfs_trans_handle
>>> *trans, struct btrfs_root *root, const char *function, diff
>>> --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c index 
>>> fb4dbfc..e53dbe9 100644 --- a/fs/btrfs/extent-tree.c +++ 
>>> b/fs/btrfs/extent-tree.c @@ -6034,20 +6034,19 @@ int 
>>> btrfs_finish_extent_commit(struct btrfs_trans_handle *trans, 
>>> struct btrfs_root *root) { struct btrfs_fs_info *fs_info = 
>>> root->fs_info; +       struct btrfs_block_group_cache 
>>> *block_group, *tmp; +       struct list_head *deleted_bgs;
>>> struct extent_io_tree *unpin; u64 start; u64 end; int ret;
>>> 
>>> -       if (trans->aborted) -               return 0; - if 
>>> (fs_info->pinned_extents == &fs_info->freed_extents[0]) unpin
>>> = &fs_info->freed_extents[1]; else unpin = 
>>> &fs_info->freed_extents[0];
>>> 
>>> -       while (1) { +       while (!trans->aborted) { 
>>> mutex_lock(&fs_info->unused_bg_unpin_mutex); ret = 
>>> find_first_extent_bit(unpin, 0, &start, &end, EXTENT_DIRTY, 
>>> NULL); @@ -6066,6 +6065,34 @@ int 
>>> btrfs_finish_extent_commit(struct btrfs_trans_handle *trans, 
>>> cond_resched(); }
>>> 
>>> +       /* +        * Transaction is finished.  We don't need
>>> the lock anymore.  We +        * do need to clean up the block
>>> groups in case of a transaction +        * abort. +        */
>>> + deleted_bgs = &trans->transaction->deleted_bgs; + 
>>> list_for_each_entry_safe(block_group, tmp, deleted_bgs,
>>> bg_list) { +               u64 trimmed = 0; + +
>>> ret = -EROFS; +               if (!trans->aborted) + ret =
>>> btrfs_discard_extent(root, + block_group->key.objectid, + 
>>> block_group->key.offset, + &trimmed); + + 
>>> list_del_init(&block_group->bg_list); + 
>>> btrfs_put_block_group_trimming(block_group); + 
>>> btrfs_put_block_group(block_group); + +               if (ret)
>>> { +                       const char *errstr = 
>>> btrfs_decode_error(ret); + btrfs_warn(fs_info, +
>>> "Discard failed while removing blockgroup: errno=%d %s\n", + 
>>> ret, errstr); +               } +       } + return 0; }
>>> 
>>> @@ -9845,6 +9872,11 @@ int btrfs_remove_block_group(struct 
>>> btrfs_trans_handle *trans, * currently running transaction
>>> might finish and a new one start, * allowing for new block
>>> groups to be created that can reuse the same * physical device
>>> locations unless we take this special care. +        * +
>>> * There may also be an implicit trim operation if the file
>>> system +        * is mounted with -odiscard. The same
>>> protections must remain + * in place until the extents have
>>> been discarded completely when +        * the transaction
>>> commit has completed. */ remove_em = 
>>> (atomic_read(&block_group->trimming) == 0); /* @@ -9917,8 
>>> +9949,10 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info 
>>> *fs_info) return;
>>> 
>>> spin_lock(&fs_info->unused_bgs_lock); + while 
>>> (!list_empty(&fs_info->unused_bgs)) { u64 start, end; + int
>>> trimming;
>>> 
>>> block_group = list_first_entry(&fs_info->unused_bgs, struct 
>>> btrfs_block_group_cache, @@ -10016,12 +10050,39 @@ void 
>>> btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info) 
>>> spin_unlock(&block_group->lock);
>>> spin_unlock(&space_info->lock);
>>> 
>>> +               /* DISCARD can flip during remount */ + 
>>> trimming = btrfs_test_opt(root, DISCARD); + +               /* 
>>> Implicit trim during transaction commit. */ +               if 
>>> (trimming) + btrfs_get_block_group_trimming(block_group); + /*
>>> * Btrfs_remove_chunk will abort the transaction if things go * 
>>> horribly wrong. */ ret = btrfs_remove_chunk(trans, root, 
>>> block_group->key.objectid); + +               if (ret) { + if
>>> (trimming) + btrfs_put_block_group_trimming(block_group); + 
>>> goto end_trans; +               } + +               /* + * If
>>> we're not mounted with -odiscard, we can just forget + * about
>>> this block group. Otherwise we'll need to wait + * until
>>> transaction commit to do the actual discard. + */ +
>>> if (trimming) { + WARN_ON(!list_empty(&block_group->bg_list));
>>> + spin_lock(&trans->transaction->deleted_bgs_lock); + 
>>> list_move(&block_group->bg_list, + 
>>> &trans->transaction->deleted_bgs); + 
>>> spin_unlock(&trans->transaction->deleted_bgs_lock); + 
>>> btrfs_get_block_group(block_group); +               }
>>> end_trans: btrfs_end_transaction(trans, root); next: diff
>>> --git a/fs/btrfs/free-space-cache.c
>>> b/fs/btrfs/free-space-cache.c index 9dbe5b5..c79253e 100644 ---
>>> a/fs/btrfs/free-space-cache.c +++ b/fs/btrfs/free-space-cache.c
>>> @@ -3274,35 +3274,23 @@ next: return ret; }
>>> 
>>> -int btrfs_trim_block_group(struct btrfs_block_group_cache 
>>> *block_group, -                          u64 *trimmed, u64
>>> start, u64 end, u64 minlen) +void
>>> btrfs_get_block_group_trimming(struct btrfs_block_group_cache
>>> *cache) { -       int ret; + atomic_inc(&cache->trimming); +}
>>> 
>>> -       *trimmed = 0; +void
>>> btrfs_put_block_group_trimming(struct btrfs_block_group_cache
>>> *block_group) +{ +       struct extent_map_tree *em_tree; +
>>> struct extent_map *em; + bool cleanup;
>>> 
>>> spin_lock(&block_group->lock); -       if
>>> (block_group->removed) { -
>>> spin_unlock(&block_group->lock); - return 0; -       } -
>>> atomic_inc(&block_group->trimming); + cleanup =
>>> (atomic_dec_and_test(&block_group->trimming) && + 
>>> block_group->removed); spin_unlock(&block_group->lock);
>>> 
>>> -       ret = trim_no_bitmap(block_group, trimmed, start, end, 
>>> minlen); -       if (ret) -               goto out; - -
>>> ret = trim_bitmaps(block_group, trimmed, start, end, minlen);
>>> -out: - spin_lock(&block_group->lock); -       if 
>>> (atomic_dec_and_test(&block_group->trimming) && - 
>>> block_group->removed) { -               struct extent_map_tree 
>>> *em_tree; -               struct extent_map *em; - - 
>>> spin_unlock(&block_group->lock); - +       if (cleanup) { 
>>> lock_chunks(block_group->fs_info->chunk_root); em_tree = 
>>> &block_group->fs_info->mapping_tree.map_tree; 
>>> write_lock(&em_tree->lock); @@ -3326,10 +3314,31 @@ out: *
>>> this block group have left 1 entry each one. Free them. */ 
>>> __btrfs_remove_free_space_cache(block_group->free_space_ctl);
>>> - } else { +       } +} + +int btrfs_trim_block_group(struct 
>>> btrfs_block_group_cache *block_group, + u64 *trimmed, u64
>>> start, u64 end, u64 minlen) +{ +       int ret; + +
>>> *trimmed = 0; + + spin_lock(&block_group->lock); +       if
>>> (block_group->removed) { spin_unlock(&block_group->lock); +
>>> return 0; } + btrfs_get_block_group_trimming(block_group); + 
>>> spin_unlock(&block_group->lock); + +       ret = 
>>> trim_no_bitmap(block_group, trimmed, start, end, minlen); + if
>>> (ret) +               goto out;
>>> 
>>> +       ret = trim_bitmaps(block_group, trimmed, start, end, 
>>> minlen); +out: + btrfs_put_block_group_trimming(block_group);
>>> return ret; }
>>> 
>>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c index 
>>> 2ccd8d4..a80da03 100644 --- a/fs/btrfs/super.c +++ 
>>> b/fs/btrfs/super.c @@ -69,7 +69,7 @@ static struct 
>>> file_system_type btrfs_fs_type;
>>> 
>>> static int btrfs_remount(struct super_block *sb, int *flags,
>>> char *data);
>>> 
>>> -static const char *btrfs_decode_error(int errno) +const char 
>>> *btrfs_decode_error(int errno) { char *errstr = "unknown";
>>> 
>>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c 
>>> index 5628e25..2005262 100644 --- a/fs/btrfs/transaction.c +++ 
>>> b/fs/btrfs/transaction.c @@ -256,6 +256,8 @@ loop: 
>>> mutex_init(&cur_trans->cache_write_mutex); 
>>> cur_trans->num_dirty_bgs = 0; 
>>> spin_lock_init(&cur_trans->dirty_bgs_lock); + 
>>> INIT_LIST_HEAD(&cur_trans->deleted_bgs); + 
>>> spin_lock_init(&cur_trans->deleted_bgs_lock); 
>>> list_add_tail(&cur_trans->list, &fs_info->trans_list); 
>>> extent_io_tree_init(&cur_trans->dirty_pages, 
>>> fs_info->btree_inode->i_mapping); diff --git 
>>> a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h index 
>>> 0b24755..14325f2 100644 --- a/fs/btrfs/transaction.h +++ 
>>> b/fs/btrfs/transaction.h @@ -74,6 +74,8 @@ struct 
>>> btrfs_transaction { */ struct mutex cache_write_mutex;
>>> spinlock_t dirty_bgs_lock; +       struct list_head
>>> deleted_bgs; + spinlock_t deleted_bgs_lock; struct
>>> btrfs_delayed_ref_root delayed_refs; int aborted; int
>>> dirty_bg_run; -- 1.8.4.5
>>> 
>>> -- To unsubscribe from this list: send the line "unsubscribe 
>>> linux-btrfs" in the body of a message to 
>>> majordomo@vger.kernel.org More majordomo info at 
>>> http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> 
> 
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)

iQIcBAEBAgAGBQJVd39VAAoJEB57S2MheeWyROkP/3yZKTetC+Ael7NKpQ8TLk6I
usu3EWAz3mkg1Xmd/Isb9HLrCcxFwl4RPE2DORyXpZOF8Vx/2TfwZ9GWeziQsSUl
ArTemnfRS5eZ1Vwh2MiY0ONJrR7OegJwtJ2z2p2w5XjvLj7v/0iBBvBrdWo4Zasl
l4n6othn771D3744sm69WpmUeU+KsdQf8UgSlfpe2vDMounFrPQE91b1HTCrnM/S
w0ccLNju2HWnEqP3GuukFyi3UtylEz8NfhNzWbSyFKlc5Z7LvT5JTU1AcT5U8vSG
G5aTDEZnAuUVx74o7+lL4/kE855vyeHc3Lag6Uc86ZMOjrR8AW2daeLFGhFqxGby
mDPx4wnOBx6kHuZyAFVZk3SXOUdK6jGWIwLnkJQXCNFry8v0pFpt+e+tPrwMYsnp
tBhH9sQeHp9F0U+RPsG18glgpN/xCv9/CEtoOteVZfSlRlv7ktpbYuEITd4y9p0O
x62NTi7oJEqGugsVPV3Y8gsrCW5oQIAA/YaoQFEP5hOqacsS/OV5bbdCvn7qD4Qw
mtF0gNNzvXLy9fIGw/P2NY2fwHHUSVZ21cSBKNxMn2KD9eMrXSnw+WdWeLTfn4v6
Lv7tdOSSd1JCSNUbfLMBXGRKm5E4nmn9idi69R0zyJ61P7fvpqxRyqtxqIpsHups
WKo867u3URagNmYuh6ld
=PZYC
-----END PGP SIGNATURE-----
