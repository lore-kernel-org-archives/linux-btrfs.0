Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87130C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 14:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C850206BB
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 14:48:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C850206BB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbeKTBMm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 20:12:42 -0500
Received: from mout.gmx.net ([212.227.17.22]:55323 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729398AbeKTBMl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 20:12:41 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MCL6r-1gGGPX1VVh-0099eZ; Mon, 19
 Nov 2018 15:48:47 +0100
Subject: Re: [PATCH v2] Btrfs: fix deadlock when enabling quotas due to
 concurrent snapshot creation
To:     fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20181119094823.27346-1-fdmanana@kernel.org>
 <20181119141536.20748-1-fdmanana@kernel.org>
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
Message-ID: <19a37acc-9b6f-7606-7ddd-2119b9bda207@gmx.com>
Date:   Mon, 19 Nov 2018 22:48:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181119141536.20748-1-fdmanana@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="F1fISdoIZC4vHpx6GuDoIWIkxsObRhsPg"
X-Provags-ID: V03:K1:ZUVPeikHQsy9EXdohB3UpvXxkB13HnukWquBitgnG9HBA+rrsM2
 YnXzd9LUkG0LaoGPCMNX5+O9zThnaGTsl61ZtuUYJe41rCiJhBuLiDsQjw2JZI6Tjhg3VUU
 aFzRoePzGmsRGAIqt5Nh6vjhQNPUU+t5h4tuJWYpfLVHY3MiepBc8VXeSl8ndUShq/jrxd1
 636//EO5s6a73TYzKrmFQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:UghawyE4jhw=:HKhOH78pUtB10Fz3BRmRvO
 B4AIDTGI7zSj0z0A5JwMZL594VEMew/KV6q/GbtfuPFtyFxHx23emx6ApKq5LAfcAjAbfXUDy
 Xhj8ErG1sqNV/8XE+X6hSh/XSvJZlnKUZsjQBDrYHlp+oy9ARvRgv0WJi3ZMpByXLqWxi1PBk
 BfI+rWS1CvK23PBiIvTJCt8cWl+IZNOZduhSDzuX2ShGP/F52Ueps/r0X94v0JBmUgMDaHxVX
 DPhKXy/ke5znc80ko5RZneoNkU0KDxqFO/taRZ8S1Hu1wow8nK/qMcIeNpqLMgPLQuTusocC5
 LEhy0i7rb2D1q19hlOAqRfFh+xeVhObUMzp2PHbN35cd/keSYF7AFALW00sGk/emD0Q66qjcM
 J6RmNU5MNtIQ2CJgw17l65xNy3FfB7SH9NMzJxYLy+o11DkwIXEiiezHU3vfe1cOb8k2R3b+l
 Ubx2e9q1yjUXiw26Cxy+hyx29LKafHxYfHuy6qKWeOjU8id9SwEfCPjrAgfbwEVUhN8Azqcsw
 ktY8SNGF68PnfB9pD8ifdR9nRveda6nTUpX6bpJvHA281/kecfbynRoFCA11XlPk2kLUjLtw2
 3JsBbZOqbQfmQBwCveBZf3dgNwEv1fzfDg0PIuQ/CqNoQlEVRQp96cx4nIv5WexaHW60WVl1p
 9JgLFQrJLiXco9daaQf/jzh7E8GENbEfI4FIiosJytpgHwt22Lhw1aU/h4ox1nA+W73BZdh3C
 m3ETjnWxSEFngCB3jmV+Z/N5rtexKmRurE1GtlRfG2J0yHoaR+kvD7xNG0mziJoF+nHhcGLwo
 R2AdW1zIIfJODOg3z3eAoEqAEsmwRUWFvLbLfZ7COhVhKk/ugOfRA+vFSZrkl7Gvar2qUNzF6
 CoX75ZsKKBHq3vFDpYMhLfLKlYFXo0t+ITJr90ktAPr37B9txhZRk3GrUvzS0g
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--F1fISdoIZC4vHpx6GuDoIWIkxsObRhsPg
Content-Type: multipart/mixed; boundary="2ipuG0WayWBaXQRmqCb51avKyTomAbIPp";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Message-ID: <19a37acc-9b6f-7606-7ddd-2119b9bda207@gmx.com>
Subject: Re: [PATCH v2] Btrfs: fix deadlock when enabling quotas due to
 concurrent snapshot creation
References: <20181119094823.27346-1-fdmanana@kernel.org>
 <20181119141536.20748-1-fdmanana@kernel.org>
In-Reply-To: <20181119141536.20748-1-fdmanana@kernel.org>

--2ipuG0WayWBaXQRmqCb51avKyTomAbIPp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/19 =E4=B8=8B=E5=8D=8810:15, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> If the quota enable and snapshot creation ioctls are called concurrentl=
y
> we can get into a deadlock where the task enabling quotas will deadlock=

> on the fs_info->qgroup_ioctl_lock mutex because it attempts to lock it
> twice, or the task creating a snapshot tries to commit the transaction
> while the task enabling quota waits for the former task to commit the
> transaction while holding the mutex. The following time diagrams show h=
ow
> both cases happen.
>=20
> First scenario:
>=20
>            CPU 0                                    CPU 1
>=20
>  btrfs_ioctl()
>   btrfs_ioctl_quota_ctl()
>    btrfs_quota_enable()
>     mutex_lock(fs_info->qgroup_ioctl_lock)
>     btrfs_start_transaction()
>=20
>                                              btrfs_ioctl()
>                                               btrfs_ioctl_snap_create_v=
2
>                                                create_snapshot()
>                                                 --> adds snapshot to th=
e
>                                                     list pending_snapsh=
ots
>                                                     of the current
>                                                     transaction
>=20
>     btrfs_commit_transaction()
>      create_pending_snapshots()
>        create_pending_snapshot()
>         qgroup_account_snapshot()
>          btrfs_qgroup_inherit()
> 	   mutex_lock(fs_info->qgroup_ioctl_lock)
> 	    --> deadlock, mutex already locked
> 	        by this task at
> 		btrfs_quota_enable()
>=20
> Second scenario:
>=20
>            CPU 0                                    CPU 1
>=20
>  btrfs_ioctl()
>   btrfs_ioctl_quota_ctl()
>    btrfs_quota_enable()
>     mutex_lock(fs_info->qgroup_ioctl_lock)
>     btrfs_start_transaction()
>=20
>                                              btrfs_ioctl()
>                                               btrfs_ioctl_snap_create_v=
2
>                                                create_snapshot()
>                                                 --> adds snapshot to th=
e
>                                                     list pending_snapsh=
ots
>                                                     of the current
>                                                     transaction
>=20
>                                                 btrfs_commit_transactio=
n()
>                                                  --> waits for task at
>                                                      CPU 0 to release
>                                                      its transaction
>                                                      handle
>=20
>     btrfs_commit_transaction()
>      --> sees another task started
>          the transaction commit first
>      --> releases its transaction
>          handle
>      --> waits for the transaction
>          commit to be completed by
>          the task at CPU 1
>=20
>                                                  create_pending_snapsho=
t()
>                                                   qgroup_account_snapsh=
ot()
>                                                    btrfs_qgroup_inherit=
()
>                                                     mutex_lock(fs_info-=
>qgroup_ioctl_lock)
>                                                      --> deadlock, task=
 at CPU 0
>                                                          has the mutex =
locked but
>                                                          it is waiting =
for us to
>                                                          finish the tra=
nsaction
>                                                          commit
>=20
> So fix this by setting the quota enabled flag in fs_info after committi=
ng
> the transaction at btrfs_quota_enable(). This ends up serializing quota=

> enable and snapshot creation as if the snapshot creation happened just
> before the quota enable request. The quota rescan task, scheduled after=

> committing the transaction in btrfs_quote_enable(), will do the account=
ing.
>=20
> Fixes: 6426c7ad697d ("btrfs: qgroup: Fix qgroup accounting when creatin=
g snapshot")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>=20
> V2: Added second deadlock example to changelog and changed the fix to d=
eal
>     with that case as well.
>=20
>  fs/btrfs/qgroup.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index d4917c0cddf5..ae1358253b7b 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1013,16 +1013,22 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs=
_info)
>  		btrfs_abort_transaction(trans, ret);
>  		goto out_free_path;
>  	}
> -	spin_lock(&fs_info->qgroup_lock);
> -	fs_info->quota_root =3D quota_root;
> -	set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
> -	spin_unlock(&fs_info->qgroup_lock);
> =20
>  	ret =3D btrfs_commit_transaction(trans);
>  	trans =3D NULL;
>  	if (ret)
>  		goto out_free_path;

