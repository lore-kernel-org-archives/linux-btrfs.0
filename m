Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.229.20.24]:55114 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925Ab3JYKfy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 06:35:54 -0400
Date: Fri, 25 Oct 2013 16:35:46 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: swapfile on btrfs, temporary solution for wiki
Message-ID: <20131025163546.4cf3291a@natsu>
In-Reply-To: <CAGqmi74F9GurJL73qtU4JG+Fi4RbXE7tiaO1uEQqEY2ym278eA@mail.gmail.com>
References: <CAGqmi74OvQ=BFroP+QCf6eUtc61__LYRGtZJNcPz1XrSWX-q_w@mail.gmail.com>
	<CAGqmi74F9GurJL73qtU4JG+Fi4RbXE7tiaO1uEQqEY2ym278eA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/maU/BlCgiPuzy/O8FtTKIOg"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/maU/BlCgiPuzy/O8FtTKIOg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Oct 2013 23:52:01 +0300
Timofey Titovets <nefelim4ag@gmail.com> wrote:

> Hello, i suggest temporary solution to use swap file under btrfs.
> I test it, and it work good.
>=20
> I invent simple the way, how create and using swap file, just see
> following sh code:
>=20
> swapfile=3D$(losetup -f) #free loop device
> truncate -s 8G /swap   #create 8G sparse swap file
> losetup $swapfile /swap #mount file to loop
> mkswap  $swapfile
> swapon  $swapfile
>=20
> i just adding this to rc.local and this work good.
> May be, add it to btrfs Wiki as temporary solution to using swap file?

I always thought Btrfs does not allow swap files on purpose, because it is =
not
deadlock-proof when used in the swapping context.

Imagine you try swapping out pages to free up some memory, and in the proce=
ss
Btrfs needs to allocate some memory to actually perform the write, the kern=
el
says "Sure, but for that we need to swap out some more pages..." You see wh=
ere
that goes.

Same issue is possible with swap on other complex filesystems an example
being networked ones like NFS and SMB/CIFS.

It might work for some time (or even work 99% of time), but you still may be
endangering your system to a possibility of a lock-up, and certainly adding
that to any Wiki/FAQ/website as "the solution" might not be the best choice.

--=20
With respect,
Roman

--Sig_/maU/BlCgiPuzy/O8FtTKIOg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlJqSYIACgkQTLKSvz+PZwjNJgCeJL/mWNML8wRXy/CZ821WywC6
YU4An359vKWfeuf0/+zV38i8WROK/zoC
=2riF
-----END PGP SIGNATURE-----

--Sig_/maU/BlCgiPuzy/O8FtTKIOg--
