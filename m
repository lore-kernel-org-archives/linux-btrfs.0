Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFABC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 01:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A0DF206B2
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 01:06:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A0DF206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391222AbeKVLnh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 06:43:37 -0500
Received: from mout.gmx.net ([212.227.15.15]:55335 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730060AbeKVLng (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 06:43:36 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MOf5S-1gJbpq3LFu-0064RL; Thu, 22
 Nov 2018 02:06:37 +0100
Subject: Re: [PATCH 2/6] btrfs: add cleanup_ref_head_accounting helper
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc:     Josef Bacik <jbacik@fb.com>
References: <20181121185912.24288-1-josef@toxicpanda.com>
 <20181121185912.24288-3-josef@toxicpanda.com>
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
Message-ID: <d35e384e-0564-7937-fa65-3a25b8296a05@gmx.com>
Date:   Thu, 22 Nov 2018 09:06:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181121185912.24288-3-josef@toxicpanda.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GonEQgvppJbyODW6G3brQHUUX9iNO0Pdo"
X-Provags-ID: V03:K1:RItxZQnheJsiMIHOUDEIiN28lccwoqAPdiYT6xY2hPvVkNgEQnD
 GcvW4/7v1XqUy4Y+fn1OwvW0FhQq0JiTSiqM2J1gML5dGkKhkthK0uSnqU/328JlYynj18I
 Sd/2on0lY+Z8Xz6QygLQMG0tgCkieY1rdyZKKx9brs0I3TvzAFmJjPh3oodD8KE8RtBckKz
 SqgES6kKAoFfnWqoHBKJg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:KmW+nlXiotw=:LupuMouumiWQ2LWF4wixAg
 Rh2gyb+jpxKjko/C8DKAKB2Vr4sZuW8m2mErvEcUZnwDoUSWW/iwtiIy4eQUGPlnzjGqanxeI
 hzbuTLvHWt8+CL24gtac8yp76vsVMVhTxvz/0zleBNv8uMyGQYZhwVzGM7x9Jg67mHarCvb4v
 VDYiz5FujUZ1YWloij+i7+W0Iv42tDPuZfXevFSQJFZPXPTwaIp22ObSMPRxYsovNyiVpCNIN
 wTcC4mq8ihTDOv+ECHbK+G89Cfcwwg3m6rDFjR5rQE0DcrMoAJCy5kqSc73G10HvgHdOOwrTj
 8+VWALz/l9c5Vs2YvHCLkPeQj/W0ESLVKSCdbYgnrZ0UijIincAiLP/ICbAlG1AHTTZPbE7fT
 MQ1OWPMrlk7Hi3Gqiw5r0EuGedznZQ8B0hZg6nN9xUB0aTLQM9843C20hKt2j3W7WeggDK+D3
 tE3l96f30TWsHUgiyo3nTKi1OP68LSseDof+YmUsZ3bt0olBV+brEBaWAXM98uION9zFpcmAa
 7xVX66HgOI1eNpL3oBTD3kn3aY9fRXcCi26Wz2uSXO7D4V1MfhJHtE7NXF9yUZLtGT+sdwGjH
 pG5UyYPSM1ktnAnsAGkRdG04nvUjl31xoDcaWXuvJHRUwhWpCMH4o7KECAobHWB+filnmHLyj
 O0YBsjG/slZg7ThWLAnBROYKfJdP74uylQllV+XCxfIIENBzad10osBbgSxuUBdJOLcK3esaM
 RykVTHONqTUfRnKcxU4es6YTMiEohE1uSfV4pp+hq0DKcEoOHx0ltoNiSvXQVqe1ug4qMHdPt
 p8UO5uf750wX3tRVhM7grbmgfEaPpyu7EaLtPh5/qwm6/maulzWuVX1xhip7gd+avR+Z2P66s
 Go5JMSpYpvSD1ISnc/4omg78QmaP1Ju/zWu81KW4A=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GonEQgvppJbyODW6G3brQHUUX9iNO0Pdo
Content-Type: multipart/mixed; boundary="BAvH2WLIys5pRgtxLCWY88nSHHt0hxKX5";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
Message-ID: <d35e384e-0564-7937-fa65-3a25b8296a05@gmx.com>
Subject: Re: [PATCH 2/6] btrfs: add cleanup_ref_head_accounting helper
References: <20181121185912.24288-1-josef@toxicpanda.com>
 <20181121185912.24288-3-josef@toxicpanda.com>
In-Reply-To: <20181121185912.24288-3-josef@toxicpanda.com>

--BAvH2WLIys5pRgtxLCWY88nSHHt0hxKX5
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/22 =E4=B8=8A=E5=8D=882:59, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
>=20
> We were missing some quota cleanups in check_ref_cleanup, so break the
> ref head accounting cleanup into a helper and call that from both
> check_ref_cleanup and cleanup_ref_head.  This will hopefully ensure tha=
t
> we don't screw up accounting in the future for other things that we add=
=2E
>=20
> Reviewed-by: Omar Sandoval <osandov@fb.com>
> Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 67 +++++++++++++++++++++++++++++-------------=
--------
>  1 file changed, 39 insertions(+), 28 deletions(-)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index c36b3a42f2bb..e3ed3507018d 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2443,6 +2443,41 @@ static int cleanup_extent_op(struct btrfs_trans_=
handle *trans,
>  	return ret ? ret : 1;
>  }
> =20
> +static void cleanup_ref_head_accounting(struct btrfs_trans_handle *tra=
ns,
> +					struct btrfs_delayed_ref_head *head)
> +{
> +	struct btrfs_fs_info *fs_info =3D trans->fs_info;
> +	struct btrfs_delayed_ref_root *delayed_refs =3D
> +		&trans->transaction->delayed_refs;
> +
> +	if (head->total_ref_mod < 0) {
> +		struct btrfs_space_info *space_info;
> +		u64 flags;
> +
> +		if (head->is_data)
> +			flags =3D BTRFS_BLOCK_GROUP_DATA;
> +		else if (head->is_system)
> +			flags =3D BTRFS_BLOCK_GROUP_SYSTEM;
> +		else
> +			flags =3D BTRFS_BLOCK_GROUP_METADATA;
> +		space_info =3D __find_space_info(fs_info, flags);
> +		ASSERT(space_info);
> +		percpu_counter_add_batch(&space_info->total_bytes_pinned,
> +				   -head->num_bytes,
> +				   BTRFS_TOTAL_BYTES_PINNED_BATCH);
> +
> +		if (head->is_data) {
> +			spin_lock(&delayed_refs->lock);
> +			delayed_refs->pending_csums -=3D head->num_bytes;
> +			spin_unlock(&delayed_refs->lock);
> +		}
> +	}
> +
> +	/* Also free its reserved qgroup space */
> +	btrfs_qgroup_free_delayed_ref(fs_info, head->qgroup_ref_root,
> +				      head->qgroup_reserved);

This part will be removed in patch "[PATCH] btrfs: qgroup: Move reserved
data account from btrfs_delayed_ref_head to btrfs_qgroup_extent_record".

So there is one less thing to worry about in delayed ref head.

Thanks,
Qu

> +}
> +
>  static int cleanup_ref_head(struct btrfs_trans_handle *trans,
>  			    struct btrfs_delayed_ref_head *head)
>  {
> @@ -2478,31 +2513,6 @@ static int cleanup_ref_head(struct btrfs_trans_h=
andle *trans,
>  	spin_unlock(&head->lock);
>  	spin_unlock(&delayed_refs->lock);
> =20
> -	trace_run_delayed_ref_head(fs_info, head, 0);
> -
> -	if (head->total_ref_mod < 0) {
> -		struct btrfs_space_info *space_info;
> -		u64 flags;
> -
> -		if (head->is_data)
> -			flags =3D BTRFS_BLOCK_GROUP_DATA;
> -		else if (head->is_system)
> -			flags =3D BTRFS_BLOCK_GROUP_SYSTEM;
> -		else
> -			flags =3D BTRFS_BLOCK_GROUP_METADATA;
> -		space_info =3D __find_space_info(fs_info, flags);
> -		ASSERT(space_info);
> -		percpu_counter_add_batch(&space_info->total_bytes_pinned,
> -				   -head->num_bytes,
> -				   BTRFS_TOTAL_BYTES_PINNED_BATCH);
> -
> -		if (head->is_data) {
> -			spin_lock(&delayed_refs->lock);
> -			delayed_refs->pending_csums -=3D head->num_bytes;
> -			spin_unlock(&delayed_refs->lock);
> -		}
> -	}
> -
>  	if (head->must_insert_reserved) {
>  		btrfs_pin_extent(fs_info, head->bytenr,
>  				 head->num_bytes, 1);
> @@ -2512,9 +2522,9 @@ static int cleanup_ref_head(struct btrfs_trans_ha=
ndle *trans,
>  		}
>  	}
> =20
> -	/* Also free its reserved qgroup space */
> -	btrfs_qgroup_free_delayed_ref(fs_info, head->qgroup_ref_root,
> -				      head->qgroup_reserved);
> +	cleanup_ref_head_accounting(trans, head);
> +
> +	trace_run_delayed_ref_head(fs_info, head, 0);
>  	btrfs_delayed_ref_unlock(head);
>  	btrfs_put_delayed_ref_head(head);
>  	return 0;
> @@ -6991,6 +7001,7 @@ static noinline int check_ref_cleanup(struct btrf=
s_trans_handle *trans,
>  	if (head->must_insert_reserved)
>  		ret =3D 1;
> =20
> +	cleanup_ref_head_accounting(trans, head);
>  	mutex_unlock(&head->mutex);
>  	btrfs_put_delayed_ref_head(head);
>  	return ret;
>=20


--BAvH2WLIys5pRgtxLCWY88nSHHt0hxKX5--

--GonEQgvppJbyODW6G3brQHUUX9iNO0Pdo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlv2ARYACgkQwj2R86El
/qjEhAf/S2vmlLLfAhMB687ozuGxMIKawLyS52uk3GmKQYoRJUcemqDKR7w/nw6E
hl9ue4wLr5ULnKpAUjg/SztBzErE7jR0Z8vwfQ7+PzPKfL/0OqKsOV6IC+Ap88qX
6T9rA49ghuaLY2kSyP8TVZOxOFub8ddG7aR5mu+CauTp0GPnfoHNUv1myal7Er2S
H4hgJthp5crjwcoYSUsfg9qmqBIZO4vxYMcAUEhdjG+8G8V+NSRaq2PRGEqK5jnK
iV9/64hsO/Eg3wUlMcTyWlQGekNzS0AIsrC89N3k2QpWh6JAqfFKGCkofsigwPlb
nuHhNWp/Td6wf9j1v06PG++lHGaJjA==
=+shI
-----END PGP SIGNATURE-----

--GonEQgvppJbyODW6G3brQHUUX9iNO0Pdo--
