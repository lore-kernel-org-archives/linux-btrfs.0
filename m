Return-Path: <SRS0=cHbd=PD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C16D3C43444
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Dec 2018 05:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99E33214D8
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Dec 2018 05:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbeLZFT5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Dec 2018 00:19:57 -0500
Received: from mout.gmx.net ([212.227.17.22]:58655 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbeLZFT4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Dec 2018 00:19:56 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MDn8s-1gaPZN119K-00H6wU; Wed, 26
 Dec 2018 06:19:40 +0100
Subject: Re: [PATCH] btrfs: add a check for sysfs_create_group
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20181226034607.73523-1-kjlu@umn.edu>
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
Message-ID: <f855ee8e-7a02-8f0c-5327-baa78a4340f7@gmx.com>
Date:   Wed, 26 Dec 2018 13:19:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20181226034607.73523-1-kjlu@umn.edu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IEsgZL5DSxyiOVdtqLY21VeaqXdblcmeD"
X-Provags-ID: V03:K1:NIgPZYi5sGhhZGioW5SPmPYlTn+DF4/8UpJsU3rD/jhQm9SHKXD
 Dy0J2HHLgChZB1uDOZohlrySTC3VEgkl/kJn+EaMjGSQOKqvSwe3W2p9VPvUAq0jwpEJ0h2
 HIsPdqlvMt30hJr0RbGHZbrB3jlW7D7WEMzvkPKq0cMQlJb/Kc2ZXqTq+Cx5LUJM6jsnKIp
 70UdP3ZxF23Vv5LyeABsQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:eLSlIGENfXQ=:6elISIxUF5f2TQJz+xJhue
 lj+dCIRSdEqXmmE6zuPf5cG8ls0KH2Me0MQ9FmMAusZC/Ok7ZYxgVwjmWJY9hhbQtboApND0Z
 NPR6S6jhuT4HgQYeDuIK+808/rk/+em4dWxLh/cz5G4iNxP/0QTb+iDP4jcHwT0Ri69bltCJG
 RcXyo/VExDPNIUDU9XwrgZWuL+4NxVixZsUhTYF8AnRsSdwUl7tR71uk8WU7vIvt26ldvVXvJ
 ngpRz3/KYQuk5AXkTLVvLXoTD+U0sH8OtmqrF7+XaYT/jOuoa0nGmrNVme+IuQObq7iCd4ldq
 VzS7+VA9YPK0iefd0w3xrRMurtxQblHmoDBd2MtnaHkiFTira3zFllE03P2pODtveyG25jK/N
 vYTvszYYSBNhnY/TqSopJmyGC3K0kfvVcxSZFvT4I/Xz/6mtUqzOt3PQ7DFUjW3H6BM3Wo9p7
 VFqPPL6sIYV2U7fwFhPyzB4MDVDzZMucla9gP21vU6yLyIhid/JLa6rtnI7o9WOPGrHjeU/Xj
 TSu/lSLj82rC4XGmP4sClwJwqWqGi3lDHOOYLiZIwfaSRhptS9LIkmD7gJeJ5ifjL1aBZu3ui
 MZb1aPhOYkhWyXE5uBenMRh9yl8cuvNnLVx1/+0xKROqBXJ5h6bSRvVrcG5ZtPiFSVferrW2A
 /9gjMlQWmO+Cd4Gs72qHurgaLQV8z2jW9VZ0wckCKitTXv0IGKWfg3Sgna0AxAAT5/zLNXF0N
 U/A0/IVAov8ioJKOpIP9wKN8UYq/0SI/8CrpxLaqZ79MxEGxXJ5vLN3ZYKFoHJ2kKFAgluQYp
 LT2Qcw8mTu45uF8CrrWC9TORuhdGi4b4a3h5gzdR7OjoE5tY3d2P6cszib4dP+5kIn4hg+J5w
 6KuCZr8zqD/fdiSoZK//PxPKvfyYJXnk7SMhIjz0CYyi1bKu0+Ce84LzPT5crc
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IEsgZL5DSxyiOVdtqLY21VeaqXdblcmeD
Content-Type: multipart/mixed; boundary="DPjGUiB9JC5a1xFJqUgtR8GNMz2xS3SWa";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Kangjie Lu <kjlu@umn.edu>
Cc: pakki001@umn.edu, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <f855ee8e-7a02-8f0c-5327-baa78a4340f7@gmx.com>
Subject: Re: [PATCH] btrfs: add a check for sysfs_create_group
References: <20181226034607.73523-1-kjlu@umn.edu>
In-Reply-To: <20181226034607.73523-1-kjlu@umn.edu>

--DPjGUiB9JC5a1xFJqUgtR8GNMz2xS3SWa
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/26 =E4=B8=8A=E5=8D=8811:46, Kangjie Lu wrote:
> In case sysfs_create_group fails, let's check its return value and
> issues an error message.
>=20
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  fs/btrfs/sysfs.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 3717c864ba23..62529153a51a 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -889,6 +889,8 @@ void btrfs_sysfs_feature_update(struct btrfs_fs_inf=
o *fs_info,
>  	 */
>  	sysfs_remove_group(fsid_kobj, &btrfs_feature_attr_group);
>  	ret =3D sysfs_create_group(fsid_kobj, &btrfs_feature_attr_group);
> +	if (ret)
> +		pr_err("failed to create btrfs_feature_attr_group.\n");

Btrfs have better error message infrastructures (e.g. distinguish
different filesystems).

Please use btrfs_error() or btrfs_warn() instead.

Despite that, I think the patch looks good.

Thanks,
Qu

>  }
> =20
>  static int btrfs_init_debugfs(void)
>=20


--DPjGUiB9JC5a1xFJqUgtR8GNMz2xS3SWa--

--IEsgZL5DSxyiOVdtqLY21VeaqXdblcmeD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwjD2QACgkQwj2R86El
/qizGwf+L9R4RTkoy8d69ho2xvEEvOGh9ZD2WdmIXuLJueXgxOHylBs0QIJo4QH/
KzmodW7r3mX+pvPoI3NObTU/ACq2FFOPi+dWY/zdSGUmOuFDYyjljP70OWZoolN7
Nx8llubPc+nQLcI2vJcIFDSMjSjeNXsZIl8Qd3XN9mpBhHAHvcHj4y8Caqj53rRf
Vsf3IWMCPXtewNpEqp4NJZuuzTQLxULaWOUDXm2CsxJeXa+B2wVIn/dLSRqBxipq
/bJSXy5NNjP8CFo6zsSu1nmyyt/Is3q03uaMidRyOyQS1Kvm6Bu/DeuY+12c9SVc
MhHUIPL3xMRbzaBwE509Umc7qVJwnA==
=fqQa
-----END PGP SIGNATURE-----

--IEsgZL5DSxyiOVdtqLY21VeaqXdblcmeD--
