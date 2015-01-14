Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:53147 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbbANVXv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 16:23:51 -0500
Received: from marcec.fritz.box ([93.181.44.4]) by mail.gmx.com (mrgmx102)
 with ESMTPSA (Nemesis) id 0MUTSJ-1YJzi32sdf-00RFgq for
 <linux-btrfs@vger.kernel.org>; Wed, 14 Jan 2015 22:23:48 +0100
Date: Wed, 14 Jan 2015 22:23:34 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs scrub status reports not running when it is
Message-ID: <20150114222334.5f207a5d@marcec.fritz.box>
In-Reply-To: <CAPs0BijZX-BcM7uRq58TwSUqsNRqsySXeHYRezgVQcfXw-d22g@mail.gmail.com>
References: <CAPs0BijZX-BcM7uRq58TwSUqsNRqsySXeHYRezgVQcfXw-d22g@mail.gmail.com>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Yh5KHXkgBoh3VsYnuku3cm5"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/Yh5KHXkgBoh3VsYnuku3cm5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Wed, 14 Jan 2015 16:06:02 -0500
schrieb Sandy McArthur Jr <sandymac@gmail.com>:

> Sometimes btrfs scrub status reports that is not running when it still is.
[...]

FWIW, I (and one other person) reported this in the thread titled 'btrfs sc=
rub
status misreports as "interrupted"' (starting on 22.11.2014).

> # uname -a
> Linux mcplex 3.18.2-gentoo #1 SMP Mon Jan 12 10:24:25 EST 2015 x86_64
> Intel(R) Core(TM) i7-2600S CPU @ 2.80GHz GenuineIntel GNU/Linux
>
> # btrfs --version
> Btrfs v3.18.1

Too bad it's still there; I'm on kernel 3.17.8 and userspace 3.18.1,
respectively, and didn't see this issue the last time I ran a scrub, so I w=
as
hoping it was gone by now.

(On the upside, though, this isn't exactly the worst bug btrfs has ever
had ;) .)

Greetings
--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/Yh5KHXkgBoh3VsYnuku3cm5
Content-Type: application/pgp-signature
Content-Description: Digitale Signatur von OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUtt5iAAoJEL/Q5oYsiHj0m7EP/iWXf4dg0ZYY9YUrcjsIaE+R
L8u2pa25psyyCND/i5IXFSN8OuQ1/rymX2hPcqoqev2y2gnVBFq4hOt//N3i9gOM
095uEhIql+boN7KDwCaYf3koYzfGRln8Y0k22ACaGzGHAAsBq6tjwOL5O8yS25tZ
s/G9thkdD+MQAEG2Ck9iD2lPmKJEiwXjFGzJOLxSIFD8r3LvJHRATmWndQClHEvZ
HNQH38kE2mlIGfw9cSyOY0xUNcz8YmOfaLc48fIoK9xWq/dNmfdbZ+jKFUwa2DkJ
6iqANTObDKsLNwRfMYv9gM87/kBvtyn4VLtilBpnlCmhC8zhev+M1l+nysBihdVP
gU1oj588VL+i8ONjRwYTzs+hRuW26kij3o0SVnqND8ZE2u/cTyMgQVQdCyIud2YM
pTe5OKI1WtYXx2CWQh9DcHlEFBTZCTq5AQ3GOSXVyT7gA/6GsmEySFv7frLN95JK
tmtdy4n8hxfe0gvIN68TDEPImentFe9eBzQYQzMY+2EKnDZfBMlIA6eSNhFmu+p3
2R8ksrpXEXW1yv1rAEh3AqSEgIhPZ4+SCISGuWykmjWBlnRZiY7jCNmdtiStyZcX
piZYTv9w8JRrhZf7kRNOoR0+yl/J36DLx1u524WzVswmADTthcWsHIVKZrWPTdaD
c80EkElu1NnuIkYH6Eyk
=7jDi
-----END PGP SIGNATURE-----

--Sig_/Yh5KHXkgBoh3VsYnuku3cm5--
