Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31077 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750932AbbKPKHp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Nov 2015 05:07:45 -0500
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <fdmanana@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
References: <786c7fb7179fe73f419c5ab9bea9f86d49510962.1447411735.git.zhaolei@cn.fujitsu.com> <CAL3q7H405kjq=aQ8WpAFZO0TLOVBoa6kTt29shnKHcFBrn9f3A@mail.gmail.com>
In-Reply-To: <CAL3q7H405kjq=aQ8WpAFZO0TLOVBoa6kTt29shnKHcFBrn9f3A@mail.gmail.com>
Subject: RE: [PATCH] btrfs: Continue replace when set_block_ro failed
Date: Mon, 16 Nov 2015 18:07:41 +0800
Message-ID: <00df01d12056$a1bcb430$e5361c90$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Filipe Manana

Thanks for review.

> -----Original Message-----
> From: Filipe Manana [mailto:fdmanana@gmail.com]
> Sent: Friday, November 13, 2015 8:02 PM
> To: Zhao Lei <zhaolei@cn.fujitsu.com>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH] btrfs: Continue replace when set_block_ro failed
> 
> On Fri, Nov 13, 2015 at 11:38 AM, Zhao Lei <zhaolei@cn.fujitsu.com> wrote:
> > xfstests/011 failed in node with small_size filesystem.
> > Can be reproduced by following script:
> >   DEV_LIST="/dev/vdd /dev/vde"
> >   DEV_REPLACE="/dev/vdf"
> >
> >   do_test()
> >   {
> >       local mkfs_opt="$1"
> >       local size="$2"
> >
> >       dmesg -c >/dev/null
> >       umount $SCRATCH_MNT &>/dev/null
> >
> >       echo  mkfs.btrfs -f $mkfs_opt "${DEV_LIST[*]}"
> >       mkfs.btrfs -f $mkfs_opt "${DEV_LIST[@]}" || return 1
> >       mount "${DEV_LIST[0]}" $SCRATCH_MNT
> >
> >       echo -n "Writing big files"
> >       dd if=/dev/urandom of=$SCRATCH_MNT/t0 bs=1M
> count=1 >/dev/null 2>&1
> >       for ((i = 1; i <= size; i++)); do
> >           echo -n .
> >           /bin/cp $SCRATCH_MNT/t0 $SCRATCH_MNT/t$i || return 1
> >       done
> >       echo
> >
> >       echo Start replace
> >       btrfs replace start -Bf "${DEV_LIST[0]}" "$DEV_REPLACE"
> $SCRATCH_MNT || {
> >           dmesg
> >           return 1
> >       }
> >       return 0
> >   }
> >
> >   # Set size to value near fs size
> >   # for example, 1897 can trigger this bug in 2.6G device.
> >   #
> >   ./do_test "-d raid1 -m raid1" 1897
> >
> > System will report replace fail with following warning in dmesg:
> >
> > Reason:
> >  When big data writen to fs, the whole free space will be allocated
> > for data chunk.
> >  And operation as scrub need to set_block_ro(), and when there is
> > only one metadata chunk in system(or other metadata chunks  are all
> > full), the function will try to allocate a new chunk,  and failed
> > because no space in device.
> >
> > Fix:
> >  When set_block_ro failed for metadata chunk, it is not a problem
> > because scrub_lock forbids commit_trancaction.
> 
> Hi Zhao, I'm confused reading this explanation.
> 
> Why isn't it a problem if the block group gets modified while the transaction is
> ongoing? Through writepages() for example.
> Committing a transaction isn't the only way to write data or metadata to a
> block group.
> 
Metadata chunks always updated in cow, the writepages() will write
new data to different place with operation done by replace.

Thanks
Zhaolei

> thanks
> 
> >  Let replace continue in this case is no problem.
> >
> > Tested by above script, and xfstests/011, plus 100 times xfstests/070.
> >
> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> > ---
> >  fs/btrfs/scrub.c | 9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c index
> > a39f5d1..5a30753 100644
> > --- a/fs/btrfs/scrub.c
> > +++ b/fs/btrfs/scrub.c
> > @@ -3532,6 +3532,7 @@ int scrub_enumerate_chunks(struct scrub_ctx
> *sctx,
> >         u64 length;
> >         u64 chunk_offset;
> >         int ret = 0;
> > +       int ro_set = 0;
> >         int slot;
> >         struct extent_buffer *l;
> >         struct btrfs_key key;
> > @@ -3617,10 +3618,7 @@ int scrub_enumerate_chunks(struct scrub_ctx
> *sctx,
> >                 scrub_pause_on(fs_info);
> >                 ret = btrfs_inc_block_group_ro(root, cache);
> >                 scrub_pause_off(fs_info);
> > -               if (ret) {
> > -                       btrfs_put_block_group(cache);
> > -                       break;
> > -               }
> > +               ro_set = !ret;
> >
> >                 dev_replace->cursor_right = found_key.offset + length;
> >                 dev_replace->cursor_left = found_key.offset; @@
> > -3660,7 +3658,8 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
> >
> >                 scrub_pause_off(fs_info);
> >
> > -               btrfs_dec_block_group_ro(root, cache);
> > +               if (ro_set)
> > +                       btrfs_dec_block_group_ro(root, cache);
> >
> >                 btrfs_put_block_group(cache);
> >                 if (ret)
> > --
> > 1.8.5.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
> > in the body of a message to majordomo@vger.kernel.org More majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> --
> Filipe David Manana,
> 
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."

