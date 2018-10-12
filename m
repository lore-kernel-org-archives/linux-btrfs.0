Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CD28C6783C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 13:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6BDD20868
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 13:13:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6BDD20868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbeJLUqQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 16:46:16 -0400
Received: from mout.gmx.net ([212.227.17.22]:60761 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728354AbeJLUqQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 16:46:16 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LguAU-1fqTpU22qc-00oGNa; Fri, 12
 Oct 2018 15:13:47 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LguAU-1fqTpU22qc-00oGNa; Fri, 12
 Oct 2018 15:13:47 +0200
Subject: Re: [PATCH] Btrfs: fix use-after-free during inode eviction
To:     fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20181012120248.32262-1-fdmanana@kernel.org>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <e0d50a42-0ac5-e3e0-1cca-ef4e8ec52250@gmx.com>
Date:   Fri, 12 Oct 2018 21:13:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20181012120248.32262-1-fdmanana@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="V7OXdTVvP6vxdN7ifJwkrLePQIpRGxDus"
X-Provags-ID: V03:K1:nI3eNZeVvvpDMBwPcHf+0hDP+JaMN6c/QiUZ2imW3E3Oq2kNyeu
 d2CjS4RYVueoQnA8OPRXFCC2dezng7UakM+uYlgE+GJeDU4dBYWltW0t7tEozaVIAjo8ZbX
 DudgjzTc2trx8wt+w7UmiASWmUUr9BxQGvdCQ1uQNZbIYU8gxg0ZNNdUw7SvwQnOSFU0qsy
 ZIafHOkZM5vErUl4VgZzA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:u3cCbuMpCpg=:918ExSdCeNmcrnhqkz1M5W
 FNM5+RjCJq73s8ZWRzErOB7oBUyMjZyS8GMhIN5hvNes49qG71gZ2lWWt462bjPsLiSAQ4VLE
 I3P6G0b7p6/10qNOBX633LNd+hQ2QPx/GsUZ6hMVGlH86mG7T+M1iUmkiBuL74/Txgw9MDy9p
 PyP9jM5GgqXS4V45EKtRNPJVPrtC69n1FnLiyPF+HvUIYO7ZRND9SJHJqcN4muJULwHDhwrmP
 SOg3RWDq3gx9AUlhFimxpDZeEnrAn8Eo7hFQ7qu8snVg7a1EBR7ZTha7h8v0bGBufF73tFhGV
 VnojS/SG0brVoMtCCBjv5SMzxeLzLo+t+7iD2OuA/FNqyfMTMQP5q1GMVPMWRux4/ibTLyyY6
 PUS8O2+nkDWXxsADX1DLVz/sRy8LLkXssR2c2rrA7DsVx412nVpvNCZ65rok4GMOqCs61dXY/
 cGotqMRkbOxXMDp2/CQjfNjWxA/OPCGCUJvgvJ33Xog9a7JNKUGFllwraA2mERJkuPmZYiZri
 oYa5kJ/z+44N/WrFGvLO+klLgVL1t9Raklao7mjFO7Ub/KK7rH88uwTilwglJwGFkZ26KIAi5
 V+NSBb76nAWi9h7IX1QW9UuGkE+SmB4wZ2t+LOqx8yLdgRqZP00YwpraqJa+qW15QvZ/rJF2H
 1dTE0GKiCURq+2ZdBOSTXAg6Wv+W+05rAam8JLnVt/fKuq0o1lPcWbDEsiwhczADPbfpVDCe/
 I86rWImFAKGwHs66zdKJNMkuZdEkebB3AaJm2bTE/FPSg5+Og5kmRyRbDhcntiOckF2JOQja4
 EHuytGxke9UK8x4F1UNJQM1WhBnhg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--V7OXdTVvP6vxdN7ifJwkrLePQIpRGxDus
Content-Type: multipart/mixed; boundary="MdcChxUIjSVXDGTbkgjoSi7NeA3wFaXkO";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Message-ID: <e0d50a42-0ac5-e3e0-1cca-ef4e8ec52250@gmx.com>
Subject: Re: [PATCH] Btrfs: fix use-after-free during inode eviction
References: <20181012120248.32262-1-fdmanana@kernel.org>
In-Reply-To: <20181012120248.32262-1-fdmanana@kernel.org>

--MdcChxUIjSVXDGTbkgjoSi7NeA3wFaXkO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/12 =E4=B8=8B=E5=8D=888:02, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> At inode.c:evict_inode_truncate_pages(), when we iterate over the inode=
's
> extent states, we access an extent state record's "state" field after w=
e
> unlocked the inode's io tree lock. This can lead to a use-after-free is=
sue
> because after we unlock the io tree that extent state record might have=

> been freed due to being merged into another adjacent extent state
> record (a previous inflight bio for a read operation finished in the
> meanwhile which unlocked a range in the io tree and cause a merge of
> extent state records, as explained in the comment before the while loop=

> added in commit 6ca0709756710 ("Btrfs: fix hang during inode eviction d=
ue
> to concurrent readahead")).
>=20
> Fix this by keeping a copy of the extent state's flags in a local varia=
ble
> and using it after unlocking the io tree.
>=20
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D201189
> Fixes: b9d0b38928e2 ("btrfs: Add handler for invalidate page")
> CC: stable@vger.kernel.org # 4.4+
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Indeed my fault, state should only be accessed with spinlock hold.

Thanks,
Qu

> ---
>  fs/btrfs/inode.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3ea5339603cf..66c6c4103d2f 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5274,11 +5274,13 @@ static void evict_inode_truncate_pages(struct i=
node *inode)
>  		struct extent_state *cached_state =3D NULL;
>  		u64 start;
>  		u64 end;
> +		unsigned state_flags;
> =20
>  		node =3D rb_first(&io_tree->state);
>  		state =3D rb_entry(node, struct extent_state, rb_node);
>  		start =3D state->start;
>  		end =3D state->end;
> +		state_flags =3D state->state;
>  		spin_unlock(&io_tree->lock);
> =20
>  		lock_extent_bits(io_tree, start, end, &cached_state);
> @@ -5291,7 +5293,7 @@ static void evict_inode_truncate_pages(struct ino=
de *inode)
>  		 *
>  		 * Note, end is the bytenr of last byte, so we need + 1 here.
>  		 */
> -		if (state->state & EXTENT_DELALLOC)
> +		if (state_flags & EXTENT_DELALLOC)
>  			btrfs_qgroup_free_data(inode, NULL, start, end - start + 1);
> =20
>  		clear_extent_bit(io_tree, start, end,
>=20


--MdcChxUIjSVXDGTbkgjoSi7NeA3wFaXkO--

--V7OXdTVvP6vxdN7ifJwkrLePQIpRGxDus
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvAngYACgkQwj2R86El
/qiBZAf/RmeHVNQkaCkiHBRowWlfSRtzvVFj8440iq4LPFBeImk+KqbMxF2ZPh9K
3vtjWXPhHTp8Mxeu2GbLVVE/uSz9tKiNqrLmjOO1zDxNG4SWkG2AByHMWwLMsKOj
XX+CyF7lobkjxnsb9cA2dp4XUwTRRZyTQx9ssKjTOw5OInbC93MbQAsDIJZ7kwq2
xz+D1bdY7DSekq556YEDX6UFfnPUlFdP1/zCfHgSYvns9AX8gHNkiEacdWRuy//J
vjSeCUPdooccpReoeZbuEFp9ND5lNx/GIfDlxrEpW7mDDkYnmJvo5QLnSKd3MuCO
FFLbYorxo9SYPs6YULNZLo7jlhH7xA==
=Nw6t
-----END PGP SIGNATURE-----

--V7OXdTVvP6vxdN7ifJwkrLePQIpRGxDus--
