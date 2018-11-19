Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9778C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 11:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DF5E20989
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 11:09:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DF5E20989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbeKSVc7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 16:32:59 -0500
Received: from mout.gmx.net ([212.227.17.21]:52029 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728632AbeKSVc7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 16:32:59 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MAloF-1gHqrd3HjP-00BuqY; Mon, 19
 Nov 2018 12:09:35 +0100
Subject: Re: [PATCH] Btrfs: fix deadlock when enabling quotas due to
 concurrent snapshot creation
To:     fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20181119094823.27346-1-fdmanana@kernel.org>
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
Message-ID: <f42a7622-0ebb-f431-c484-cb3c4013b7a7@gmx.com>
Date:   Mon, 19 Nov 2018 19:09:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181119094823.27346-1-fdmanana@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LPOHRHsya1dhKKIr0h66B0L8xWL5DL0RA"
X-Provags-ID: V03:K1:c4VEa/CoaABrVYMCF10qEN77InzafsiLzZu2C2gmPWJVWJTFW2Y
 LsI43G5WtdgC+50Z25ujy2/zi/2KqR/+hDGe0pFw/q40q2M6WgikHV5XiMM8Hge1c0j0EFl
 sVTy39zOSMd6A+arhFEEvAd/LdsyCXS7ncgTpPVoXF32wNw4NyjJw419r/rLnUUlb0nNjt8
 1gamOGx/9QwuqR112Mraw==
X-UI-Out-Filterresults: notjunk:1;V01:K0:gAGcZbwlZqw=:8pU/qUN/RPQYae6/Gr8q0o
 h9A/jUWoIxUr1+6v4JgoHQeFySCO7oakqqRJ61FO9yv5ApVqvA5JhRLdGqT52YZOfsRgVgsft
 C+3AOMD1X/Vtsogh3+2rfAfJp3dZLYhdRY5IhIgKYMNMagXHYHS0Yea/om/Gl4Y8DKD1pxBp/
 EeorwqHVZWzIlPQ8YB5jyXUPi3mnmFVBSZsZZumeHYyJMJbb/fpDdKOxoEN3QWyMuL3W4s6gj
 r+BcwMTgDC7SHbk1JC7Fdr11rsKneTD12wPs9atBthrxU2ofitbxueMzwFDOj+BWq2dcDU5xV
 1RPqEic8oei5/eb7utHMUKjclEuMEIYUnMaz7NS9HJ9H7y3LCNamNxxhkY9PhxoZV8648XwTH
 nQASuhlCiqT43zEm2KuyhwF1ISdRCorg8EvtpKvCQ+NB3dhYIrM9rNbZJsGMSceRL3itKkSke
 7FbWA3vhQT4JPZxj7PBY//bvOvt5EuE2dcQNliATekX3t8kiOl+JjWIwQQIKG0yfRdBfKVwvV
 G5+liC4Pf9t15OsLCrM9J+zw+B2Zn6bJ6U6ygn0HixbRsJLT3gJRhenViLJxc1v5wuvxia4T0
 pWbQEWvkmEC5Mq3g1y8NTnJySGUJ6kvv3rOUsXkxCXXDy762DlA9F+z8icq9XjDRKJbIHKFOF
 jLbSviPF6/wv1ZBTm+262CYUcLfWrMRctBq3ekXa7oUqRz+yKOLGix91jPYs3JqZgir1Bl8fs
 MGBsiE/lp7B3pw4QJVCKSipv6vrS0b3/+fUsxs4SgdWDTux0W5COFXfQFNp0g1K8VBYEif55a
 75IWPxTBXH6e1fSuJMuE3eIcVUglL7Evr8BtJlRQB9gQ5VvOjn1fOc11nXNXPVBOcLhlNsd4X
 AwxOLNiQDNxkSxZUzdN1osUdGOUwXcSju9ZlB0xkkSUMAdnfND0/bQcYCu6+ur
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LPOHRHsya1dhKKIr0h66B0L8xWL5DL0RA
Content-Type: multipart/mixed; boundary="s1YQM9Szik5nxecVZH3kdYSoimIUCObGK";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Message-ID: <f42a7622-0ebb-f431-c484-cb3c4013b7a7@gmx.com>
Subject: Re: [PATCH] Btrfs: fix deadlock when enabling quotas due to
 concurrent snapshot creation
References: <20181119094823.27346-1-fdmanana@kernel.org>
In-Reply-To: <20181119094823.27346-1-fdmanana@kernel.org>

--s1YQM9Szik5nxecVZH3kdYSoimIUCObGK
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/19 =E4=B8=8B=E5=8D=885:48, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> If the quota enable and snapshot creation ioctls are called concurrentl=
y
> we can get into a deadlock where the task enabling quotas will deadlock=

> on the fs_info->qgroup_ioctl_lock mutex because it attempts to lock it
> twice. The following time diagram shows how this happens.
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

The backtrace looks valid.

>=20
> So fix this by adding a flag to the transaction handle that signals if =
the
> transaction is being used for enabling quotas (only seen by the task do=
ing
> it) and do not lock the mutex qgroup_ioctl_lock at btrfs_qgroup_inherit=
()
> if the transaction handle corresponds to the one being used to enable t=
he
> quotas.
>=20
> Fixes: 6426c7ad697d ("btrfs: qgroup: Fix qgroup accounting when creatin=
g snapshot")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/qgroup.c      | 10 ++++++++--
>  fs/btrfs/transaction.h |  1 +
>  2 files changed, 9 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index d4917c0cddf5..3aec3bfa3d70 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -908,6 +908,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_inf=
o)
>  		trans =3D NULL;
>  		goto out;
>  	}
> +	trans->enabling_quotas =3D true;

