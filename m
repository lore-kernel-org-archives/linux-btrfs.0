From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: btrfs lock-up on copying files
Date: Thu, 30 Jun 2011 20:43:47 +0600
Message-ID: <20110630204347.0d70506e@natsu>
References: <20110630123738.6042e563@natsu>
	<4E0C8A3F.2060202@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.JuH2R0YgvkPK4gAxufS/Wi"; protocol="application/pgp-signature"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0C8A3F.2060202@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/.JuH2R0YgvkPK4gAxufS/Wi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 30 Jun 2011 10:37:51 -0400
Josef Bacik <josef@redhat.com> wrote:

> Can you do sysrq+w when this happens?  The caching kthread should still
> be able to make progress, which is what we seem to be waiting on.  Does
> it eventually unhang and continue on?  Thanks,

Hello,

Unfortunately I already rebooted that server so can't check SysRq+W.
Before the reboot I waited for about 40 minutes, and the block device seeme=
d to be 100% idle during all this time.
I got an advice on IRC to wait for a couple of hours if this happens again,=
 which I am going to try if it does.

--=20
With respect,
Roman

--Sig_/.JuH2R0YgvkPK4gAxufS/Wi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4Mi6MACgkQTLKSvz+PZwhx3ACfQsns8U4uHKMsYKBQWbtLtElB
1O4An2vRjsEU646XDT0iio5r04pVxa8Z
=Kdod
-----END PGP SIGNATURE-----

--Sig_/.JuH2R0YgvkPK4gAxufS/Wi--
