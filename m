Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:35991 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751344AbeF1ICX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 04:02:23 -0400
Subject: Re: [PATCH RFC] btrfs: Do extra device generation check at mount time
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        Anand Jain <anand.jain@oracle.com>
References: <20180628070443.23421-1-wqu@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <575511f2-512c-2aa0-1dd9-027f00c4ce75@gmx.com>
Date: Thu, 28 Jun 2018 16:02:08 +0800
MIME-Version: 1.0
In-Reply-To: <20180628070443.23421-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iheNartZHr5t8c3dNYYvgmX20g9fun5Kp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iheNartZHr5t8c3dNYYvgmX20g9fun5Kp
Content-Type: multipart/mixed; boundary="gmCKvD9h7seiWF2lyL73KsXJXmm58rby5";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 Anand Jain <anand.jain@oracle.com>
Message-ID: <575511f2-512c-2aa0-1dd9-027f00c4ce75@gmx.com>
Subject: Re: [PATCH RFC] btrfs: Do extra device generation check at mount time
References: <20180628070443.23421-1-wqu@suse.com>
In-Reply-To: <20180628070443.23421-1-wqu@suse.com>

--gmCKvD9h7seiWF2lyL73KsXJXmm58rby5
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Also CC Anand Jain, since he is also working on various device related
work, and an expert on this.

Especially I'm not pretty sure if such enhancement is already on his
agenda or there are already some unmerged patch for this.

Thanks,
Qu

On 2018=E5=B9=B406=E6=9C=8828=E6=97=A5 15:04, Qu Wenruo wrote:
> There is a reporter considering btrfs raid1 has a major design flaw
> which can't handle nodatasum files.
>=20
> Despite his incorrect expectation, btrfs indeed doesn't handle device
> generation mismatch well.
>=20
> This means if one devices missed and re-appeared, even its generation
> no longer matches with the rest device pool, btrfs does nothing to it,
> but treat it as normal good device.
>=20
> At least let's detect such generation mismatch and avoid mounting the
> fs.
> Currently there is no automatic rebuild yet, which means if users find
> device generation mismatch error message, they can only mount the fs
> using "device" and "degraded" mount option (if possible), then replace
> the offending device to manually "rebuild" the fs.
>=20
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> I totally understand that, generation based solution can't handle
> split-brain case (where 2 RAID1 devices get mounted degraded separately=
)
> at all, but at least let's handle what we can do.
>=20
> The best way to solve the problem is to make btrfs treat such lower gen=

> devices as some kind of missing device, and queue an automatic scrub fo=
r
> that device.
> But that's a lot of extra work, at least let's start from detecting suc=
h
> problem first.
> ---
>  fs/btrfs/volumes.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++=

>  1 file changed, 50 insertions(+)
>=20
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e034ad9e23b4..80a7c44993bc 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6467,6 +6467,49 @@ static void btrfs_report_missing_device(struct b=
trfs_fs_info *fs_info,
>  			      devid, uuid);
>  }
> =20
> +static int verify_devices_generation(struct btrfs_fs_info *fs_info,
> +				     struct btrfs_device *dev)
> +{
> +	struct btrfs_fs_devices *fs_devices =3D dev->fs_devices;
> +	struct btrfs_device *cur;
> +	bool warn_only =3D false;
> +	int ret =3D 0;
> +
> +	if (!fs_devices || fs_devices->seeding || !dev->generation)
> +		return 0;
> +
> +	/*
> +	 * If we're not replaying log, we're completely safe to allow
> +	 * generation mismatch as it won't write anything to disks, nor
> +	 * remount to rw.
> +	 */
> +	if (btrfs_test_opt(fs_info, NOLOGREPLAY))
> +		warn_only =3D true;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(cur, &fs_devices->devices, dev_list) {
> +		if (cur->generation && cur->generation !=3D dev->generation) {
> +			if (warn_only) {
> +				btrfs_warn_rl_in_rcu(fs_info,
> +	"devid %llu has unexpected generation, has %llu expected %llu",
> +						     dev->devid,
> +						     dev->generation,
> +						     cur->generation);
> +			} else {
> +				btrfs_err_rl_in_rcu(fs_info,
> +	"devid %llu has unexpected generation, has %llu expected %llu",
> +						     dev->devid,
> +						     dev->generation,
> +						     cur->generation);
> +				ret =3D -EINVAL;
> +				break;
> +			}
> +		}
> +	}
> +	rcu_read_unlock();
> +	return ret;
> +}
> +
>  static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_=
key *key,
>  			  struct extent_buffer *leaf,
>  			  struct btrfs_chunk *chunk)
> @@ -6552,6 +6595,13 @@ static int read_one_chunk(struct btrfs_fs_info *=
fs_info, struct btrfs_key *key,
>  				return PTR_ERR(map->stripes[i].dev);
>  			}
>  			btrfs_report_missing_device(fs_info, devid, uuid, false);
> +		} else {
> +			ret =3D verify_devices_generation(fs_info,
> +							map->stripes[i].dev);
> +			if (ret < 0) {
> +				free_extent_map(em);
> +				return ret;
> +			}
>  		}
>  		set_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
>  				&(map->stripes[i].dev->dev_state));
>=20


--gmCKvD9h7seiWF2lyL73KsXJXmm58rby5--

--iheNartZHr5t8c3dNYYvgmX20g9fun5Kp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls0lgAACgkQwj2R86El
/qg5XAf/aAuKr7ojCa8rkFNATMaySNS2VdXDvMgj1UXqsmhu5WQ1zbWgJjr/mEtM
YRM+AjY5DvLQ04QCekx6FWHwaVWro0YMn1rYmZ7UhY3Q0cuUX5iNwCdNtdzu7RNX
rM3833Bo31T/mmZf1DtOyycu0yb9YxapTRs7sANmRH5Gxomh4KBK+a9vuvqqE7E7
9NMf8RenkP/ejbfe46EMRFnAUxhuK5ystc08aP8ysigH3MmVYGiwVaQDY6lizSF4
eXkWAIme5XQZlhS13iBpzq9EXGol1hGHf9ThIRZynnyhOoF1gCyQbbS+e0YszAMD
Rndobw1OOuaI690NwolQ50TstaOFQg==
=oju4
-----END PGP SIGNATURE-----

--iheNartZHr5t8c3dNYYvgmX20g9fun5Kp--
