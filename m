From: Claudio Martins <ctpm@ist.utl.pt>
Subject: Re: Mass-Hardlinking Oops
Date: Tue, 13 Oct 2009 01:31:25 +0100
Message-ID: <200910130131.26380.ctpm@ist.utl.pt>
References: <4A74401B.90801@mccme.ru> <4AD372A7.2020907@hp.com> <20091012200442.GA8830@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: jim owens <jowens@hp.com>, John Dong <jdong@ubuntu.com>,
	=?utf-8?q?P=C3=A4r_Andersson?= <paran@lysator.liu.se>,
	linux-btrfs@vger.kernel.org, "Yan, Zheng " <yanzheng@21cn.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091012200442.GA8830@think>
List-ID: <linux-btrfs.vger.kernel.org>


On Monday 12 October 2009, Chris Mason wrote:
> On Mon, Oct 12, 2009 at 02:17:11PM -0400, jim owens wrote:
> > John Dong wrote:
> > >I don't think that's a good counterargument for why this is not a =
bug.
> >
> > it is not a "bug".  hard links are not a required feature of all
> > filesystems nor is a defined large number required for those with
> > hard links.
> >
> > >Can't think of any off the top of my head for Linux, but
> > >definitely in OS X Time Machine can easily create 200+ hardlinks.
> >
> > so 311 is 50% than the app uses... plenty of growth.
>
> Just to clarify again, the max link count on btrfs is 2^32.  The lowe=
r
> limit is only in place on links to the same file in the same director=
y.
>


 Hi Chris and all,

 I've made a quick test and managed to create many more links to the sa=
me file=20
in the *same* directory on other filsystems:=20

  XFS can do at least 100000, probably more;=20
  Reiserfs did 64535;
  ext3 managed to do 32000;
  ext4 did 65000.

 While I agree it might be a bit stupid to create so many hardlinks to =
the=20
same file on the same directory, this issue can be seen as one of "back=
ward=20
compatibility" with other widely used and established Linux filesystems=
=2E=20

Despite it being stupid or not, the fact is that I've seen some crazy s=
tuff=20
along the years working with Unix, so people will expect this kind of t=
hings=20
to *not* break when they switch from their old filesystems to shiny new=
=20
btrfs.

 The fact being that this limit is way lower than on other filesystems =
(we're=20
talking 2 orders of magnitude, at best!), I too suggest that the limit =
should=20
be increased. Not being critical, it might be done when some other feat=
ures=20
require a format change but, nonetheless, should be done for the sake o=
f=20
avoiding breakage on existing systems.

 Best regards, and thanks for your hard work.

Cl=C3=A1udio

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
