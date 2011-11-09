From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: Grow btrfs partition & filesystem backwards
Date: Wed, 09 Nov 2011 19:58:44 +0100
Message-ID: <2286851.zJGgl5jPAW@venice>
References: <CACCfv7obU+-13+Z7-S-N_y8etdJZxyw_csZBD5Ran62xW6tgWA@mail.gmail.com> <CANZ96zWM-AuOc9OddyHPrVyQdOpGHqXC3twyGhsZFA=EZpDjUQ@mail.gmail.com> <20111109133624.GO4149@shiny>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Ernst =?ISO-8859-1?Q?Sj=F6strand?= <ernstp@gmail.com>,
	Jordan Windsor <jordanw2@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>,
	Billy Crook <billycrook@gmail.com>, chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111109133624.GO4149@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday, 09 November, 2011 08:36:24 Chris Mason wrote:
> The only choice for an online operation is to make a new partition in
> front of the old one and just add that as a second disk in btrfs.
>=20
> The slow method of shifting the bytes down is probably a better long
> term choice.
>=20
> -chris

Hi Chris,

does the chunk tree be able to map the sectors "before" ? If so we shou=
ld only=20
"shift down" the map logical->physical in the chunk tree/device tree.

The only exception should be the superblock which has to be moved.

At the mount time we should pass a parameter which set how the data sho=
uld be=20
moved backward. Then the kernel remap the chunk tree/device tree.

I don't know if the gains is greater than the work, but from a theoreti=
cal=20
point of view, it should be doable..



>=20
> On Wed, Nov 09, 2011 at 06:40:06AM -0600, Billy Crook wrote:
> > I think the biggest point of contention is that with all the stuff
> > going on in the background in btrfs, its difficult to be sure that =
the
> > resize operation has completed.  With grows, you don't have to worr=
y.
> > With shrinks, if you truncate the block device too soon, you will
> > corrupt the filesystem.
> >=20
> > 2011/11/9 Ernst Sj=F6strand <ernstp@gmail.com>:
> > > Gparted can do that, it just takes a very long time because it mo=
ves
> > > everything back first.
> > >=20
> > > Regards
> > > //Ernst
> > >=20
> > > On Wed, Nov 9, 2011 at 05:23, Jordan Windsor <jordanw2@gmail.com>=
 wrote:
> > >> Hello,
> > >> I was wondering how I would go about growing a btrfs filesystem
> > >> backwards, I don't have any space to store the files temporally,
> > >> I'd
> > >> need to do it in place.
> > >> Thanks.
> > >> --
> > >> To unsubscribe from this list: send the line "unsubscribe
> > >> linux-btrfs" in the body of a message to
> > >> majordomo@vger.kernel.org
> > >> More majordomo info at  http://vger.kernel.org/majordomo-info.ht=
ml
> > >=20
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe
> > > linux-btrfs" in the body of a message to majordomo@vger.kernel.or=
g
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btr=
fs"
> > in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwi=
nd.it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
