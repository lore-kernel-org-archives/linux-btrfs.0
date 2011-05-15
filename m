From: kehon <coolkehon@gmail.com>
Subject: Re: [GIT PULL] Btrfs updates
Date: Sun, 15 May 2011 11:41:59 -0400
Message-ID: <20110515154159.GA4296@gshadow>
References: <1305470325-sup-6477@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; x-action=pgp-signed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305470325-sup-6477@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Any plans to update the wiki ?
https://btrfs.wiki.kernel.org/index.php/Changelog
:P
On 05/15/11 at 10:47am, Chris Mason wrote:
> 
> Hi everyone,
> 
> The master branch of the btrfs unstable tree has a few more fixes:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master
> 
> These include small fixes in the new per-file flags, an oops in
> the btrfs acl code and ENOSPC fixes for mixed block groups (used in very
> small filesystems).
> 
> Li Zefan (3) commits (+15/-10):
>     Btrfs: fix FS_IOC_SETFLAGS ioctl (+2/-0)
>     Btrfs: fix FS_IOC_GETFLAGS ioctl (+7/-0)
>     fs: remove FS_COW_FL (+6/-10)
> 
> Daniel J Blueman (1) commits (+3/-2):
>     Prevent oopsing in posix_acl_valid()
> 
> liubo (1) commits (+26/-11):
>     Btrfs: fix easily get into ENOSPC in mixed case
> 
> Total: (5) commits (+44/-23)
> 
>  fs/btrfs/acl.c         |    5 +++--
>  fs/btrfs/extent-tree.c |   37 ++++++++++++++++++++++++++-----------
>  fs/btrfs/ioctl.c       |   24 +++++++++++++++---------
>  include/linux/fs.h     |    1 -
>  4 files changed, 44 insertions(+), 23 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJNz/RGAAoJEFWnpyuyLRXa6M8P/0Ev5byjWO7bRheomupHtUUe
Oo4OVsQAN7dvD/GSfRCoCEnNEFAn70wNnARW4bPgWC8jvM5HSPx+fFc4u4URBS6q
3mZUEyB2XMsAKqrDiXuIHgsUFcCZWW9IwhS5q8vMJ6F5ZZR9lIVt1Uh8l9qghdNh
6pdohUCJ6gRQZyaY+P/Cv0eZJ1KdOcnmqL7PU8EMS/0OZWAgE/SMoYBuiX8qftTP
jiNdxlIATgVeUA1r7Q7qaBiYQ4x76RuzINe5rtLK04Gg5eYZ1FPyrWZc12/347u3
soOcGKsKKRQ7WvSDnaK2ecz4r5XaeL7s5lnGFcfVlP+71qPpGe6i/JVQKR7+AZpN
gBSbXAO/VkkW8mx2BbNNTx93LFkr962XyLzS44mzik4VzPdZ7QM5Bd3q2sWQfRKO
ePHoHiH5ZeDsukLZw4cHKVbsHr1ZcaBn1vEqof047Sy79BlEuy0wLr1R7kG/FZMy
S+y1gU3gku+3BMb+NuHJwWEFVx1zmAhp/r9fRdyOaHmgxdBsi0bDtCuYPoSxl68O
2m9WlJNxBkuMZ66UAYnhbX97x/WCOvNByLCTzFm25H1ISzHgF2z/pbuK2iz+OGG9
I+vDFX06LJcc/NTOx2dv86Wxaw2MsEOXNoBomIXvn2O+8IeltTLbxd/+8NGavMFc
kw0DNwrL8tMx3M7nVfbD
=OD9q
-----END PGP SIGNATURE-----
