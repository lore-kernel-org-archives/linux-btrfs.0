From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: Problems with set-default, home subvolume and snapshot
Date: Tue, 06 Sep 2011 08:16:18 -0400
Message-ID: <1315311380.2530.6.camel@ayu>
References: <20110905130742.GA4756@zambezi.lan>
	 <4E64E026.4020009@cyberphoria.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: =?ISO-8859-1?Q?Bj=F6rn?= Kalkbrenner <terminar@cyberphoria.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E64E026.4020009@cyberphoria.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2011-09-05 at 16:43 +0200, Bj=C3=B6rn Kalkbrenner wrote:
> Hi Ilya,
>=20
> Am 05.09.2011 15:07, schrieb Ilya Dryomov:
> > Well, it's *sort of* expected if you think about it. When you mount=
ed
> > after set-default, your /home is no longer a valid subvolume access
> > point (it was in the default subvolume, until you rebooted). Inside
> > your snapshot /home is just an empty directory (there's more to it,
> > that's why you can't delete it, but that's irrelevant here). Howeve=
r
> > if you mount with subvolid=3D<objectid>, you point to a subvolume
> > directly, skipping the lookup (which leads to an empty dir if you a=
re
> > inside your snapshot). That's why it works when you use the subvoli=
d.
> > We should probably tune the lookup to make subvol=3D work in this c=
ase.=20
>=20
> Ah, thank you very much, that sounds logical with the lookup table an=
d
> the - not valid access point - BUT:
>=20
> Why could i still manually "mount -o subvol=3Dhome /dev/mapper/root /=
home"
> and home was just empty but mounted (i looked at the mount table outp=
ut)?
> Shouldn't that give me an error that home can't be found in the looku=
p
> table?

This is actually because of how the subvolume mounting works internally=
=2E
It turns out that currently, the command
	mount -o subvol=3Dhome /dev/mapper/root /home
effectively does the same thing as
	mount /dev/mapper/root /home	# Mount the "default" subvolume
	mount --bind /home/home /home	# Switch to the "home" subvolume
which of course succeeds if /home in your default subvolume is an empty
directory.
Hopefully this can be improved at some point :)

--=20
Calvin Walton <calvin.walton@kepstin.ca>

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
