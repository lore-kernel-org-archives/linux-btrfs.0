Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1FF8C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 01:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E79C20651
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 01:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbfAQBE3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Jan 2019 20:04:29 -0500
Received: from mout.gmx.net ([212.227.17.21]:57293 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727306AbfAQBE2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Jan 2019 20:04:28 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MXEs5-1gmuGZ0iFZ-00WIFL; Thu, 17
 Jan 2019 02:04:23 +0100
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
Message-ID: <ef892414-ea36-271b-35f5-b4f753ff7bea@gmx.com>
Date:   Thu, 17 Jan 2019 09:04:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190116160057.22040-1-josef@toxicpanda.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QwfvdjAeH33yycBPa9TdDCRho370ejvvd"
X-Provags-ID: V03:K1:aCkjS5Tl2vKCfbP7uzT4l3UYQq4Xs9ednA8E4XqIXZeOuFxCnSO
 UBb6I0ujRUEgNY1F71lqzWm/94s/9YtoR5+FGjaNUWDGe6OhJQYe+2djEtOCyBLzlQW9SaP
 RKYU4i+hq+ohdUIz2Bnn32CefMgdvOrlhfzEx6ZCpnD4m/la4mliPfKMObOEQXXBWyEu366
 4Klm0HjlWLRH3p3REhpHA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:2z5ft4BfOoY=:b8lLa2T/7OkXFYUVsA2oQo
 5lYSz+X6qA5LR+J4qNsW7GvbdTBrXdYDpz56/KdTxa5xrgNTcNILH3/twQ3hi48+2wRvTEFXm
 ApwD7MhdQI3gQ16Fd2mmUUGpkFLOqSXH3Njleo40f8Z1kF+nT4ZhGdEAa1d0l7lrRSL2GQjBN
 UsteAPuHXsdhwJvgC4n/jxO5h9oa/76HGVohEGijRFsmIhDm4kHMD8wz+vM+C691nH71LZtDp
 /jU4ssM9Ppm+dROy8vpi5XfBFtHdMhFU254SVzNf7HvYqeFDwCxdwhLbuLBK81Wg7Cjnak7nq
 DIo/skccHhJy+L/zAuqDaGwWrqCkHJVV40g/BDC0b4UQe0jreZNWoO+4nActJQtQIl7omi480
 +vyOkKNzrJQrUAeyuvKbIAcV6e2PZAUg2ZHKbQb0dN8HUjRfA6NZYTU+NsJpSwN8K+tlnoouS
 SAyEAU2xAXE0NoZ3M8GWs/H891TC4wTdMvYySnCqD6VQILeEonJzQBWFrTC9dICwpKbMN8pLT
 UUfkDkt+pPQCGndoTeEmGePKUYPVFYaVkA9CkRbRem4sxGGuKQBM2H5pi1TMzoHg6gHBKoqHJ
 kWAnQKIqDtxsRnEy46Dr0mnQXDPzm7iwyPviojiqs25XL/a/EqXB8zo3SMGwC9ixT+O2uZLAT
 fnWzP0H/aTUby1rvrEwsV6NuYfupBZ5ru2zU8kE+1+uM5GoluFeYVChp6YkJ4TiCBSUsjIDk5
 J1PIdNtqeIqTnE1QgzUFcWp9yZWdSYuVDLpZtStVY6dn5EG6ND8u2eGNjdZFznP2Dy/U3buV8
 Xc33yzVLmyDuVR2FPjI0fWyvy0ACT7RmzF9SieYSa+/cLCLmypT0zwcBW8groOHYTFfd7AYum
 WlwF5VmRz+M8DJZ+Bujlew3qVti/C2/HGdr+B2eF2L+KiPrE3ZcGvII5aCFo2E
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QwfvdjAeH33yycBPa9TdDCRho370ejvvd
Content-Type: multipart/mixed; boundary="9iXzfZiVvKQy85bIYS51gDuLVb4LLSyse";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
Message-ID: <ef892414-ea36-271b-35f5-b4f753ff7bea@gmx.com>
Subject: Re: [PATCH] btrfs: honor path->skip_locking in backref code
References: <20190116160057.22040-1-josef@toxicpanda.com>
In-Reply-To: <20190116160057.22040-1-josef@toxicpanda.com>

--9iXzfZiVvKQy85bIYS51gDuLVb4LLSyse
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

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

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
>  				ret =3D find_extent_in_eb(eb, bytenr,
>  							*extent_item_pos, &eie, ignore_offset);
> -				btrfs_tree_read_unlock_blocking(eb);
> +				if (!path->skip_locking)
> +					btrfs_tree_read_unlock_blocking(eb);
>  				free_extent_buffer(eb);
>  				if (ret < 0)
>  					goto out;
>=20


--9iXzfZiVvKQy85bIYS51gDuLVb4LLSyse--

--QwfvdjAeH33yycBPa9TdDCRho370ejvvd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw/1I0ACgkQwj2R86El
/qgQHgf+LugO3ffsiUJ95E4X16gnUSvBougdCjfY2Fiw7FLvEm1lGENE1Bciz6ks
7AWLWHXH3Jxh6bVr5IiP9yj7appfRWODl1gh+AXCkhK2Sf8vDt7i7kMDU6xcWn/r
1+7XFJqvSEqMRJ6bbW+o2AcHYvyYi/+jvYIg2ETdbflVCQl1mWiXImZ+LKloECdC
W4LnJWs1vDhBqibEVXjlRXfNHsE5F1yXwDZsGZzqXZO/b4u5BJJxKQ+jzJURIZQZ
eR2QMvCWpDIIs7LEyzi1RBeeuLEpxkQmZOoVV6Yz8Tn1RxwCzo9j4/c2lIOTqSv8
ofupXsrRRsNyYZw6iTPVUWpOSDLuRA==
=UoRx
-----END PGP SIGNATURE-----

--QwfvdjAeH33yycBPa9TdDCRho370ejvvd--
