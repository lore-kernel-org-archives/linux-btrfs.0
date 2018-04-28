Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52899 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759622AbeD1Ipq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Apr 2018 04:45:46 -0400
Subject: Re: BTRFS RAID filesystem unmountable
To: Michael Wade <spikewade@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAB+znrFyimDnOZt46CqterRJ6MvwD4TSWagQvv-oQxjPvG-m2w@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <54d2f70a-adae-98cc-581f-2e4786783b26@gmx.com>
Date: Sat, 28 Apr 2018 16:45:30 +0800
MIME-Version: 1.0
In-Reply-To: <CAB+znrFyimDnOZt46CqterRJ6MvwD4TSWagQvv-oQxjPvG-m2w@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pArtpPS5XeigrjCdLVNNNGFLbGx6gO2gX"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pArtpPS5XeigrjCdLVNNNGFLbGx6gO2gX
Content-Type: multipart/mixed; boundary="gR533a0hEVZL9rgpPyMNsWtSrPwjnHR3v";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Michael Wade <spikewade@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <54d2f70a-adae-98cc-581f-2e4786783b26@gmx.com>
Subject: Re: BTRFS RAID filesystem unmountable
References: <CAB+znrFyimDnOZt46CqterRJ6MvwD4TSWagQvv-oQxjPvG-m2w@mail.gmail.com>
In-Reply-To: <CAB+znrFyimDnOZt46CqterRJ6MvwD4TSWagQvv-oQxjPvG-m2w@mail.gmail.com>

--gR533a0hEVZL9rgpPyMNsWtSrPwjnHR3v
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8828=E6=97=A5 16:30, Michael Wade wrote:
> Hi all,
>=20
> I was hoping that someone would be able to help me resolve the issues
> I am having with my ReadyNAS BTRFS volume. Basically my trouble
> started after a power cut, subsequently the volume would not mount.
> Here are the details of my setup as it is at the moment:
>=20
> uname -a
> Linux QAI 4.4.116.alpine.1 #1 SMP Mon Feb 19 21:58:38 PST 2018 armv7l G=
NU/Linux

The kernel is pretty old for btrfs.
Strongly recommended to upgrade.

>=20
> btrfs --version
> btrfs-progs v4.12

So is the user tools.

Although I think it won't be a big problem, as needed tool should be ther=
e.

>=20
> btrfs fi show
> Label: '11baed92:data'  uuid: 20628cda-d98f-4f85-955c-932a367f8821
> Total devices 1 FS bytes used 5.12TiB
> devid    1 size 7.27TiB used 6.24TiB path /dev/md127

So, it's btrfs on mdraid.
It would normally make things harder to debug, so I could only provide
advice from the respect of btrfs.
For mdraid part, I can't ensure anything.

>=20
> Here are the relevant dmesg logs for the current state of the device:
>=20
> [   19.119391] md: md127 stopped.
> [   19.120841] md: bind<sdb3>
> [   19.121120] md: bind<sdc3>
> [   19.121380] md: bind<sda3>
> [   19.125535] md/raid:md127: device sda3 operational as raid disk 0
> [   19.125547] md/raid:md127: device sdc3 operational as raid disk 2
> [   19.125554] md/raid:md127: device sdb3 operational as raid disk 1
> [   19.126712] md/raid:md127: allocated 3240kB
> [   19.126778] md/raid:md127: raid level 5 active with 3 out of 3
> devices, algorithm 2
> [   19.126784] RAID conf printout:
> [   19.126789]  --- level:5 rd:3 wd:3
> [   19.126794]  disk 0, o:1, dev:sda3
> [   19.126799]  disk 1, o:1, dev:sdb3
> [   19.126804]  disk 2, o:1, dev:sdc3
> [   19.128118] md127: detected capacity change from 0 to 7991637573632
> [   19.395112] Adding 523708k swap on /dev/md1.  Priority:-1 extents:1
> across:523708k
> [   19.434956] BTRFS: device label 11baed92:data devid 1 transid
> 151800 /dev/md127
> [   19.739276] BTRFS info (device md127): setting nodatasum
> [   19.740440] BTRFS critical (device md127): unable to find logical
> 3208757641216 len 4096
> [   19.740450] BTRFS critical (device md127): unable to find logical
> 3208757641216 len 4096
> [   19.740498] BTRFS critical (device md127): unable to find logical
> 3208757641216 len 4096
> [   19.740512] BTRFS critical (device md127): unable to find logical
> 3208757641216 len 4096
> [   19.740552] BTRFS critical (device md127): unable to find logical
> 3208757641216 len 4096
> [   19.740560] BTRFS critical (device md127): unable to find logical
> 3208757641216 len 4096
> [   19.740576] BTRFS error (device md127): failed to read chunk root

This shows it pretty clear, btrfs fails to read chunk root.
And according your above "len 4096" it's pretty old fs, as it's still
using 4K nodesize other than 16K nodesize.

