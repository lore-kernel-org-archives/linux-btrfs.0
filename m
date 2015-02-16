Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:42682 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445AbbBPLR5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Feb 2015 06:17:57 -0500
Received: by labgf13 with SMTP id gf13so27674464lab.9
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Feb 2015 03:17:55 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20150216111136.GD23683@localhost.localdomain>
References: <1423831124-21199-1-git-send-email-fdmanana@suse.com>
	<1423846574-3391-1-git-send-email-fdmanana@suse.com>
	<20150215043913.GA27387@localhost.localdomain>
	<CAL3q7H6uH8LPq=d-84et8puhOx+a+uo8_z-2EMowNb_=C6hk-w@mail.gmail.com>
	<20150216100742.GB23683@localhost.localdomain>
	<CAL3q7H6y3g=2yryj9Z4tc6M6fshFEStRok_g4cEaveaKXNSU6A@mail.gmail.com>
	<20150216111136.GD23683@localhost.localdomain>
Date: Mon, 16 Feb 2015 11:17:55 +0000
Message-ID: <CAL3q7H6eRcAQ=MAyMQx0onbrAk1SbNTZ3KZW3bbPw0Y-etazRA@mail.gmail.com>
Subject: Re: [PATCH v3] Btrfs: don't remove extents and xattrs when logging
 new names
