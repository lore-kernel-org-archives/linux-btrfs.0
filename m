Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:35941 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726590AbeHUSA7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 14:00:59 -0400
Subject: Re: Are the btrfs mount options inconsistent?
To: David Howells <dhowells@redhat.com>, dsterba@suse.cz
Cc: clm@fb.com, linux-btrfs@vger.kernel.org, wqu@suse.de
References: <20180821142432.GD24025@twin.jikos.cz>
 <4b5b0a92-8a51-e516-b14a-74557b002d71@gmx.com>
 <20180816130515.GR24025@twin.jikos.cz>
 <31114.1534417285@warthog.procyon.org.uk>
 <32208.1534767847@warthog.procyon.org.uk>
 <341.1534859015@warthog.procyon.org.uk>
 <4246.1534862142@warthog.procyon.org.uk>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b1d99959-568a-43f8-15b2-9f46794c94ce@gmx.com>
Date: Tue, 21 Aug 2018 22:40:16 +0800
MIME-Version: 1.0
In-Reply-To: <4246.1534862142@warthog.procyon.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MZJEToqwfCa76CVetrNCRIRd7JxyxbAz4"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MZJEToqwfCa76CVetrNCRIRd7JxyxbAz4
Content-Type: multipart/mixed; boundary="jjEQFhWRwjG9BAjumBg0ZyqYNOiGY8CXI";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: David Howells <dhowells@redhat.com>, dsterba@suse.cz
Cc: clm@fb.com, linux-btrfs@vger.kernel.org, wqu@suse.de
Message-ID: <b1d99959-568a-43f8-15b2-9f46794c94ce@gmx.com>
Subject: Re: Are the btrfs mount options inconsistent?
References: <20180821142432.GD24025@twin.jikos.cz>
 <4b5b0a92-8a51-e516-b14a-74557b002d71@gmx.com>
 <20180816130515.GR24025@twin.jikos.cz>
 <31114.1534417285@warthog.procyon.org.uk>
 <32208.1534767847@warthog.procyon.org.uk>
 <341.1534859015@warthog.procyon.org.uk>
 <4246.1534862142@warthog.procyon.org.uk>
In-Reply-To: <4246.1534862142@warthog.procyon.org.uk>

--jjEQFhWRwjG9BAjumBg0ZyqYNOiGY8CXI
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/21 =E4=B8=8B=E5=8D=8810:35, David Howells wrote:
> David Sterba <dsterba@suse.cz> wrote:
>=20
>> - nothing: auto-detect non-rotating devices, enable SSD mount option i=
n turn
>=20
> And it's right that this should only turn on SSD if *all* the devices a=
re
> non-rotating?

If I didn't miss anything again, yes.

It's btrfs_open_one_device() who updates fs_devices->rotating, and any
device with rotating disk will set it to 1.
So it needs all device to to non-rotating to meet
!fs_info->fs_devices->rotating.

Thanks,
Qu

>=20
> David
>=20


--jjEQFhWRwjG9BAjumBg0ZyqYNOiGY8CXI--

--MZJEToqwfCa76CVetrNCRIRd7JxyxbAz4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlt8JFAACgkQwj2R86El
/qjF3Qf/fsE0lmrI198fpcKS7ns2UN8h9b9PahMj3+iv4H3ayPg33MdEPuLCxuMc
GmnJa1x7OQH9ynLM4b8iCNdVZqQ0oE59xl4O9+DaSKKeeVbm+u97es2s28JdKZcE
cx7ecfpm0M2d3vj8wE+V3ayp8NoYbwglvQcRduX+cWM/8EQKVLup0PxbyM5zYIAq
0Uw2RqTR6N3I+6l08KEWuo/DYQwEYL+4hFd6w8NgwoTMNMsx80JN7EK3awx6I0f6
Ey969WyzXkda9XiHovEHkFJJeoJXe+btkeVrY8B74bMCMUSjjZO+H7xJLPEJgd5U
fxUEVAiCRGEJ1pbNlCZfvZt0MMi+fA==
=6KxT
-----END PGP SIGNATURE-----

--MZJEToqwfCa76CVetrNCRIRd7JxyxbAz4--
