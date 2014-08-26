Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:45984 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaHZGp0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Aug 2014 02:45:26 -0400
Date: Mon, 25 Aug 2014 23:45:22 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs: btrfs: fix potential overflow
Message-ID: <20140826064522.GD3246@norris-Latitude-E6410>
References: <1408858881-30497-1-git-send-email-computersforpeace@gmail.com>
 <CAGqmi757Husduwnis_ci_z1Z-6tjCuOHDHt0dx=jBquguzrFbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGqmi757Husduwnis_ci_z1Z-6tjCuOHDHt0dx=jBquguzrFbA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 24, 2014 at 12:44:11PM +0300, Timofey Titovets wrote:
> 2014-08-24 8:41 GMT+03:00 Brian Norris <computeaboversforpeace@gmail.com>:
> > --- a/fs/btrfs/scrub.c
> > +++ b/fs/btrfs/scrub.c
> > @@ -2320,26 +2320,26 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
> >         do_div(nstripes, map->stripe_len);
> >         if (map->type & BTRFS_BLOCK_GROUP_RAID0) {
> >                 offset = map->stripe_len * num;
> > -               increment = map->stripe_len * map->num_stripes;
> > +               increment *= map->num_stripes;
> >                 mirror_num = 1;
> >         } else if (map->type & BTRFS_BLOCK_GROUP_RAID10) {
> >                 int factor = map->num_stripes / map->sub_stripes;
> >                 offset = map->stripe_len * (num / map->sub_stripes);
> > -               increment = map->stripe_len * factor;
> > +               increment *= factor;
> >                 mirror_num = num % map->sub_stripes + 1;
> >         } else if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
> > -               increment = map->stripe_len;
> > +               increment *= 1;
> Why? I think multiple by one is useless or i miss something?

A misguided attempt to keep the code structure intact. I'll drop these
for v2.

[snip]

Thanks,
Brian
