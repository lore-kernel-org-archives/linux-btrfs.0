Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C492C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 05:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D98620660
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 05:39:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfANFj5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 00:39:57 -0500
Received: from mout.gmx.net ([212.227.17.22]:55289 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725910AbfANFj5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 00:39:57 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MPppG-1gf5Uf0WdW-0055EN for
 <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2019 06:39:56 +0100
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: [REGRESSION] Super slow balance in v5.0-rc1
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
Message-ID: <f26305c2-3c8f-6d16-f414-636e5548851e@gmx.com>
Date:   Mon, 14 Jan 2019 13:39:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NDX9XXnkXffln5xu0wS2KqzPDjxQy7hnJ"
X-Provags-ID: V03:K1:NBzSgqOXLe9SYYhhFE0bWAocD22LrR9hgYv+qWag6lCId2ncSMi
 ZOQXnfDKJBp3YgRf8ILSZPjBT2jHCvy7CYIphxMsWgfAVjv/hBKZir9q+7iACUOJkoEXTjX
 a4m+n+EKO2FWJD72NwncIjj8Hx8CaxZuyZwm7CwiTzs0PeQQfgZbuLw2BSJ2EO7ObckqZ6W
 t7n0LScxeIMGj9f9pDlBQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:V2gP8tu+udw=:FON0LGjfS0GP7C09ijsHLC
 i/Kh56qiD/Kb6ziph5yPbI4AH2Q2lOYPHvVeMxQ+2YXXYUqF3O8Yv84bonoODoMlU0WqRburP
 vj82JVo/8Yd+8vLlDYNLJfs84ZcdSt7Y057dRcx48POU2VTT62Vmj8Xwp7nZR+IL+lGVFEioN
 78af+BcZ2tyWqViwp4eqvGCUGJ3OD8AZOtZ4Wp0l8dMwM3dUW16aSpvZzw6rZF6iY7qLUWcAe
 hdSFYQKc9laiHJsRfBHm5M4J8b8uwUliqNacxZ7ai0gpGcmYS/HuSX4pwRUwnTn2BFHi3IsJJ
 VlhGnosG7+GT3uExqBBfwrHE5/PZ/wLfMf57beo3L7D6WlF7X02XqJJdtXCrKoQT+jXgI7f9H
 p/RCnIjmjUVngKjddTsQQdwGQNhmRc2AEbla7o9Rug7LuXwiWmoBTvZULrMyioBLVdFikdybZ
 5c0QY9WreX55xPxqCUnBCBLFx+UyCAinsHLZesjGELAdEUxADbqpgscfQ5rtEuExSnpkDsbPV
 NHeZOfYAMOGDOtiUM2qdnFAzejckEV/+kNdRLsPn9lMT/EWPiECJcyM971x7dO6jxNLj+VHmZ
 unapeTgg2CmImZQGZK2icLV5E6fmhEb0qopVq0Elkxohksx13osv1zeGibqCvXro+X5iXECOd
 npzm3/PGsQynf4YxUsKuSVNWaMs0rzmlRBWs6rf+ktk4wuKDfCc9X3g9As7QZFFA7M2YqUpnM
 yvaioQQvMcDNU1kTY6ccEZFmE4drFTEmZXX8nHm5AZIoh5RffPfUnV+uMc+Oc5gwMqazQcZ37
 eRHD3zfJqK3wDrD5gskrawikWwYBwSc9Bt/mNNmfDZx2X4Q2lHYKqZ1h97NWRsRhqmo+jNeEz
 Y98DvXd3J0E1m+1Oecm7mYuelXyKgk9BYi60IMR5Oh3FsQvKIiBcVBe7T3Z0AA
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NDX9XXnkXffln5xu0wS2KqzPDjxQy7hnJ
Content-Type: multipart/mixed; boundary="WUihtgO6F7xwm3Q7qpFhbEVVURK06s2Lk";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <f26305c2-3c8f-6d16-f414-636e5548851e@gmx.com>
Subject: [REGRESSION] Super slow balance in v5.0-rc1

--WUihtgO6F7xwm3Q7qpFhbEVVURK06s2Lk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

When rebasing my qgroup + balance optimization patches, I found one very
obvious performance regression for balance.

For normal 4G subvolume, 16 snapshots, balance workload, v4.20 kernel
only takes 3s to relocate a metadata block group, while for v5.0-rc1, I
don't really know how it will take as it hasn't finished yet.

And the most important part is, this happens when quota is *DISABLED*!!!

I'm bisecting for this regression, but if there are some users trying
latest rc kernel, please be aware of this regression.

Thanks,
Qu


--WUihtgO6F7xwm3Q7qpFhbEVVURK06s2Lk--

--NDX9XXnkXffln5xu0wS2KqzPDjxQy7hnJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw8IKIACgkQwj2R86El
/qgcmwf+PMWBLXyA/msf2BMLNO9MbZKkLVswLcHU2GVM43Heu/sUptx5McF9lOOJ
EBGpejGbg77Y2mTfh6YOyByuwviVnwsfYMHcBICI5Sr2lFhKqNCAtCQTPLBcrSZb
qB7c+1W0MYwC41cZje+mVuQkKq/ueN35KEL0PaZmndPYmNvdOJVlgflTFiAhgo+o
32QWWO5WSAXdi/Z+O+E3DUsWAap/TEW21VYZB0v8oH+aZo7zUkBWNZV8jnDoXQfs
eyb7ln306dPViAlloCRegxvhWJadJmDAT1ZEerzRQ0ZPGk185loUOUrrrcej/1SQ
FBceVWGM4g7eckQngT8ee5mVQA1ayA==
=5fXg
-----END PGP SIGNATURE-----

--NDX9XXnkXffln5xu0wS2KqzPDjxQy7hnJ--
