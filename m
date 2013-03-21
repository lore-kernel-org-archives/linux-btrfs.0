Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55378 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3CUVmQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 17:42:16 -0400
Date: Thu, 21 Mar 2013 21:42:13 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Joseph Moore <japlha@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Problems with compiling btrfs
Message-ID: <20130321214213.GJ19395@carfax.org.uk>
References: <CAGR7nwePCTCF0nz7rNqqS9x=UqLugtPL2wp7rA1SgU81R0mDcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="54ZiyWcDhi/7bWb8"
In-Reply-To: <CAGR7nwePCTCF0nz7rNqqS9x=UqLugtPL2wp7rA1SgU81R0mDcA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--54ZiyWcDhi/7bWb8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 21, 2013 at 03:11:56PM -0600, Joseph Moore wrote:
> I'm trying to compile the btrfs source code but I'm getting an error.
> Any suggestions?
> 
> Thanks
> Joe
> 
> [root@ol6 btrfs-progs]# uname -a
> Linux ol6.localdomain 2.6.39-400.17.2.el6uek.x86_64 #1 SMP Wed Mar 13
> 12:31:05 PDT 2013 x86_64 x86_64 x86_64 GNU/Linux

   If this is a standard distribution kernel, then it's massively out
of date, and you *really* need to upgrade it. If it's a heavily-
backported enterprise kernel, then it's probably still quite out of
date, but less so (and you should take advice from whoever you pay for
your support contract about whether it's supported/reliable/sane to
use it).

   However, that's just our usual warning, and isn't related to your
problem below...

> [root@ol6 src]# git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
> Initialized empty Git repository in /usr/local/src/btrfs-progs/.git/
> remote: Counting objects: 3539, done.
> remote: Compressing objects: 100% (1289/1289), done.
> remote: Total 3539 (delta 2633), reused 3015 (delta 2246)
> Receiving objects: 100% (3539/3539), 1.02 MiB | 613 KiB/s, done.
> Resolving deltas: 100% (2633/2633), done.
> 
> [root@ol6 src]# cd btrfs-progs
> [root@ol6 btrfs-progs]# pwd
> /usr/local/src/btrfs-progs
> 
> [root@ol6 btrfs-progs]# make
>     [LD]     mkfs.btrfs
> mkfs.o: In function `is_ssd':
> /usr/local/src/btrfs-progs/mkfs.c:1234: undefined reference to
> `blkid_probe_get_wholedisk_devno'
> collect2: ld returned 1 exit status
> make: *** [mkfs.btrfs] Error 1

   You need libblkid-devel (or whatever your distribution calls the
development package for libblkid). You may also want to check out the
list of required build packages on the wiki at [1], just in case
you're missing any others.

   Hugo.

[1] https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories#Dependencies

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Unix: For controlling fungal diseases in crops. ---         

--54ZiyWcDhi/7bWb8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUUt+tb9z9OVl50rAAQL8Mg//RaMv9oZf+a7Eaj8YVUR5U3WqycDvK+K8
No6davXl30vQ7PfKR6lctOQa5H/dwyB/65p8yVJihNdtP85EbWfaH5+r4j4+xMTj
Zrdkcvzm+lWOCzxrpm5AD4ouXw70YyRfMupllJGB5hnfPF7mqj+h7Ne7YZGpi7tH
EJW5wp3BZhufwqyJEt2yLXDwxqtT35aCMckZFN09w+DhMO4uHVi7OxL0mmYOL9zV
WiMk/A3oc9MF7wRBM+qp4C1xT6bSN6MKmD7+E59paGrAL9Pj5FwQtjT+5nSFPh7L
2VijE3Z58ijjv474hm/XfT6aeOmUXgBzcVB/IMqa03THbTAQ/XbLGSw1RdfI9r4r
i5Awes+ulSMyJ4VhwFxipKFZ1y8Qgq2jRX3WgtTaMtNe0ZoP/iTwJsTxoW+NoiMj
BRFO9LBYNKgLN71X+0VDfHNk6T1Ev69esi7mbBPos6yKrwEuXDSgNOAvYqs7cd23
VBQV+oI8dRTCS+oUVnaNtY50Fw4N8Zz1N55l/TaPNbypOMYy7/OvEfpbx61U/mSz
wXFLEO+kIt+GF6uArOUSYu7o6QbcUbMMQyOJU8uH/1qTg6qh6BXPauTK0lLwaN6L
rwjPYoeNS4s96lhP1vRz5d+lP+M+da/PqWCc9fj/ro9rdA5ITxk1uJLqdyNyQj5E
UYtNSyM5fII=
=sCKa
-----END PGP SIGNATURE-----

--54ZiyWcDhi/7bWb8--
