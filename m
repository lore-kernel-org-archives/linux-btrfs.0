Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13538 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751999AbbBFKxy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Feb 2015 05:53:54 -0500
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <fdmanana@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
References: <1423212122-12952-1-git-send-email-zhaolei@cn.fujitsu.com>	<1423212122-12952-3-git-send-email-zhaolei@cn.fujitsu.com> <CAL3q7H61kG20B66wKd52bbks2dYgsikst__kq+dzOG-jOAKXvw@mail.gmail.com>
In-Reply-To: <CAL3q7H61kG20B66wKd52bbks2dYgsikst__kq+dzOG-jOAKXvw@mail.gmail.com>
Subject: RE: [PATCH 2/2] btrfs: Set hole_size to free space in case of contains_pending_extent
Date: Fri, 6 Feb 2015 18:52:52 +0800
Message-ID: <006101d041fb$0e768730$2b639590$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Filipe
 
> This was already fixed by Forrest recently. See:
> https://patchwork.kernel.org/patch/5776231/
> 
Thanks for notice, I overlooked the second half of his patch...
Please ignore it.

Thanks
Zhaolei

> > ---
> >  fs/btrfs/volumes.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index 5cd0930..0cc9422 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -1194,8 +1194,12 @@ again:
> >                          */
> >                         if (contains_pending_extent(trans, device,
> >                                                     &search_start,
> > -                                                   hole_size))
> > -                               hole_size = 0;
> > +                                                   hole_size)) {
> > +                               if (search_start > key.offset)
> > +                                       hole_size = 0;
> > +                               else
> > +                                       hole_size = key.offset - search_start;
> > +                       }
> >
> >                         if (hole_size > max_hole_size) {
> >                                 max_hole_start = search_start;
> > --
> > 1.8.5.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> --
> Filipe David Manana,
> 
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."


