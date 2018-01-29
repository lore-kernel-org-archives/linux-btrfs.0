Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52839 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751547AbeA2OHG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 09:07:06 -0500
Subject: Re: [PATCH v3] btrfs: Ignore errors from
 btrfs_qgroup_trace_extent_post
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1517211848-13324-1-git-send-email-nborisov@suse.com>
 <1517233981-31889-1-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3e753bcf-415e-ad94-ee5f-28cf1c9ca477@gmx.com>
Date: Mon, 29 Jan 2018 22:06:52 +0800
MIME-Version: 1.0
In-Reply-To: <1517233981-31889-1-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="brNkLEah4wEsXc6nfhiwwyucpd5j22qn1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--brNkLEah4wEsXc6nfhiwwyucpd5j22qn1
Content-Type: multipart/mixed; boundary="AnwUxTzzoO1TbCK9QH5a2gnunfvgsHW7i";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <3e753bcf-415e-ad94-ee5f-28cf1c9ca477@gmx.com>
Subject: Re: [PATCH v3] btrfs: Ignore errors from
 btrfs_qgroup_trace_extent_post
References: <1517211848-13324-1-git-send-email-nborisov@suse.com>
 <1517233981-31889-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1517233981-31889-1-git-send-email-nborisov@suse.com>

--AnwUxTzzoO1TbCK9QH5a2gnunfvgsHW7i
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8829=E6=97=A5 21:53, Nikolay Borisov wrote:
> Running generic/019 with qgroups on the scratch device enabled is
> almost guaranteed to trigger the BUG_ON in btrfs_free_tree_block. It's
> supposed to trigger only on -ENOMEM, in reality, however, it's possible=

> to get -EIO from btrfs_qgroup_trace_extent_post. This function just
> finds the roots of the extent being tracked and sets the qrecord->old_r=
oots
> list. If this operation fails nothing critical happens except the
> quota accounting can be considered wrong. In such case just set the
> INCONSISTENT flag for the quota and print a warning, rather than
> killing off the system. Additionally, it's possible to trigger a BUG_ON=

> in btrfs_truncate_inode_items as well.
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> V3:=20
>  * Incorporate feedback from Qu and make btrfs_qgroup_trace_extent_post=
 always
>  return 0 since higher layers don't really handle errors properly.
>=20
> V2:=20
>  * Always print a warning if btrfs_qgroup_trace_extent_post fails=20
>   * Set quota inconsistent flag if btrfs_qgroup_trace_extent_post fails=

>  fs/btrfs/delayed-ref.c | 3 ++-
>  fs/btrfs/qgroup.c      | 7 +++++--
>  2 files changed, 7 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index a1a40cf382e3..7ab5e0128f0c 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -821,7 +821,8 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info=
 *fs_info,
>  	spin_unlock(&delayed_refs->lock);
> =20
>  	if (qrecord_inserted)
> -		return btrfs_qgroup_trace_extent_post(fs_info, record);
> +		btrfs_qgroup_trace_extent_post(fs_info, record);
> +
>  	return 0;
> =20
>  free_head_ref:
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 9e61dd624f7b..ebde770ba498 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1442,8 +1442,11 @@ int btrfs_qgroup_trace_extent_post(struct btrfs_=
fs_info *fs_info,
>  	int ret;
> =20
>  	ret =3D btrfs_find_all_roots(NULL, fs_info, bytenr, 0, &old_root, fal=
se);
> -	if (ret < 0)
> -		return ret;
> +	if (ret < 0) {
> +		fs_info->qgroup_flags |=3D BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
> +		btrfs_warn(fs_info, "Error accounting new delayed refs extent (err c=
ode: %d). Quota inconsistent", ret);
> +		return 0;
> +	}
> =20
>  	/*
>  	 * Here we don't need to get the lock of
>=20


--AnwUxTzzoO1TbCK9QH5a2gnunfvgsHW7i--

--brNkLEah4wEsXc6nfhiwwyucpd5j22qn1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpvKn0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhlpQf/fbYYfvc+//Ko4qCso9LGLdk3
dQ3ABZiBrIMJxnDn/k3vH4sV7vA1Ejy3WLcD1ekMpX/+a32x25FoRcYrICaomAxJ
zJueTvgRNwrF8wOwoJ2FQ6tdgjw6lbTfuSnJbZ7kY9NFeeZ8wwl0yniyEXR0xeL3
cpCrz6pnVaQcbQ0ecHMpW+7e/IWOxrhD1wyfIwmWTDkGQDbnp1Q4uBq6e+Y+mj6z
LgeoD1BG2IRvdMMCvyOkfbiezpN1K5BRJgU4DnftiFBRUhaM60Y0OUnLMDQValIM
EArF/ma9XNWX2eElerWOrvre+pfBNnu3CbtpUYiLNJ7slAUgLUtyupGXxrJFVw==
=xS4s
-----END PGP SIGNATURE-----

--brNkLEah4wEsXc6nfhiwwyucpd5j22qn1--
