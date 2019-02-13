Return-Path: <SRS0=8r0n=QU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7150C282C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 05:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93C45222C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 05:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbfBMFol (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Feb 2019 00:44:41 -0500
Received: from mout.gmx.net ([212.227.17.20]:50705 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbfBMFol (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Feb 2019 00:44:41 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M2tKM-1hBrtS2vKQ-00se5J; Wed, 13
 Feb 2019 06:44:29 +0100
Subject: Re: [PATCH] fstests: fix fssum to actually ignore file holes when
 supposed to
To:     fdmanana@kernel.org, fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
References: <20181029094340.18154-1-fdmanana@kernel.org>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <5e65b105-64ec-bf99-ea4d-b20622ad12a9@gmx.com>
Date:   Wed, 13 Feb 2019 13:44:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20181029094340.18154-1-fdmanana@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DKyM0A5DcxVSL8tZNsNMFo8WvBoSOhD3n"
X-Provags-ID: V03:K1:bjOU/GORN+adMseRfB68EUgGRFcqm0NEqjRgidpiDapAZBYX/Nr
 ksocDHgirmtY1yBiqI2RR9/GKdO2UTVktaQMl5z9vNlBOo71FTjfx9o1M8Q3adlEIR/covf
 LJGtzoG4KqOk1CwfCYfTilAvjv/aZQcvhEawCnHlUfK2Hy6VqMeU27GLr5Mo2wxQ0i1Roh8
 5+5dMs8zl8xu43ZAObwbw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:aqUYIAMEAK8=:Yz6x32KBA2lgWlAMqzvmFu
 JqAAA6cqQyxk/EZDXJs3IN3hx3HohIILlIe068CfLH/XORLsPyDvhfWmRnv7yIIdjdfRwUT1H
 3vYRWsYquo3ZOiZGJBF+lnujnNKa4QIIQO2+Py6kVFzyU321Vm/Ku2Y284LS/areGkQhmo6Xl
 5RAX5NxoJyi16TwyGTOuwBMRIsqhdG4L242GSYtuqMDVqCF3z+Af5kMrYOg2crzTcPaJzL9xM
 GP38BEBeSrqEaRgiYAOPAN66RovDDxhRGiMFh555zuK1UlT4M7zMvAMSF1jEDSLSovaqbBxto
 PQ6Fs11qMOE4r+Lw9ZQGfqF47ny0AjqvV5ftQNY1kXRgHQHzno4J6yB3Nn6NDKC9DSvsv4m+x
 tI/SOJ+VNnTWdD+JIsigsxqN1iWv5uiN6+DMVaRjCWDBHFz+mE2XSQhwsO5kXZu5UKUflJsUA
 KgHPYU7E/9RhAoRpJZnswreJfvQZ0eWjsVOUHIUUhLcAR0+DZlWZaSC/0IbInj+jA6XmnkjFd
 Jva2s/3NkO6l6n/idjkImSYX75TCKU5VFaANKaFG/OsZdzDbAOm+6z/hZ+LilmSGStQfXCWJI
 QcGtEAGjFti3quC8ZTldMfbc4M70KpCEMS6bigLviPkGPCEokjMsXaGz/qk4IMfNhmVi6mJCg
 t4S/aatOWfMmQs0ExqowCUnlI7M3CW8s7wGPc/DCk+BZRZKehM67BOXBj+eygcJOCoWapw9iD
 Zq1/Y9e7jGq78FatKxj/8Ji0TEJ8EhvSHIaua2GC5NUnvdmB9Ib/GLz8f4GmKjMuV2YvfHvfm
 e/16iIgoyrb6jlRvV9vHV+Qmi4kYIb3oknvJp/xhQR3eG2hNpV7325ICPP4iRCyaahtdbZ7E0
 gw1IKojUb1cotzOGYsuIT8XnSyU6qfEKFyRsLWPbxrf+gbsp4iR8CUhyQ9M4Bh
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DKyM0A5DcxVSL8tZNsNMFo8WvBoSOhD3n
Content-Type: multipart/mixed; boundary="FYifrTNYtS9LgRWWzwUtO2ivOiywNuRev";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@kernel.org, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Message-ID: <5e65b105-64ec-bf99-ea4d-b20622ad12a9@gmx.com>
Subject: Re: [PATCH] fstests: fix fssum to actually ignore file holes when
 supposed to
References: <20181029094340.18154-1-fdmanana@kernel.org>
In-Reply-To: <20181029094340.18154-1-fdmanana@kernel.org>

--FYifrTNYtS9LgRWWzwUtO2ivOiywNuRev
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/29 =E4=B8=8B=E5=8D=885:43, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> Unless the '-s' option is passed to fssum, it should not detect file ho=
les
> and have their existence influence the computed checksum for a file. Th=
is
> tool was added to test btrfs' send/receive feature, so that it checks f=
or
> any metadata and data differences between the original filesystem and t=
he
> filesystem that receives send streams.
>=20
> For a long time the test btrfs/007, which tests btrfs' send/receive wit=
h
> fsstress, fails sporadically reporting data differences between files.
> However the md5sum/sha1sum from the reported files in the original and
> new filesystems are the same. The reason why fssum fails is because eve=
n
> in normal mode it still accounts for number of holes that exist in the
> file and their respective lengths. This is done using the SEEK_DATA mod=
e
> of lseek. The btrfs send feature does not preserve holes nor prealloc
> extents (not supported by the current protocol), so whenever a hole or
> prealloc (unwritten) extent is detected in the source filesystem, it
> issues a write command full of zeroes, which will translate to a regula=
r
> (written) extent in the destination filesystem. This is why fssum repor=
ts
> a different checksum. A prealloc extent also counts as hole when using
> lseek.
>=20
> For example when passing a seed of 1540592967 to fsstress in btrfs/007,=

> the test fails, as file p0/d0/f7 has a prealloc extent in the original
> filesystem (in the incr snapshot).
>=20
> Fix this by making fssum just read the hole file and feed its data to t=
he
> digest calculation function when option '-s' is not given. If we ever g=
et
> btrfs' send/receive to support holes and fallocate, we can just change
> the test and pass the '-s' option to all fssum calls.

However this is causing more problem here.

Now since fssum doesn't skip holes, for a super large sparse file, fssum
will try to fill all the holes with zero and spend tons of CPU time
calculating the result.

E.g. when seed =3D 1550703281.
We will have a PiB level file:
$ ls /mnt/scratch/base/p0/f3 -alh
-rw-rw-rw- 1 1441 2774 666P Feb 13 13:39 /mnt/scratch/base/p0/f3

(well, 666, no wonder this will fail)

But it only takes aroud 1M:
$ du /mnt/scratch/base/p0/f3
1044	/mnt/scratch/base/p0/f3

This is even more annoying than test failure.

Can't we just filter out the fallocate/hole punching part in the test
itself?

Thanks,
Qu

>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  src/fssum.c | 65 +++++------------------------------------------------=
--------
>  1 file changed, 5 insertions(+), 60 deletions(-)
>=20
> diff --git a/src/fssum.c b/src/fssum.c
> index 5da39abf..f1da72fb 100644
> --- a/src/fssum.c
> +++ b/src/fssum.c
> @@ -224,71 +224,16 @@ int
>  sum_file_data_permissive(int fd, sum_t *dst)
>  {
>  	int ret;
> -	off_t pos;
> -	off_t old;
> -	int i;
> -	uint64_t zeros =3D 0;
> -
> -	pos =3D lseek(fd, 0, SEEK_CUR);
> -	if (pos =3D=3D (off_t)-1)
> -		return errno =3D=3D ENXIO ? 0 : -2;
> =20
>  	while (1) {
> -		old =3D pos;
> -		pos =3D lseek(fd, pos, SEEK_DATA);
> -		if (pos =3D=3D (off_t)-1) {
> -			if (errno =3D=3D ENXIO) {
> -				ret =3D 0;
> -				pos =3D lseek(fd, 0, SEEK_END);
> -				if (pos !=3D (off_t)-1)
> -					zeros +=3D pos - old;
> -			} else {
> -				ret =3D -2;
> -			}
> -			break;
> -		}
>  		ret =3D read(fd, buf, sizeof(buf));
> -		assert(ret); /* eof found by lseek */
> -		if (ret <=3D 0)
> +		if (ret < 0)
> +			return -errno;
> +		sum_add(dst, buf, ret);
> +		if (ret < sizeof(buf))
>  			break;
> -		if (old < pos) /* hole */
> -			zeros +=3D pos - old;
> -		for (i =3D 0; i < ret; ++i) {
> -			for (old =3D i; buf[i] =3D=3D 0 && i < ret; ++i)
> -				;
> -			if (old < i) /* code like a hole */
> -				zeros +=3D i - old;
> -			if (i =3D=3D ret)
> -				break;
> -			if (zeros) {
> -				if (verbose >=3D 2)
> -					fprintf(stderr,
> -						"adding %llu zeros to sum\n",
> -						(unsigned long long)zeros);
> -				sum_add_u64(dst, 0);
> -				sum_add_u64(dst, zeros);
> -				zeros =3D 0;
> -			}
> -			for (old =3D i; buf[i] !=3D 0 && i < ret; ++i)
> -				;
> -			if (verbose >=3D 2)
> -				fprintf(stderr, "adding %u non-zeros to sum\n",
> -					i - (int)old);
> -			sum_add(dst, buf + old, i - old);
> -		}
> -		pos +=3D ret;
>  	}
> -
> -	if (zeros) {
> -		if (verbose >=3D 2)
> -			fprintf(stderr,
> -				"adding %llu zeros to sum (finishing)\n",
> -				(unsigned long long)zeros);
> -		sum_add_u64(dst, 0);
> -		sum_add_u64(dst, zeros);
> -	}
> -
> -	return ret;
> +	return 0;
>  }
> =20
>  int
>=20


--FYifrTNYtS9LgRWWzwUtO2ivOiywNuRev--

--DKyM0A5DcxVSL8tZNsNMFo8WvBoSOhD3n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxjrrcACgkQwj2R86El
/qg7Swf9F2hoO5xIx0s/OINU4szQwy8cSrAvFK1UlSGL4JwHhYlTsksXtP9qu2+9
mHtnhzlKUWz3q/Efk9PikkqIWNUw1bM8sloloB+MoXLCpwrAk/N57dXkfavMwcgM
vSnyaCp875HCvGkBq1vRKwaBR4tLQIB2bCl4OT2g2DgfJwoiBwb/T2MEsGUhb3I/
LJZe6uGX8sIY+500sc6BspO8lQQSxdkkaEBSDi2X4d11NJg/hQHB7rn42ZaootPf
yTxMnVtTeDUvucnxdDnxvlDZO1Z8KsipXLZh9rkU+AgNm6kLrUDseMF2U+Fnv46m
Ci9SAETJQphlQOpqxlu1pD4DU/JgCg==
=pJHl
-----END PGP SIGNATURE-----

--DKyM0A5DcxVSL8tZNsNMFo8WvBoSOhD3n--
