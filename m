Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48307 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751180AbcLSURy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Dec 2016 15:17:54 -0500
Subject: Re: Btrfs: don't WARN() in btrfs_transaction_abort() for IO errors
From: Jeff Mahoney <jeffm@suse.com>
To: Chris Mason <clm@fb.com>, David Sterba <DSterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <2b857413-77b2-56c3-4748-786ae2c3ea14@suse.com>
Message-ID: <37f1fd28-2a7f-6dfb-1a21-e4d836ed640e@suse.com>
Date: Mon, 19 Dec 2016 15:17:50 -0500
MIME-Version: 1.0
In-Reply-To: <2b857413-77b2-56c3-4748-786ae2c3ea14@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sAujjUh66irdbsPV2NhTFEEs5LllIih8T"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sAujjUh66irdbsPV2NhTFEEs5LllIih8T
Content-Type: multipart/mixed; boundary="NXlxE2w9Q3eqMQfrIgs7XxSIFs158WUlF";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Chris Mason <clm@fb.com>, David Sterba <DSterba@suse.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <37f1fd28-2a7f-6dfb-1a21-e4d836ed640e@suse.com>
Subject: Re: Btrfs: don't WARN() in btrfs_transaction_abort() for IO errors
References: <2b857413-77b2-56c3-4748-786ae2c3ea14@suse.com>
In-Reply-To: <2b857413-77b2-56c3-4748-786ae2c3ea14@suse.com>

--NXlxE2w9Q3eqMQfrIgs7XxSIFs158WUlF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 12/19/16 3:09 PM, Jeff Mahoney wrote:
> commit e5d6b12fe14e89ea1c494585c47b1dfb31d71183
> Author: Chris Mason <clm@fb.com>
> Date:   Fri Dec 9 05:56:33 2016 -0800
>=20
>     Btrfs: don't WARN() in btrfs_transaction_abort() for IO errors
>=20
>     btrfs_transaction_abort() has a WARN() to help us nail down whateve=
r
>     problem lead to the abort.  But most of the time, we're aborting fo=
r EIO,
>     and the warning just adds noise.
>=20
>     Signed-off-by: Chris Mason <clm@fb.com>
>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index fc1864a..50bcfb8 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3445,9 +3445,14 @@ do {                                            =
                 \
>         /* Report first abort since mount */                    \
>         if (!test_and_set_bit(BTRFS_FS_STATE_TRANS_ABORTED,     \
>                         &((trans)->fs_info->fs_state))) {       \
> -               WARN(1, KERN_DEBUG                              \
> -               "BTRFS: Transaction aborted (error %d)\n",      \
> -               (errno));                                       \
> +               if ((errno) !=3D -EIO) {                          \
> +                       WARN(1, KERN_DEBUG                             =
 \
> +                       "BTRFS: Transaction aborted (error %d)\n",     =
 \
> +                       (errno));                                      =
 \
> +               } else {                                               =
 \
> +                       pr_debug("BTRFS: Transaction aborted (error %d)=
\n", \
> +                                 (errno));                     \
> +               }                                               \
>         }                                                       \
>         __btrfs_abort_transaction((trans), __func__,            \
>                                   __LINE__, (errno));           \
>=20
>=20
> Can we use btrfs_debug here instead?  There are a few naked pr_* calls =
left
> but most of them are either continuing prior lines or don't have an fsi=
nfo available.

Actually, this landed in upstream already so I'll post a proper patch
instead.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--NXlxE2w9Q3eqMQfrIgs7XxSIFs158WUlF--

--sAujjUh66irdbsPV2NhTFEEs5LllIih8T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJYWEBuAAoJEB57S2MheeWyVgUP/j1xGmoT8FtfqOWG2uAKZFFH
OllOflQrMtjrCzV5bDGOgGzs5wu4SIPi3ZJpRu9uKfET7Do9IQ4CdtAx78A4lyUr
etbbXbZiCfy37DrPB2CCnEnDErFiYrJMZa44dEHRvDV8qZaEHEqJCRuFQLNuxLVU
ULDgZl8j8Zu/JqmpjMh+6YT5dt31qJRUThoiCPPfaUQKr4C/Byh42uinaC2iQCKP
/mSWseCe4h9unB/WGxDc0wRedw4N4jNqMpDjQdvb0kqHBWAhjQ5DapjHig3LUmwa
kHFQ4QgLh3ODZxfaV0iP3ot83GQvgwJZV6/Yrt4gic7sFxzgCayxEztTe0D9/cHQ
HuRc6+LwVjxMurbqH07dFH9SXPCGM6h3U/Dnz0Z/9BILFvvkD5Q78vvudZc8O5JA
cYWlHAGGhGmer0z56KxZj2ZaFo/DmhSjl1lXORIAgkEAKjEjcVIiBLiN44GU67k3
DnQvUFqAWAeN+FKPN/DmgFy7wPhpFVr/OETL6j4wcRqAhY7h15Li8EYbecjidZt4
nFYRiINg9eFJolJV+SNrUGiuOyA3aGHlNwwc3nOTi5pml7JvMHjdWq2HMSBalKww
79EldaLeKb1lkRsrfv7NmRu12WJTO3WS8hdmhP+MS5H9IMSkwDHjAARmUX6dxqOa
8PPhiddkBPlMMVwDSdtV
=FHEQ
-----END PGP SIGNATURE-----

--sAujjUh66irdbsPV2NhTFEEs5LllIih8T--
