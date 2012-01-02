From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs-tools in Debian squeeze-backports?
Date: Mon, 2 Jan 2012 14:43:40 +0000
Message-ID: <20120102144340.GA21476@carfax.org.uk>
References: <4F01BF5D.2070801@pocock.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Cc: linux-btrfs@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F01BF5D.2070801@pocock.com.au>
List-ID: <linux-btrfs.vger.kernel.org>


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 02, 2012 at 03:29:49PM +0100, Daniel Pocock wrote:
> These are the btrfs-tools versions on Debian:
> 
> squeeze:
> kernel: 2.6.32
> tools: 0.19+20100601-3
> 
> squeeze-backports:
> kernel: 2.6.39
> tools: nothing (so user ends up with 0.19+20100601-3)
> 
> wheezy/testing/sid:
> kernel: 3.1.6-1
> tools: 0.19+20111105-2
> 
> Using the 2.6.39 kernel from squeeze-backports,

   Don't do that. It's pretty old, and there's been a large number of
fixes in btrfs since then. I would recommend using the very latest
kernel you can -- preferably an -rc series kernel (after -rc3
or so, though), or the latest release kernel.

> do I need a newer btrfs-tools

   The only real reason to upgrade your btrfs tools is to get access
to the newer features of the FS.

> and is there a particular reason it is not in squeeze-backports too?

   You'll have to ask the backports people about that. The btrfs
developers don't have any control over what ends up in most
distributions.

> Or should I not be trying to use the versions in squeeze at all - should
> I be on testing/wheezy or unstable?

   You should definitely be on 3.1 or 3.2 kernel at the moment.

> The Debian btrfs wiki and the regular btrfs wiki don't really suggest a
> good starting point (other than suggesting the btrfs has been in Debian
> since squeeze)
> http://wiki.debian.org/Btrfs
> 
> If I try to use the version from testing or unstable, I get this error
> on a squeeze setup:
> 
>  btrfs-tools depends on e2fslibs (>= 1.41.99); however:
>   Version of e2fslibs on system is 1.41.12-4stable1.

   In that case, I'd suggest either building from the git source tree
for tools (see the wiki[1] for instructions), or, if you insist on
having .deb packages, doing your own backport:

$ apt-get build-dep btrfs-tools
$ apt-get source -t unstable btrfs-tools
$ cd btrfs-tools-0.19+20111105
$ fakeroot debian/rules
$ sudo dpkg -i ../btrfs-tools-0.19+20111105.deb   # This may be a different name

   Hugo.

[1] http://btrfs.ipv5.de/index.php?title=Btrfs_source_repositories#Official_repository

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Anyone using a computer to generate random numbers is, of ---    
                       course,  in a state of sin.                       

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPAcKcIKyzvlFcI40RArkmAJsGv1TPq9lZLUjWn6JXoQe//91tzwCgoffL
9nqbv5gaOjWr4IGXKzXXZok=
=inVi
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
