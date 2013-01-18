Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34493 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3ARPzm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jan 2013 10:55:42 -0500
Date: Fri, 18 Jan 2013 15:55:35 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Gene Czarcinski <gene@czarc.net>
Cc: dsterba@suse.cz, chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [GIT PULL] btrfs-progs: more bugfixes for 0.20-rc1
Message-ID: <20130118155535.GB5406@carfax.org.uk>
References: <20130117174721.GD22785@twin.jikos.cz>
 <50F95920.406@czarc.net>
 <20130118144439.GB19967@twin.jikos.cz>
 <50F96F00.3040008@czarc.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V0207lvV8h4k8FAm"
In-Reply-To: <50F96F00.3040008@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 18, 2013 at 10:49:20AM -0500, Gene Czarcinski wrote:
> On 01/18/2013 09:44 AM, David Sterba wrote:
> >On Fri, Jan 18, 2013 at 09:16:00AM -0500, Gene Czarcinski wrote:
> >>>Sergei Trofimovich (1):
> >>>       version.sh: fix version when built from tarball
> >>While you are about it, how about adding in this fix from Dieter Ries to fix
> >>version a little more:
> >>http://article.gmane.org/gmane.comp.file-systems.btrfs/20069
> >I did not notice it before, but Dieter's patch does not work when progs
> >are built from .git repository
> >
> >-echo "#define BTRFS_BUILD_VERSION \"Btrfs $v\"" >> .build-version.h
> >+echo "#define BTRFS_BUILD_VERSION \"$v\"" >> .build-version.h
> >
> >$v is set with the git tag, so the "Btrfs" string does not appear in the
> >output (eg. mkfs.btrfs).
> >
> >Technically, $v should always contain some sort of a tag, Sergei's patch
> >hardcodes it to the latest one for the non-git case. This is IMHO the
> >right approach.
> >
> OK, I see what you mean.  However, the current situation when btrfs
> is built from a tarball results in:
> 
> >btrfs  --version
> Btrfs Btrfs v0.19

   I guess one problem here is that there's no canonical way of
generating a tarball (without the git files) from a git checkout, with
detailed version information. So what's happening, I suspect, is that
the distributions/people producing source tarballs of btrfs-progs are
checking out the git tree, deleting .git, and tarring up that, which
loses any git versioning.

   I think a solution may be to have a "dist" or "tar" make target
which does the above automatically and includes a suitably-generated
version.h in the tarball.

   Hugo.

> and
> 
> >mkfs.btrfs  -V
> mkfs.btrfs, part of Btrfs Btrfs v0.19
> 
> There must be a way to reliably just have one "Btrfs" and I will
> look into it.
> 
> Gene

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Klytus, I'm bored. What plaything can you offer me today? ---    

--V0207lvV8h4k8FAm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUPlwd79z9OVl50rAAQLENA/+PL/e7WcFYwdH8IhGohSTxYvnkUtIUuXt
m6MhzCOyHjeecjBwOqUAHkiKCb0V8bAjlelJAnxpJMTeOwO3rdbwexdO1Nl44IFy
EGHTP9Znz+9rKBKgN/5T0Ln3hrVlCaaOmKj5muqzdBcfrPeiB9nGHFqDwkiI6I1Q
zvKtvkbMOLUapIExGxrTkXm2vay5pelYJwwqMpzO9rASD6h6f0jVIroCGiEwyomz
xHBFX1gEdoLVmfOklEcnzTufR99R1mlPkez+7IDu2BJWVjxmIgmP1XPOLNN+FyjG
qiueD02Wihkm1OYtnQF8c1XjH5+jMi8fCNO9ukEv3Sz0dy6QvnazUjG9sfI0QHC+
8iacKCXoTfISYPzbRWGz4se22BtjF+XPjcjHHAE6V2q8nO7jOwsfDHtjrLbi3ugQ
dVtnlMgBJ1pjpybsFEK/A84wwBC7gf7WNlgSTvfX7YwKuGWKT/GkdZoApDrORfeU
Vz2r778+B2MqmB4r9ovGuKcla/Xu1t8FGhnWM7Xc3J2L5R1LYDH3zoHpuYYqd8IS
1PtNSFPe6Ngizr6uZYnsi/1F2aKViC4h7BdXuOpxraTGiX+GME41WMVn6i2ldCdr
rHm8iXFJtaIMRh6ZQiTKuWjxrg56Ga+3k7gbElfbnk5f7KdSIHpn1R7vXNplA3Cw
vPx0s2llTTg=
=1IYF
-----END PGP SIGNATURE-----

--V0207lvV8h4k8FAm--
