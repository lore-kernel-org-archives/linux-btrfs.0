Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mehl.schokokeks.org ([46.4.40.247]:39405 "EHLO
	mehl.schokokeks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418AbaCQK71 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Mar 2014 06:59:27 -0400
Date: Mon, 17 Mar 2014 11:59:24 +0100
From: Florian Bruhin <me@the-compiler.org>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS critical / kernel BUG / high load
Message-ID: <20140317105924.GD21978@lupin>
References: <20140317055754.GA21978@lupin>
 <20140317104715.GB2447@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_mehl.schokokeks.org-611-1395053965-0001-2"
In-Reply-To: <20140317104715.GB2447@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_mehl.schokokeks.org-611-1395053965-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Liu Bo <bo.li.liu@oracle.com> [2014-03-17 18:47:16 +0800]:
> On Mon, Mar 17, 2014 at 06:57:54AM +0100, Florian Bruhin wrote:
> > Hi,
> >=20
> > on one of my servers running btrfs, I noticed a very high load of
> > 26/26/26. After investigating further, this happened in my logs about
> > 5 minutes before the monitoring alerted me because of the load:
> >=20
> > [...]
> >=20
> > So basically after that happened, my load stayed high, so probably
> > something went berzerk.
>=20
> I get what makes the load stay high, but still don't know how this BUG_ON=
 was triggered.
>=20
> Or maybe by 'gdb btrfs.ko and list *btrfs_search_old_slot+0x7c4',=20
> you can get where it refers to?

I'm not really experienced with debugging kernel code or modules.

That's what I tried:

$ gunzip -c /usr/lib/modules/3.13.6-1-ARCH/kernel/fs/btrfs/btrfs.ko.gz > bt=
rfs.ko
$ gdb btrfs.ko
[...]
Reading symbols from btrfs.ko...(no debugging symbols found)...done.
(gdb) list *btrfs_search_old_slot+0x7c4
No symbol table is loaded.  Use the "file" command.
(gdb) file /boot/vmlinuz-linux
Reading symbols from /boot/vmlinuz-linux...(no debugging symbols found)...d=
one.
(gdb) list *btrfs_search_old_slot+0x7c4
No symbol table is loaded.  Use the "file" command.

It seems the addresses shown are dependent at load-time anyways? Or
should I recompile the kernel with debugging symbols and try again,
should that work?

Florian

--=20
() ascii ribbon campaign - stop html mail    www.asciiribbon.org
/\ www.the-compiler.org  | I love long mails http://email.is-not-s.ms/
"There are some good people in it, but the orchestra as a whole is equivale=
nt=20
to a gang bent on destruction." -- John Cage, composer=20

--=_mehl.schokokeks.org-611-1395053965-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTJtWMAAoJEJFusMj9VaByd14QAKcYiSC9QzsFkgONa/EJxaXZ
IKeD1/ewjbp2Qg46Xyc62AtBX5IyS2LT1puJllnpWGUfkCzUKQbCY+unmjjljFgF
pnuMsRxAQ/uJ17bkFxSc4zegm9H98S1i9FpNK5bU/xrM91kA06XKghddiWPKQJqN
/sNZ+0ByVp9aDmwXkJQxq/R8WZMGYjk2tJX4tNCQ5uiRxef7VVXf9AEMDJYBT41y
cqEwj3703tv5HxXfDlLqAcjF+eqj4BLqnBRxxje0blBrwjazIxF+OTJn5DvsI6XW
mFbzskwcUrOUKO3iXaG9Nf25mx3iv9X1R9JuOFprbRIACh6yjOzsjLO/FdaScmjb
rgfgbbMkGmrm0i38ewjOAd2B6DSeqvRk/tBcxcPQOrgZL6KR0kNQr/X4vTWRRIZH
1lPUlCXV2r/0aubJVuXBV7rJ+lapYupHhxmMjouzvwUHS6g6oXNmlb3/h/x4W4al
4FfvJCClDwLYptTANpqJKcbNCE9XS9R/djzjlgQIymS+2FJ/vH7K/959yzH+w/k4
pguqll6vdHZCsea9IWXOZ7qjowWblM0TSutCqhxSmNcTEw1qzneN9r1XgRtAerKH
aDK1vaEZ1DSeIeYPEbNRplrqA8rJ+BkJiMhbAc+Knao7W93FACC7wgqZzStQCPD+
1yIr3A2pcGe2xjwPCkIP
=ZGw8
-----END PGP SIGNATURE-----

--=_mehl.schokokeks.org-611-1395053965-0001-2--
