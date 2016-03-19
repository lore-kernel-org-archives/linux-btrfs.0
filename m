Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:33970 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbcCSUcE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Mar 2016 16:32:04 -0400
Received: by mail-wm0-f53.google.com with SMTP id p65so109223210wmp.1
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Mar 2016 13:32:03 -0700 (PDT)
Received: from [192.168.13.14] (f054252192.adsl.alicedsl.de. [78.54.252.192])
        by smtp.googlemail.com with ESMTPSA id m202sm5056278wma.7.2016.03.19.13.32.00
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Sat, 19 Mar 2016 13:32:01 -0700 (PDT)
Subject: Re: [4.4.1] btrfs-transacti frequent high CPU usage despite little
 fragmentation
To: linux-btrfs@vger.kernel.org
References: <56E92B38.10605@inoio.de>
 <pan$4920$33ddf09b$49bd87c9$2053e366@cox.net> <56EBCB7A.1010508@gmail.com>
 <pan$c1998$42b65a7e$8b396259$757615d8@cox.net>
From: Ole Langbehn <neurolabs.de@gmail.com>
Message-ID: <56EDB732.9060605@gmail.com>
Date: Sat, 19 Mar 2016 21:31:46 +0100
MIME-Version: 1.0
In-Reply-To: <pan$c1998$42b65a7e$8b396259$757615d8@cox.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="hAhC58u0lfXImkS9wvTulhSqWXeAi7Xik"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hAhC58u0lfXImkS9wvTulhSqWXeAi7Xik
Content-Type: multipart/mixed; boundary="bOfo4MJOseL89qCQC9i80rWwE9OhWDIuK"
From: Ole Langbehn <neurolabs.de@gmail.com>
To: linux-btrfs@vger.kernel.org
Message-ID: <56EDB732.9060605@gmail.com>
Subject: Re: [4.4.1] btrfs-transacti frequent high CPU usage despite little
 fragmentation
References: <56E92B38.10605@inoio.de>
 <pan$4920$33ddf09b$49bd87c9$2053e366@cox.net> <56EBCB7A.1010508@gmail.com>
 <pan$c1998$42b65a7e$8b396259$757615d8@cox.net>
In-Reply-To: <pan$c1998$42b65a7e$8b396259$757615d8@cox.net>

--bOfo4MJOseL89qCQC9i80rWwE9OhWDIuK
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Duncan,

thanks again for your effort, I highly appreciate it.

On 19.03.2016 00:06, Duncan wrote:
> autodefrag

Got it, thanks.

> Nocow interacts with snapshots. =20

Thanks for presenting that in that much detail.

> What can happen then, and used to happen frequently before 3.17, tho mu=
ch=20
> less frequently but it can still happen now, is that over time and with=
=20
> use, the filesystem will allocate all available space as one type,=20
> typically data chunks, and then run out of space in the other type of=20
> chunk, typically metadata, and have no unallocated space from which to =

> allocate more.   So you'll have lots of space left, but it'll be all ti=
ed=20
> up in only partially used chunks of the one type and you'll be out of=20
> space in the other type.
>=20
> And by the time you actually start getting ENOSPC errors as a result of=
=20
> the situation, there's often too little space left to create even the o=
ne=20
> additional chunk necessary for a balance to write the data from other=20
> chunks into, in ordered to combine some of the less used chunks into=20
> fewer chunks at 100% usage (but for the last one, of course).
>=20
> And you were already in a tight spot in that regard and may well have h=
ad=20
> errors if you had simply tried an unfiltered balance, because data chun=
ks=20
> are typically 1 GiB in size (and can be upto 10 GiB in some circumstanc=
es=20
> on large enough filesystems, tho I think the really large sizes require=
=20
> multi-device), and you were down to 300-ish MiB of unallocated space, n=
ot=20
> enough to create a new 1 GiB data chunk.
>
> And considering the filesystem's near terabyte scale, to be down to und=
er=20
> a GiB of unallocated space is even more startling, particularly on newe=
r=20
> kernels where empty chunks are normally reclaimed automatically (tho as=
=20
> the usage=3D0 balances reclaimed some space for you, obviously not all =
of=20
> them had been reclaimed in your case).

As I said before, this fs has (with 99.9% probability) never seen
kernels <3.18. I'm curious why it came to the point of only having
300MiB unallocated, or what could potentially lead to this.

> Meanwhile, discussion in another thread reminded me of another factor, =

> quotas.

Sure thing I had quotas enabled without the direct need for them ;).
I've been using

https://github.com/agronick/btrfs-size/

which uses quotas in order to display human readable snapshot sizes.

As a wrap up to the chunk allocation issue (the balance has finished):

# btrfs filesystem usage /
Overall:
    Device size:                 915.32GiB
    Device allocated:            169.04GiB
    Device unallocated:          746.28GiB
    Device missing:                  0.00B
    Used:                        155.51GiB
    Free (estimated):            758.33GiB      (min: 758.33GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:164.01GiB, Used:151.95GiB
   /dev/sda2     164.01GiB

Metadata,single: Size:5.00GiB, Used:3.55GiB
   /dev/sda2       5.00GiB

System,single: Size:32.00MiB, Used:48.00KiB
   /dev/sda2      32.00MiB

Unallocated:
   /dev/sda2     746.28GiB

Cheers,

Ole


--bOfo4MJOseL89qCQC9i80rWwE9OhWDIuK--

--hAhC58u0lfXImkS9wvTulhSqWXeAi7Xik
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlbttzIACgkQoxgU3D8/uhE2XQCg0EIJpywEk7ovrcmZWYjC1IH2
XqgAn0xuw9UUO/eZlGlO7RizmbG672KC
=n6EB
-----END PGP SIGNATURE-----

--hAhC58u0lfXImkS9wvTulhSqWXeAi7Xik--
