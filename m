From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Grow btrfs partition & filesystem backwards
Date: Wed, 9 Nov 2011 08:36:24 -0500
Message-ID: <20111109133624.GO4149@shiny>
References: <CACCfv7obU+-13+Z7-S-N_y8etdJZxyw_csZBD5Ran62xW6tgWA@mail.gmail.com>
 <CAD=4a=V0L_QXW=BNxvQVk5MEZn2quCif=Wy1RioGydBP4oK-9w@mail.gmail.com>
 <CANZ96zWM-AuOc9OddyHPrVyQdOpGHqXC3twyGhsZFA=EZpDjUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Ernst =?iso-8859-1?Q?Sj=F6strand?= <ernstp@gmail.com>,
	Jordan Windsor <jordanw2@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Billy Crook <billycrook@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CANZ96zWM-AuOc9OddyHPrVyQdOpGHqXC3twyGhsZFA=EZpDjUQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

The only choice for an online operation is to make a new partition in
front of the old one and just add that as a second disk in btrfs.

The slow method of shifting the bytes down is probably a better long
term choice.

-chris

On Wed, Nov 09, 2011 at 06:40:06AM -0600, Billy Crook wrote:
> I think the biggest point of contention is that with all the stuff
> going on in the background in btrfs, its difficult to be sure that th=
e
> resize operation has completed.  With grows, you don't have to worry.
> With shrinks, if you truncate the block device too soon, you will
> corrupt the filesystem.
>=20
> 2011/11/9 Ernst Sj=F6strand <ernstp@gmail.com>:
> > Gparted can do that, it just takes a very long time because it move=
s
> > everything back first.
> >
> > Regards
> > //Ernst
> >
> > On Wed, Nov 9, 2011 at 05:23, Jordan Windsor <jordanw2@gmail.com> w=
rote:
> >> Hello,
> >> I was wondering how I would go about growing a btrfs filesystem
> >> backwards, I don't have any space to store the files temporally, I=
'd
> >> need to do it in place.
> >> Thanks.
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-bt=
rfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
> >>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btr=
fs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
