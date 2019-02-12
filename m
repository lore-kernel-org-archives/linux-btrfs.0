Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F1FC282D7
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 05:07:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 649C321855
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 05:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfBLFHc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 00:07:32 -0500
Received: from mout.gmx.net ([212.227.15.18]:44385 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbfBLFHb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 00:07:31 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LuPYt-1h39Jr0iXv-011jvP; Tue, 12
 Feb 2019 06:07:25 +0100
Subject: Re: [PATCH] btrfs: honor path->skip_locking in backref code
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20190116160057.22040-1-josef@toxicpanda.com>
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
Message-ID: <2bdd075d-2c56-611b-c0a0-4126d27daec5@gmx.com>
Date:   Tue, 12 Feb 2019 13:07:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190116160057.22040-1-josef@toxicpanda.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="U0PMUGMXfNUnUoJjqxiYn7TiYGegy98HW"
X-Provags-ID: V03:K1:sqXbDAB6sDD5vKuWeouqv/zQeR0itnEy4ywtN4m8OMURl7KceK4
 xbaPv8wDibIO/u//3zTUYGep39LkVufCfX964XgZ46w7aL+EU5+4xi7+EHmdo4PD10C9cG8
 ovl09nG+HdWpfaLMLT1hqFwfWv++sbC/f5B+6nbRG8WWtCG5G1ipRc0/Jt/sEEJ8wNe+9Z4
 7qZnjIsZYol+7gewHsqdw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ooCODiwd9tE=:O1XTloQwWp1MAN3dKnrpqR
 tW88QQJ2ArqqiUN3YqChuwQsItMAVDLK+ygHKilo4+l0ryKJfKoc+shP9u5JnrigXcVguA+iX
 cXGxbGqvxGIdfEewTrkJInVUig5b6RulOkih8srRrSWiQQjUWEl/R+JO8eDwCF26/JRYd061h
 k1vdSNsWjykfbGYIpa55kS2VVKN67DxJwB0tlx3tpFj8gmp/wsiGPch8N8RyZAGIUxFgEN9DH
 WoIlkJF0ELbv6rQpAb/C3meSKO9CzzWD4sUhN3QoUXkEzx42jOzWcvzUX4ceVOBRrHO11QxrO
 quapcxjdGzTYoU93An2AOio4SAreP7AeWRZQfyxh2Iq5ydP997IVuV/l43PELb9UFJTdNoM3S
 mmzcbdseYAbWB8W7EH/QNZP2d8Z35D0A5xk2eBGZ9i8snzQxaVnxxAJe39n+wG4d+EGzh/NPe
 L6Qw5v/plNQtLf5pbS32bonrrVutG34M33ZpZXrtiuI2CDlHqBYPB2Tee1fYRBipmodeUVGss
 MO8ewu7KPqZUXtqkCiyjeYYjHMD8J9zZHO/gffOOPK/9BOYZEBO8uA9h3b2llcVTcEZgEXS03
 4lFEa5OvF5Y1SKvz4kiCYkBhgv6ts3ZlKr5fQUZfaLF7gJWEFBH43WWi99lOtKKUYlYrBRmUJ
 u0FOmZ3oH0irq4QMy4mPFlvFr7Mn1we5Y5iZRPcTaLwru47Hz8aseW4mB15E2ZQWou7Hbb/hR
 pGg2yNS+RYum5VhZEOhzp0GT+FAZE+BWzU3UteHOEoKo6HZoomdhIxIKntsYGeYdiP3nO+tH8
 9Y9na/8lDc7IEJdc551xJMyWsLthjyaCdTPU414OFeN2elfLzmWIAusJxKOKqNGwTWrSvSCK/
 qUc1+MDOeo0SbTB/Z6X8OAFe3W5tIKlfUtG5Ahe6siELhfzkLGP2rZ9VpNsrFb
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--U0PMUGMXfNUnUoJjqxiYn7TiYGegy98HW
Content-Type: multipart/mixed; boundary="gQflmb8b6RW88jfK5uFfBf5chmyFTiM09";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
Message-ID: <2bdd075d-2c56-611b-c0a0-4126d27daec5@gmx.com>
Subject: Re: [PATCH] btrfs: honor path->skip_locking in backref code
References: <20190116160057.22040-1-josef@toxicpanda.com>
In-Reply-To: <20190116160057.22040-1-josef@toxicpanda.com>

--gQflmb8b6RW88jfK5uFfBf5chmyFTiM09
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/17 =E4=B8=8A=E5=8D=8812:00, Josef Bacik wrote:
> qgroups will do the old roots lookup at delayed ref time, which could b=
e
> while walking down the extent root while running a delayed ref.  This
> should be fine, except we specifically lock eb's in the backref walking=

> code irrespective of path->skip_locking, which deadlocks the system.
> Fix up the backref code to honor path->skip_locking, nobody will be
> modifying the commit_root when we're searching so it's completely safe
> to do.  Thanks,
>=20
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/backref.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 78556447e1d5..973e8251b1bf 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -712,7 +712,7 @@ static int resolve_indirect_refs(struct btrfs_fs_in=
fo *fs_info,
>   * read tree blocks and add keys where required.
>   */
>  static int add_missing_keys(struct btrfs_fs_info *fs_info,
> -			    struct preftrees *preftrees)
> +			    struct preftrees *preftrees, bool lock)
>  {
>  	struct prelim_ref *ref;
>  	struct extent_buffer *eb;
> @@ -737,12 +737,14 @@ static int add_missing_keys(struct btrfs_fs_info =
*fs_info,
>  			free_extent_buffer(eb);
>  			return -EIO;
>  		}
> -		btrfs_tree_read_lock(eb);
> +		if (lock)
> +			btrfs_tree_read_lock(eb);
>  		if (btrfs_header_level(eb) =3D=3D 0)
>  			btrfs_item_key_to_cpu(eb, &ref->key_for_search, 0);
>  		else
>  			btrfs_node_key_to_cpu(eb, &ref->key_for_search, 0);
> -		btrfs_tree_read_unlock(eb);
> +		if (lock)
> +			btrfs_tree_read_unlock(eb);
>  		free_extent_buffer(eb);
>  		prelim_ref_insert(fs_info, &preftrees->indirect, ref, NULL);
>  		cond_resched();
> @@ -1227,7 +1229,7 @@ static int find_parent_nodes(struct btrfs_trans_h=
andle *trans,
> =20
>  	btrfs_release_path(path);
> =20
> -	ret =3D add_missing_keys(fs_info, &preftrees);
> +	ret =3D add_missing_keys(fs_info, &preftrees, path->skip_locking =3D=3D=
 0);
>  	if (ret)
>  		goto out;
> =20
> @@ -1288,11 +1290,13 @@ static int find_parent_nodes(struct btrfs_trans=
_handle *trans,
>  					ret =3D -EIO;
>  					goto out;
>  				}
> -				btrfs_tree_read_lock(eb);
> +				if (!path->skip_locking)
> +					btrfs_tree_read_lock(eb);
>  				btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);

This btrfs_set_lock_blocking_rw() or the btrfs_set_lock_blocking_read()
in latest misc-next call need @eb to be read locked first.

So this line should also be in the (!path->skip_locking) branch, and
such modification solves the BUG_ON() caused by btrfs/007.

Thanks,
Qu

>  				ret =3D find_extent_in_eb(eb, bytenr,
>  							*extent_item_pos, &eie, ignore_offset);
> -				btrfs_tree_read_unlock_blocking(eb);
> +				if (!path->skip_locking)
> +					btrfs_tree_read_unlock_blocking(eb);
>  				free_extent_buffer(eb);
>  				if (ret < 0)
>  					goto out;
>=20


--gQflmb8b6RW88jfK5uFfBf5chmyFTiM09--

--U0PMUGMXfNUnUoJjqxiYn7TiYGegy98HW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxiVIcACgkQwj2R86El
/qhMzAf9H5kTZD5SmMkkYq9wWni0zK/xPoL/csZ8XW3wpJA+ekf2UWnNoadGpoSt
ZhFODrjd72MHtUK7Tau3bVG0pRtAovpMFImOxwaERUkgb/5TaL7gJNwoFH1rbPQN
pQ6PTrZfa4d2b/K5wJPLq8ppliiv3UQHFs39gXHc5NtkEK5w6arJUVP2iK49YnNU
0Gx8rWpQrgsf3FauOf8FsMUpqvwrPK/ZqnxntCfjGXozhE411n+AYYzRSkkoR85B
wzQBMqNAyYP//O5qOnY4ijVOhhNNQRlY5AttuQkrCRC4v8C4K6GRxjTKrP9LC6SY
N6nUuOFu53A6uCo65j7i25imuYZKYQ==
=n9hS
-----END PGP SIGNATURE-----

--U0PMUGMXfNUnUoJjqxiYn7TiYGegy98HW--
