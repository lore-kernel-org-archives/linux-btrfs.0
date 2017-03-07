Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36567 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932888AbdCGRpv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Mar 2017 12:45:51 -0500
Subject: Re: [PATCH 1/9] btrfs: qgroup: Add trace point for qgroup reserved
 space
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.com, clm@fb.com
References: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
 <20170227071039.8335-2-quwenruo@cn.fujitsu.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <54b53e20-9499-9e24-ddda-c49bddd57b32@suse.com>
Date: Tue, 7 Mar 2017 11:30:59 -0500
MIME-Version: 1.0
In-Reply-To: <20170227071039.8335-2-quwenruo@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gJLas7gDLqCFfMMFNv5WQPlp2cvuAcFAr"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gJLas7gDLqCFfMMFNv5WQPlp2cvuAcFAr
Content-Type: multipart/mixed; boundary="eJSIgGch7NqiTrlkh06VOsJiv83AfjaPL";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
 dsterba@suse.com, clm@fb.com
Message-ID: <54b53e20-9499-9e24-ddda-c49bddd57b32@suse.com>
Subject: Re: [PATCH 1/9] btrfs: qgroup: Add trace point for qgroup reserved
 space
References: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
 <20170227071039.8335-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170227071039.8335-2-quwenruo@cn.fujitsu.com>

