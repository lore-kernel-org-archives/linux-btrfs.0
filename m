Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:54511 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933839AbeFWACS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 20:02:18 -0400
Subject: Re: Bad superblock when mounting rw, ro mount works
To: Daniel Underwood <daniel.underwood13@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAHac6AspsJ5iu+HECOr1ytVRjqB1JyVtqKVwxBF-H+t_18-Tnw@mail.gmail.com>
 <CAJCQCtStcPseu+2KNYQN2C3wKkAenuQm59yiK_X8jOsfAA-Myg@mail.gmail.com>
 <CAJCQCtTsWq_wZP-MO2-aXmzFAyR-QoT8147NFEiMqyGa7bbDNQ@mail.gmail.com>
 <CAHac6AtGU1VprzTqD-zaqEuBQBg_stZPVRZt5RcdQ6vaKemGVQ@mail.gmail.com>
 <10e17ab5-0a17-e5c4-a648-37faa75ccb3e@gmx.com>
 <CAHac6Av1L-LWKHat3aePEGBZ0LTW9yb2U+9rdezc774a8fiEhg@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d0978796-0000-6060-761e-706ffe127e8b@gmx.com>
Date: Sat, 23 Jun 2018 08:02:07 +0800
MIME-Version: 1.0
In-Reply-To: <CAHac6Av1L-LWKHat3aePEGBZ0LTW9yb2U+9rdezc774a8fiEhg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nbzz7BwEML6kPm1THNJybfZaP6DjLyeJ5"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nbzz7BwEML6kPm1THNJybfZaP6DjLyeJ5
Content-Type: multipart/mixed; boundary="Nd0YAsXxlOTkpmvFgmn5znXHH3s0cFRcB";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Daniel Underwood <daniel.underwood13@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <d0978796-0000-6060-761e-706ffe127e8b@gmx.com>
Subject: Re: Bad superblock when mounting rw, ro mount works
References: <CAHac6AspsJ5iu+HECOr1ytVRjqB1JyVtqKVwxBF-H+t_18-Tnw@mail.gmail.com>
 <CAJCQCtStcPseu+2KNYQN2C3wKkAenuQm59yiK_X8jOsfAA-Myg@mail.gmail.com>
 <CAJCQCtTsWq_wZP-MO2-aXmzFAyR-QoT8147NFEiMqyGa7bbDNQ@mail.gmail.com>
 <CAHac6AtGU1VprzTqD-zaqEuBQBg_stZPVRZt5RcdQ6vaKemGVQ@mail.gmail.com>
 <10e17ab5-0a17-e5c4-a648-37faa75ccb3e@gmx.com>
 <CAHac6Av1L-LWKHat3aePEGBZ0LTW9yb2U+9rdezc774a8fiEhg@mail.gmail.com>
In-Reply-To: <CAHac6Av1L-LWKHat3aePEGBZ0LTW9yb2U+9rdezc774a8fiEhg@mail.gmail.com>

--Nd0YAsXxlOTkpmvFgmn5znXHH3s0cFRcB
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8823=E6=97=A5 05:20, Daniel Underwood wrote:
> Thanks for the help, I started `check --repair --init-extent-tree`
> right around a week ago as a last effort before restoring from backup.
> Unfortunately, that command is still running. It does seem to be using
> about half of the system's RAM (8 of 16GB) and 100% load on a single
> core. Is this type of run time expected for an 8TB drive?

It depends.
Since it will iterate the whole disk serval times, it takes a long time,
especially if you have a lot of used space of that 8T drive.

To determine if it's doing dead loop, we need to verify the output is
not duplicating itself.

> The byte
> numbers it's referencing seem to be a bit odd to me as they're larger
> than the number of bytes on the drive.

Completely valid.
As btrfs is using logical address, it's completely valid that logical
bytenr is larger than your device if you have balanced the device
several times before.

