Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-2.hut.fi ([130.233.228.92]:33955 "EHLO smtp-2.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355Ab2GPV3n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jul 2012 17:29:43 -0400
Date: Tue, 17 Jul 2012 00:29:33 +0300
From: Sami Liedes <sami.liedes@iki.fi>
To: Arne Jansen <sensille@gmx.net>
Cc: linux-btrfs@vger.kernel.org, Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
Message-ID: <20120716212932.GB8653@sli.dy.fi>
References: <4FF5998D.8020205@jan-o-sch.net>
 <20120705234739.GA9736@sli.dy.fi>
 <4FF6C12A.10305@jan-o-sch.net>
 <20120706143350.GA10427@sli.dy.fi>
 <4FF6FF8C.4010007@jan-o-sch.net>
 <20120706234405.GB8933@sli.dy.fi>
 <4FFA9EEB.7060008@gmx.net>
 <20120710041625.GA8909@sli.dy.fi>
 <4FFBD24E.2050902@gmx.net>
 <5003CECC.2040908@gmx.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MW5yreqqjyrRcusr"
In-Reply-To: <5003CECC.2040908@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 16, 2012 at 10:20:28AM +0200, Arne Jansen wrote:
> Any news on this? I you give me some hints, I can try to reproduce
> it here.

I've been planning for a few days now to try if it's reproducible in a
virtual machine with the same filesystem images. However I haven't
gotten around to doing this yet... I tried to get KMEMCHECK working on
my computer, but failed (and generated a bug report). It seems to work
in KVM though.

So, currently my idea is to boot the machine with a live USB stick,
install kvm and make qemu qcow images backed by the real (2*1.1T)
devices, but writing changes to the qcow images (I dare not mess with
the actual devices, and don't happen to have quite 2.2T extra space
outside of them...), and try to run scrub there. If that succeeds and
the bug happens there too, debugging *should* be easier, and it
*should* be possible to run it under KMEMCHECK too. If the bug doesn't
happen inside a virtual machine, that would be interesting information
too.

Another idea might be to use LVM snapshots of the actual devices, but
recent messages have made be wary of that approach - plus it's
somewhat of a pain, because the snapshotting would have to be done
before mounting anyway, since I have two devices and I doubt LVM
supports snapshotting two separate devices at the exact same moment.

However, I'm a bit ill at the moment, so I assume it might be at least
a few days until I get to actually implementing this...

	Sami

--MW5yreqqjyrRcusr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJQBIe7AAoJEKLT589SE0a0+7wP/2S6VLiw9HmfvktFyiWyziVq
E8R9+2JUbutkOjOtwdfvlV9QE2GIIZAkH7TQQ7jeIzn18Id+iG1qHvNak3V/mSEe
GAfW/XsdkZIi9P/VkkATjT6b8W8Pg97/6uGt1zZGF19xDKwojzDcDU2WqKSGRiB3
t6MZUfBXGRsrmsTAM/kwMWjWXbIz2hYDNCx4ItlKo3ndgs4ltuTsKaTKAhXbyAEr
2dVVgehcuEZTzBsJUjCv1mf3MvfCLvKm0kgsOjNwryBh65/jDlYAKmqBq/9FJNSb
5TjxXNtGMVB9U53QzbSsTz+oruJhoKpsdZpZux8oXe3TBogQmAydpT+TTJH3E1U/
yNqt0RrjEgc1/Q5HA+cwKQG4tmZ7K+iIpmYoG3F2HE6l9NBG9pE/rKKJbuY8fp+3
yxYEJfIFQXaAIY+/5kDnAQlyvPp019/e0DGEfnUNvLEbC+Ud0C3u5k6mn5LjSJKm
wWw6TWvsXXVAg6aZFv74T0dpKtgnne4bpvjXWvCUaOI4+2O1y5bFmtsRj+LWLej+
QQerX7Dj9ji8Y0U9fhANlBXnmaRDB+5fA+Z9KOt1nftl8T73PbW6SGG47HBMcsTh
j+0IvExdkNwPSMURW47coxF8CKEppuYpzllL5RL87B/P/QvSGpMPFCHfpq1VxYm0
v4bMD3kmnoFSp48x+LTh
=EWTl
-----END PGP SIGNATURE-----

--MW5yreqqjyrRcusr--