The main concern here is, if we don't set qgroup enabled bit before we
commit transaction, there will be a window where new tree modification
could happen before QGROUP_ENABLED bit set.

There may be some qgroup reserved space related problem in such case,
but I'm not 100% sure to foresee such problem.


The best way to do this is, commit trans first, and before any other one
trying to start transaction, we set the bit.
However I can't find such infrastructure now (I still remember we used
to have a pending bit to change quota enabled flag, but removed later)

Thanks,
Qu

> =20
> +	/*
> +	 * Set quota enabled flag after committing the transaction, to avoid
> +	 * deadlocks on fs_info->qgroup_ioctl_lock with concurrent snapshot
> +	 * creation.
> +	 */
> +	spin_lock(&fs_info->qgroup_lock);
> +	fs_info->quota_root =3D quota_root;
> +	set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
> +	spin_unlock(&fs_info->qgroup_lock);
> +
>  	ret =3D qgroup_rescan_init(fs_info, 0, 1);
>  	if (!ret) {
>  	        qgroup_rescan_zero_tracking(fs_info);
>=20


--2ipuG0WayWBaXQRmqCb51avKyTomAbIPp--

--F1fISdoIZC4vHpx6GuDoIWIkxsObRhsPg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvyzUoACgkQwj2R86El
/qgRfwf/VdTRhWY4kQkkkPTmaqJ8GmgRgZu6k84VhDn5htFx6itWOnoX4IeLCY25
h1tO3oUGjwxWnM+2s/mTY28hHLz0tKLASyNtBLI+cMuAA/mt9cHsbC/EC6SlFhGZ
f9ftGCM9JRgjLeo3/eai5qrG3/vDrcEPFw0qJ/poOjbsr5AtfFaMRAVX5/jRLVyp
OTx6o4jELe893MA/TpCmgqXdfSGVf2cxZjOVv2DN3bva57YqORBVLOfaPTWJFQsy
KH9F1Ug7sU0NpzJ4r6q+52KKIf16a0F/bQJ9/au7IndjfuciRD+ldNSmV6Ca9PaO
3B/3/PkAfCrWlq9cRr1Gpoy6ZIKn2A==
=blUc
-----END PGP SIGNATURE-----

--F1fISdoIZC4vHpx6GuDoIWIkxsObRhsPg--
