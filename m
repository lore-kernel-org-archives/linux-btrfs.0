Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56260 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3D3Jlf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Apr 2013 05:41:35 -0400
Date: Tue, 30 Apr 2013 10:41:31 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: helmut@hullen.de
Cc: linux-btrfs@vger.kernel.org
Subject: Re: WARNING: at fs/btrfs/free-space-cache.c:921
 __btrfs_write_out_cache+0x6b9/0x9a0 [btrfs]()
Message-ID: <20130430094131.GA8274@carfax.org.uk>
References: <CADn-QaMao+mtnJVuwjbnqHgFzKhqUfn2uiDgN5hFw_fHP+mGcQ@mail.gmail.com>
 <CVrGRAreCXB@helmut.hullen.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
In-Reply-To: <CVrGRAreCXB@helmut.hullen.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 30, 2013 at 08:55:00AM +0200, Helmut Hullen wrote:
> Hallo, Alexander,
> 
> Du meintest am 30.04.13:
> 
> > On my HP Compaq dc5800 with Ubuntu 13.04 and their
> > 3.8.0-19-lowlatency kernel, I've got quite some kernel traces in the
> > syslog.
> 
> It's a very good idea to use the newest kernel for btrfs. 3.8.0 is  
> really old.
> 
> Just try kernel 3.8.10.

   The differences in btrfs between the two are very small, and even
I(*) wouldn't call 3.8.0 "very old" quite yet, given that 3.9 was only
released yesterday. From memory, there's one btrfs patch in the 3.8
stable series.

   Your problem is "just" a warning, and appears to be something to do
with running out of space, or having too many CRCs... I don't really
know the free space cache code at all well, so I'm mostly guessing
here, from looking at the WARN_ON in __btrfs_write_out_cache.

   Hugo.

(*) High Priest of the Kernel Upgrade.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                       ---   __(_'>  Squeak!   ---                       

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUX+Ry1heFHXiqx3kAQIwxQ//Qrso6GvJ5ZlC4lBzkTWpfEYVCq+wJXtA
Hrze8HuJGRnvh+IFN9yow9o1evH0gjoogVN8xlV1VB/Cy4EmWDk5BSoftWNH1pwW
CKmMGZBsAc9bi3zAtUiMLRn7x99F0jSPg9HQVBaPCckAt+brtkLgp39Xks9dPH+1
hbD5+zvr9+iGiEl7MUoLm5H81tfywgw5nSS80LjySGlFXPVvJ/oQdad1vGDMg+hA
kSHXXOZSHSd2w3zWYGi1kIY0GEU3U5ZJGzB3PYDhy2QSLLaM9cVuaGxMzW8ybDfG
/EXgN5gpNGqHPwJXHWtWk+Vo0QlJuWU1M6nxJQxNqK6NLUJ1s1GmoAXKDmMOSSgH
QlTtbF8kHxrpoLMGzFY7pOYCRTfiMhD423ZE2gi5zKazTBUXJeVGMX/Wa4NaqBLe
0SvlpaW/TJXyyR7i9+WTmz0vOvmz+vhBIEmEMIXaZqo0jLNf7dfYE/Aw09EC5Xdf
L9b5ZU3eRCq+PsJFwZ5i/rTv/pIHrKy56qPzX+JdSvgoXxSI/y7KB2X8oBm3DjDl
mFcfCkrB2jB/isgHKjarxXGWI23f3Hx5/WMRxM6jtduaR2qOWMeqsnZIGaFVMJtb
gYbsK64sLnBfhF+PkB4cQ/ouJPPY+Ni74Swit08L/9XBTwpIzchMbfjuDZtSnOID
EYfioQzGKUs=
=o365
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
