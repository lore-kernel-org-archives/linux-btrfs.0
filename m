Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62231 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752848AbdKXLW3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 06:22:29 -0500
Subject: Re: misc/021-image-multi-devices fails on latest
 btrfs-devel/misc-next
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
References: <CAKuJGC9bi3V5acV6CJEH8GYrdOZ4dA52D-4a7WEGPiVQHTsuxw@mail.gmail.com>
 <CAKuJGC9PnKn0FdZZG9F_LTOc2tcS=a-mGTo8qmg5ubtHfBq8pg@mail.gmail.com>
 <54224bfa-153a-ad2d-0e84-41c43e752be2@gmx.com>
 <CAKuJGC-w2HuNXFeFhLN21BAPdtzG=8rWX4rFDU6WPkH1F5RSSQ@mail.gmail.com>
 <CAKuJGC-hOTkWwKQasocRociw=jOritrLgBaG7_dD==A-jadTpQ@mail.gmail.com>
 <55e496fe-6a73-b759-ed8c-4f415ddacd1d@gmx.com>
 <CAKuJGC-SRh=hrF6uo0vRuQd5=61CbPe-mSpuwMA1DcStihY=dg@mail.gmail.com>
 <19a5ec80-3860-20b8-cb12-fcb41b21dc00@gmx.com>
 <CAKuJGC-NaE3J2tu+HEED5fkBs5C=kkkrJqb0QfkTtpdmEdSn9Q@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ccdf8c94-3fae-8c04-7b4f-b5bb7546ed06@gmx.com>
Date: Fri, 24 Nov 2017 19:22:23 +0800
MIME-Version: 1.0
In-Reply-To: <CAKuJGC-NaE3J2tu+HEED5fkBs5C=kkkrJqb0QfkTtpdmEdSn9Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OllDxwbBOkLaMVaHe6aWakGjqBRAFv1g1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OllDxwbBOkLaMVaHe6aWakGjqBRAFv1g1
Content-Type: multipart/mixed; boundary="rqPHdqJxkiPiM89Ecdlqwuv6eacKBKU7S";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <ccdf8c94-3fae-8c04-7b4f-b5bb7546ed06@gmx.com>
Subject: Re: misc/021-image-multi-devices fails on latest
 btrfs-devel/misc-next
References: <CAKuJGC9bi3V5acV6CJEH8GYrdOZ4dA52D-4a7WEGPiVQHTsuxw@mail.gmail.com>
 <CAKuJGC9PnKn0FdZZG9F_LTOc2tcS=a-mGTo8qmg5ubtHfBq8pg@mail.gmail.com>
 <54224bfa-153a-ad2d-0e84-41c43e752be2@gmx.com>
 <CAKuJGC-w2HuNXFeFhLN21BAPdtzG=8rWX4rFDU6WPkH1F5RSSQ@mail.gmail.com>
 <CAKuJGC-hOTkWwKQasocRociw=jOritrLgBaG7_dD==A-jadTpQ@mail.gmail.com>
 <55e496fe-6a73-b759-ed8c-4f415ddacd1d@gmx.com>
 <CAKuJGC-SRh=hrF6uo0vRuQd5=61CbPe-mSpuwMA1DcStihY=dg@mail.gmail.com>
 <19a5ec80-3860-20b8-cb12-fcb41b21dc00@gmx.com>
 <CAKuJGC-NaE3J2tu+HEED5fkBs5C=kkkrJqb0QfkTtpdmEdSn9Q@mail.gmail.com>
In-Reply-To: <CAKuJGC-NaE3J2tu+HEED5fkBs5C=kkkrJqb0QfkTtpdmEdSn9Q@mail.gmail.com>

--rqPHdqJxkiPiM89Ecdlqwuv6eacKBKU7S
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8824=E6=97=A5 18:15, Lakshmipathi.G wrote:
>>
>> No, it's not about btrfs-image itself, the flag is introduced long lon=
g
>> long way ago.
>>
> Okay.
>=20
>> It's about kernel change which doesn't allow image with such flag to b=
e
>> mounted AFAIK.
>=20
> No luck yet! It works on 4.14.0

