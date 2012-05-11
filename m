From: Aaron Toponce <aaron.toponce@gmail.com>
Subject: Re: Minimum device size of 256 MiB?
Date: Fri, 11 May 2012 14:50:32 -0600
Message-ID: <20120511205032.GV21964@eightyeight.xmission.com>
References: <CAALTfKDFhNgCuvuA3C+wYCBL2b-qZkNrwti_MbNn4Aiob+QdkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="IuJpT0rwbUevm2bB"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAALTfKDFhNgCuvuA3C+wYCBL2b-qZkNrwti_MbNn4Aiob+QdkQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--IuJpT0rwbUevm2bB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 11, 2012 at 03:57:24PM -0400, Berke Durak wrote:
> There seems to be a 256 MiB lower limit on device size : mkfs.btrfs
> refuses to create a filesystem on a device that is smaller than that.

I've noticed the same. I'm interested in researching the patterns the
filesystem puts down on an encrypted container, but would like to use 1MB
files as the block device for the filesystem. Looking for patterns in 256MB
files is too expensive.

--
. o .   o . o   . . o   o . .   . o .
. . o   . o o   o . o   . o o   . . o
o o o   . o .   . o o   o o .   o o o

--IuJpT0rwbUevm2bB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: http://ae7.st/s/pgp

iQEcBAABCgAGBQJPrXuVAAoJEM55Ebf8BAiPfywH/iRI1880nvVCEczff4gmfd6X
J2gElNaarPO1G4WQFq2ifQ4oVMq/Wqdq8igWZHJb7aZoJ2lSzMLP/OIC7/J2pasU
XF4QPQBjYOYOTPC8DBZPGV/4c5qiOOb8tsSosUlXptye3ecMEQRWNnFPCpBpDDzA
IZkM+1IkjEuxbidxg9FFTV3dAgciiLSLqEggiQs70je7gCTpsxEjd0Ubn6J6+Y8w
xE9DYZrENdwjmDpEtrHVkQLLhSv860i1RAXBRLeMKbiLID8fOZ4uknvaBoEGk434
8kwSGvoIDCU89dgql131TYe8wBUKiHE5H4kOc3jEV2aG6Mo7DNN23v5uMmRQFho=
=FwMw
-----END PGP SIGNATURE-----

--IuJpT0rwbUevm2bB--
