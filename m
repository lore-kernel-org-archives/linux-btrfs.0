Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:42609 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751086AbeDQAcB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 20:32:01 -0400
Subject: Re: btrfs fails to mount after power outage
To: Tom Vincent <tom@tlvince.com>, linux-btrfs@vger.kernel.org
References: <CAG4vCreOmBdsPT84ajozGb4XV83+Fc-joyUqXgizutPah0VrrA@mail.gmail.com>
 <db34f571-2a31-5a0a-9f8d-e55a9b579753@gmx.com>
 <CAG4vCrfCb=VUQe8rpMebeUCHbqwrXviBmOYpekRbFMRL-xJVKA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1bd207c8-f1f9-125f-df2b-d77a6595bbd6@gmx.com>
Date: Tue, 17 Apr 2018 08:31:54 +0800
MIME-Version: 1.0
In-Reply-To: <CAG4vCrfCb=VUQe8rpMebeUCHbqwrXviBmOYpekRbFMRL-xJVKA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ij56Xi2W5fucLOXkEmO1OytUWSTMwD4lu"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ij56Xi2W5fucLOXkEmO1OytUWSTMwD4lu
Content-Type: multipart/mixed; boundary="FAzlNf9WB5bEcOOHu20JgACGH1qiV1TG2";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tom Vincent <tom@tlvince.com>, linux-btrfs@vger.kernel.org
Message-ID: <1bd207c8-f1f9-125f-df2b-d77a6595bbd6@gmx.com>
Subject: Re: btrfs fails to mount after power outage
References: <CAG4vCreOmBdsPT84ajozGb4XV83+Fc-joyUqXgizutPah0VrrA@mail.gmail.com>
 <db34f571-2a31-5a0a-9f8d-e55a9b579753@gmx.com>
 <CAG4vCrfCb=VUQe8rpMebeUCHbqwrXviBmOYpekRbFMRL-xJVKA@mail.gmail.com>
In-Reply-To: <CAG4vCrfCb=VUQe8rpMebeUCHbqwrXviBmOYpekRbFMRL-xJVKA@mail.gmail.com>

--FAzlNf9WB5bEcOOHu20JgACGH1qiV1TG2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8817=E6=97=A5 00:07, Tom Vincent wrote:
> On 12 April 2018 at 00:25, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>> I'm curious about what's the underlying disk?
>=20
> It's an Samsung PM951 NVMe SSD.
>=20
>> Is it plain physical device? Or have other layers like bcache/lvm?
>=20
> btrfs on LUKS
>=20
>>> btrfs check
>> Full output please.
>=20
> https://gist.githubusercontent.com/tlvince/acf51b37622c216e1c33cdc3dfbd=
321f/raw/d0237948bbffacd4bb8d53fdfa5f23391416c1e2/btrfs-check.txt

Unfortunately, not only extent tree, but also fs trees got corrupted:
root 259 inode 19916 errors 2000, link count wrong
	unresolved ref dir 16196710 index 2 namelen 12 name foo.gpg filetype 0
errors 3, no dir item, no dir index

Such output along other error messages means at least one tree block of
your fs trees get corrupted.

And it seems that all corrupted tree blocks belongs to subvolume 259.

>> For transid error, btrfs check --repair can fix it, but only do it whe=
n
>> that's the only problem.
>=20
> I ran this (for ~12+ hours) to no avail; it appears to have been
> looping around "Btree for root 259 is fixed". I grew impatient and
> SIGINT-ed, which unsurprisingly toasted the file system once and for
> all (I rebuilt from backups at that point).

check --repair won't help much in this case.
So btrfs-restore would be your last chance to salvage data.

>=20
> Full output:
>=20
> https://gist.githubusercontent.com/tlvince/8060c19526aa011b0baff2b12e38=
73fd/raw/ecc43bd9dc7b352e490aa0bf0deac368af04e117/btrfs-check-repair.txt
>=20
> Note, the system was fine for a few days after zero-log (before check
> --repair), but then hit the same transid error at boot.

Your filesystem is already *CORRUPTED*, so whatever happens is not a
surprise.

Only a filesystem which passes "btrfs check" without any problems could
be ensured to run for a long time.

Thanks,
Qu

>=20
> On 13 April 2018 at 06:46, Duncan <1i5t5.duncan@cox.net> wrote:
>> What mount options?  In particular, is the discard option used (and of=

>> course I'm assuming nothing as insane as nobarrier)?
>=20
> noatime,compress=3Dlzo
>=20
> ... as well as some defaults: rw,noatime,compress=3Dlzo,ssd,space_cache=

>=20


--FAzlNf9WB5bEcOOHu20JgACGH1qiV1TG2--

--ij56Xi2W5fucLOXkEmO1OytUWSTMwD4lu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrVQHoACgkQwj2R86El
/qj2/Af8CII0/pYp69a5H3PX/H6Mtv44C/HKxH+euBL0mAgfgfzPY10Fdeyut9wR
IlPl5QZIcbJ/fsym18Gp7r9+N3nsqBGylSWSpcqFcT9lAtJYwv8I/znl2IhT3ZIv
llTc8TRzJrOI07FOGRNU4s+Qn1o2+Z9k1XvHD1RWj0ytHREYz0/qioY/GQMlstyH
uyvn1YRKbRcxKwqfL1z5WkpV4+7klALdABsoF4cBO+x/aLuOjOCI8joJwHb2OU00
G1YIzlADb3B3NI0neha+TWu49/ZAtSqsD+t3X5rWxe57fodn85B80zDbZbV093+N
06+I6+y9y5rUgS1H0HyFLeE31y77zQ==
=+nRM
-----END PGP SIGNATURE-----

--ij56Xi2W5fucLOXkEmO1OytUWSTMwD4lu--