From: Filipe David Manana <fdmanana@gmail.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Filipe Manana <fdmanana@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 16, 2015 at 11:11 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Mon, Feb 16, 2015 at 10:24:02AM +0000, Filipe David Manana wrote:
>> On Mon, Feb 16, 2015 at 10:07 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> > On Sun, Feb 15, 2015 at 10:29:43PM +0000, Filipe David Manana wrote:
>> >> On Sun, Feb 15, 2015 at 4:39 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> >> > On Fri, Feb 13, 2015 at 04:56:14PM +0000, Filipe Manana wrote:
>> >> >> If we are recording in the tree log that an inode has new names (new hard
>> >> >> links were added), we would drop items, belonging to the inode, that we
>> >> >> shouldn't:
>> >> >>
>> >> >> 1) When the flag BTRFS_INODE_COPY_EVERYTHING is set in the inode's runtime
>> >> >>    flags, we ended up dropping all the extent and xattr items that were
>> >> >>    previously logged. This was done only in memory, since logging a new
>> >> >>    name doesn't imply syncing the log;
>> >> >>
>> >> >> 2) When the flag BTRFS_INODE_COPY_EVERYTHING is set in the inode's runtime
>> >> >>    flags, we ended up dropping all the xattr items that were previously
>> >> >>    logged. Like the case before, this was done only in memory because
>> >> >>    logging a new name doesn't imply syncing the log.
>> >> >>
>> >> >> This led to some surprises in scenarios such as the following:
>> >> >>
>> >> >> 1) write some extents to an inode;
>> >> >> 2) fsync the inode;
>> >> >> 3) truncate the inode or delete/modify some of its xattrs
>> >> >> 4) add a new hard link for that inode
>> >> >> 5) fsync some other file, to force the log tree to be durably persisted
>> >> >> 6) power failure happens
>> >> >>
>> >> >> The next time the fs is mounted, the fsync log replay code is executed,
>> >> >> and the resulting file doesn't have the content it had when the last fsync
>> >> >> against it was performed, instead if has a content matching what it had
>> >> >> when the last transaction commit happened.
>> >> >>
>> >> >> So change the behaviour such that when a new name is logged, only the inode
>> >> >> item and reference items are processed.
>> >> >>
>> >> >> This is easy to reproduce with the test I just made for xfstests, whose
>> >> >> main body is:
>> >> >>
>> >> >>   _scratch_mkfs >> $seqres.full 2>&1
>> >> >>   _init_flakey
>> >> >>   _mount_flakey
>> >> >>
>> >> >>   # Create our test file with some data.
>> >> >>   $XFS_IO_PROG -f -c "pwrite -S 0xaa -b 8K 0 8K" \
>> >> >>       $SCRATCH_MNT/foo | _filter_xfs_io
>> >> >>
>> >> >>   # Make sure the file is durably persisted.
>> >> >>   sync
>> >> >>
>> >> >>   # Append some data to our file, to increase its size.
>> >> >>   $XFS_IO_PROG -f -c "pwrite -S 0xcc -b 4K 8K 4K" \
>> >> >>       $SCRATCH_MNT/foo | _filter_xfs_io
>> >> >>
>> >> >>   # Fsync the file, so from this point on if a crash/power failure happens, our
>> >> >>   # new data is guaranteed to be there next time the fs is mounted.
>> >> >>   $XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foo
>> >> >>
>> >> >>   # Now shrink our file to 5000 bytes.
>> >> >>   $XFS_IO_PROG -c "truncate 5000" $SCRATCH_MNT/foo
>> >> >>
>> >> >>   # Now do an expanding truncate to a size larger than what we had when we last
>> >> >>   # fsync'ed our file. This is just to verify that after power failure and
>> >> >>   # replaying the fsync log, our file matches what it was when we last fsync'ed
>> >> >>   # it - 12Kb size, first 8Kb of data had a value of 0xaa and the last 4Kb of
>> >> >>   # data had a value of 0xcc.
>> >> >>   $XFS_IO_PROG -c "truncate 32K" $SCRATCH_MNT/foo
>> >> >>
>> >> >>   # Add one hard link to our file. This made btrfs drop all of our file's
>> >> >>   # metadata from the fsync log, including the metadata relative to the
>> >> >>   # extent we just wrote and fsync'ed. This change was made only to the fsync
>> >> >>   # log in memory, so adding the hard link alone doesn't change the persisted
>> >> >>   # fsync log. This happened because the previous truncates set the runtime
>> >> >>   # flag BTRFS_INODE_NEEDS_FULL_SYNC in the btrfs inode structure.
>> >> >>   ln $SCRATCH_MNT/foo $SCRATCH_MNT/foo_link
>> >> >>
>> >> >>   # Now make sure the in memory fsync log is durably persisted.
>> >> >>   # Creating and fsync'ing another file will do it.
>> >> >>   # After this our persisted fsync log will no longer have metadata for our file
>> >> >>   # foo that points to the extent we wrote and fsync'ed before.
>> >> >>   touch $SCRATCH_MNT/bar
>> >> >>   $XFS_IO_PROG -c "fsync" $SCRATCH_MNT/bar
>> >> >>
>> >> >>   # As expected, before the crash/power failure, we should be able to see a file
>> >> >>   # with a size of 32Kb, with its first 5000 bytes having the value 0xaa and all
>> >> >>   # the remaining bytes with value 0x00.
>> >> >>   echo "File content before:"
>> >> >>   od -t x1 $SCRATCH_MNT/foo
>> >> >>
>> >> >>   # Simulate a crash/power loss.
>> >> >>   _load_flakey_table $FLAKEY_DROP_WRITES
>> >> >>   _unmount_flakey
>> >> >>
>> >> >>   _load_flakey_table $FLAKEY_ALLOW_WRITES
>> >> >>   _mount_flakey
>> >> >>
>> >> >>   # After mounting the fs again, the fsync log was replayed.
>> >> >>   # The expected result is to see a file with a size of 12Kb, with its first 8Kb
>> >> >>   # of data having the value 0xaa and its last 4Kb of data having a value of 0xcc.
>> >> >>   # The btrfs bug used to leave the file as it used te be as of the last
>> >> >>   # transaction commit - that is, with a size of 8Kb with all bytes having a
>> >> >>   # value of 0xaa.
>> >> >>   echo "File content after:"
>> >> >>   od -t x1 $SCRATCH_MNT/foo
>> >> >>
>> >> >> The test case for xfstests follows soon.
>> >> >>
>> >> >> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>> >> >> ---
>> >> >>
>> >> >> V2: Added missing assignment to max_key.type for directory inode case.
>> >> >>
>> >> >> V3: Fixed the test/clear bit logic so that the bits are only cleared
>> >> >>     if we aren't logging new names.
>> >> >>
>> >> >>  fs/btrfs/tree-log.c | 39 +++++++++++++++++++++++++++------------
>> >> >>  1 file changed, 27 insertions(+), 12 deletions(-)
>> >> >>
>> >> >> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
>> >> >> index b0fe52a..aa4ebea 100644
>> >> >> --- a/fs/btrfs/tree-log.c
>> >> >> +++ b/fs/btrfs/tree-log.c
>> >> >> @@ -4069,8 +4069,10 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
>> >> >>       if (S_ISDIR(inode->i_mode)) {
>> >> >>               int max_key_type = BTRFS_DIR_LOG_INDEX_KEY;
>> >> >>
>> >> >> -             if (inode_only == LOG_INODE_EXISTS)
>> >> >> -                     max_key_type = BTRFS_XATTR_ITEM_KEY;
>> >> >> +             if (inode_only == LOG_INODE_EXISTS) {
>> >> >> +                     max_key_type = BTRFS_INODE_EXTREF_KEY;
>> >> >> +                     max_key.type = max_key_type;
>> >> >> +             }
>> >> >>               ret = drop_objectid_items(trans, log, path, ino, max_key_type);
>> >> >>       } else {
>> >> >>               if (inode_only == LOG_INODE_EXISTS) {
>> >> >> @@ -4092,18 +4094,31 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
>> >> >>                       if (err)
>> >> >>                               goto out_unlock;
>> >> >>               }
>> >> >> -             if (test_and_clear_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
>> >> >> -                                    &BTRFS_I(inode)->runtime_flags)) {
>> >> >> -                     clear_bit(BTRFS_INODE_COPY_EVERYTHING,
>> >> >> -                               &BTRFS_I(inode)->runtime_flags);
>> >> >> -                     ret = btrfs_truncate_inode_items(trans, log,
>> >> >> -                                                      inode, 0, 0);
>> >> >> -             } else if (test_and_clear_bit(BTRFS_INODE_COPY_EVERYTHING,
>> >> >> -                                           &BTRFS_I(inode)->runtime_flags) ||
>> >> >> +             if (test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
>> >> >> +                          &BTRFS_I(inode)->runtime_flags)) {
>> >> >> +                     if (inode_only == LOG_INODE_EXISTS) {
>> >> >> +                             max_key.type = BTRFS_INODE_EXTREF_KEY;
>> >> >> +                             ret = drop_objectid_items(trans, log, path, ino,
>> >> >> +                                                       max_key.type);
>> >> >
>> >> > BTRFS_INODE_NEEDS_FULL_SYNC is set in several cases, one of them is
>> >> > 'evict inode and re-read', and this patch is made for truncate,
>> >> > can you make sure that there is no side effect in other cases?
>> >>
>> >> This patch is not made specifically for truncate. It's about logging
>> >> new names and its unexpected results for some cases, such as the given
>> >> example. The truncate example was used because it's one of the
>> >> simplest ways to ensure the inode gets the need_full_sync flag set
>> >> (other cases, such as when it's set due to extent map allocation
>> >> failure, aren't so convenient for testing).
>> >>
>> >> Yes, I verified other cases, both with need_full_sync and
>> >> copy_everything flags set. Didn't experience any problem.
>> >> If you have a specific scenario/test (or at least a hypothesis) where
>> >> this fails let me know.
>> >
>> > In the case 'get evicted and re-read', extent_maps of this inode are freeed and we've no idea
>> > about modified extents before the inode gets evict from cache, so if we
>> > bypass btrfs_truncate_inode_items() when LOG_INODE_EXISTS, how to
>> > determine which extent should be put into log tree?
>>
>> 1) inode is fsynced
>>
>> 2) write some new extents
>>
>> 3) inode is evicted
>>
>> 4) inode is loaded again (need_full_sync bit is set and
>> btrfs_inode->logged_trans == 0)
>>
>> 5) add a new name (hard link)
>>
>> 6) inode remains with the same extents in the log (those collected by
>> the first fsync)
>>
>> 7) fsync the inode - all new extents are added to the log -
>> need_full_sync bit is set and btrfs_inode->logged_trans == 0, making
>> btrfs_inode_in_log() always return false (0), btrfs_log_dentry_safe()
>> and btrfs_log_inode() get executed and the layer sees need_full_sync
>> bit set, dropping all the inode items from the log and collecting all
>> the new ones from the fs/subvol tree.
>>
>> What's the problem then?
>
> Step(5) also calls btrfs_log_inode(), where has

