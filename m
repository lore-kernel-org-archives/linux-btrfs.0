Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48889 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755837AbdCGTLO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Mar 2017 14:11:14 -0500
Subject: Re: [PATCH 2/9] btrfs: qgroup: Re-arrange tracepoint timing to
 co-operate with reserved space tracepoint
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.com, clm@fb.com
References: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
 <20170227071039.8335-3-quwenruo@cn.fujitsu.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <15ffc421-17f7-c7b1-824c-00f23a1f51d4@suse.com>
Date: Tue, 7 Mar 2017 14:11:09 -0500
MIME-Version: 1.0
In-Reply-To: <20170227071039.8335-3-quwenruo@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Th0STcmSqedFTWMgpt3qnLirdSqJEEr9k"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Th0STcmSqedFTWMgpt3qnLirdSqJEEr9k
Content-Type: multipart/mixed; boundary="cJBjJcQlGnu6qWqOw9K2XRCcvJDQ3tijb";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
 dsterba@suse.com, clm@fb.com
Message-ID: <15ffc421-17f7-c7b1-824c-00f23a1f51d4@suse.com>
Subject: Re: [PATCH 2/9] btrfs: qgroup: Re-arrange tracepoint timing to
 co-operate with reserved space tracepoint
References: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
 <20170227071039.8335-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170227071039.8335-3-quwenruo@cn.fujitsu.com>

--cJBjJcQlGnu6qWqOw9K2XRCcvJDQ3tijb
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2/27/17 2:10 AM, Qu Wenruo wrote:
> Newly introduced qgroup reserved space trace points are normally nested=

> into several common qgroup operations.
>=20
> While some other trace points are not well placed to co-operate with
> them, causing confusing output.
>=20
> This patch re-arrange trace_btrfs_qgroup_release_data() and
> trace_btrfs_qgroup_free_delayed_ref() trace points so they are triggere=
d
> before reserved space ones.
>=20
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: Jeff Mahoney <jeffm@suse.com>

> ---
>  fs/btrfs/qgroup.c | 10 +++++-----
>  fs/btrfs/qgroup.h |  6 +-----
>  2 files changed, 6 insertions(+), 10 deletions(-)
>=20
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index b303d4794026..e46499cafdbf 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2895,14 +2895,14 @@ static int __btrfs_qgroup_release_data(struct i=
node *inode, u64 start, u64 len,
>  	if (ret < 0)
>  		goto out;
> =20
> -	if (free) {
> -		btrfs_qgroup_free_refroot(BTRFS_I(inode)->root->fs_info,
> -				BTRFS_I(inode)->root->objectid,
> -				changeset.bytes_changed);
> +	if (free)
>  		trace_op =3D QGROUP_FREE;
> -	}
>  	trace_btrfs_qgroup_release_data(inode, start, len,
>  					changeset.bytes_changed, trace_op);
> +	if (free)
> +		btrfs_qgroup_free_refroot(BTRFS_I(inode)->root->fs_info,
> +				BTRFS_I(inode)->root->objectid,
> +				changeset.bytes_changed);
>  out:
>  	ulist_release(&changeset.range_changed);
>  	return ret;
> diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
> index 26932a8a1993..92608edf0e89 100644
> --- a/fs/btrfs/qgroup.h
> +++ b/fs/btrfs/qgroup.h
> @@ -186,15 +186,11 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handl=
e *trans,
>  			 struct btrfs_qgroup_inherit *inherit);
>  void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
>  			       u64 ref_root, u64 num_bytes);
> -/*
> - * TODO: Add proper trace point for it, as btrfs_qgroup_free() is
> - * called by everywhere, can't provide good trace for delayed ref case=
=2E
> - */
>  static inline void btrfs_qgroup_free_delayed_ref(struct btrfs_fs_info =
*fs_info,
>  						 u64 ref_root, u64 num_bytes)
>  {
> -	btrfs_qgroup_free_refroot(fs_info, ref_root, num_bytes);
>  	trace_btrfs_qgroup_free_delayed_ref(fs_info, ref_root, num_bytes);
> +	btrfs_qgroup_free_refroot(fs_info, ref_root, num_bytes);
>  }
>  void assert_qgroups_uptodate(struct btrfs_trans_handle *trans);
> =20
>=20


--=20
Jeff Mahoney
SUSE Labs


--cJBjJcQlGnu6qWqOw9K2XRCcvJDQ3tijb--

--Th0STcmSqedFTWMgpt3qnLirdSqJEEr9k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIUAwUBWL8FzR57S2MheeWyAQiDlw/1EnG9mtOXG3M88Inbf69sUv3/R0VDmZwi
uzZwU0Pa0KPs+qxoeudLlypHcTisYDa1VofSsmBistitZNL4bmwpsJMguONzeAXF
wLfrOFbNsDfhi1HV5MZyGcV03GUz3u7QnDqVw4OnVYSs5cRGVA0jvvO4znpaVgTo
Tf4jnJ+S8xYOwflP/1MtPc6kJsW9SdKpgbcAi2LlNUCY3hUKRo1vmilJWMoXTVao
boDuTtVz/veje82buOldlYZWFaqTAoe1Si1Bd4f2DiaN6i6Fz2isgRsDqPpI/jDw
1GYEYjy0rNDcL3fzxu57gb1qF4TGRolIsMcNflSqs0biuSnNuasZX8v42hfQc2AK
2zAmQjxKaJH2r2KmReHNR1I6lBJ9XydwecsySKJpcueqNL3yy9ntZF2SsRmCC3L2
iHgHJw7hU2lcZkWsUkpbBbe1rO6hpot6VZOMm/G3+g9+DYFchxxNFDb3ncmBXB1V
3jfGP6hnXHcexC+e/pG0BYdyeGhjj3S/f/ri+fU3Y4mCc+AnouVKonoddMma/dEv
Ldzjo8mdjUOcLq/55pVrXKD19uiQwMGi0BNUSP1tHz4eq3XVn5Pj2M164qqh30BG
MTNep/gRpvvB7SPEI/qirN+VykWKM27a6Rf01Hz26TS/TEifIeEjv5+7s98m/jCm
QiRnM75BUQ==
=qIHh
-----END PGP SIGNATURE-----

--Th0STcmSqedFTWMgpt3qnLirdSqJEEr9k--
