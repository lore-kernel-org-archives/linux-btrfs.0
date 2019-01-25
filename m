Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D68C282C3
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 01:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B97E218D2
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 01:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbfAYB7h (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Jan 2019 20:59:37 -0500
Received: from mout.gmx.net ([212.227.15.15]:48457 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728063AbfAYB7h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Jan 2019 20:59:37 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LkgEO-1hNHWX3J1I-00aUqG; Fri, 25
 Jan 2019 02:59:22 +0100
Subject: Re: [PATCH -next] btrfs: qgroup: Fix inconsistent IS_ERR and PTR_ERR
To:     YueHaibing <yuehaibing@huawei.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <1548381009-80383-1-git-send-email-yuehaibing@huawei.com>
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
Message-ID: <87ac97b6-2b14-9b48-ed28-4d0cbce7322f@gmx.com>
Date:   Fri, 25 Jan 2019 09:59:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1548381009-80383-1-git-send-email-yuehaibing@huawei.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qgNe8SOIJ4U8KdQr62IyWiGQvTSoEzN5W"
X-Provags-ID: V03:K1:XUcVhVtYtxXBJIJ4d83Ktu9RFH9UHxLyfu5TXmUpo56HjydiFEs
 OyzKRoGy8c6GgQ25J46Qx42QTO2oBnkLu6Qw6AZrfujjeLAacFsUo7clSFKx9DUR9qpFQ5O
 m3EPUZ0dJNxNu4zlZZ60EzCrZqVgpGHd/suIEsVc5HzmN7ds1oFIVQL2c/rj2AWBy5+zEN6
 F8taTYdPV6sN/+4Gl0A/Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:VB9bc4SyJio=:lZ5COpcJq5VCvrBmmHgawf
 YY0xBKxgGUjnQUpAXJ1O/D4ETKcNBntG3lY9VvPSfLi7kVuxf8HqhlNgn0y2cI/1/9MtKHdOK
 pCcvItKcyuYS4roGiw1xKG+vbMZnofPPgDod1icuD9VmvBOdXLMAmi4XtLjpDL416skc55dWg
 JxKgTy3IJGMRzLsjwsE1p0cB3zm6AUGfsPIr5buK9t0nQKzIq3qZqUMGyh0G0kT+XHU4+ZUg0
 ofqVLyOCcPw9CLzvGccehjqk6+RuGHx4BfZHuqniUV9xDUQUdaQDyBuGqXuoQ8mLIiw4eXfce
 qRCNiVFhMYDh0DjybmPaWogk8neCi468reuMsNRsqEbnnSlKZ5UiaLl61ut+RMjCLLVWgIW1t
 UM46ynvtVIZZK2jDpyngWvVocnQmszlhRAW0a3os6F3HCDIgit4OeoxCbHnIEAYg4qBM3JEjY
 F8tH8lH/VVisQ8JecqaVfH21URojqHFCD4sVX5gFSaqjk+4c31NKr+gYfh6KazAzbLeMbxv/y
 uiDe5I/jNE7FqvZyNT/bNB2E7yI+ZCa72+e87gQ3T+kHtDa7SSwZfGiWeYf0+ArtUl4y1U6cP
 /sT4jf/PL7uTW1LNNbt3VszsBS/yTdEJ10OBqTN3c7rWxy+YvXk+iq2+sNiAEaKSS+Aiq9Bi2
 6tm3DH9fczSJJvBDhFfnzubMM7/OsvKQb6ktUe7VfUy1n7ohf54d2RO2zFDy3AI84VKvOhQfY
 s7iKGlIk+IqQUbV5yvybfnM5eu5b7L22cMJc6Z/iuC2xrrS3/WV59gqPty/YwykWXM423MX6e
 ZogKPmT0e6k42oyv/COYIn2UW9U9q6Lm5MO0rR+my1Oe4KMGrgxAwPzU7iTL2XvS9NCJCrG1b
 Bdty8sgfqi/xiq+vCstu5UQ7pmRI04exkrfVmthJCt2zpqHc06whapXHLa1I3w
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qgNe8SOIJ4U8KdQr62IyWiGQvTSoEzN5W
Content-Type: multipart/mixed; boundary="YCXUkXFkYcRcwx6TRk94ZDFWGSRTkI3PB";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: YueHaibing <yuehaibing@huawei.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-ID: <87ac97b6-2b14-9b48-ed28-4d0cbce7322f@gmx.com>
Subject: Re: [PATCH -next] btrfs: qgroup: Fix inconsistent IS_ERR and PTR_ERR
References: <1548381009-80383-1-git-send-email-yuehaibing@huawei.com>
In-Reply-To: <1548381009-80383-1-git-send-email-yuehaibing@huawei.com>

--YCXUkXFkYcRcwx6TRk94ZDFWGSRTkI3PB
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/25 =E4=B8=8A=E5=8D=889:50, YueHaibing wrote:
> Change the call to PTR_ERR to access the value just tested by IS_ERR.
>=20
> Fixes: 2b35a512e9cf ("btrfs: qgroup: Use delayed subtree rescan for bal=
ance")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  fs/btrfs/qgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 8559ed9..16d7ec8 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -3931,7 +3931,7 @@ int btrfs_qgroup_trace_subtree_after_cow(struct b=
trfs_trans_handle *trans,
>  				   block->reloc_generation, block->level,
>  				   &block->first_key);
>  	if (IS_ERR(reloc_eb)) {
> -		ret =3D PTR_ERR(subv_eb);
> +		ret =3D PTR_ERR(reloc_eb);

Nice catch.

I'll fold the this fix in my original patch if it's OK for you.

Thanks,
Qu

>  		reloc_eb =3D NULL;
>  		goto free_out;
>  	}
>=20
>=20
>=20


--YCXUkXFkYcRcwx6TRk94ZDFWGSRTkI3PB--

--qgNe8SOIJ4U8KdQr62IyWiGQvTSoEzN5W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxKbXMACgkQwj2R86El
/qjCQgf/ZGh+mpxDZQ1fNekELd9Z/WaugVr93RhnGG11Ly/FgHDGVTYPVJywNWpd
rQpxJ0dBO4KmW8i5nPpHsccxoGibcdZ8efdBklfoTWFKyIvKrMbfA1uFglNgKZVg
hH1LAsXnydjsI/J/rL/p1o13QI3lLA8seEL7/Y0QBgY4fgrtXL7C02rNdGFODYsp
SWgja5kZ6+iB+Kl0BUEhkg28cKeGoy64OOcj2usUZWVe2yDvl/GJ1MRRhypvXkH5
yrJddZLSzpJgEqJcxpHB0F+ne7l4y1hj2zvDOCEapGuAQObNXunPqu+cTFLtzY/f
nmSzOF27xJOemn7iG9ZFkn7hcC2yqw==
=RPRW
-----END PGP SIGNATURE-----

--qgNe8SOIJ4U8KdQr62IyWiGQvTSoEzN5W--
