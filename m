From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: [PATCH v2 1/5] btrfs: add command to zero out superblock
Date: Wed, 02 May 2012 18:42:16 +0200
Message-ID: <2913005.FpWZk4H159@bursa01>
References: <1335876033-12201-1-git-send-email-kario@wit.edu.pl> <20120502142843.GD6740@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: dave@jikos.cz, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120502142843.GD6740@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 02 of May 2012 16:28:43 David Sterba wrote:
> On Tue, May 01, 2012 at 02:40:29PM +0200, Hubert Kario wrote:
> > +static const char * const cmd_zero_dev_usage[] =3D {
> > +	"btrfs device zero-superblock <device> [<device> ...]",
>=20
> FYI, this step is named 'clear superblock' in kernel code as done aft=
er the
> device is removed, and I suggest to consider to name the command like
> 'clear-superblock' or 'clear-sb'.

A similar function in mdadm is called zero superblock so I just re used=
 the=20
name (according to the principle of least surprise). Users, even admins=
,=20
generally don't read kernel code...
=20
> Also, kernel clears only the "superblock magic" string, ie. the
> "_BHRfS_M" bytes. This leaves the rest of the superblock intact, for
> possible recovery when it's cleared accidentally.

That's when a device is removed from the filesystem, not when a filesys=
tem is=20
just not used any more and you want to re-purpose the devices.

> I had prototyped a similar utility (in perl, so nothing for progs
> inclusion for now) and rewrote the magic string with _BHRf$_M ie. the
> S -> $ for visual similarity with the action performed. This allows t=
o
> detect cleared superblocks and activate them back eventually.
>=20
> I'm not sure if this is useful and sensible usecase, clearing superbl=
ock
> is a one-time action anyway, so it's more for the sake of tool
> flexibility.

Clearing superblock is not a light decision and should generally be per=
formed=20
just before formatting the partition with some other fs or physical vol=
ume for=20
LVM. IMHO recoverability of "cleared" superblock is a function hardly a=
nyone=20
would use.
=20
> To your implementation: I think adding a function doing the superbloc=
k
> reset would be enough here. Something like this (in pseudocode):
>=20
> for (i =3D 0 ; i < BTRFS_SUPER_MIRROR_MAX; i++) {
> 	bytenr =3D btrfs_sb_offset(i);
> 	"break if bytenr > device size"
> 	memset(superblock buffer, CLEARPATTERN, sizeof(...))
> }
> write_all_supers(root);

That's exactly what btrfs_prepare_device does. And it's a function run =
by btfs=20
just before btrfs dev add and by mkfs. Duplicating its code would be a =
bad=20
idea.

Regards,
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
