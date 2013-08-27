Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667Ab3H0T2b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Aug 2013 15:28:31 -0400
Message-ID: <521CFDD8.6030205@suse.com>
Date: Tue, 27 Aug 2013 15:28:24 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add support for asserts
References: <1377550566-10941-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1377550566-10941-1-git-send-email-jbacik@fusionio.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="7KklAtGs2JAMd1TfSXPGV7qC46q0SwkfT"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7KklAtGs2JAMd1TfSXPGV7qC46q0SwkfT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 8/26/13 4:56 PM, Josef Bacik wrote:
> One of the complaints we get a lot is how many BUG_ON()'s we have.  So =
to help
> with this I'm introducing a kconfig option to enable/disable a new ASSE=
RT()
> mechanism much like what XFS does.  This will allow us developers to st=
ill get
> our nice panics but allow users/distros to compile them out.  With this=
 we can
> go through and convert any BUG_ON()'s that we have to catch actual prog=
ramming
> mistakes to the new ASSERT() and then fix everybody else to return erro=
rs.  This
> will also allow developers to leave sanity checks in their new code to =
make sure
> we don't trip over problems while testing stuff and vetting new feature=
s.
> Thanks,

I don't think the complaint is so much about the number of BUG_ONs, but
that there's no distinction between something that is supposed to be
impossible and something that is improbable. The BUG_ONs to keep code
correctness are good and are littered all over the kernel with positive
results. The BUG_ONs that are there in place of real error handling
served their purpose and need to be replaced.

So, I don't know if it's a net win to compile the "good" BUG_ONs out of
the code. Especially if a user runs into something strange yet familiar
and the first response is "oh, huh, can you rebuild with asserts enabled?=
"

For the call sites that are unimplemented error handling, something to
annotate those so that we can keep track of them and gradually eliminate
those too would be good, though.

-Jeff

> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/Kconfig |    9 +++++++++
>  fs/btrfs/ctree.h |   16 ++++++++++++++++
>  2 files changed, 25 insertions(+), 0 deletions(-)
>=20
> diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
> index 2b3b832..398cbd5 100644
> --- a/fs/btrfs/Kconfig
> +++ b/fs/btrfs/Kconfig
> @@ -72,3 +72,12 @@ config BTRFS_DEBUG
>  	  performance, or export extra information via sysfs.
> =20
>  	  If unsure, say N.
> +
> +config BTRFS_ASSERT
> +	bool "Btrfs assert support"
> +	depends on BTRFS_FS
> +	help
> +	  Enable run-time assertion checking.  This will result in panics if
> +	  any of the assertions trip.  This is meant for btrfs developers onl=
y.
> +
> +	  If unsure, say N.
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index c90be01..8278a3f 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3814,6 +3814,22 @@ void btrfs_printk(const struct btrfs_fs_info *fs=
_info, const char *fmt, ...)
>  #define btrfs_debug(fs_info, fmt, args...) \
>  	btrfs_printk(fs_info, KERN_DEBUG fmt, ##args)
> =20
> +#ifdef BTRFS_ASSERT
> +
> +static inline void assfail(char *expr, char *file, int lin)
> +{
> +	printk(KERN_ERR "BTRFS assertion failed: %s, file: %s, line: %d",
> +	       expr, file, line);
> +	BUG();
> +}
> +
> +#define ASSERT(expr)	\
> +	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
> +#else
> +#define ASSERT(expr)	((void)0)
> +#endif
> +
> +#define btrfs_assert()
>  __printf(5, 6)
>  void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *func=
tion,
>  		     unsigned int line, int errno, const char *fmt, ...);
>=20


--=20
Jeff Mahoney
SUSE Labs


--7KklAtGs2JAMd1TfSXPGV7qC46q0SwkfT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSHP3YAAoJEB57S2MheeWyRUcP/0ITckz38CstAvJ6l0MO6SMD
yKCBAMXL0aABD3l/9Wjb/DZBv00YvBKUfhocraE9vy+HvJvikLApQ41ztFpVx2/q
MeW/0WwYOAIa56uwp4pJtkifmhVRYKqkzj1foYnJlygdKZAsSz24z3O9HcxJBZl/
winEnxzVu0LsnumcAsnVUJufoF0LCrAAbWmTpAVB/vi+vY0JJhnlKmqZG0Z65WIf
BKAz0WtRCRta2E9hWvMH7lXrqY8s+dGTJcpB/kEsKTjWViqs0HYtpru/KtBQ054U
XM01YYZEzU+Ytnfs2OQD1172lM6ac20Bb6ShwtQy+v5Ee5d3xEwjfv8K39rcfnhT
Njc58FJNw79QeEzbErgAjwhk0n266JKeHf2mKMoO1F1KL0L44yKfqWbF/3BpXcjQ
R6PteZlQ/fmLRuEsbIfyWbmwPhQBPL3kU5tyVCNbRhWmFX+/nmpwl5V0JKiyD+me
H2FyzL0OLXo5AQB6VApRYlG3EGsPLdG88bCO0wSXAW/OTjzXv1XSF+Crh9+iXo8Y
bP7w6XPdYHVFqnBI9U3SgwssOKNR22voszVGeD/HwoNGpY92Urf/DJhzJK0EO7lH
fNZVLgLbGC7sJfegT0CR4+9fvrgkE9ymXnKtZkVQu8qZ6Xa8K1ezHnRSVr4yCwYe
cT7HO8iksCB7cxtY5SeP
=/DMa
-----END PGP SIGNATURE-----

--7KklAtGs2JAMd1TfSXPGV7qC46q0SwkfT--