> Here's the head and tail of the
> current run (separated by -----) if that's indicative of progress:
>=20
> btrfs unable to find ref byte nr 49673574858752 parent 0 root 1  owner
> 2 offset 0
> btrfs unable to find ref byte nr 49673719529472 parent 0 root 1  owner
> 1 offset 1
> btrfs unable to find ref byte nr 62243448012800 parent 0 root 1  owner
> 0 offset 1
> btrfs unable to find ref byte nr 49673575120896 parent 0 root 1  owner
> 1 offset 1
> btrfs unable to find ref byte nr 49673575251968 parent 0 root 1  owner
> 0 offset 1
> checking extents
> ref mismatch on [49218307751936 67108864] extent item 0, found 1
> data backref 49218307751936 root 5 owner 1359193 offset 536870912
> num_refs 0 not found in extent tree
> incorrect local backref count on 49218307751936 root 5 owner 1359193
> offset 536870912 found 1 wanted 0 back 0x5583559bd790
> backpointer mismatch on [49218307751936 67108864]
> -----------------
> data backref 49230998138880 root 5 owner 1409678 offset 7408779264
> num_refs 0 not found in extent tree
> incorrect local backref count on 49230998138880 root 5 owner 1409678
> offset 7408779264 found 1 wanted 0 back 0x5583b95f0e20
> backpointer mismatch on [49230998138880 16384]
> adding new data backref on 49230998138880 root 5 owner 1409678 offset
> 7408779264 found 1
> Repaired extent references for 49230998138880
> ref mismatch on [49230998155264 16384] extent item 0, found 1
> data backref 49230998155264 root 5 owner 669291 offset 3905650688
> num_refs 0 not found in extent tree
> incorrect local backref count on 49230998155264 root 5 owner 669291
> offset 3905650688 found 1 wanted 0 back 0x5582efb12930
> backpointer mismatch on [49230998155264 16384]
> adding new data backref on 49230998155264 root 5 owner 669291 offset
> 3905650688 found 1

Looks it's processing.
But it's better to keep all the output and verify the same section of
bytenr doesn't re-appear too many times.

>=20
> Thanks,
> Daniel
>=20
>=20
> On Thu, Jun 14, 2018 at 10:43 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wr=
ote:
>> From the output, specially the lowmem mode output since original mode
>> handles extent tree corruption poorly and aborted, it's your extent tr=
ee
>> corrupted and causing the bug.
>>
>> Thus, you should be able to mount the fs RO and copy all the data back=

>> without much hassle.
>> Just need to pay attention for csum error.
>>
>> And considering how many extent tree corruption, I don't think it's a
>> good idea to manually fix the fs.
>>
>> The last chance is, to try --repair --init-extent-tree as your last
>> chance, if you still want to salvage the filesystem.
>> The lowmem mode shows no extra bug, thus it's possible for
>> --init-extent-tree to re-init extent tree and save the day.
>>
>> But personally speaking I'm not fully confident of the operation, thus=

>> it may fail and you may need to use the backup.
>>
>> BTW, even --init-extent-tree succeeded, you may still need to run btrf=
s
>> check again to check if all the bugs are fixed.
>> But at least from the lowmem output, the remaining errors are all fixa=
ble.
>>
>> Thanks,
>> Qu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Nd0YAsXxlOTkpmvFgmn5znXHH3s0cFRcB--

--nbzz7BwEML6kPm1THNJybfZaP6DjLyeJ5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlstjf8ACgkQwj2R86El
/qjh+AgAngjG06/E8tM8NlyaQfcmzogMgUt/J3y4aAAb6KdU+btNBXqSxW47uax6
iVsWLc5JpesmegjFFPnxsObTBGboO76GH6/rvTx8B4+dh+z9iMYwZkBVJy+pRoMe
P04P+1RT2GZFjMAj9KFEQ7cw0H2gVLP1gF/mD18BUVoWcSUa3JXNPFio63dFKM/4
+ILn2uN76AJ8nug3XhzBRmyEhg9WykSSQZyH4qm+pfquE2e70g/qF4OmDI4p3UF1
0pOCbcOeR+ErmWt+CdUloLgrkBU24NiCJ2Tt0YGaV137w8n2W2RLJ4tjgPUEXS1T
erVc8I2FeJBgOeI0K6XMu12OqnpAGA==
=JRTX
-----END PGP SIGNATURE-----

--nbzz7BwEML6kPm1THNJybfZaP6DjLyeJ5--
