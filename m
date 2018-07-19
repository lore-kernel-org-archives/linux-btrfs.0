Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:44269 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726724AbeGSKE2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 06:04:28 -0400
Subject: Re: btrfs check (not lowmem) and OOM-like hangs (4.17.6)
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
References: <20180717203257.GA10237@merlins.org>
 <20180717205905.GB10237@merlins.org>
 <8a0fbf2d-ee13-f6d6-a046-5dfba936aa87@gmx.com>
 <20180718002451.GF10237@merlins.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ebccf82e-1812-f62d-08b5-41a673906e0e@gmx.com>
Date: Thu, 19 Jul 2018 17:22:02 +0800
MIME-Version: 1.0
In-Reply-To: <20180718002451.GF10237@merlins.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="otk3qBY1jZGH7YjSG6DUHEyCBCQPwAm44"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--otk3qBY1jZGH7YjSG6DUHEyCBCQPwAm44
Content-Type: multipart/mixed; boundary="LpMmLb4kophqltiEuDsM1KqjZ9R56ot3A";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <ebccf82e-1812-f62d-08b5-41a673906e0e@gmx.com>
Subject: Re: btrfs check (not lowmem) and OOM-like hangs (4.17.6)
References: <20180717203257.GA10237@merlins.org>
 <20180717205905.GB10237@merlins.org>
 <8a0fbf2d-ee13-f6d6-a046-5dfba936aa87@gmx.com>
 <20180718002451.GF10237@merlins.org>
In-Reply-To: <20180718002451.GF10237@merlins.org>

--LpMmLb4kophqltiEuDsM1KqjZ9R56ot3A
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8818=E6=97=A5 08:24, Marc MERLIN wrote:
> On Wed, Jul 18, 2018 at 08:05:51AM +0800, Qu Wenruo wrote:
>> No OOM triggers? That's a little strange.
>> Maybe it's related to how kernel handles memory over-commit?
> =20
> Yes, I think you are correct.
>=20
>> And for the hang, I think it's related to some memory allocation failu=
re
>> and error handler just didn't handle it well, so it's causing deadlock=

>> for certain page.
>=20
> That indeed matches what I'm seeing.
>=20
>> ENOMEM handling is pretty common but hardly verified, so it's not that=

>> strange, but we must locate the problem.
>=20
> I seem to be getting deadlocks in the kernel, so I'm hoping that at lea=
st
> it's checked there, but maybe not?
>=20
>> In my system, at least I'm not using btrfs as root fs, and for the
>> memory eating program I normally ensure it's eating all the memory +
>> swap, so OOM killer is always triggered, maybe that's the cause.
>>
>> So in your case, maybe it's btrfs not really taking up all memory, thu=
s
>> OOM killer not triggered.
>=20
> Correct, the swap is not used.
>=20
>> Any kernel dmesg about OOM killer triggered?
> =20
> Nothing at all. It never gets triggered.
>=20
>>> Here is my system when it virtually died:
>>> ER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAN=
D
>>> root     31006 21.2 90.7 29639020 29623180 pts/19 D+ 13:49   1:35 ./b=
trfs check /dev/mapper/dshelf2
>=20
> See how btrs was taking 29GB in that ps output (that's before it takes
> everything and I can't even type ps anymore)
> Note that VSZ is almost equal to RSS. Nothing gets swapped.
>=20
> Then see free output:
>=20
>>>              total       used       free     shared    buffers     ca=
ched
>>> Mem:      32643788   32180100     463688          0      44664     11=
9508
>>> -/+ buffers/cache:   32015928     627860
>>> Swap:     15616764     443676   15173088
>>
>> For swap, it looks like only some other program's memory is swapped ou=
t,
>> not btrfs'.
>=20
> That's exactly correct. btrfs check never goes to swap, I'm not sure wh=
y,
> and because there is virtual memory free, maybe that's why OOM does not=

> trigger?
> So I guess I can probably "fix" my problem by removing swap, but ultima=
tely
> it would be useful to know why memory taken by btrfs check does not end=
 up
> in swap.
>=20
>> And unfortunately, I'm not so familiar with OOM/MM code outside of
>> filesystem.
>> Any help from other experienced developers would definitely help to
>> solve why memory of 'btrfs check' is not swapped out or why OOM killer=

>> is not triggered.
>=20
> Do you have someone from linux-vm you might be able to ask, or should w=
e Cc
> this thread there?

Michal Hocho gives me a brief session about this.
Which is super helpful in this case, thank you Michal!

Firstly, btrfs-progs usage of malloc() will result anonymous pages, thus
they can be swapped out.

Secondly, kernel doesn't like to swap out anonymous pages at all, thus
kernel won't try to aggressively swap out such pages.

Thirdly, for user anonymous memory, there is LRU-like algorithm to
determine which memory should go swapped out.
But considering how btrfs check uses pages, it would only make it harder
to be swapped out.

So it's not an easy way thing to aggressively swap out memory of btrfs
check to swap.
Although Michal mentioned some cgroup way to limit the memory usage so
it can be more aggressively swapped out, I'm still digging into it.

Thanks,
Qu

>=20
> Thanks,
> Marc
>=20


--LpMmLb4kophqltiEuDsM1KqjZ9R56ot3A--

--otk3qBY1jZGH7YjSG6DUHEyCBCQPwAm44
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltQWDoACgkQwj2R86El
/qjWsgf6Ains1oIVzFSgcRZhxo5iG70+7E5m4HRqRNvpcaaW5wm9wroh2IR23OUz
C1HeqjvFFKH5rKAf3pvzAKfToH5bSBeyv84IPyAqc8gaV8BW7Lf8rjdWLjd7Q6Zb
g9xvESbWOBrBLydDwpYf3lxYrVrMKJxvV51rK3oQjtOHv9zBqc59Y5yXAXX46i2S
bfixw/TiOt27ePfIZDe4YvOWTbwIpx6J/OP+PnBpMV6c8KYyK2u4kS6MKPFavep/
2Ut2xEQvt9AhLEt2SdFjkrqNRNy/ULXTapth7jStNweaWSq3NlnTWCScaV7dbQqQ
RLw2xB5+lck2SjW3IZqi3wLp/30QAw==
=S3l8
-----END PGP SIGNATURE-----

--otk3qBY1jZGH7YjSG6DUHEyCBCQPwAm44--