The same dmesg result as I, so I didn't see any problem here.

To make it clear, what kernel config and commit are you using when the
test fails?

In my test, if I use the david/for-4.15 branch, it will fails to umount
the fs, due to the known bug if you enabled
CONFIG_BTRFS_FS_CHECK_INTEGRITY (you reported it first).
And for any upstream kernel version like v4.14-rc7 or v4.14, not problem
at all.

BTW, the btrfs-progs version should not affect, since all the problem is
about kernel failing to mount.

Despite that (either disable that option or apply the patch I submitted)
I can't reproduce the bug you reported (which fails to mount the fs).

Thanks,
Qu
> -----
> -bash-4.4$ sudo make TEST=3D021\* test-misc
>     [TEST]   misc-tests.sh
>     [TEST/misc]   021-image-multi-devices
> -bash-4.4$ sudo dmesg
> [  162.635824] BTRFS: device fsid f0c92f1b-c1ba-4576-8a07-8ce4f7b5bacd
> devid 1 transid 5 /dev/loop0
> [  162.672952] BTRFS: device fsid f0c92f1b-c1ba-4576-8a07-8ce4f7b5bacd
> devid 2 transid 5 /dev/loop1
> [  162.692848] BTRFS info (device loop1): disk space caching is enabled=

> [  162.695725] BTRFS info (device loop1): has skinny extents
> [  162.698003] BTRFS info (device loop1): flagging fs with big metadata=
 feature
> [  162.701643] BTRFS info (device loop1): creating UUID tree
> [  163.792851] BTRFS warning (device loop0): unrecognized super flag:
> 17179869184
> [  163.796350] BTRFS info (device loop0): disk space caching is enabled=

> [  163.807644] BTRFS info (device loop0): has skinny extents
> [  163.811613] BTRFS info (device loop0): checking UUID tree
> [  163.841625] BTRFS error (device loop0): 1 errors while writing super=
s
> [  163.845457] BTRFS: error (device loop0) in write_all_supers:3709:
> errno=3D-5 IO failure (1 errors while writing supers)
> [  163.851520] BTRFS info (device loop0): forced readonly
> [  163.855184] BTRFS warning (device loop0): Skipping commit of
> aborted transaction.
> [  163.859121] BTRFS: error (device loop0) in
> cleanup_transaction:1873: errno=3D-5 IO failure
> [  163.862577] BTRFS info (device loop0): delayed_refs has NO entry
> [  163.865623] BTRFS error (device loop0): commit super ret -5
> [  163.868303] BTRFS error (device loop0): cleaner transaction attach
> returned -30
> -bash-4.4$ uname -a
> Linux ip-172-31-33-196.us-west-2.compute.internal 4.14.0 #1 SMP Fri
> Nov 24 09:48:11 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
> -----
>=20
> Cheers,
> Lakshmipathi.G
> http://www.giis.co.in http://www.webminal.org
>=20


--rqPHdqJxkiPiM89Ecdlqwuv6eacKBKU7S--

--OllDxwbBOkLaMVaHe6aWakGjqBRAFv1g1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloYAO8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgmTwgAqTdJoXm7MCtUrP6X432vIjSm
zqVjeX0CKAyPbNkuN2kZk+laRvPEotSShjDsEaL16pGepq9LengdusmH6pGjoqwY
6RxpnaSn0XxEIIdjkieqizjfaLGJmXKuyzIDz6cVEdzHkmhXTsdw1AOnwQ4t3CAS
JcwPFJP88OY2Zk+1kVtIz4koufGHgrXPaJJTzVcVFZKNPRLoLR18/t2fTpQlUkH/
GTtiVYgP66KZ2DnTTKglspfWcal8WVhLkyiwmVw29XcN6hkqaEeqiYMjbsgePrNh
TdlB5sLqsmmz5L4lozg1jrAoEcKbZW1CvR7sujxDLP4eYXezdDrqsbNZQl8ldg==
=T+0h
-----END PGP SIGNATURE-----

--OllDxwbBOkLaMVaHe6aWakGjqBRAFv1g1--
