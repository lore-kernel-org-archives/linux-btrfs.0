Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55951 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbbKXUcN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 15:32:13 -0500
Date: Tue, 24 Nov 2015 20:32:10 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Vincent Olivier <vincent@up4.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs check help
Message-ID: <20151124203210.GR24333@carfax.org.uk>
References: <AF79907D-A36B-4806-B31A-3E327F2E5642@up4.com>
 <5654C86C.9080800@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rTHIjeKG9uUlSyhr"
In-Reply-To: <5654C86C.9080800@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--rTHIjeKG9uUlSyhr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 24, 2015 at 03:28:28PM -0500, Austin S Hemmelgarn wrote:
> On 2015-11-24 12:06, Vincent Olivier wrote:
> >Hi,
> >
> >Woke up this morning with a kernel panic (for which I do not have details). Please find below the output for btrfs check. Is this normal ? What should I do ? Arch Linux 4.2.5. Btrfs-utils 4.3.1. 17x4TB RAID10.
> You get bonus points for being on a reasonably up-to-date kernel and
> userspace :)
> 
> This is actually a pretty tame check result for a filesystem that's
> been through kernel panic. I think everything listed here is safe
> for check to fix, but I would suggest waiting until the devs provide
> opinions before actually running with --repair.  I would also
> suggest comparing results between the different devices in the FS,
> if things are drastically different, you may have issues that check
> can't fix on it's own.
> >[root@3dcpc5 ~]# btrfs check /dev/sdk
> >Checking filesystem on /dev/sdk
> >UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> >checking extents
> >checking free space cache
> >checking fs roots
> These next two lines are errors, but I'm not 100% certain if it's
> safe to have check fix them:
> >root 5 inode 1341670 errors 400, nbytes wrong
> >root 11406 inode 1341670 errors 400, nbytes wrong

   I think so yes.

> This next one is also an error, and I am fairly certain that it's
> safe to have check fix as long as the number at the end is not too
> big.
> >found 19328809638262 bytes used err is 1

   Agreed.

   Hugo.

> The rest is just reference info
> >total csum bytes: 18849042724
> >total tree bytes: 27389886464
> >total fs tree bytes: 4449746944
> >total extent tree bytes: 3075457024
> >btree space waste bytes: 2880474254
> The only other thing I know that's worth mentioning is that if the
> numbers on these next two lines don't match, you may be missing some
> writes from right before the crash.
> >file data blocks allocated: 19430708535296
> >referenced 20123773407232

-- 
Hugo Mills             | Great films about cricket: Umpire of the Rising Sun
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--rTHIjeKG9uUlSyhr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWVMlKAAoJEFheFHXiqx3kgkMP/Rk+fbVkSyxppt+w59xcroph
GeuPbn6H2h1p8ZJWAz6RsM6P0xu/4hTgvmUZckV/xrjHGx2ciksSEi6xr7MNXpSL
xuOc6edUbwaXACQZE2EOjKcrE3yM6V+zpHakMP2+AqV0sRBsdgS0PJHFAQ3LCGOp
xgX5IzsNROrN9vYLnqGVYKYa8sGetemNUcoMs9vUadr9mqQ5TEGn6RdirMRxwK41
9yD4r2fckXGMF+1xaNA2FvaM/tQAdPPFhEjZe3egmjQfjgodWtmRuMi1dPSM9xKN
+L9GAbK6IV6yxJ8PtPsP7Xv95HbMKgtTi5UhdQqY/k77mkq/qbjYHloOD3apkWpu
Ep3KoNLHezR4oywUZPoZhhs29SU5IptPRk0uizKAV/eAVovwI/VkZd7/5zbjbG72
3okuXUK2NTIecvdlKKtl8evxLW4Ei+XPTppE4BeFr3yqY1vLwO+HHOFSoK8DHl94
p0rsgtnBX5YGzig8A3sajsujIV5+5EqSavQg6DK7jN6fH5EXaKnZ/A0ACdaYDSR8
YgoXiMM5vaWMiZIKf8svvDA9lsJU8Ik8zWVpej5HoszRCzuSJp5m3sdw0WhOJpos
F+PxgNSQHyPy9upD0TPZq0RNbRrXxC6XlygJYXFggPS7lS18X9P1/enPXOeDlvoB
STRBNL5E6OR/McCn5R08
=xbnT
-----END PGP SIGNATURE-----

--rTHIjeKG9uUlSyhr--
