Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:51400 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751920AbdLBBr0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Dec 2017 20:47:26 -0500
Subject: Re: exclusive subvolume space missing
To: Tomasz Pala <gotar@polanet.pl>
Cc: linux-btrfs@vger.kernel.org
References: <20171201161555.GA11892@polanet.pl>
 <55036341-2e8e-41dc-535f-f68d8e74d43f@gmx.com>
 <20171202012324.GB20205@polanet.pl>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <0d3cd6f5-04ad-b080-6e62-7f25824860f1@gmx.com>
Date: Sat, 2 Dec 2017 09:47:19 +0800
MIME-Version: 1.0
In-Reply-To: <20171202012324.GB20205@polanet.pl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tivmXw60AIpbp9tbunhw4jMUHNRJSd7IJ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tivmXw60AIpbp9tbunhw4jMUHNRJSd7IJ
Content-Type: multipart/mixed; boundary="HRGGdK1VkUqko7MSg1nhhGLNg6aOFrTho";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tomasz Pala <gotar@polanet.pl>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <0d3cd6f5-04ad-b080-6e62-7f25824860f1@gmx.com>
Subject: Re: exclusive subvolume space missing
References: <20171201161555.GA11892@polanet.pl>
 <55036341-2e8e-41dc-535f-f68d8e74d43f@gmx.com>
 <20171202012324.GB20205@polanet.pl>
In-Reply-To: <20171202012324.GB20205@polanet.pl>

--HRGGdK1VkUqko7MSg1nhhGLNg6aOFrTho
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8802=E6=97=A5 09:23, Tomasz Pala wrote:
> On Sat, Dec 02, 2017 at 08:27:56 +0800, Qu Wenruo wrote:
>=20
>> I assume there is program eating up the space.
>> Not btrfs itself.
>=20
> Very doubtful. I've encountered ext3 "eating" problem once, that couldn=
't be
> find by lsof on 3.4.75 kernel, but the space was returning after killin=
g
> Xorg. The system I'm having problem now is very recent, the space
> doesn't return after reboot/emergency and doesn't sum up with files.

Unlike vanilla df or "fi usage" or "fi df", btrfs quota only counts
on-disk extents.

That's to say, reserved space won't contribute to qgroup.
Unless one is using anonymous file, which is opened but unlinked, so no
one can access it except the owner.
(Which I doubt that may be your case)

Which should make quota the best tool to debug your problem.
(As long as you follow the variant limitations of btrfs quota,
especially you need to sync or use --sync option to show qgroup numbers)

>=20
>>> Now, the weird part for me is exclusive data count:
>>>
>>> # btrfs sub sh ./snapshot-171125
>>> [...]
>>>         Subvolume ID:           388
>>> # btrfs fi du -s ./snapshot-171125=20
>>>      Total   Exclusive  Set shared  Filename
>>>   21.50GiB    63.35MiB    20.77GiB  snapshot-171125
>>
>> That's the difference between how sub show and quota works.
>>
>> For quota, it's per-root owner check.
>=20
> Just to be clear: I've enabled quota _only_ to see subvolume usage on
> spot. And exclusive data - the more detailed approach I've described in=

> e-mail I've send a minute ago.
>=20
>> Means even a file extent is shared between different inodes, if all
>> inodes are inside the same subvolume, it's counted as exclusive.
>> And if any of the file extent belongs to other subvolume, then it's
>> counted as shared.
>=20
> Good to know, but this is almost UID0-only system. There are system
> users (vendor provided) and 2 ssh accounts for su, but nobody uses this=

> machine for daily work. The quota values were the last tool I could fin=
d
> to debug.
>=20
>> For fi du, it's per-inode owner check. (The exact behavior is a little=

>> more complex, I'll skip such corner case to make it a little easier to=

>> understand).
>>
>> That's to say, if one file extent is shared by different inodes, then
>> it's counted as shared, no matter if these inodes belong to different =
or
>> the same subvolume.
>>
>> That's to say, "fi du" has a looser condition for "shared" calculation=
,
>> and that should explain why you have 20+G shared.
>=20
> There shouldn't be many multi-inode extents inside single subvolume, as=
 this is mostly fresh
> system, with no containers, no deduplication, snapshots are taken from
> the same running system before or after some more important change is
> done. By 'change' I mean altering text config files mostly (plus
> etckeeper's git metadata), so the volume of difference is extremelly
> low. Actually most of the difs between subvolumes come from updating
> distro packages. There were not much reflink copies made on this
> partition, only one kernel source compiled (.ccache files removed
> today). So this partition is as clean, as it could be after almost
> 5 months in use.
>=20
> Actually I should rephrase the problem:
>=20
> "snapshot has taken 8 GB of space despite nothing has altered source su=
bvolume"

Then please provide correct qgroup numbers.

The correct number should be get by:
# btrfs quota enable <mnt>
# btrfs quota rescan -w <mnt>
# btrfs qgroup show -prce --sync <mnt>

Rescan and --sync are important to get the correct number.
(while rescan can take a long long time to finish)

And further more, please ensure that all deleted files are really deleted=
=2E
Btrfs delay file and subvolume deletion, so you may need to sync several
times or use "btrfs subv sync" to ensure deleted files are deleted.

(vanilla du won't tell you if such delayed file deletion is really done)

Thanks,
Qu
>=20


--HRGGdK1VkUqko7MSg1nhhGLNg6aOFrTho--

--tivmXw60AIpbp9tbunhw4jMUHNRJSd7IJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloiBicXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjM7QgAmkOo4jDAF3keOE0vUgmJkMA1
Zp303F1B5zh3+2RNfWVXVzMdU3XPbCYG9m6wvkRQMRvUTowmFW6cil8M+e6rwRGo
LD5RbAuFQ1EvtEvIM/ewuWyxfmuiWB8AOGAsj0FRDPBmezPvOiU4jK7slPHBcrN6
RN6klXjrvinUN9zNdUDbHbiBBIRs4HWIj6mNGn6TkemSezpHJejYfj/XNnsd1HTe
vAcVCFbORefS0qNwv58vDx5462qX/9yElrwd3tmaPYiwhwjGWPmB1XV+P5APqR5O
Q6pBCYc+88yjItgLaMEPEZgJJ5tFUdLRJ6u26nFLIJgennR4753MZg4lfStS4g==
=CIxK
-----END PGP SIGNATURE-----

--tivmXw60AIpbp9tbunhw4jMUHNRJSd7IJ--