--eJSIgGch7NqiTrlkh06VOsJiv83AfjaPL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2/27/17 2:10 AM, Qu Wenruo wrote:
> Introduce the following trace points:
> qgroup_update_reserve
> qgroup_meta_reserve
>
> These trace points are handy to trace qgroup reserve space related
> problems.
>=20
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/qgroup.c            | 15 +++++++++++++++
>  include/trace/events/btrfs.h | 43 ++++++++++++++++++++++++++++++++++++=
+++++++
>  2 files changed, 58 insertions(+)
>=20
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index a5da750c1087..b303d4794026 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1075,6 +1075,8 @@ static int __qgroup_excl_accounting(struct btrfs_=
fs_info *fs_info,
>  	qgroup->excl +=3D sign * num_bytes;
>  	qgroup->excl_cmpr +=3D sign * num_bytes;
>  	if (sign > 0) {
> +		trace_qgroup_update_reserve(fs_info, qgroup->qgroupid,
> +					    qgroup->reserved, -(s64)num_bytes);
>  		if (WARN_ON(qgroup->reserved < num_bytes))
>  			report_reserved_underflow(fs_info, qgroup, num_bytes);
>  		else
> @@ -1100,6 +1102,9 @@ static int __qgroup_excl_accounting(struct btrfs_=
fs_info *fs_info,
>  		WARN_ON(sign < 0 && qgroup->excl < num_bytes);
>  		qgroup->excl +=3D sign * num_bytes;
>  		if (sign > 0) {
> +			trace_qgroup_update_reserve(fs_info, qgroup->qgroupid,
> +						    qgroup->reserved,
> +						    -(s64)num_bytes);
>  			if (WARN_ON(qgroup->reserved < num_bytes))
>  				report_reserved_underflow(fs_info, qgroup,
>  							  num_bytes);
> @@ -2424,6 +2429,8 @@ static int qgroup_reserve(struct btrfs_root *root=
, u64 num_bytes, bool enforce)
> =20
>  		qg =3D unode_aux_to_qgroup(unode);
> =20
> +		trace_qgroup_update_reserve(fs_info, qg->qgroupid,
> +					    qg->reserved, num_bytes);
>  		qg->reserved +=3D num_bytes;
>  	}
> =20
> @@ -2469,6 +2476,8 @@ void btrfs_qgroup_free_refroot(struct btrfs_fs_in=
fo *fs_info,
> =20
>  		qg =3D unode_aux_to_qgroup(unode);
> =20
> +		trace_qgroup_update_reserve(fs_info, qg->qgroupid,
> +					    qg->reserved, -(s64)num_bytes);
>  		if (WARN_ON(qg->reserved < num_bytes))
>  			report_reserved_underflow(fs_info, qg, num_bytes);
>  		else
> @@ -2945,6 +2954,8 @@ int btrfs_qgroup_reserve_meta(struct btrfs_root *=
root, int num_bytes,
>  		return 0;
> =20
>  	BUG_ON(num_bytes !=3D round_down(num_bytes, fs_info->nodesize));
> +	trace_qgroup_meta_reserve(fs_info, root->objectid,
> +				  (s64)num_bytes);
>  	ret =3D qgroup_reserve(root, num_bytes, enforce);
>  	if (ret < 0)
>  		return ret;
> @@ -2964,6 +2975,8 @@ void btrfs_qgroup_free_meta_all(struct btrfs_root=
 *root)
>  	reserved =3D atomic_xchg(&root->qgroup_meta_rsv, 0);
>  	if (reserved =3D=3D 0)
>  		return;
> +	trace_qgroup_meta_reserve(root->fs_info, root->objectid,
> +				  -(s64)reserved);
>  	btrfs_qgroup_free_refroot(fs_info, root->objectid, reserved);
>  }
> =20
> @@ -2978,6 +2991,8 @@ void btrfs_qgroup_free_meta(struct btrfs_root *ro=
ot, int num_bytes)
>  	BUG_ON(num_bytes !=3D round_down(num_bytes, fs_info->nodesize));
>  	WARN_ON(atomic_read(&root->qgroup_meta_rsv) < num_bytes);
>  	atomic_sub(num_bytes, &root->qgroup_meta_rsv);
> +	trace_qgroup_meta_reserve(root->fs_info, root->objectid,
> +				  -(s64)num_bytes);
>  	btrfs_qgroup_free_refroot(fs_info, root->objectid, num_bytes);
>  }
> =20
> diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.=
h
> index a3c3cab643a9..2d5799d8a4a2 100644
> --- a/include/trace/events/btrfs.h
> +++ b/include/trace/events/btrfs.h
> @@ -1475,6 +1475,49 @@ TRACE_EVENT(qgroup_update_counters,
>  		  __entry->cur_new_count)
>  );
> =20
> +TRACE_EVENT(qgroup_update_reserve,
> +
> +	TP_PROTO(struct btrfs_fs_info *fs_info, u64 qgid, u64 cur_reserved,
> +		 s64 diff),
> +
> +	TP_ARGS(fs_info, qgid, cur_reserved, diff),
> +
> +	TP_STRUCT__entry_btrfs(
> +		__field(	u64,	qgid			)
> +		__field(	u64,	cur_reserved		)
> +		__field(	s64,	diff			)
> +	),
> +
> +	TP_fast_assign_btrfs(fs_info,
> +		__entry->qgid		=3D qgid;
> +		__entry->cur_reserved	=3D cur_reserved;
> +		__entry->diff		=3D diff;
> +	),
> +
> +	TP_printk_btrfs("qgid =3D %llu, cur_reserved =3D %llu, diff =3D %lld"=
,
> +		__entry->qgid, __entry->cur_reserved, __entry->diff)
> +);
> +

This is always called using a qgroup pointer.  Why not just pass it and
let the the assignment clause grab the values?

> +TRACE_EVENT(qgroup_meta_reserve,
> +
> +	TP_PROTO(struct btrfs_fs_info *fs_info, u64 refroot, s64 diff),
> +
> +	TP_ARGS(fs_info, refroot, diff),
> +
> +	TP_STRUCT__entry_btrfs(
> +		__field(	u64,	refroot			)
> +		__field(	s64,	diff			)
> +	),
> +
> +	TP_fast_assign_btrfs(fs_info,
> +		__entry->refroot	=3D refroot;
> +		__entry->diff		=3D diff;
> +	),
> +
> +	TP_printk_btrfs("refroot =3D %llu, diff =3D %lld",
> +		__entry->refroot, __entry->diff)
> +);

Same here, but with btrfs_root * instead.

-Jeff

> +
>  #endif /* _TRACE_BTRFS_H */
> =20
>  /* This part must be outside protection */
>=20


--=20
Jeff Mahoney
SUSE Labs


--eJSIgGch7NqiTrlkh06VOsJiv83AfjaPL--

--gJLas7gDLqCFfMMFNv5WQPlp2cvuAcFAr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWL7gQx57S2MheeWyAQgM8xAAuOeo56ZG7mcWy73tdd6trtJ1s1akfmrR
WCnlFniq5QCnnMq9aMq6Hkd7QpnVC1Q9ZPFK2viPToKmu03QE6MrBRHhWBW64/Sj
Zc/k0HkPT1kICD4YLTdO+3/JwLxghx0a6TkcuJjNO1S7lFdfIT/+3qysZv0MtxtS
L2nzrFLO0l/OPVCCwE8bK7OoggRK/y7Xv7WuBzAUd1tcG8N/WYKiXFcFllMEkZu/
2kF5xrpHtTCTbR2f2vCg4zTOWTYP/c5fT8OuhfW0h6hB8PTSrM0a6XHrErIFDcE3
EL6Y3w1xVVU/bCMH4V2T+1TTVdfJkfqaBy/Xq7LEflaWJR0nFAJKZqCBp0GhNLzM
OyamBhogppGMxkCcZV7IZzFOAFn3P+PvSZHxU1goUfdiRVyOiYraK48pHWGxYTEI
wdxFfdnXPNVyHlIrNmhzzQcElTJ6LSBVaD9PUSbVzQUT286l9FCVH1e5P+cVBgZ6
ivg8k5ClsRAXle2gAWO9gHnk67DWZnbc8qXPU86Z/AudjrlcaamDYjtHBDVHuyKz
w13vxhUMIx7E47sWfqApjN4DqF/IG6S9VJ/LbPdMJjYxcQZOQUHdejtfeEhlwDIX
f0vS2+1aMHKWoRox5sRnkyYgQywV6+zxm57PfayRArNCVaa5DxWr0/k3mGIypPXG
D8oLRkDe72o=
=/SFF
-----END PGP SIGNATURE-----

--gJLas7gDLqCFfMMFNv5WQPlp2cvuAcFAr--
