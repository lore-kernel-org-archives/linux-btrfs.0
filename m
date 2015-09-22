Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:33774 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbbIVMpI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 08:45:08 -0400
Received: by iofh134 with SMTP id h134so13418060iof.0
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2015 05:45:06 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <010401d0f529$4db27670$e9176350$@cn.fujitsu.com>
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>
	<CAL3q7H5o-gprcTGz5hNGdvoQNR7h55+tOsiM9CK27fA_61_7KQ@mail.gmail.com>
	<00fc01d0f51e$5528ddf0$ff7a99d0$@cn.fujitsu.com>
	<CAL3q7H5=ZnEav6CHAGW+oUwNJAuoYcxcBmHQG9Ssa_gaMDTh7w@mail.gmail.com>
	<010401d0f529$4db27670$e9176350$@cn.fujitsu.com>
Date: Tue, 22 Sep 2015 13:45:06 +0100
Message-ID: <CAL3q7H5wAH_qJLvdT-8Hg5p--Ju89ENMPsAZu=zB1yEqaoqMfg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
From: Filipe David Manana <fdmanana@gmail.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 22, 2015 at 12:24 PM, Zhao Lei <zhaolei@cn.fujitsu.com> wrote:
> Hi, Filipe David Manana
>
>> -----Original Message-----
>> From: linux-btrfs-owner@vger.kernel.org
>> [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Filipe David Manana
>> Sent: Tuesday, September 22, 2015 6:22 PM
>> To: Zhao Lei <zhaolei@cn.fujitsu.com>
>> Cc: linux-btrfs@vger.kernel.org
>> Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
>>
>> On Tue, Sep 22, 2015 at 11:06 AM, Zhao Lei <zhaolei@cn.fujitsu.com> wrote:
>> > Hi, Filipe David Manana
>> >
>> > Thanks for review this patch.
>> >
>> >> -----Original Message-----
>> >> From: Filipe David Manana [mailto:fdmanana@gmail.com]
>> >> Sent: Monday, September 21, 2015 9:27 PM
>> >> To: Zhao Lei <zhaolei@cn.fujitsu.com>
>> >> Cc: linux-btrfs@vger.kernel.org
>> >> Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
>> >>
>> >> On Mon, Sep 21, 2015 at 1:59 PM, Zhao Lei <zhaolei@cn.fujitsu.com>
>> wrote:
>> >> > btrfs in v4.3-rc1 failed many xfstests items with '-o nospace_cache'
>> >> > mount option.
>> >> >
>> >> > Failed cases are:
>> >> >
>> >> > btrfs/008,016,019,020,026,027,028,029,031,041,046,048,050,051,053,0
>> >> > 54,
>> >> >  077,083,084,087,092,094
>> >>
>> >> Hi Zhao,
>> >>
>> >> So far I tried a few of those against Chris' integration-4.3 branch
>> >> (same btrfs code as 4.3-rc1):
>> >>
>> >> MOUNT_OPTIONS="-o nospace_cache" ./check btrfs/008 btrfs/016
>> >> btrfs/019
>> >> btrfs/020
>> >> FSTYP         -- btrfs
>> >> PLATFORM      -- Linux/x86_64 debian3 4.2.0-rc5-btrfs-next-12+
>> >> MKFS_OPTIONS  -- /dev/sdc
>> >> MOUNT_OPTIONS -- -o nospace_cache /dev/sdc
>> >> /home/fdmanana/btrfs-tests/scratch_1
>> >>
>> >> btrfs/008 2s ... 1s
>> >> btrfs/016 4s ... 3s
>> >> btrfs/019 4s ... 2s
>> >> btrfs/020 2s ... 1s
>> >> Ran: btrfs/008 btrfs/016 btrfs/019 btrfs/020 Passed all 4 tests
>> >>
>> >> And none of the tests failed...
>> >>
>> > Sorry I hadn't paste detail of my test command.
>> >
>> > It is from a coincidence operation which is some different with
>> > standard steps(as yours), I mount fs with -o no_space_cache manually
>> > without set MOUNT_OPT, then xfstests entered into a special path, and
>> triggered the bug:
>> >   export TEST_DEV='/dev/sdb5'
>> >   export TEST_DIR='/var/ltf/tester/mnt'
>> >   mkdir -p '/var/ltf/tester/mnt'
>> >
>> >   export SCRATCH_DEV_POOL='/dev/sdb6 /dev/sdb7 /dev/sdb8 /dev/sdb9
>> /dev/sdb10 /dev/sdb11'
>> >   export SCRATCH_MNT='/var/ltf/tester/scratch_mnt'
>> >   mkdir -p '/var/ltf/tester/scratch_mnt'
>> >
>> >   export DIFF_LENGTH=0
>> >
>> >   mkfs.btrfs -f "$TEST_DEV"
>> >   mount -o nospace_cache "$TEST_DEV" "$TEST_DIR"
>> >
>> >   ./check generic/014
>> >
>> > Result:
>> >   FSTYP         -- btrfs
>> >   PLATFORM      -- Linux/x86_64 lenovo
>> 4.3.0-rc2_HEAD_1f93e4a96c9109378204c147b3eec0d0e8100fde_
>> >   MKFS_OPTIONS  -- /dev/sdb6
>> >   MOUNT_OPTIONS -- /dev/sdb6 /var/ltf/tester/scratch_mnt
>> >
>> >   generic/014 0s ... - output mismatch (see
>> /var/lib/xfstests/results//generic/014.out.bad)
>> >       --- tests/generic/014.out   2015-09-22 17:46:13.855391451 +0800
>> >       +++ /var/lib/xfstests/results//generic/014.out.bad  2015-09-22
>> 17:57:06.446095748 +0800
>> >       @@ -3,4 +3,5 @@
>> >        ------
>> >        test 1
>> >        ------
>> >       -OK
>> >       +truncfile returned 1 : "write: No space left on device
>> >       +Seed = 1442915826 (use "-s 1442915826" to re-execute this test)"
>> >   Ran: generic/014
>> >   Failures: generic/014
>> >   Failed 1 of 1 tests
>> >
>> > And following script is from trace result of above test.
>> > Maybe I can remove the xfstest description because it is not standard steps.
>> >
>> >> >
>> >> > generic/004,010,014,023,024,074,075,080,086,087,089,091,092,100,112
>> >> > ,12
>> >> > 3,
>> >> > 124,125,126,127,131,133,192,193,198,207,208,209,213,214,215,228,239
>> >> > ,24
>> >> > 0,
>> >> >  246,247,248,255,263,285,306,313,316,323
>> >> >
>> >> > We can reproduce this bug with following simple command:
>> >> >  TEST_DEV=/dev/vdh
>> >> >  TEST_DIR=/mnt/tmp
>> >> >
>> >> >  umount "$TEST_DEV" >/dev/null
>> >> >  mkfs.btrfs -f "$TEST_DEV"
>> >> >  mount "$TEST_DEV" "$TEST_DIR"
>> >> >
>> >> >  umount "$TEST_DEV"
>> >> >  mount "$TEST_DEV" "$TEST_DIR"
>> >> >
>> >> >  cp /bin/bash $TEST_DIR
>> >> >
>> >> > Result is:
>> >> >  (omit previous commands)
>> >> >  # cp /bin/bash $TEST_DIR
>> >> >  cp: writing `/mnt/tmp/bash': No space left on device
>> >> >
>> >> > By bisect, we can see it is triggered by patch titled:
>> >> >  commit e44163e17796
>> >> >  ("btrfs: explictly delete unused block groups in close_ctree and
>> >> > ro-remount")
>> >> >
>> >> > But the wrong code is not in above patch, btrfs delete all chunks
>> >> > if no data in filesystem, and above patch just make it obviously.
>> >> >
>> >> > Detail reason:
>> >> >  1: mkfs a blank filesystem, or delete everything in filesystem
>> >> >  2: umount fs
>> >> >     (current code will delete all data chunks)
>> >> >  3: mount fs
>> >> >     Because no any data chunks, data's space_cache have no chance
>> >> >     to init, it means: space_info->total_bytes == 0, and
>> >> >     space_info->full == 1.
>> >>
>> >> Right, and that's the problem. When the space_info is initialized it
>> >> should never be flagged as full, otherwise any buffered write
>> >> attempts fail immediately with enospc instead of trying to allocate a
>> >> data block group (at extent-tree.c:btrfs_check_data_free_space()).
>> >>
>> >> That was fixed recently by:
>> >>
>> >> https://patchwork.kernel.org/patch/7133451/
>> >>
>> >> (with a respective test too,
>> >> https://patchwork.kernel.org/patch/7133471/)
>> >>
>> >
>> > It can fix problem in mount, but can not fix problem of "raid-level
>> > change", please see below.
>> >
>> >> >  4: do some write
>> >> >     Current code will ignore chunk allocate because space_info->full,
>> >> >     and return -ENOSPC.
>> >> >
>> >> > Fix:
>> >> >  Don't auto-delete last blockgroup for a raid type.
>> >> >  If we delete all blockgroup for a raidtype, it not only cause
>> >> > above bug,  but also may change filesystem to all-single in some case.
>> >>
>> >> I don't get this. Can you mention in which cases that happens and why
>> >> (in the commit message)?
>> >>
>> >> It isn't clear when reading the patch why we need to keep at least
>> >> one block of each type/profile, and seems to be a workaround for a different
>> problem.
>> >>
>> > Simply speaking, if we run following command after apply your patch:
>> >
>> >   TEST_DEV=(/dev/vdg /dev/vdh)
>> >   TEST_DIR=/mnt/tmp
>> >
>> >   umount "$TEST_DEV" >/dev/null
>> >   mkfs.btrfs -f -d raid1 "${TEST_DEV[@]}"
>> >   mount -o nospace_cache "$TEST_DEV" "$TEST_DIR"
>> >
>> >   umount "$TEST_DEV"
>> >   mount -o nospace_cache "$TEST_DEV" "$TEST_DIR"
>> >
>> >   btrfs filesystem usage $TEST_DIR
>> >
>> > The result is:
>> >   # btrfs filesystem usage $TEST_DIR
>> >   (omit)
>> >   Data,single: Size:8.00MiB, Used:0.00B
>> >      /dev/vdg        8.00MiB
>> >   ...
>> >
>> > We can see data chunk is changed from raid1 to single, because if we
>> > delete all data chunks before mount, there are raid-type information
>> > in filesystem, and btrfs will use raid-type of "0x0" for new data
>> > chunk after your patch.
>> >
>> > So, leave at least one data chunk is a simple workaround for above two
>> > bug.
>>
>> Well it's a hack that besides not being very logical it's also incomplete and
>> unreliable: preventing the cleaner kthread (automatic removal of unused block
>> groups) from deleting the last block group of a kind doesn't prevent the block
>> group from being deleted by a balance, just as the new regression xfstest
>> does...
>>
>
> What this patch fixed is regression caused by patch
> of "auto-remove-bg-at-umount".

Well no, that patch did not introduce any problem so far... It only
exposes more easily a problem that exists for a long time...

>
> And the balance problem is another bug, which should be fixed by
> another patch.
>
>> In other words, the problem existed before we had automatic removal of
>> unused block groups, but just less likely for someone to run into it.
>>
>> So please lets have a real fix for this problem. Seems like we're losing raid
>> profile type somewhere when allocating a new block group.
>>
> I think way of "remain last bg" is not a hack way, just like we create
> one blank data chunk in mkfs.
>
> In detail, maybe "writing raidtype in disk" is more direct way,
> but it will change our disk data format(as superblock),
> and need change lots of code as chunk-allocate, balance, mkfs, check, or more.
> plus of compatibility with old filesystem.
>
> So the way in this patch maybe the most suit for above bug.



At the very least this patch should have its title and description
changed - to reflect that it attempts to solve only (and partially)
the problem of losing raid profile type. Because the enospc issue is
not caused by not having any data block group allocated, but it's
instead due to a recent regression when initializing a space_info
object as full, as described and proved in the patch mentioned before
[1] - you could run into the enospc issue even without having the
automatic removal of empty block groups or the patch [2] introduced in
4.3 (just try the new xfstest [3] to verify it yourself).

[1] https://patchwork.kernel.org/patch/7133451/
[2] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=e44163e177960ee60e32a73bffdd53c3a5827406
[3] https://git.kernel.org/cgit/fs/xfs/xfstests-dev.git/commit/?id=da82741228c7efaedae2e027efc54b1892800fe1

>
> Thanks
> Zhaolei
>
>> thanks
>>
>>
>> >
>> > Thanks
>> > Zhaolei
>> >
>> >> thanks
>> >>
>> >> >
>> >> > Test:
>> >> >  Test by above script, and confirmed the logic by debug output.
>> >> >
>> >> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
>> >> > ---
>> >> >  fs/btrfs/extent-tree.c | 3 ++-
>> >> >  1 file changed, 2 insertions(+), 1 deletion(-)
>> >> >
>> >> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c index
>> >> > 5411f0a..35cf7eb 100644
>> >> > --- a/fs/btrfs/extent-tree.c
>> >> > +++ b/fs/btrfs/extent-tree.c
>> >> > @@ -10012,7 +10012,8 @@ void btrfs_delete_unused_bgs(struct
>> >> btrfs_fs_info *fs_info)
>> >> >                                                bg_list);
>> >> >                 space_info = block_group->space_info;
>> >> >                 list_del_init(&block_group->bg_list);
>> >> > -               if (ret || btrfs_mixed_space_info(space_info)) {
>> >> > +               if (ret || btrfs_mixed_space_info(space_info) ||
>> >> > +                   block_group->list.next ==
>> >> > + block_group->list.prev) {
>> >> >                         btrfs_put_block_group(block_group);
>> >> >                         continue;
>> >> >                 }
>> >> > --
>> >> > 1.8.5.1
>> >> >
>> >> > --
>> >> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>> >> > in the body of a message to majordomo@vger.kernel.org More
>> >> > majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >>
>> >>
>> >>
>> >> --
>> >> Filipe David Manana,
>> >>
>> >> "Reasonable men adapt themselves to the world.
>> >>  Unreasonable men adapt the world to themselves.
>> >>  That's why all progress depends on unreasonable men."
>> >
>>
>>
>>
>> --
>> Filipe David Manana,
>>
>> "Reasonable men adapt themselves to the world.
>>  Unreasonable men adapt the world to themselves.
>>  That's why all progress depends on unreasonable men."
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body
>> of a message to majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
