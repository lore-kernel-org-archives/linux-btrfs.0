From: Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Subject: Symlinks' device numbers differ from regular files'
Date: Fri, 19 Nov 2010 00:54:23 +0100
Message-ID: <20101118235423.GC12925@toke.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="QV9egoCq9O4JbpTr"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--QV9egoCq9O4JbpTr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

I am having a problem with my btrfs partitions: symlinks are reported to=20
have different device numbers than directories and regular files, even=20
though they are on the same partition. This causes my backup software to=20
mess up backing up the symlinks.

An illustrative example:

$ touch tmp; ln -s tmp tmp2; stat tmp tmp2
  File: `tmp'
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: 15h/21d	Inode: 984027      Links: 1
--- snip ---
  File: `tmp2' -> `tmp'
  Size: 3         	Blocks: 0          IO Block: 4096   symbolic link
Device: 13h/19d	Inode: 984028      Links: 1
--- snip ---

$ uname -r
2.6.35-ck

I'm not using subvolumes, or any fancy features of btrfs, really. I'm=20
running Arch Linux.

Is this normal? And if not, how do I fix it?

Any help would be greatly appreciated.  Thanks in advance.

Regards,
-Toke H=F8iland-J=F8rgensen

--QV9egoCq9O4JbpTr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJM5byvAAoJEEpVxJf3RPcFozkP/23kObtEvIkhSDzf4HO8pHLQ
MFx/+NMCKDIMpAMDOoDKzGisb+zfP8LEwW3FNE2VehrXoYsAO59LIcb/t2523Ocq
gIq5T1BlGCGAxgiwmTftqv2IagCkLj2tnyuNzwSUIVZErZABHwD3nzGm2602VU/G
Q/usj+m3oQ7yYZvOxzJB0JEQUL3l+EDkCQtTHGsFSX35qjAhwjCOkhWHfkHOphRe
WxzP0qk7hsM0yAQZEl6BxEkEHeq+m5t+suPllQuubaqJGAKSRe+R3JiYk9ucuarf
pLHCDzAcNIs7gZquKxRcM7ilj1WOkmLP7MfCerckkDd7GPftXndnqC7+aW7twx4W
G9aS7oj/nGwpsJZOqaT2UQT1XihAEsPzZAZReVrxWFjTMHbibmloAU2NVD7f2VCT
X02xpwWRHLiTeUNNy22AluoL/bJKpES8quPbliE2lNXHv9r/1Q5A3LAkL6xE6hLr
1NMS2GlznfPeLPST48mG6HroipWuTSm07Lh3maxl4AVnqtO4Ey7VLySpxWmuIhMx
7p8F8l5aX/FHx8VBa5ZL6vJGF2EkToiA//vITGhzjioHZn0aH7r+BJzFgNQdzgi0
NlyCbWItd/iWtD52xnH8QhDsul0LQzWbPuQ0Q4VuRRq3XNIvjL+BvMK8n8yQNPbR
JdFwnomA1Z9w2Ybzf9d2
=4d3p
-----END PGP SIGNATURE-----

--QV9egoCq9O4JbpTr--
