Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F986C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 08:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6513B21855
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 08:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfCNIAC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 04:00:02 -0400
Received: from mout.gmx.net ([212.227.17.22]:48723 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726284AbfCNIAC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 04:00:02 -0400
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MVZuV-1hXskC1Esx-00Yvl2; Thu, 14
 Mar 2019 08:59:44 +0100
Subject: Re: [PATCH] btrfs: fix a NULL pointer dereference
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190314075041.28966-1-kjlu@umn.edu>
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
Message-ID: <6c65c23a-71f7-d31d-63b1-91919b933def@gmx.com>
Date:   Thu, 14 Mar 2019 15:59:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190314075041.28966-1-kjlu@umn.edu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mC0apToDGpZarcL1RQjPGdoj9rin4f9dz"
X-Provags-ID: V03:K1:aNwG+hVOWzeldTzhy9WIyM6rfhfYvCKcKIlHZZoLzwKC7sj/5yR
 32OyrthcYZFKDG+sYTAaIGh9NCIlE7+EoV1+DuaJVM3ly0rTuj1qABJM6nJ9y39CU8Sfo2H
 g3WUeU6Qxl67WT1ZqK/ejWl+mvtztIr0pwsoNKlHkXMufhX5820y140P9DidCMvE69rjl7g
 D+hOhKntSwvJsoPDj/koA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:gZ2kgHBJfA4=:Pkr9RettYYRsdQkJwTw0JK
 VUjS8CovZordD4ApMkkdEVXeq4IRffi42iGU1esINRYh+ddIEpHULFeK35qIlgtsG+8CF4345
 LeDCsUiXb4nVgWGjHgwT7hG1Li4YMihge2p8yj+jwz66Ux/iwucr5sfFqaZpyuJNSJFl0rWb/
 /i9EcyT2fPli00i/EM56QsGisjFTdfFoQAG5En07CdOJdVs+SjKtZBFJiEprvq0IB2ohZJohv
 gjAVLOUMa2Aa0cvud+VvuVf4oenA8Q3pYKBKPzN7tSv6KaiHrjbAiJwTW0lODHgSPtm+qVBoi
 9lTg04YK9cjh/DC+dM+GiTd1uH/HX+PibprIjo5VDgIGaPULVUNias3f5sg5hz3jaO9DfeHwm
 KNNwfhQxCQFEk2e5yCVtc2uWBH7mGz/nV4/bzQy2YUOZPYrXujDTAStd0TNdLM34gC1omFWx3
 fM6+P7fSTQecyrVjRiUGNRWmPcYXTch+7P6rjU8DcVQpBsAGQyj5ZW96JGMcRu9r6DkBnJlgJ
 WiJnYF9+GzEP7fZxuhVivpTgweSvPHMIZbZAcVKiQsWeUA2KFMAX5XzhDM8luH9OvbDuGmTnK
 TSzv4VpW8Vtr7zZ+cHqLYpO/jnSANCEW4CPyjnffj9+Ft87ulggCbJuv4nZw1Wu+ZuINP5JXY
 dtFN9Bo+QFeYYyXaMj5tjMYFKsNMVrxeEnjUAuL+1E8qwVPuWgxOEz4LxwGvUz1uP1iEcrxAJ
 spUg7EZ10RksNqD3vLwcf4TECpSds9lM3I3SnDYvGdOFjcFxPIlrsO0ZjrLY7qw4+hpxN1nM+
 NSu9SkRd93q0bY05cgCQvbSwMUzVbxtR4mG/rhe8wwnJVyQfRd0VZVa2v0n3jfM8WQqHaLkuX
 QbmAUkZ+p57FsHs26vVuVkeFg6Y/DVO2m6V95JXKeUghM+tJ8aIq5Zd1j6d5pI
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mC0apToDGpZarcL1RQjPGdoj9rin4f9dz
Content-Type: multipart/mixed; boundary="Z4BVcKsIXLHGNn2aJ33lNEzVAC2MM8l07";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Kangjie Lu <kjlu@umn.edu>
Cc: pakki001@umn.edu, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <6c65c23a-71f7-d31d-63b1-91919b933def@gmx.com>
Subject: Re: [PATCH] btrfs: fix a NULL pointer dereference
References: <20190314075041.28966-1-kjlu@umn.edu>
In-Reply-To: <20190314075041.28966-1-kjlu@umn.edu>

--Z4BVcKsIXLHGNn2aJ33lNEzVAC2MM8l07
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/14 =E4=B8=8B=E5=8D=883:50, Kangjie Lu wrote:
> btrfs_lookup_block_group may fail and return NULL. The fix goes
> to out when it fails to avoid NULL pointer dereference.
>=20
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  fs/btrfs/extent-tree.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 994f0cc41799..b1e7985bcb9d 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7303,6 +7303,8 @@ void btrfs_free_tree_block(struct btrfs_trans_han=
dle *trans,
> =20
>  		pin =3D 0;
>  		cache =3D btrfs_lookup_block_group(fs_info, buf->start);
> +		if (!cache)
> +			goto out;

The check itself is OK.

Reviewed-by: Qu Wenruo <wqu@suse.com>

The problem is, here we're freeing a tree block, if there is no block
group for it, we shouldn't be able to read the extent buffer out.

So it's near impossible to hit. (Unless there is some other things wrong)=


Thanks,
Qu

> =20
>  		if (btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN)) {
>  			pin_down_extent(fs_info, cache, buf->start,
>=20


--Z4BVcKsIXLHGNn2aJ33lNEzVAC2MM8l07--

--mC0apToDGpZarcL1RQjPGdoj9rin4f9dz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyKCecACgkQwj2R86El
/qj0WAgAgMpYZ8WtQ25v/asQL9+R63WGUU14Iy7S6VgTVBnvJl/I7UOSi592trdt
TZU6XK01zX/gKm780STYS1ZBgw+HiyfG5O1CVotIAJLUzFkCRr6MPGP05p1Tult9
T9VWrXKpBV4c4PR2jDSpI42eCaO2onZIhJp2lUI5/LO0d/Eb2tBINmTuK94jKiZE
jxhgJ82vsRcSVaSi0oapueet5OmLXBvwt9UJrAQ4L5CZiSHO7dubXZIa+wmfXLSR
7Bwoayg44CHChOf4XVkIo1gphoxlx45jeyr0t1qmv9Xl8hm8Bd8up1fzVAaMhSez
GCbsFA9Zn9rIs2NJvr49iHIv6DTXFg==
=5FVU
-----END PGP SIGNATURE-----

--mC0apToDGpZarcL1RQjPGdoj9rin4f9dz--
