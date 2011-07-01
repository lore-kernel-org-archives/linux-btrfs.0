From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: device failure hangs the system
Date: Fri, 1 Jul 2011 15:44:39 +0600
Message-ID: <20110701154439.46da0098@natsu>
References: <4E0D929E.7030704@oracle.com>
	<4E0D9689.6040700@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/j/SjbWVRLj5fHmnO0BiDW4t"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: Anand Jain <Anand.Jain@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0D9689.6040700@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/j/SjbWVRLj5fHmnO0BiDW4t
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 01 Jul 2011 17:42:33 +0800
Anand Jain <Anand.Jain@oracle.com> wrote:

>   Looks like there is a panic (not system hang).
>   any idea where is the panic log after the system has been
>   power-recycled. (its not in the /var/log/messages or dmesg or
>   /var/crash is empty)

You can get it by seting up netconsole logging to another machine and then =
reproducing the crash.
http://www.cyberciti.biz/tips/linux-netconsole-log-management-tutorial.html

--=20
With respect,
Roman

--Sig_/j/SjbWVRLj5fHmnO0BiDW4t
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4NlwcACgkQTLKSvz+PZwjmdgCfe5p3t1QrAlFmrGzgnJjo3c5l
BrIAnAtWv5+sssBhfqIrUQaYHYhZSo77
=XyU5
-----END PGP SIGNATURE-----

--Sig_/j/SjbWVRLj5fHmnO0BiDW4t--
