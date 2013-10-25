Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38597 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab3JYKoS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 06:44:18 -0400
Date: Fri, 25 Oct 2013 11:44:14 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Roman Mamedov <rm@romanrm.net>
Cc: Timofey Titovets <nefelim4ag@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: swapfile on btrfs, temporary solution for wiki
Message-ID: <20131025104414.GD31029@carfax.org.uk>
References: <CAGqmi74OvQ=BFroP+QCf6eUtc61__LYRGtZJNcPz1XrSWX-q_w@mail.gmail.com>
 <CAGqmi74F9GurJL73qtU4JG+Fi4RbXE7tiaO1uEQqEY2ym278eA@mail.gmail.com>
 <20131025163546.4cf3291a@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ylS2wUBXLOxYXZFQ"
In-Reply-To: <20131025163546.4cf3291a@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ylS2wUBXLOxYXZFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 25, 2013 at 04:35:46PM +0600, Roman Mamedov wrote:
> On Thu, 24 Oct 2013 23:52:01 +0300
> Timofey Titovets <nefelim4ag@gmail.com> wrote:
> 
> > Hello, i suggest temporary solution to use swap file under btrfs.
> > I test it, and it work good.
> > 
> > I invent simple the way, how create and using swap file, just see
> > following sh code:
> > 
> > swapfile=$(losetup -f) #free loop device
> > truncate -s 8G /swap   #create 8G sparse swap file
> > losetup $swapfile /swap #mount file to loop
> > mkswap  $swapfile
> > swapon  $swapfile
> > 
> > i just adding this to rc.local and this work good.
> > May be, add it to btrfs Wiki as temporary solution to using swap file?
> 
> I always thought Btrfs does not allow swap files on purpose, because it is not
> deadlock-proof when used in the swapping context.

   It's more that the current swap interface is based on device+block
list, and if you balance a filesystem, the blocks for a file move --
but there's no way of telling the swap code to cope with that.

> Imagine you try swapping out pages to free up some memory, and in the process
> Btrfs needs to allocate some memory to actually perform the write, the kernel
> says "Sure, but for that we need to swap out some more pages..." You see where
> that goes.
> 
> Same issue is possible with swap on other complex filesystems an example
> being networked ones like NFS and SMB/CIFS.

   The network filesystems have a similar problem as btrfs -- they
don't export devices, and you don't get direct access to the low-level
blocks under the FS, so the swap code can't deal with it.

   That said, there's been a lot of work recently on getting
swap-over-NFS to work properly -- effectively giving a new interface
for the swap code that doesn't rely on direct mapping to device
blocks. That new interface gives us the minimal external
infrastructure necessary to consider doing swapfiles on btrfs.

> It might work for some time (or even work 99% of time), but you still may be
> endangering your system to a possibility of a lock-up, and certainly adding
> that to any Wiki/FAQ/website as "the solution" might not be the best choice.

   The deadlock situation is dealt with by adding a flag to the memory
allocator in the swap-critical paths, which says you're not allowed to
swap anything when you make the allocation. That at least allows the
memory allocation to fail (hopefully gracefully) without deadlocking.
I suspect that this is also part of the swap-on-NFS work -- adding
that flag everywhere necessary.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- He's playing Schubert.  I think Schubert is losing. ---       

--ylS2wUBXLOxYXZFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUmpLflheFHXiqx3kAQLf5g/8D6q296NgQJxKvg6a/XN2DvAKmNwpZOp9
wx78PoZHRHldL70BP/gtKE2ClSDgfyJFlEFDlzE2JV0eoefHLB3G3eVgCaiWKs0Z
YI0YJ7VfW+Kmp9jj5byQEYqExeF4PlfgybqChF/l5Lk6IqYNcm9qABFlUJI7IQ3Y
SweLDXXWqSGfExgpzxcTSDxIj9GQwmK9FemLeH+yt9enIXAnGtGdicT5XJJTjCKF
Yidc5JT5oRnlDa1kjZTFmnofrRbve5XXYXEqeZ9bbqFnBAfoKqaAGOwUfUJu+qM/
Euaz1Y4sIQv33Ze4E+5zMEFIyqkkkWC3Ne2dwCAlZORm8p+a5YK3TAySFkU7QPFo
AZSqEowa/O5vs5mHEtUAjADUwFVOdPiF51SBB1mSDB7uj5wHAIgrpoLnqMT57h/n
uoPyRN0aFppldnr2cLobV3ZzOpPNbR0LML5jxN+qd8gt7X3pm1iSfBFP1O40SzD6
s6PPDmwQwvk+/2rzGws11zdUcW4HA1IjWSuJyVqZmWJirHuw6wLHmUPaMFhVuaTf
5md6uuV0zyBY0QuXV9x3PEbea2kOBuCr70bmhYDkNYe4S1Vh9hiw6GTCfYajgKqy
QtUlhHXLbhmH9otJsRG2s5w5/T2bf4jYa7h+wBJQsUeM4zgsvmAltzDO+NHv5UQc
SZd1x7PY+NE=
=saRc
-----END PGP SIGNATURE-----

--ylS2wUBXLOxYXZFQ--
