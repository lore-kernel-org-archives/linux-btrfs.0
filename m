Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab3KFRJE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 12:09:04 -0500
Message-ID: <527A77A9.7040208@suse.com>
Date: Wed, 06 Nov 2013 12:08:57 -0500
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH 00/13] [PATCH 00/13] sysfs publishing patchset (v2)
References: <20131101170654.164867629@suse.com> <20131106170226.GY16662@twin.jikos.cz>
In-Reply-To: <20131106170226.GY16662@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="enXCMSrhNCa26ekcKxcc17r4gj6296WXv"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--enXCMSrhNCa26ekcKxcc17r4gj6296WXv
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/6/13, 12:02 PM, David Sterba wrote:
> On Fri, Nov 01, 2013 at 01:06:54PM -0400, Jeff Mahoney wrote:
>> v2: An earlier version had a chunk intended for fs/btrfs/extent-tree.c=

>> added as part of patch 13 instead of patch 10, causing build failures.=

>>
>> <fsid>/devices/sdc1
>> <fsid>/devices/sdd1
>> <fsid>/label
>> <fsid>/allocation/data/flags
> ...
>> <fsid>/allocation/metadata/flags
> ...
>=20
> How is the mixed blockgroup setup presented? I guess that the values
> from used_bytes, total_bytes etc would be the same for data and metadat=
a
> and the flags would denote that it's mixed.

No, since that's not how it's represented in the kernel. There's a
single space_info that's used for both, so allocation/data and
allocation/metadata wouldn't exist at all. allocation/mixed would exist
instead.

-Jeff


--=20
Jeff Mahoney
SUSE Labs


--enXCMSrhNCa26ekcKxcc17r4gj6296WXv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSenesAAoJEB57S2MheeWyNAgQAKxkqGufxJeLg65LC+IdRZ+V
Ql224+MShZsMG5VYjBCjaWg7FXSVH+hR33iJ6bY/du7d0/Gy4faDt1qPSy7L+qK0
6DgCpiJ/dpIUOtbMoRO2rUBR2MqPktuQPKxPaXzn2Fhvx23mWv3jvZx6P3an53kT
/oHA7v6wh/g5WbnfCeVLUU2COEwFqoAxuMSg1n+Lo5B0Tbq12T6AZz2DK+0NCHo7
0Piwyece+m6MdyWUt52tuQ/GCAr/yzYCRtndCdeW5Xq1XD7n3LQ/dIGB6SvUF7jW
K8uZqtgJDCchmk8/xewsdDju8gzQMZQs0y4Vsw4e6/0Kf+iBvnQ/PcQbp4CSis3U
hgU6em5R+Q9UGDTqa4UMy5YuvsA8lvEcBoNqK1O3/M+iuw3Dfxi05wNE1zozhn95
CcSm/myQe1ZWomTHqjMf0MGu3e0OJbHMvjZYtOaw0iQK6a4/s/3C1X4IyhGb/ZsH
Kt2bRHSzGjPaVmu2HCVwuDfMSBs/AI/9z35Iw7mQeVo6WoweFjSpRpFpZ0w/cJVm
pec8n5bD3z7soPR4xjB7dyn9w1K7GBEySmYhBcdZcPmrpQt14ZQWoL3Ph8GCcprm
7AD7EG2/67W9BhGhAeHXotgvIWPatZAD2YOyvDt2vGnrAoiTGlH5xNbH0BLk/QcH
Fjz3YcixrvX8u2Q83RtS
=TFf4
-----END PGP SIGNATURE-----

--enXCMSrhNCa26ekcKxcc17r4gj6296WXv--