Should we put enabling_quotas bit into btrfs_transaction instead of
btrfs_trans_handle?

Isn't it possible to have different trans handle pointed to the same
transaction?

And I'm not really sure about the naming "enabling_quotas".
What about "quota_ioctl_mutex_hold"? (Well, this also sounds awful)

Thanks,
Qu

> =20
>  	fs_info->qgroup_ulist =3D ulist_alloc(GFP_KERNEL);
>  	if (!fs_info->qgroup_ulist) {
> @@ -2250,7 +2251,11 @@ int btrfs_qgroup_inherit(struct btrfs_trans_hand=
le *trans, u64 srcid,
>  	u32 level_size =3D 0;
>  	u64 nums;
> =20
> -	mutex_lock(&fs_info->qgroup_ioctl_lock);
> +	if (trans->enabling_quotas)
> +		lockdep_assert_held(&fs_info->qgroup_ioctl_lock);
> +	else
> +		mutex_lock(&fs_info->qgroup_ioctl_lock);
> +
>  	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
>  		goto out;
> =20
> @@ -2413,7 +2418,8 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handl=
e *trans, u64 srcid,
>  unlock:
>  	spin_unlock(&fs_info->qgroup_lock);
>  out:
> -	mutex_unlock(&fs_info->qgroup_ioctl_lock);
> +	if (!trans->enabling_quotas)
> +		mutex_unlock(&fs_info->qgroup_ioctl_lock);
>  	return ret;
>  }
> =20
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 703d5116a2fc..a5553a1dee30 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -122,6 +122,7 @@ struct btrfs_trans_handle {
>  	bool reloc_reserved;
>  	bool sync;
>  	bool dirty;
> +	bool enabling_quotas;
>  	struct btrfs_root *root;
>  	struct btrfs_fs_info *fs_info;
>  	struct list_head new_bgs;
>=20


--s1YQM9Szik5nxecVZH3kdYSoimIUCObGK--

--LPOHRHsya1dhKKIr0h66B0L8xWL5DL0RA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvymesACgkQwj2R86El
/qgMBQgAhwA/QBypc7ESM/qv5abLICbCCfIlpkkQmblHzjA9DxOrAWVYh1PshTZA
a1LOPbgAnl47JYeDLSqS/el0FsN9RUBDttaDts73GcT+F76Qpt0/uokt9LD0TpMN
D6hfSwyz8Qh53d0P2urvOeUpvtV0fsNIAyjo42xU6UuTvPOE6GsYSLxFK8NSWUK2
sLOY7j0VoQwD8UCq7pA6y3W9khRH91d7u8ebjo3g79SAasax23PdbR7fALejznX8
TD+30aqbVCquak1SDU0oyWgmVWs2WYkrM3WxSwzd6KZcxD9TgNQ9GgwK/AVsKx8l
u7LtLQOPQhUfwk01ZSyUAyLVDWNuBw==
=JiLt
-----END PGP SIGNATURE-----

--LPOHRHsya1dhKKIr0h66B0L8xWL5DL0RA--
