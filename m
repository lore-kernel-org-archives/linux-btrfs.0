Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:33384 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbbKPK5W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Nov 2015 05:57:22 -0500
Received: by igvi2 with SMTP id i2so72981742igv.0
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 02:57:21 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <00e001d1205b$d37fb5d0$7a7f2170$@cn.fujitsu.com>
References: <786c7fb7179fe73f419c5ab9bea9f86d49510962.1447411735.git.zhaolei@cn.fujitsu.com>
	<CAL3q7H405kjq=aQ8WpAFZO0TLOVBoa6kTt29shnKHcFBrn9f3A@mail.gmail.com>
	<00df01d12056$a1bcb430$e5361c90$@cn.fujitsu.com>
	<CAL3q7H6FB4H_Gmyfe1oqp7MQQocVBwQ6asKJACxqqBEMGe79Yw@mail.gmail.com>
	<00e001d1205b$d37fb5d0$7a7f2170$@cn.fujitsu.com>
Date: Mon, 16 Nov 2015 10:57:21 +0000
Message-ID: <CAL3q7H4dJWhBgwggt6KXSoiSE1yyHAVe4fb51iWYA+=8GbN-8Q@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Continue replace when set_block_ro failed
From: Filipe Manana <fdmanana@gmail.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 16, 2015 at 10:44 AM, Zhao Lei <zhaolei@cn.fujitsu.com> wrote:
> Hi, Filipe Manana
>
>> -----Original Message-----
>> From: linux-btrfs-owner@vger.kernel.org
>> [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Filipe Manana
>> Sent: Monday, November 16, 2015 6:27 PM
>> To: Zhao Lei <zhaolei@cn.fujitsu.com>
>> Cc: linux-btrfs@vger.kernel.org
>> Subject: Re: [PATCH] btrfs: Continue replace when set_block_ro failed
>>
>> On Mon, Nov 16, 2015 at 10:07 AM, Zhao Lei <zhaolei@cn.fujitsu.com> wrote:
>> > Hi, Filipe Manana
>> >
>> > Thanks for review.
>> >
>> >> -----Original Message-----
>> >> From: Filipe Manana [mailto:fdmanana@gmail.com]
>> >> Sent: Friday, November 13, 2015 8:02 PM
>> >> To: Zhao Lei <zhaolei@cn.fujitsu.com>
>> >> Cc: linux-btrfs@vger.kernel.org
>> >> Subject: Re: [PATCH] btrfs: Continue replace when set_block_ro failed
>> >>
>> >> On Fri, Nov 13, 2015 at 11:38 AM, Zhao Lei <zhaolei@cn.fujitsu.com> wrote:
>> >> > xfstests/011 failed in node with small_size filesystem.
>> >> > Can be reproduced by following script:
>> >> >   DEV_LIST="/dev/vdd /dev/vde"
>> >> >   DEV_REPLACE="/dev/vdf"
>> >> >
>> >> >   do_test()
>> >> >   {
>> >> >       local mkfs_opt="$1"
>> >> >       local size="$2"
>> >> >
>> >> >       dmesg -c >/dev/null
>> >> >       umount $SCRATCH_MNT &>/dev/null
>> >> >
>> >> >       echo  mkfs.btrfs -f $mkfs_opt "${DEV_LIST[*]}"
>> >> >       mkfs.btrfs -f $mkfs_opt "${DEV_LIST[@]}" || return 1
>> >> >       mount "${DEV_LIST[0]}" $SCRATCH_MNT
>> >> >
>> >> >       echo -n "Writing big files"
>> >> >       dd if=/dev/urandom of=$SCRATCH_MNT/t0 bs=1M
>> >> count=1 >/dev/null 2>&1
>> >> >       for ((i = 1; i <= size; i++)); do
>> >> >           echo -n .
>> >> >           /bin/cp $SCRATCH_MNT/t0 $SCRATCH_MNT/t$i || return 1
>> >> >       done
>> >> >       echo
>> >> >
>> >> >       echo Start replace
>> >> >       btrfs replace start -Bf "${DEV_LIST[0]}" "$DEV_REPLACE"
>> >> $SCRATCH_MNT || {
>> >> >           dmesg
>> >> >           return 1
>> >> >       }
>> >> >       return 0
>> >> >   }
>> >> >
>> >> >   # Set size to value near fs size
>> >> >   # for example, 1897 can trigger this bug in 2.6G device.
>> >> >   #
>> >> >   ./do_test "-d raid1 -m raid1" 1897
>> >> >
>> >> > System will report replace fail with following warning in dmesg:
>> >> >
>> >> > Reason:
>> >> >  When big data writen to fs, the whole free space will be allocated
>> >> > for data chunk.
>> >> >  And operation as scrub need to set_block_ro(), and when there is
>> >> > only one metadata chunk in system(or other metadata chunks  are all
>> >> > full), the function will try to allocate a new chunk,  and failed
>> >> > because no space in device.
>> >> >
>> >> > Fix:
>> >> >  When set_block_ro failed for metadata chunk, it is not a problem
>> >> > because scrub_lock forbids commit_trancaction.
>> >>
>> >> Hi Zhao, I'm confused reading this explanation.
>> >>
>> >> Why isn't it a problem if the block group gets modified while the
>> >> transaction is ongoing? Through writepages() for example.
>> >> Committing a transaction isn't the only way to write data or metadata
>> >> to a block group.
>> >>
>> > Metadata chunks always updated in cow, the writepages() will write new
>> > data to different place with operation done by replace.
>>
>> So why do we try to set the block group ro? Your change is really confusing - if
>> we fail setting the block group to read-only mode, we just ignore it and proceed
>> - why bother in the first place to set it read-only?
>>
> I find a problem that set_group_ro will failed for metadata when disk almost full,
> but we also have a good news that the time when set_group_ro failed is
> just when it is not necessary.

Yes - but the code will ignore the failure for any error code, not
just -ENOSPC. Surely btrfs_inc_block_group_ro() can return error codes
different from -ENOSPC. You should make it clear in the code (and in
the change log) why ENOSPC is such a special case - why we need to set
the block to RO and why we can ignore the ENOSPC failure.

>
>> Someone reading the code will find it fishy, and going back to git history,
>> your change log doesn't really explains why this is being done and why is
>> it safe to do it.
>>
> Thanks for notice, it is necessary to add detail explanation into changelog.
>
>> You also forgot to paste the warning you mention below "System will report
>> replace fail with following warning in dmesg:" in the change log.
>>
> Agree, I'll paste it in changelog.
>
> Thanks
> Zhaolei
>
>> thanks
>>
>> >
>> > Thanks
>> > Zhaolei
>> >
>> >> thanks
>> >>
>> >> >  Let replace continue in this case is no problem.
>> >> >
>> >> > Tested by above script, and xfstests/011, plus 100 times xfstests/070.
>> >> >
>> >> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
>> >> > ---
>> >> >  fs/btrfs/scrub.c | 9 ++++-----
>> >> >  1 file changed, 4 insertions(+), 5 deletions(-)
>> >> >
>> >> > diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c index
>> >> > a39f5d1..5a30753 100644
>> >> > --- a/fs/btrfs/scrub.c
>> >> > +++ b/fs/btrfs/scrub.c
>> >> > @@ -3532,6 +3532,7 @@ int scrub_enumerate_chunks(struct scrub_ctx
>> >> *sctx,
>> >> >         u64 length;
>> >> >         u64 chunk_offset;
>> >> >         int ret = 0;
>> >> > +       int ro_set = 0;
>> >> >         int slot;
>> >> >         struct extent_buffer *l;
>> >> >         struct btrfs_key key;
>> >> > @@ -3617,10 +3618,7 @@ int scrub_enumerate_chunks(struct scrub_ctx
>> >> *sctx,
>> >> >                 scrub_pause_on(fs_info);
>> >> >                 ret = btrfs_inc_block_group_ro(root, cache);
>> >> >                 scrub_pause_off(fs_info);
>> >> > -               if (ret) {
>> >> > -                       btrfs_put_block_group(cache);
>> >> > -                       break;
>> >> > -               }
>> >> > +               ro_set = !ret;
>> >> >
>> >> >                 dev_replace->cursor_right = found_key.offset +
>> length;
>> >> >                 dev_replace->cursor_left = found_key.offset; @@
>> >> > -3660,7 +3658,8 @@ int scrub_enumerate_chunks(struct scrub_ctx
>> >> > *sctx,
>> >> >
>> >> >                 scrub_pause_off(fs_info);
>> >> >
>> >> > -               btrfs_dec_block_group_ro(root, cache);
>> >> > +               if (ro_set)
>> >> > +                       btrfs_dec_block_group_ro(root, cache);
>> >> >
>> >> >                 btrfs_put_block_group(cache);
>> >> >                 if (ret)
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
