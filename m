From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: fix chunk allocate size calculation
Date: Tue, 6 Apr 2010 10:15:41 -0400
Message-ID: <20100406141541.GC5413@think>
References: <20100317204556.GA4409@localhost.localdomain>
 <g2o3d0408631004060054t652c69d2n1b150e7f57fce625@mail.gmail.com>
 <20100406111358.GA5218@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: "Yan, Zheng " <yanzheng@21cn.com>, Josef Bacik <josef@redhat.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100406111358.GA5218@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 06, 2010 at 07:13:58AM -0400, Chris Mason wrote:
> On Tue, Apr 06, 2010 at 03:54:27PM +0800, Yan, Zheng  wrote:
> > On Thu, Mar 18, 2010 at 4:45 AM, Josef Bacik <josef@redhat.com> wro=
te:
> > > If the amount of free space left in a device is less than what we=
 think should
> > > be the minimum size, just ignore the minimum size and use the amo=
unt we have. =A0I
> > > ran into this running tests on a 600mb volume, the chunk allocato=
r wouldn't let
> > > me allocate the last 52mb of the disk for data because we want to=
 have at least
> > > 64mb chunks for data. =A0This patch fixes that problem. =A0Thanks=
,
> > >
> > > Signed-off-by: Josef Bacik <josef@redhat.com>
> > >
> > > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > > index 9df8e3f..1c5b5ba 100644
> > > --- a/fs/btrfs/volumes.c
> > > +++ b/fs/btrfs/volumes.c
> > > @@ -2244,8 +2244,10 @@ again:
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0do_div(calc_size, stripe_len);
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0calc_size *=3D stripe_len;
> > > =A0 =A0 =A0 =A0}
> > > +
> > > =A0 =A0 =A0 =A0/* we don't want tiny stripes */
> > > - =A0 =A0 =A0 calc_size =3D max_t(u64, min_stripe_size, calc_size=
);
> > > + =A0 =A0 =A0 if (!looped)
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 calc_size =3D max_t(u64, min_stripe=
_size, calc_size);
> > >
> > > =A0 =A0 =A0 =A0do_div(calc_size, stripe_len);
> > > =A0 =A0 =A0 =A0calc_size *=3D stripe_len;
> >=20
> > I encountered an Oops caused by 'calc_size =3D=3D 0'. It's likely i=
ntroduced
> > by this change. (calc_size can be zero after calling do_div)

Ok, anyone object to this:

=46rom 9f680ce04ea19dabbbafe01b57b61930a9b70741 Mon Sep 17 00:00:00 200=
1
=46rom: Chris Mason <chris.mason@oracle.com>
Date: Tue, 6 Apr 2010 09:37:47 -0400
Subject: [PATCH] Btrfs: make sure the chunk allocator doesn't create ze=
ro length chunks

A recent commit allowed for smaller chunks to be created, but didn't
make sure they were always bigger than a stripe.  After some divides,
this led to zero length stripes.

Signed-off-by: Chris Mason <chris.mason@oracle.com>
---
 fs/btrfs/volumes.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9bf1f58..b584e9a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2249,6 +2249,12 @@ again:
 	if (!looped)
 		calc_size =3D max_t(u64, min_stripe_size, calc_size);
=20
+	/*
+	 * we're about to do_div by the stripe_len so lets make sure
+	 * we end up with something bigger than a stripe
+	 */
+	calc_size =3D max_t(u64, calc_size, stripe_len * 4);
+
 	do_div(calc_size, stripe_len);
 	calc_size *=3D stripe_len;
=20
--=20
1.7.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