Right, which is why this change (and my previous one) were made...

>
>         BTRFS_I(inode)->logged_trans = trans->transid;
>         BTRFS_I(inode)->last_log_commit = BTRFS_I(inode)->last_sub_trans;
>
> Won't the above make it skip step(7)'s fsync?  Haven't confirmed it though.

It won't. That isn't enough to make btrfs_inode_in_log() return true.
As I mentioned before, when the inode is read it gets
btrfs_inode->logged_trans set to 0, that alone is enough to make
btrfs_inode_in_log() return false.

Perhaps the best is to have an actual test to exercise eviction and
test fsync behaves well. Regardless of this change, it's a useful test
to have.

thanks

>
>
> Thanks,
>
> -liubo
>
>>
>> thanks
>>
>>
>> >
>> > Thanks,
>> >
>> > -liubo
>> >>
>> >> thanks
>> >>
>> >> >
>> >> > Thanks,
>> >> >
>> >> > -liubo
>> >> >
>> >> >> +                     } else {
>> >> >> +                             clear_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
>> >> >> +                                       &BTRFS_I(inode)->runtime_flags);
>> >> >> +                             clear_bit(BTRFS_INODE_COPY_EVERYTHING,
>> >> >> +                                       &BTRFS_I(inode)->runtime_flags);
>> >> >> +                             ret = btrfs_truncate_inode_items(trans, log,
>> >> >> +                                                              inode, 0, 0);
>> >> >> +                     }
>> >> >> +             } else if (test_bit(BTRFS_INODE_COPY_EVERYTHING,
>> >> >> +                                 &BTRFS_I(inode)->runtime_flags) ||
>> >> >>                          inode_only == LOG_INODE_EXISTS) {
>> >> >> -                     if (inode_only == LOG_INODE_ALL)
>> >> >> +                     if (inode_only == LOG_INODE_ALL) {
>> >> >> +                             clear_bit(BTRFS_INODE_COPY_EVERYTHING,
>> >> >> +                                       &BTRFS_I(inode)->runtime_flags);
>> >> >>                               fast_search = true;
>> >> >> -                     max_key.type = BTRFS_XATTR_ITEM_KEY;
>> >> >> +                             max_key.type = BTRFS_XATTR_ITEM_KEY;
>> >> >> +                     } else {
>> >> >> +                             max_key.type = BTRFS_INODE_EXTREF_KEY;
>> >> >> +                     }
>> >> >>                       ret = drop_objectid_items(trans, log, path, ino,
>> >> >>                                                 max_key.type);
>> >> >>               } else {
>> >> >> --
>> >> >> 2.1.3
>> >> >>
>> >> >> --
>> >> >> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> >> >> the body of a message to majordomo@vger.kernel.org
>> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >> > --
>> >> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> >> > the body of a message to majordomo@vger.kernel.org
>> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >>
>> >>
>> >>
>> >> --
>> >> Filipe David Manana,
>> >>
>> >> "Reasonable men adapt themselves to the world.
>> >>  Unreasonable men adapt the world to themselves.
>> >>  That's why all progress depends on unreasonable men."
>>
>>
>>
>> --
>> Filipe David Manana,
>>
>> "Reasonable men adapt themselves to the world.
>>  Unreasonable men adapt the world to themselves.
>>  That's why all progress depends on unreasonable men."



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
