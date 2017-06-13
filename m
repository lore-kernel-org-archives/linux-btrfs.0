Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48904 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751826AbdFMSfw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 14:35:52 -0400
Subject: Re: [PATCH 7/7] Btrfs: warn if total_bytes_pinned is non-zero on
 unmount
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>, Liu Bo <bo.li.liu@oracle.com>,
        kernel-team@fb.com
References: <cover.1496792333.git.osandov@fb.com>
 <0a015ca3c5d799b501b9c23475ed9e96d16de671.1496792333.git.osandov@fb.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <6752eb7c-e5d2-c082-470c-719dd618cb54@suse.com>
Date: Tue, 13 Jun 2017 14:35:47 -0400
MIME-Version: 1.0
In-Reply-To: <0a015ca3c5d799b501b9c23475ed9e96d16de671.1496792333.git.osandov@fb.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lTv9nV8p3mNHQOQQoUpoQ8hOPxRe6qmAv"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lTv9nV8p3mNHQOQQoUpoQ8hOPxRe6qmAv
Content-Type: multipart/mixed; boundary="o4Ijw6wvNjQQ7NTT7AWTnVDc9hggW7Gsa";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>, Liu Bo <bo.li.liu@oracle.com>,
 kernel-team@fb.com
Message-ID: <6752eb7c-e5d2-c082-470c-719dd618cb54@suse.com>
Subject: Re: [PATCH 7/7] Btrfs: warn if total_bytes_pinned is non-zero on
 unmount
References: <cover.1496792333.git.osandov@fb.com>
 <0a015ca3c5d799b501b9c23475ed9e96d16de671.1496792333.git.osandov@fb.com>
In-Reply-To: <0a015ca3c5d799b501b9c23475ed9e96d16de671.1496792333.git.osandov@fb.com>

--o4Ijw6wvNjQQ7NTT7AWTnVDc9hggW7Gsa
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/6/17 7:45 PM, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
>=20
> Catch any future/remaining leaks or underflows of total_bytes_pinned.
>=20
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 75ad24f8d253..5fb2fb27eda6 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9860,6 +9860,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info =
*info)
>  			    space_info->bytes_reserved > 0 ||
>  			    space_info->bytes_may_use > 0))
>  			dump_space_info(info, space_info, 0, 0);
> +		WARN_ON(percpu_counter_sum(&space_info->total_bytes_pinned) !=3D 0);=

>  		list_del(&space_info->list);
>  		for (i =3D 0; i < BTRFS_NR_RAID_TYPES; i++) {
>  			struct kobject *kobj;
>=20

Can we group this in with the other WARN_ON and add printing
total_bytes_pinned to dump_space_info?  Understanding the magnitude and
whether we're underflowed or haven't released enough is helpful.  While
testing your patchset, I did this and it found a few bugs in cleanup
after error.  I'll post those patches shortly.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--o4Ijw6wvNjQQ7NTT7AWTnVDc9hggW7Gsa--

--lTv9nV8p3mNHQOQQoUpoQ8hOPxRe6qmAv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWUAwhB57S2MheeWyAQgahQ/+M69UdDzLC8bKQxUtDZW9QW5wBzrrJOio
/cc3vOV4eBEvTxbsqphS0Lf53WP41YZa7iTwIBDIl5bSOdiRMcVYIdc31UP7bz9d
NxvoLY7U9+xu4k3twjV0wWc3IoPqVh781cj/S86r6PXF4gMMFT+W7v6QwIA9nDEW
0EXFeK4p4B3lKWWLiCLo/Rauz2zd5EfuvItp56RdrExPDEUjmJS69jHas208/WMA
sbF3TGIHXhSXWYSvfZaHPcgChThQtiU0dbZggfwQMGfDH//itc/84Vxu8n7lyYpD
noaF4cPwI+Dv9ukJZxeLwPpwzX4+nO3flrS8I0IEe/F+T0HxTUkzB0lbFqIC8zW8
2+kbRjvgIiqxS8LWFKmaai/kJ97qnOHajWlruXr2PZsgH6LIYiE+rbrRQ+6H3Pcm
RosQtbLGkEoVCczXaM65Yrt+GQH01qo1ZglWaHcOGUe/XmXzZ1znHoERYMMcGjpv
N5J5+20yezu6Jrpc+I68hwiSrO4EWbOEuS5tVDABi5AYk7NqZjySx251S5pKu+OW
IQOYxe4nLSV4Tx3UgU00lMmz+gOuqg+6TiE+QeVzWpqcHLhyxayqjUV72loAlcFt
4RgflaFHFN1OM6jPD3fzNt57VS84LarMN7NxywtE4/MnAIJRzfhgsEI6QmpBJPOZ
W7eH8GbpcbE=
=2is1
-----END PGP SIGNATURE-----

--lTv9nV8p3mNHQOQQoUpoQ8hOPxRe6qmAv--
