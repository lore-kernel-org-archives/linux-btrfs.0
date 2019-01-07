Return-Path: <SRS0=zk84=PP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19DF4C43387
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 06:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA63E2085A
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 06:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfAGGwI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Jan 2019 01:52:08 -0500
Received: from mout.gmx.net ([212.227.17.22]:41983 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725777AbfAGGwI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Jan 2019 01:52:08 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MFAaV-1gV4uF3npr-00GHjg; Mon, 07
 Jan 2019 07:51:58 +0100
Subject: Re: [PATCH 0/4] btrfs-progs: check: Add repair support for mismatch
 dir item hash
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
References: <20181025074449.32469-1-wqu@suse.com>
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
Message-ID: <40066cc8-e631-2ceb-6dc3-01795778a2fd@gmx.com>
Date:   Mon, 7 Jan 2019 14:51:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20181025074449.32469-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="yAlC7nt6c8fBTcRlMiq5BOZhjdkkY33Zz"
X-Provags-ID: V03:K1:sWIX6TorTyDTYp0q0lI8WRAXEGvrImIKHlkP2j4kRKR53miqYKp
 u9NYy7TORf1w8khx3vuFb4D1SHWBihp4clPIdPUTt2z/XXzFxqb9rA8/8UbAhbTBd/4rE3x
 HtqOKh5P+/IONf8KqQfPziZ0bhyn7FrtxYC8CD9OOTkrPLtNp1+AEtWpxPP5JPxGaWoKOrt
 d2PIcOk+5uaGYfMGiiOgg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:7FrGSTE8BV4=:dXPKuGXdKUXGPz8Cfyvld6
 VsVchr3V7wrhfxhXdnlzHdw5iFGWt3TWXXpUkZskujzSUflWKi7E/Yr587DMlT4lIsWiCWR5q
 3JmL1S/YGJ0Srsl3gmKBmYBfkS83Jbwr5oha1nVtrcRI5+BbrKbiZdl/YATkjR1Dy2fVeUuAE
 pbZvN9BXthRIWDU9LIRrDFcfJv5wrbPu6pWAJqr6p3Uq16nL57i4gl8vfmzSRZ4L4JzFwlXQa
 K7hUKfPbWX/It0brOuMHznAVWjLPpJEQm7ufQ2UTHD2SxIS5jy1t36bdQRX0ktFjaQ+uBmcGx
 5V1lP9Mxv+5EHnE7YvEfk1Qb/tZgg0w+NdXjiWVFkGfsUP+NX1TIoh2Peli1NMuq8vBjK9fiO
 P0jh+dDKPrJ+pCaaSWTZsAw6ADrQ8g95KxBVIMdhAFgwT6vuZaqZNB0HUsd0LFDvfVQr3sxfx
 kIFipEdxAbzUtP9Q9B8RD8izvDBqzHSm3dJA1aMtSaE6nBaOZm5ySSFlPnw2ZfNC+1yh/ohGK
 P7GfR1ARjnA7cb6ApNHG/rfFooGyHOINh8HyhdO74HabloPJjA3sarK9lQT8k/kNCXd8YhGJz
 4x0AJlVBkqqkUaKbR5DwU//aiaiZxMA7mjIhFkNMpnXDygVlyl2rlsOls+AwFbNsJoyxd5/0E
 5v+ImKVNtaSJa90KcK0uyhndoco4jZuyfzlAZjWGYhRx+CtBS2noBjuIjxIsY8Yymp7t34OBZ
 buwJBwuG90UDksEiANpxv1SaVzDXxUuFTLGzmrigKSbbNpCYjl+vbI8Y6jyiLC9HXlv79jOLh
 mkqhMR7KFci0hZvtKWIA9CwOMHubD/sI/EF4wBYEjVD6l94/XkLol7Nt51mTp2/9As4ytvhL/
 ASFyVtOYxbrVjobJfKmb9wylzJwhqZRd0gp86g6FQ+IZfoKz9PrZXTvgP7Xouj
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--yAlC7nt6c8fBTcRlMiq5BOZhjdkkY33Zz
Content-Type: multipart/mixed; boundary="xGdObWPJObGAwsYriQEI8VsZe400vJ8du";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 David Sterba <dsterba@suse.cz>
Message-ID: <40066cc8-e631-2ceb-6dc3-01795778a2fd@gmx.com>
Subject: Re: [PATCH 0/4] btrfs-progs: check: Add repair support for mismatch
 dir item hash
References: <20181025074449.32469-1-wqu@suse.com>
In-Reply-To: <20181025074449.32469-1-wqu@suse.com>

--xGdObWPJObGAwsYriQEI8VsZe400vJ8du
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi David,

Would you please consider merging this patchset?

There are at least 2 user reporting latest kernel tree checker refuse to
mount their fs, and this patch is needed to allow btrfs-progs to fix the =
fs.

Thanks,
Qu

On 2018/10/25 =E4=B8=8B=E5=8D=883:44, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/btrfs-progs/tree/repair_bad_dir_item_hash=

>=20
> This is still based on the latest stable v4.17.1 branch (which is alrea=
dy a
> little old now)
>=20
> We have report from suse bugzilla where user report latest kernel refus=
e
> to mount the fs.
>=20
> The problem turns out to be that some old kernel (around Jan 2017) has =
a
> bug that could leads to corrupted dir item with mismatch hash.
>=20
> This patchset will allow btrfs check --repair to repair such problem.
>=20
> Qu Wenruo (4):
>   btrfs-progs: lowmem check: Add ability to repair dir item with
>     mismatch hash
>   btrfs-progs: original check: Use mismatch_dir_hash_record to record
>     bad dir items
>   btrfs-progs: original check: Add ability to repair dir item with
>     invalid hash
>   btrfs-progs: fsck-tests: Make 026-bad-dir-item-name test case to
>     verify if btrfs-check can also repair it
>=20
>  check/main.c                                  | 121 +++++++++++++++++-=

>  check/mode-common.c                           |  51 ++++++++
>  check/mode-common.h                           |   5 +-
>  check/mode-lowmem.c                           |  46 ++++++-
>  check/mode-lowmem.h                           |   1 +
>  check/mode-original.h                         |  14 ++
>  ctree.h                                       |   3 +
>  dir-item.c                                    |   6 +-
>  .../026-bad-dir-item-name/description.txt     |  41 ++++++
>  .../fsck-tests/026-bad-dir-item-name/test.sh  |  13 --
>  10 files changed, 272 insertions(+), 29 deletions(-)
>  create mode 100644 tests/fsck-tests/026-bad-dir-item-name/description.=
txt
>  delete mode 100755 tests/fsck-tests/026-bad-dir-item-name/test.sh
>=20


--xGdObWPJObGAwsYriQEI8VsZe400vJ8du--

--yAlC7nt6c8fBTcRlMiq5BOZhjdkkY33Zz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwy9wYACgkQwj2R86El
/qiPRQf+J7tGH+LaGZjRK78Cs6xizfTtIyU4rx08dkzV7RLb3gKs/AfOuWmQkoX0
08vwYK/iuL4MBLxpFfUdE4MeC4hqdzXLQ/3esofXCBkiJYcc5jcH3biBiLsg+0+3
juF6HcCL1NIaRVcUYdKIMmCq1n/BPEZpvv7YKCFf3Rkd7PER07CVdvR7GJzyZb8z
F92/UJIO4w3UnC2UiotrEZ50/xwJUWzeRS2L21fb9rR6G+iKeoP3AvoUZc/Gj4nJ
pWfn3TlKr0mM1VF3gYVg/vXjhIvewm4Lg7X5GNzjZsFF12lCjJ73GSAwBjobBogL
E1dWuA6w/hQ7SSsRMvo4oDcOPLBcKw==
=hEJ1
-----END PGP SIGNATURE-----

--yAlC7nt6c8fBTcRlMiq5BOZhjdkkY33Zz--
