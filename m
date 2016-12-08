Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53886 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751959AbcLHUHV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Dec 2016 15:07:21 -0500
Subject: Re: duperemove : some real world figures on BTRFS deduplication
To: =?UTF-8?Q?Sw=c3=a2mi_Petaramesh?= <swami@petaramesh.org>,
        linux-btrfs@vger.kernel.org
References: <81bcff57-4bee-18d5-cac4-3359150730a5@petaramesh.org>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <930fe4c7-b936-8f2d-fc4c-cc5574c27f19@suse.com>
Date: Thu, 8 Dec 2016 15:07:09 -0500
MIME-Version: 1.0
In-Reply-To: <81bcff57-4bee-18d5-cac4-3359150730a5@petaramesh.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XEjAcss7rnHaKkr7QwALAgbSRcidxmsU2"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XEjAcss7rnHaKkr7QwALAgbSRcidxmsU2
Content-Type: multipart/mixed; boundary="jLHPCBh01j1KbijUVnCVgUn6LMAwuRBhr";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: =?UTF-8?Q?Sw=c3=a2mi_Petaramesh?= <swami@petaramesh.org>,
 linux-btrfs@vger.kernel.org
Message-ID: <930fe4c7-b936-8f2d-fc4c-cc5574c27f19@suse.com>
Subject: Re: duperemove : some real world figures on BTRFS deduplication
References: <81bcff57-4bee-18d5-cac4-3359150730a5@petaramesh.org>
In-Reply-To: <81bcff57-4bee-18d5-cac4-3359150730a5@petaramesh.org>

--jLHPCBh01j1KbijUVnCVgUn6LMAwuRBhr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 12/8/16 10:11 AM, Sw=C3=A2mi Petaramesh wrote:
> Hi, Some real world figures about running duperemove deduplication on
> BTRFS :
>=20
> I have an external 2,5", 5400 RPM, 1 TB HD, USB3, on which I store the
> BTRFS backups (full rsync) of 5 PCs, using 2 different distros,
> typically at the same update level, and all of them more of less sharin=
g
> the entirety or part of the same set of user files.
>=20
> For each of these PCs I keep a series of 4-5 BTRFS subvolume snapshots
> for having complete backups at different points in time.
>=20
> The HD was full to 93% and made a good testbed for deduplicating.
>=20
> So I ran duperemove on this HD, on a machine doing "only this", using a=

> hashfile. The machine being an Intel i5 with 6 GB of RAM.
>=20
> Well, the damn thing has been running for 15 days uninterrupted !
> ...Until I [Ctrl]-C it this morning as I had to move with the machine (=
I
> wasn't expecting it to last THAT long...).
>=20
> It took about 48 hours just for calculating the files hashes.
>=20
> Then it took another 48 hours just for "loading the hashes of duplicate=

> extents".
>=20
> Then it took 11 days deduplicating until I killed it.
>=20
> At the end, the disk that was 93% full is now 76% full, so I saved 17%
> of 1 TB (170 GB) by deduplicating for 15 days.
>=20
> Well the thing "works" and my disk isn't full anymore, so that's a very=

> partial success, but still l wonder if the gain is worth the effort...

What version were you using?  I know Mark had put a bunch of effort into
reducing the memory footprint and runtime.  The earlier versions were
"can we get this thing working" while the newer versions are more efficie=
nt.

What throughput are you getting to that disk?  I get that it's USB3, but
reading 1TB doesn't take a terribly long time so 15 days is pretty
ridiculous.

At any rate, the good news is that when you run it again, assuming you
used the hash file, it will not have to rescan most of your data set.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--jLHPCBh01j1KbijUVnCVgUn6LMAwuRBhr--

--XEjAcss7rnHaKkr7QwALAgbSRcidxmsU2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJYSb1uAAoJEB57S2MheeWywAAQAKIOZf+QfSiIaLHuVO2b/7ts
FLMDLpPV9Or/WuSC85ckC3Dqwxw+e0S2I4QmsBUwS13Aywh6CfWRhRIJm4m98lsF
QXcTweMgJl5UDaLtNEIk/QSE/1pNgHXGDQKpf5mT67TFchwl5yYcmly5WbGuXdk+
poUH92D5bgFe9Pq8BbOR8B5sll24MQ1zelPpK0iYyAqOUCr6U/TyMNnjvbqk584k
8/IzVdmpdBFPx+20wEoo6qOzgyy4NFiv50UMJNobzK+p7PgyPcyvJNc6fS92NG21
tb2hPlbzqiqBOuux2VV9miRGlKhHnLtpAd3tbhRkpg9qFCIT9MtuUDoS/yMI977J
c4UtjOM7o1v20NpZadOaBc+/2a6tF6CIyGDtlYpjg2q8Pq5aej7t/noe/UTeQFVC
5m9zzyuy0HYSJRyKzcsijimNXlSuEjf48AeEl4Tu8f+D6yJQKOZcv1IYxg6lv8U9
w1NabVP/01P7Mdebs4+0HqxA2L/hDdGnvU3p5o+nw07VHPTkCNmF05OiGZ0Q0THX
94d7oeL3ukw2hq01AGJHat3yCMpibSgwN9EPOHm/Xfl3xqtmvi3OSfKylpOJiCYE
jKYjbCMGGx7cTq41rkz0O7nxShQPf3+N+C+mJ4a1fK7EsOrExmTw/2I4zZYMKaYn
I5qrkAAHUL51wLHD6Zgk
=dwqn
-----END PGP SIGNATURE-----

--XEjAcss7rnHaKkr7QwALAgbSRcidxmsU2--
