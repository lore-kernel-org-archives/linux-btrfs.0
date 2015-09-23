Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39840 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752217AbbIWB7Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 21:59:24 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <fdmanana@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>	<CAL3q7H5o-gprcTGz5hNGdvoQNR7h55+tOsiM9CK27fA_61_7KQ@mail.gmail.com>	<00fc01d0f51e$5528ddf0$ff7a99d0$@cn.fujitsu.com>	<CAL3q7H5=ZnEav6CHAGW+oUwNJAuoYcxcBmHQG9Ssa_gaMDTh7w@mail.gmail.com>	<010401d0f529$4db27670$e9176350$@cn.fujitsu.com> <CAL3q7H5wAH_qJLvdT-8Hg5p--Ju89ENMPsAZu=zB1yEqaoqMfg@mail.gmail.com>
In-Reply-To: <CAL3q7H5wAH_qJLvdT-8Hg5p--Ju89ENMPsAZu=zB1yEqaoqMfg@mail.gmail.com>
Subject: RE: [PATCH] btrfs: Fix no space bug caused by removing bg
Date: Wed, 23 Sep 2015 09:59:21 +0800
Message-ID: <022c01d0f5a3$76f29c70$64d7d550$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Filipe David Manana

> -----Original Message-----
> At the very least this patch should have its title and description changed - to
> reflect that it attempts to solve only (and partially) the problem of losing raid
> profile type.
>
When I found the bug in testing v4.3-rc1, the only error message is "no space",
and there are no way to trigger problem of "losing raid profile type" in
v4.3-rc1, this is why this patch titled "fix no space bug".

Now I need to update title, because your patch is already in integration-4.3,
so in the apply point of this patch, the bug will changed to "losing raid profile type"

> Because the enospc issue is not caused by not having any data
> block group allocated, but it's instead due to a recent regression when
> initializing a space_info object as full, as described and proved in the patch
> mentioned before [1].
>
The space_info->full is direct reason, but not root reason.

"remove all block groups" will cause the file system lost all raidtype information,
in this case, we have no way to get raid type again in mount time.
Neither "return no space in write" nor "create single-type chunk" can not help
user to restore filesystem into right state.

> - you could run into the enospc issue even without having
> the automatic removal of empty block groups or the patch [2] introduced in
> 4.3 (just try the new xfstest [3] to verify it yourself).
> 
Yes, balance operation can also delete all block groups in some case.
It is problem of balance code

Thanks
Zhaolei

> [1] https://patchwork.kernel.org/patch/7133451/
> [2]
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=e441
> 63e177960ee60e32a73bffdd53c3a5827406
> [3]
> https://git.kernel.org/cgit/fs/xfs/xfstests-dev.git/commit/?id=da82741228c7ef
> aedae2e027efc54b1892800fe1
> 
> >
> > Thanks
> > Zhaolei
> >
> >> thanks
> >>
> >>
> >> >
> >> > Thanks
> >> > Zhaolei
> >> >
> >> >> thanks
> >> >>
> >> >> >
> >> >> > Test:
> >> >> >  Test by above script, and confirmed the logic by debug output.
> >> >> >
> >> >> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> >> >> > ---
> >> >> >  fs/btrfs/extent-tree.c | 3 ++-
> >> >> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >> >> >
> >> >> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> >> >> > index 5411f0a..35cf7eb 100644
> >> >> > --- a/fs/btrfs/extent-tree.c
> >> >> > +++ b/fs/btrfs/extent-tree.c
> >> >> > @@ -10012,7 +10012,8 @@ void btrfs_delete_unused_bgs(struct
> >> >> btrfs_fs_info *fs_info)
> >> >> >                                                bg_list);
> >> >> >                 space_info = block_group->space_info;
> >> >> >                 list_del_init(&block_group->bg_list);
> >> >> > -               if (ret || btrfs_mixed_space_info(space_info)) {
> >> >> > +               if (ret || btrfs_mixed_space_info(space_info) ||
> >> >> > +                   block_group->list.next ==
> >> >> > + block_group->list.prev) {
> >> >> >                         btrfs_put_block_group(block_group);
> >> >> >                         continue;
> >> >> >                 }
> >> >> > --
> >> >> > 1.8.5.1
> >> >> >
> >> >> > --
> >> >> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
> >> >> > in the body of a message to majordomo@vger.kernel.org More
> >> >> > majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> >>
> >> >>
> >> >>
> >> >> --
> >> >> Filipe David Manana,
> >> >>
> >> >> "Reasonable men adapt themselves to the world.
> >> >>  Unreasonable men adapt the world to themselves.
> >> >>  That's why all progress depends on unreasonable men."
> >> >
> >>
> >>
> >>
> >> --
> >> Filipe David Manana,
> >>
> >> "Reasonable men adapt themselves to the world.
> >>  Unreasonable men adapt the world to themselves.
> >>  That's why all progress depends on unreasonable men."
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe
> >> linux-btrfs" in the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> 
> --
> Filipe David Manana,
> 
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."

