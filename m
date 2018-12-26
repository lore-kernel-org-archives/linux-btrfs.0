Return-Path: <SRS0=cHbd=PD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0352C43444
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Dec 2018 05:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F69F21741
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Dec 2018 05:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbeLZFsv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Dec 2018 00:48:51 -0500
Received: from mout.gmx.net ([212.227.17.22]:39231 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbeLZFsu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Dec 2018 00:48:50 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LikyX-1hEOkR2K1F-00cwT6; Wed, 26
 Dec 2018 06:48:35 +0100
Subject: Re: [PATCH v2] btrfs: add a check for sysfs_create_group
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20181226053744.74740-1-kjlu@umn.edu>
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
Message-ID: <8a466bf0-e635-3e9b-4ad8-ae7247d5a715@gmx.com>
Date:   Wed, 26 Dec 2018 13:48:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20181226053744.74740-1-kjlu@umn.edu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8p99PaSdHucG137aID7EvESnYH9vj7xnM"
X-Provags-ID: V03:K1:3R4Gi8h/4AowSwJvsaX30IrXchzUTtG6XUxtwJ4XOC6mxUxrLW+
 jTInMNHL269PpCzcIWZR5nMt2xb6KSnuafgi4BuIHXj7yf3JFROTXsBghmBeijPTZDfgM0e
 OLdVmKDIVBd7P+8T2+I+g8IAbbNS7q/yFatKMcj9NWwkoSZrDrm9VAnUycwR+LdQpczQ/Wb
 i4kDrp/kGitZH+YWS9wwQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:/dZjfVD7b+Q=:67y6Z3aP1EsJEvlWX2ukLA
 9pH33FwC72zAddR6DFTL6rHm4lOUJkuFVLvBwtKJDOem6D+W7Yq4yKkJUDCg7E/e8IhL4I+HN
 RfXKQdeMTZMvjz+m2cd5Vb9hsE1cxI28Wi/sjVaKKWiEa0a6vGM5byvz8wUPFMV6wiIdCz4h1
 wBatpszrfM3Gk51183UHcCLE+wqtW1eCvd8An4fRGMX6lz40uA4zxg+7r6SMTxB9asGI6+I7x
 EoGGYgk7oto2sPRG1Xyy2WA3woEfOabN0JdgZMCD+7PYco23cLhGZyTIUtPv56BIfYS96BGOW
 UFMZYJdluzsHP82PsxvGCMGUg1U09Cg1mzasG5HXVL8YPQKHWeikMGmrvInHWNe2c4YonrZzU
 DJFpNdyBifY4WasXCUI4gFFUW465tI3jSOdrYrHXxhn7IYEwYOW+IXOHwYb/t9YVKlly79zna
 xRZ/qiMpA15ZBJk5UTrEfHEKvkyLUmxCJQEZPN0/kEq0lhKeO6QbVQSmvnBSmL+++f1oq9b6Q
 YP9kh5maWLKB0Q5Wjv2ICH6zv2scre6DyBpDfQ/GpFTuCKcX63Hj8eNj08o7GmhA5KZ4BMr9r
 WeeAAPzzLV3kIja0x0EcZae71HxBk92lzBXcrt8hTpmStQ5iGxV7pHeLr95VJkJ5Sm+Mhr7xa
 J4n/KaEJDvhwYsXpI5EGcx0cAYRpYjNpaaT3V7OpAWKyatJQpjRv8F+7qFov57zu7RybIhO1W
 BtmtIldgC6s6eXAoLgulyeYcuV8evMxRq7mrciNJlBCFlTCVNhDTaWIbHEm14XhFQ/7mRFFqS
 Qh/ky+SaonCtZUgzBUq6M4/B+uDro83bPPa/heYn+K0m4FDQLPwknuItpje0vyXlPjv+bMd/v
 62sEISUjVU09MOLaOjSQhnY0tduI1QIZNjZpZJX/pZ7YGFWUm5/wUQUKcKbOTZYLRMF4WSlay
 5DLF3VI6NiOajIZdwC7mEkbZNbOtNq8k/l5dmXtthOc6rsTDi0GCTzCqex6AqDlqOFYDyEIfy
 fbDWk/SCEjJEy0ioonUabFkPKTk8jZGly30axN8fzN6Bbc7B4gYCwirlhukL/2xD4tY/D0r97
 7NdwYLivEzaWbI=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8p99PaSdHucG137aID7EvESnYH9vj7xnM
Content-Type: multipart/mixed; boundary="X82abKF6dfdI2MpXkZqHZAnBo0r5cnAhk";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Kangjie Lu <kjlu@umn.edu>
Cc: pakki001@umn.edu, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <8a466bf0-e635-3e9b-4ad8-ae7247d5a715@gmx.com>
Subject: Re: [PATCH v2] btrfs: add a check for sysfs_create_group
References: <20181226053744.74740-1-kjlu@umn.edu>
In-Reply-To: <20181226053744.74740-1-kjlu@umn.edu>

--X82abKF6dfdI2MpXkZqHZAnBo0r5cnAhk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/26 =E4=B8=8B=E5=8D=881:37, Kangjie Lu wrote:
> In case sysfs_create_group fails, let's check its return value and
> issues an error message.
>=20
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  fs/btrfs/sysfs.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 3717c864ba23..24ef416e700b 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -889,6 +889,8 @@ void btrfs_sysfs_feature_update(struct btrfs_fs_inf=
o *fs_info,
>  	 */
>  	sysfs_remove_group(fsid_kobj, &btrfs_feature_attr_group);
>  	ret =3D sysfs_create_group(fsid_kobj, &btrfs_feature_attr_group);
> +	if (ret)
> +		btrfs_err(fs_info, "failed to create btrfs_feature_attr_group.\n");

Forgot to mention, for btrfs_* infrastructure, no need for the ending '\n=
'.

Despite that, looks good.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>  }
> =20
>  static int btrfs_init_debugfs(void)
>=20


--X82abKF6dfdI2MpXkZqHZAnBo0r5cnAhk--

--8p99PaSdHucG137aID7EvESnYH9vj7xnM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwjFi0ACgkQwj2R86El
/qhHvwgArczKyrePa/5IRUM/BOZKT55zrOpyVp5Gw5DTSE/7riBrGrYlLal/QgLA
Sn5Cw0yXRUf/rpzUJlF7fXxgXRutbWlJvXpP9QEUP141QGwV4jgdS1fKdvfs4Iz+
rNZArD+bGvoCwt7ckxrctB0nKdNwzTOFB3XA9dAKCZ2W52/hSpXOkYzaoEaOR2DI
uqlIqryalK5fVF31ZLMTs7h/1eoR4aBu/dz1nCkL6y3UywG0JMWBYR7jBHG70kbh
ZI2P2jBR7+J0xGX1uS3lxG/kTZV3YaKNzGNDLFiNn42OBYLoTix6cshVPccrrQ47
Y5q+kPFg+pG4AcwseOBBRtj4WSVb7Q==
=n/AQ
-----END PGP SIGNATURE-----

--8p99PaSdHucG137aID7EvESnYH9vj7xnM--
