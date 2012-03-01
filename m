From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: [PATCH] [RFC] Add btrfs autosnap feature
Date: Thu, 1 Mar 2012 19:23:26 +0600
Message-ID: <20120301192326.06992f64@natsu>
References: <n>
	<1330484376-16178-1-git-send-email-anand.jain@oracle.com>
	<1330484376-16178-2-git-send-email-anand.jain@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/77C0+_9XrXQ+MeB4Xvk5zHX"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org, hugo@carfax.org.uk,
	chris.mason@oracle.com
To: asj <anand.jain@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1330484376-16178-2-git-send-email-anand.jain@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/77C0+_9XrXQ+MeB4Xvk5zHX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Feb 2012 10:59:36 +0800
asj <anand.jain@oracle.com> wrote:

> This patch adds btrfs autosnap feature. This creates and
> saves the autosnap config at /etc/autosnap/config.
> Depending on the configuration, autosnap either schedules
> the snapshots by updating the crontab or provides an API
> to trigger the snapshots from the respective applications.

The way I see it, this sort of functionality would look more logical in a
separate userspace daemon, not in 'btrfs' directly.

Such daemon could operate in the background, continuously monitor the FS and
create or remove snapshots based on various criteria (and not depend on cro=
n).

It could even become filesystem-agnostic, over time adding support for other
filesystems with snapshot functionality (ZFS and NILFS2).

It could (and should) be a separate project from the btrfs-tools altogether,
and a separate OS distribution package.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/77C0+_9XrXQ+MeB4Xvk5zHX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk9PeE4ACgkQTLKSvz+PZwj3AQCfeYtvb0JdBVtNZBuviLJgLgqu
29UAn0V5uGLkZzJvu18AOx2hEuZAiTkl
=4DrK
-----END PGP SIGNATURE-----

--Sig_/77C0+_9XrXQ+MeB4Xvk5zHX--
