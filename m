From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: [PATCH v2 1/5] btrfs: add command to zero out superblock
Date: Thu, 03 May 2012 15:11:45 +0200
Message-ID: <1405178.Vd8v8qs4AD@bursa01>
References: <1335876033-12201-1-git-send-email-kario@wit.edu.pl> <2913005.FpWZk4H159@bursa01> <20120502173629.GI6740@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: dave@jikos.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120502173629.GI6740@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 02 of May 2012 19:36:29 David Sterba wrote:
> On Wed, May 02, 2012 at 06:42:16PM +0200, Hubert Kario wrote:
> > > I'm not sure if this is useful and sensible usecase, clearing sup=
erblock
> > > is a one-time action anyway, so it's more for the sake of tool
> > > flexibility.
> >=20
> > Clearing superblock is not a light decision and should generally be
> > performed just before formatting the partition with some other fs o=
r
> > physical volume for LVM. IMHO recoverability of "cleared" superbloc=
k is a
> > function hardly anyone would use.
>=20
> googled, a few users asking about recovering from md zero-superblock,=
 and
> the solution was to recreate the array, md is said to be smart and
> recognize traces of previous array and will not destroy it if the
> parameters are same. Point for md, btrfs does not do this.

nice, didn't know about this. Such functionality would be nice to have.
But then I don't think that a "recreate the array if the parameters are=
 the=20
same" is actually a good idea, lots of space for error. A pair of funct=
ions:

btrfs dev zero-superblock
btrfs dev restore-superblock

would be a better solution IMO
=20
> > > To your implementation: I think adding a function doing the super=
block
> > > reset would be enough here. Something like this (in pseudocode):
> > >=20
> > > for (i =3D 0 ; i < BTRFS_SUPER_MIRROR_MAX; i++) {
> > >=20
> > > 	bytenr =3D btrfs_sb_offset(i);
> > > 	"break if bytenr > device size"
> > > 	memset(superblock buffer, CLEARPATTERN, sizeof(...))
> > >=20
> > > }
> > > write_all_supers(root);
> >=20
> > That's exactly what btrfs_prepare_device does. And it's a function =
run by
> > btfs just before btrfs dev add and by mkfs. Duplicating its code wo=
uld be
> > a bad idea.
>=20
> Not 'exactly' IMO:
>=20
> * calls TRIM/discard on the device
> * zeroes first 2 megabytes
> * zeroes all reachable superblocks
> * zeroes last 2 megabytes
>=20
> Too many undocumented and unobvious side-efects.

True. But close enough ;)

> Code duplication can be avoided by factoring the 'zero superblock' in=
to
> a function and calling it from btrfs_prepare_device().

Then there's also the "actually zero" vs "reversibly destroy" differenc=
e but=20
it's trivial to fix using a single option.

Regards
--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=F3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