According to above output, it means your superblock by somehow lacks the
needed system chunk mapping, which is used to initialize chunk mapping.

Please provide the following command output:

# btrfs inspect dump-super -fFa /dev/md127

Also, please consider run the following command and dump all its output:

# btrfs rescue chunk-recover -v /dev/md127.

Please note that, above command can take a long time to finish, and if
it works without problem, it may solve your problem.
But if it doesn't work, the output could help me to manually craft a fix
to your super block.

Thanks,
Qu


> [   19.783975] BTRFS error (device md127): open_ctree failed
>=20
> In an attempt to recover the volume myself I run a few BTRFS commands
> mostly using advice from here:
> https://lists.opensuse.org/opensuse/2017-02/msg00930.html. However
> that actually seems to have made things worse as I can no longer mount
> the file system, not even in readonly mode.
>=20
> So starting from the beginning here is a list of things I have done so
> far (hopefully I remembered the order in which I ran them!)
>=20
> 1. Noticed that my backups to the NAS were not running (didn't get
> notified that the volume had basically "died")
> 2. ReadyNAS UI indicated that the volume was inactive.
> 3. SSHed onto the box and found that the first drive was not marked as
> operational (log showed I/O errors / UNKOWN (0x2003))  so I replaced
> the disk and let the array resync.
> 4. After resync the volume still was unaccessible so I looked at the
> logs once more and saw something like the following which seemed to
> indicate that the replay log had been corrupted when the power went
> out:
>=20
> BTRFS critical (device md127): corrupt leaf, non-root leaf's nritems
> is 0: block=3D232292352, root=3D7, slot=3D0
> BTRFS critical (device md127): corrupt leaf, non-root leaf's nritems
> is 0: block=3D232292352, root=3D7, slot=3D0
> BTRFS: error (device md127) in btrfs_replay_log:2524: errno=3D-5 IO
> failure (Failed to recover log tree)
> BTRFS error (device md127): pending csums is 155648
> BTRFS error (device md127): cleaner transaction attach returned -30
> BTRFS critical (device md127): corrupt leaf, non-root leaf's nritems
> is 0: block=3D232292352, root=3D7, slot=3D0
>=20
> 5. Then:
>=20
> btrfs rescue zero-log
>=20
> 6. Was then able to mount the volume in readonly mode.
>=20
> btrfs scrub start
>=20
> Which fixed some errors but not all:
>=20
> scrub status for 20628cda-d98f-4f85-955c-932a367f8821
>=20
> scrub started at Tue Apr 24 17:27:44 2018, running for 04:00:34
> total bytes scrubbed: 224.26GiB with 6 errors
> error details: csum=3D6
> corrected errors: 0, uncorrectable errors: 6, unverified errors: 0
>=20
> scrub status for 20628cda-d98f-4f85-955c-932a367f8821
> scrub started at Tue Apr 24 17:27:44 2018, running for 04:34:43
> total bytes scrubbed: 224.26GiB with 6 errors
> error details: csum=3D6
> corrected errors: 0, uncorrectable errors: 6, unverified errors: 0
>=20
> 6. Seeing this hanging I rebooted the NAS
> 7. Think this is when the volume would not mount at all.
> 8. Seeing log entries like these:
>=20
> BTRFS warning (device md127): checksum error at logical 20800943685632
> on dev /dev/md127, sector 520167424: metadata node (level 1) in tree 3
>=20
> I ran
>=20
> btrfs check --fix-crc
>=20
> And that brings us to where I am now: Some seemly corrupted BTRFS
> metadata and unable to mount the drive even with the recovery option.
>=20
> Any help you can give is much appreciated!
>=20
> Kind regards
> Michael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--gR533a0hEVZL9rgpPyMNsWtSrPwjnHR3v--

--pArtpPS5XeigrjCdLVNNNGFLbGx6gO2gX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrkNKoACgkQwj2R86El
/qheFgf/akApKThJS4dOsZKln15r8rJtx+1IIUcCQmjs7Oem7hvA79usrTv3zbVY
GJsp0fJoSV9jvdAyMDrnlqSzkbkOmP2To4wAeZ8B13f4uRpStjD0Jd8aAWpZeVTc
/93B6lZk+lqBlKasHRhvEa6c02nPfVaCFTwSl+5+xFK6OyI2/eCwNPFTvRI1ovW6
ML/FsKoMfDOoHsd+f3pSrDDLDOw4gowperNzUkesvKJk1pFIhdwGIf0G8PKETmDl
HFZzzC3+lo5A3fxkyMnK35krGu/N3C/gArMZ1rTttiIBzFWUWZTz8iggbUMVOSLA
t5hpMLDtMU0RY3Fyu9ibzxkrKgzI7w==
=SuLu
-----END PGP SIGNATURE-----

--pArtpPS5XeigrjCdLVNNNGFLbGx6gO2gX--
