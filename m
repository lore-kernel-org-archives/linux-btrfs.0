Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34494 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbcDJPH4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Apr 2016 11:07:56 -0400
Date: Sun, 10 Apr 2016 15:07:53 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Richard C <mailing-lists@racitup.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfstune -u makes filesystem unmountable
Message-ID: <20160410150753.GX29474@carfax.org.uk>
References: <CAK1feJAqOgucajbGQmZMzrdaw=BmXV9ht=Rt16Kk+X3A7Xs_oA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xr11uZXTBybZk4CB"
In-Reply-To: <CAK1feJAqOgucajbGQmZMzrdaw=BmXV9ht=Rt16Kk+X3A7Xs_oA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--xr11uZXTBybZk4CB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 10, 2016 at 03:47:44PM +0100, Richard C wrote:
> Hi,
> 
> I'm writing a backup script that images a btrfs using btrfs-image,

   You are aware that btrfs-image copies only the metadata? The data
is _not_ a part of the image, so it's a fairly poor implementation of
a backup process.

   Hugo.

> then restores to a file on a loop device. Since I had trouble mounting
> the original and copied btrfs filesystems with the same UUID on the
> same machine, I decided to try btrfstune -fu. However, this appears to
> corrupt the copied filesystem altogether making fsck and mount fail.
> Details below.
> Is this a bug?
> 
> $ uname -a
> Linux adventure 3.16.0-67-generic #87~14.04.1-Ubuntu SMP Fri Mar 11
> 00:26:02 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
> $ btrfs --version
> btrfs-progs v4.4
> 
> $ btrfstune -fu /dev/loop2
> Current fsid: 36012b08-1e33-4d3c-ac23-5ccffd3295cd
> New fsid: 8f70d0af-8ffa-4c82-a817-941e6abfaf9a
> Set superblock flag CHANGING_FSID
> Change fsid in extents
> Change fsid on devices
> Clear superblock flag CHANGING_FSID
> Fsid change finished
> 
> $ btrfs check /dev/loop2
> fsid mismatch, want=36012b08-1e33-4d3c-ac23-5ccffd3295cd,
> have=8f70d0af-8ffa-4c82-a817-941e6abfaf9a
> Couldn't read chunk root
> Couldn't open file system
> $ echo $?
> 251
> 
> $ mount /dev/loop2 /mnt
>  mount: wrong fs type, bad option, bad superblock on /dev/loop2,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
> $ echo $?
> 32

-- 
Hugo Mills             | There's many a slip 'twixt wicket-keeper and gully.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--xr11uZXTBybZk4CB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXCmxIAAoJEFheFHXiqx3kyxsQAKYMlKbQJLTKm6zcyYsCM6IU
kUOm80V+247b1MOP6lusrAN8h500nalmOru8D3Hu7Ha/HKI14U1TvKIF11mG8xZe
KunsdITI1YS+HWl5fiWKVoM1zid204hOUA5M0r40zmQmrwmbe+OZXl8kHyylaaro
o2UkUKSO2tuwzrhfQQs8eU4TiBaY9KZaICa9LwcqBew69xFndc4wzfJknQXYsDoS
TYsJd7KU268VWaskKanLLgUK8T14hk2Qeu8cUJvR4HJc0zblCi2XRODh7vUIezZd
oLPxVBakJVsN0qHzPBXpdBZsPA7Olit86cK3lUobkTEBwrM2K+C834wLlA9/dd1T
FJNuBNwB/Oau7UJFpvU03D07W9EH+1XzSOjBnpQWc09yHrr14iVLzLZ4wjrMFDQT
/jln+6FNpjBD8uZuCjjhkt0nyldiL8Vax9/E6A6b7EAwk9VUG3DsV+xS/6v4qvAs
rsvxXbWSqicE5wC/hTuvHtdszm3prcfUEYu4HYtNTf1rZAimEGrmzduF0u0CUXca
b5TMl3BKHvtqouUlvdoeyhhslXPuNucDTCxSgRfMC+1IXfI+pFsQVE6R1ihExC+s
i4z22tr7iGP9f5yVAA0MkeGk9/HDFyEwVF2mxVTPsrLLrIVAZiKDpFlAv/9SmRZ7
d0bh2gK+qqW/Znkszq2q
=XhOS
-----END PGP SIGNATURE-----

--xr11uZXTBybZk4CB--
