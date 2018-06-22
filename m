Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:56735 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751998AbeFVPSJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 11:18:09 -0400
MIME-Version: 1.0
Message-ID: <trinity-edf3d825-3811-438e-b2bb-1516219506d1-1529680663501@3c-app-mailcom-bs09>
From: "Su Yue" <Damenly_Su@gmx.com>
To: nborisov@suse.com, linux-btrfs@vger.kernel.org
Cc: "Su Yue" <suy.fnst@cn.fujitsu.com>
Subject: Re: Fwd: [PATCH] btrfs: Add more details while checking tree block
Content-Type: text/plain; charset=UTF-8
Date: Fri, 22 Jun 2018 17:17:43 +0200
In-Reply-To: <CABnRu560BS0NDcuEEfexR-vkqTOMpUkAB0bWYSM8G2957yTm6w@mail.gmail.com>
References: <20180622015215.31812-1-suy.fnst@cn.fujitsu.com>
 <7b34f539-ef57-ecb3-37c8-7b3759874249@suse.com>
 <CABnRu560BS0NDcuEEfexR-vkqTOMpUkAB0bWYSM8G2957yTm6w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> From: Nikolay Borisov <nborisov@suse.com>
> Date: Fri, Jun 22, 2018 at 7:49 PM
> Subject: Re: [PATCH] btrfs: Add more details while checking tree block
> To: Su Yue <suy.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
> 
> 
> 
> 
> On 22.06.2018 04:52, Su Yue wrote:
> > For easier debug, print eb->start if level is invalid.
> > Also make print clear if bytenr found is not expected.
> >
> > Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> > ---
> >  fs/btrfs/disk-io.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index c3504b4d281b..a90dab84f41b 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -615,8 +615,8 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
> >
> >       found_start = btrfs_header_bytenr(eb);
> >       if (found_start != eb->start) {
> > -             btrfs_err_rl(fs_info, "bad tree block start %llu %llu",
> > -                          found_start, eb->start);
> > +             btrfs_err_rl(fs_info, "bad tree block start want %llu have %llu",
> 
> nit: I'd rather have the want/have in brackets (want %llu have% llu)
> 
Hmmm... Here the output message is short enough, so I think there is no
need for brackets. 
And searching for word "want" in disk_io.c , there are no brackets too.

Thanks,
Su
> > +                          eb->start, found_start);
> >               ret = -EIO;
> >               goto err;
> >       }
> > @@ -628,8 +628,8 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
> >       }
> >       found_level = btrfs_header_level(eb);
> >       if (found_level >= BTRFS_MAX_LEVEL) {
> > -             btrfs_err(fs_info, "bad tree block level %d",
> > -                       (int)btrfs_header_level(eb));
> > +             btrfs_err(fs_info, "bad tree block level %d on %llu",
> > +                       (int)btrfs_header_level(eb), eb->start);
> >               ret = -EIO;
> >               goto err;
> >       }
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
