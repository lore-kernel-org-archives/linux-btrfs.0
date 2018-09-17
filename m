Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:38347 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727124AbeIQSME (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Sep 2018 14:12:04 -0400
Subject: Re: btrfs problems
To: Adrian Bastholm <adrian@javaguru.org>, linux-btrfs@vger.kernel.org
References: <CAMrg+aRfS0NymyKo2Wwk75+TVBBbGPshnG_Yku403CwnhsimxQ@mail.gmail.com>
 <cbb66b3b-1b21-cb3c-c446-c44e861f36bc@gmx.com>
 <CAMrg+aTNK1cBG7rGVfudpydD6hMJz9UW0-3mdS8Yx4tqAQZE6Q@mail.gmail.com>
 <ecac52ad-70ed-e0e3-5660-1717f0d4f5e0@gmx.com>
 <CAMrg+aTtyOSOnZMj+4q13f7pv9wMydFgTDZ5KLbQSRz8HHcbKw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <405d08b1-9f22-1038-67c3-c055477029d4@gmx.com>
Date: Mon, 17 Sep 2018 20:44:33 +0800
MIME-Version: 1.0
In-Reply-To: <CAMrg+aTtyOSOnZMj+4q13f7pv9wMydFgTDZ5KLbQSRz8HHcbKw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6OUKgVBT52O6C5vqBLFdizhcXBLrr4ydk"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6OUKgVBT52O6C5vqBLFdizhcXBLrr4ydk
Content-Type: multipart/mixed; boundary="oPBE8koIeH90rpFKTvyG4Vmhsr8PR1dzO";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Adrian Bastholm <adrian@javaguru.org>, linux-btrfs@vger.kernel.org
Message-ID: <405d08b1-9f22-1038-67c3-c055477029d4@gmx.com>
Subject: Re: btrfs problems
References: <CAMrg+aRfS0NymyKo2Wwk75+TVBBbGPshnG_Yku403CwnhsimxQ@mail.gmail.com>
 <cbb66b3b-1b21-cb3c-c446-c44e861f36bc@gmx.com>
 <CAMrg+aTNK1cBG7rGVfudpydD6hMJz9UW0-3mdS8Yx4tqAQZE6Q@mail.gmail.com>
 <ecac52ad-70ed-e0e3-5660-1717f0d4f5e0@gmx.com>
 <CAMrg+aTtyOSOnZMj+4q13f7pv9wMydFgTDZ5KLbQSRz8HHcbKw@mail.gmail.com>
In-Reply-To: <CAMrg+aTtyOSOnZMj+4q13f7pv9wMydFgTDZ5KLbQSRz8HHcbKw@mail.gmail.com>

--oPBE8koIeH90rpFKTvyG4Vmhsr8PR1dzO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/17 =E4=B8=8B=E5=8D=887:55, Adrian Bastholm wrote:
>> Well, I'd say Debian is really not your first choice for btrfs.
>> The kernel is really old for btrfs.
>>
>> My personal recommend is to use rolling release distribution like
>> vanilla Archlinux, whose kernel is already 4.18.7 now.
>=20
> I just upgraded to Debian Testing which has the 4.18 kernel

Then I strongly recommend to use the latest upstream kernel and progs
for btrfs. (thus using Debian Testing)

And if anything went wrong, please report asap to the mail list.

Especially for fs corruption, that's the ghost I'm always chasing for.
So if any corruption happens again (although I hope it won't happen), I
may have a chance to catch it.

>=20
>> Anyway, enjoy your stable fs even it's not btrfs anymore.
>=20
> My new stable fs is too rigid. Can't grow it, can't shrink it, can't
> remove vdevs from it , so I'm planning a comeback to BTRFS. I guess
> after the dust settled I realize I like the flexibility of BTRFS.
>=20
>=20
>  This time I'm considering BTRFS as rootfs as well, can I do an
> in-place conversion ? There's this guide
> (https://www.howtoforge.com/how-to-convert-an-ext3-ext4-root-file-syste=
m-to-btrfs-on-ubuntu-12.10)
> I was planning on following.

Btrfs-convert is recommended mostly for short term trial (the ability to
rollback to ext* without anything modified)

=46rom the code aspect, the biggest difference is the chunk layout.
Due to the ext* block group usage, each block group header (except some
sparse bg) is always used, thus btrfs can't use them.

This leads to highly fragmented chunk layout.
We doesn't have error report about such layout yet, but if you want
everything to be as stable as possible, I still recommend to use a newly
created fs.

>=20
> Another thing is I'd like to see a "first steps after getting started
> " section in the wiki. Something like take your first snapshot, back
> up, how to think when running it - can i just set some cron jobs and
> forget about it, or does it need constant attention, and stuff like
> that.

There are projects do such things automatically, like snapper.

If your primary concern is to make the fs as stable as possible, then
keep snapshots to a minimal amount, avoid any functionality you won't
use, like qgroup, routinely balance, RAID5/6.

And keep the necessary btrfs specific operations to minimal, like
subvolume/snapshot (and don't keep too many snapshots, say over 20),
shrink, send/receive.

Thanks,
Qu

>=20
> BR Adrian
>=20
>=20


--oPBE8koIeH90rpFKTvyG4Vmhsr8PR1dzO--

--6OUKgVBT52O6C5vqBLFdizhcXBLrr4ydk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlufobEACgkQwj2R86El
/qhHZQf9EL9k1smUTQdMc4hwVYQPmChiUGqxhVtULH6siC7K6Ouvvk1YW/E/zFVw
WGySAtC81PRI53rgKstr3FtSs6CQ5SLeMtJMtB4XbGmaun/yQcnee69cAGdeH/OG
L84M5hiyV9KvRFBAnIRzFODxk5EnKk6cuci9N01mz8e5WWot7S/8et0oJbbJKON+
R02dLFBhq+mjrfqxd/TERsGfjXvfNnFMMZLiT9PjqGhy+R2jkKAQjShElF8iY+Ci
Q2D7keYnguL+slSMuUMVHYEKTXo1niVM2BB4fTYkntQnxTRp1rtbz7fcI2EkMJ1W
AiS2V/E+bfhDe6CbIBho9QqwGXIErA==
=GqS8
-----END PGP SIGNATURE-----

--6OUKgVBT52O6C5vqBLFdizhcXBLrr4ydk--
