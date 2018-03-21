Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:49088 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbeCUHQq (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 21 Mar 2018 03:16:46 -0400
Subject: Re: [PATCH] btrfs: Remove obsolete function declaration
To: Nikolay Borisov <nborisov@suse.com>, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
References: <1521615821-17703-1-git-send-email-nborisov@suse.com>
From: Qu Wenruo <wqu@suse.com>
Message-ID: <ad566699-9a26-e439-0e5d-4e9b1bdf06a5@suse.com>
Date: Wed, 21 Mar 2018 15:16:25 +0800
MIME-Version: 1.0
In-Reply-To: <1521615821-17703-1-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1fJrXON4Clza32U8cMC6OjPBAbHO5blPN"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1fJrXON4Clza32U8cMC6OjPBAbHO5blPN
Content-Type: multipart/mixed; boundary="YnVpWxmoAqHGmdiJwoSuicEKF9AUdkKeY";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.com>
To: Nikolay Borisov <nborisov@suse.com>, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
Message-ID: <ad566699-9a26-e439-0e5d-4e9b1bdf06a5@suse.com>
Subject: Re: [PATCH] btrfs: Remove obsolete function declaration
References: <1521615821-17703-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1521615821-17703-1-git-send-email-nborisov@suse.com>

--YnVpWxmoAqHGmdiJwoSuicEKF9AUdkKeY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8821=E6=97=A5 15:03, Nikolay Borisov wrote:
> This function was removed in 24bc2843edd5 ("btrfs:
> Refactor __get_raid_index() to btrfs_bg_flags_to_raid_index()") what
> remains is a defunct declaration. Remove it.

Nice find, thanks for get this.


But strangely, I just fetched David's repo, but didn't find that commit
hash anywhere.

I'm fetching from git.kernel.org repo, or is that repo only updated when
pushing to Linus?

Thanks,
Qu

>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> David,=20
>=20
> This is a fixlet to the aforementioned patch which is only in your misc=
-next,=20
> I'd suggest just squash this fixlet into the original one.=20
>=20
>  fs/btrfs/ctree.h | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index fbe51edb9cac..03be51d77357 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2801,7 +2801,6 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, =
struct fstrim_range *range);
>  int btrfs_init_space_info(struct btrfs_fs_info *fs_info);
>  int btrfs_delayed_refs_qgroup_accounting(struct btrfs_trans_handle *tr=
ans,
>  					 struct btrfs_fs_info *fs_info);
> -int __get_raid_index(u64 flags);
>  int btrfs_start_write_no_snapshotting(struct btrfs_root *root);
>  void btrfs_end_write_no_snapshotting(struct btrfs_root *root);
>  void btrfs_wait_for_snapshot_creation(struct btrfs_root *root);
>=20


--YnVpWxmoAqHGmdiJwoSuicEKF9AUdkKeY--

--1fJrXON4Clza32U8cMC6OjPBAbHO5blPN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFBBAEBCAArFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqyBskNHHdxdUBzdXNl
LmNvbQAKCRDCPZHzoSX+qK5HB/0cVLIRxc0v2Jru2DnxNUasumP1IqwZUMKu0VdV
l+fraph1z9T8rGC6xdCLcpuG2uLBPxM0Rn21BgrSswcPpuK1YW/vYpj/G83FT9Yq
sNbEYWw9dwWyzP+YW6Uwy7t0U2y2A8ZhIw1UogWYeYH3sLJm1l0cuTR8esYS3Tr2
a+58NGzIHSPHYP2DoT0HwHoiFz9EljLxRlouK30qaqe1izN6VvcgomdLGRByAGgt
NfrpNYKvKXR8gAWU2zy8xCi/GnsIgC2RZrJRaPZ7vyWMclCGY+TsAozxxAISq5p/
PlrNixflcwKRvg7YPZYLOEacp+bTuqpo6UePn3DTQ9ZKSCt8
=yFg2
-----END PGP SIGNATURE-----

--1fJrXON4Clza32U8cMC6OjPBAbHO5blPN--
