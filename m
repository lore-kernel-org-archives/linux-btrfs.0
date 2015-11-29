Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42764 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbbK2OSJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Nov 2015 09:18:09 -0500
Date: Sun, 29 Nov 2015 14:18:06 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: "disk full" on a 5 GB btrfs filesystem, FAQ outdated?
Message-ID: <20151129141806.GG24333@carfax.org.uk>
References: <20151129130754.GI31524@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MtLaQwm2ZGHj8IC"
In-Reply-To: <20151129130754.GI31524@torres.zugschlus.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--3MtLaQwm2ZGHj8IC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 29, 2015 at 02:07:54PM +0100, Marc Haber wrote:
> Hi,
> 
> I have a banana pi with a btrfs filesystem of 5 GB in size, which
> frequently runs out of space (lots of snapshots). This is currently
> again the case:
> 
> [27/524]mh@banana:~$ sudo btrfs balance start /
> ERROR: error during balancing '/' - No space left on device
> There may be more info in syslog - try dmesg | tail
> [28/525]mh@banana:~$ sudo btrfs balance start / -dlimit=3
> [sudo] password for mh on banana:
> ERROR: error during balancing '/' - No space left on device
> There may be more info in syslog - try dmesg | tail
> [29/526]mh@banana:~$ sudo btrfs balance start / -dlimit=3
> ERROR: error during balancing '/' - No space left on device
> There may be more info in syslog - try dmesg | tail
> [30/526]mh@banana:~$ sudo btrfs balance start / -dusage=0
> Done, had to relocate 0 out of 8 chunks
> [31/527]mh@banana:~$ sudo btrfs balance start / -dlimit=3
> ERROR: error during balancing '/' - No space left on device
> There may be more info in syslog - try dmesg | tail
> [32/528]mh@banana:~$ sudo btrfs fi show /
> Label: none  uuid: ada6b7f5-98d6-4fee-a3a3-b73bd152ff6c
>         Total devices 1 FS bytes used 3.37GiB
>         devid    1 size 6.89GiB used 4.22GiB path /dev/mapper/banana-root
> 
> btrfs-progs v4.3
> [33/529]mh@banana:~$ sudo btrfs fi df /
> Data, single: total=3.41GiB, used=3.25GiB
> System, DUP: total=32.00MiB, used=16.00KiB
> Metadata, DUP: total=384.00MiB, used=121.75MiB
> GlobalReserve, single: total=48.00MiB, used=0.00B
> [34/530]mh@banana:~$ uname -a
> Linux banana 4.3.0-zgbpi-armmp-lpae+ #2 SMP Sat Nov 7 13:07:34 UTC 2015 armv7l GNU/Linux
> [36/532]mh@banana:~$ df -h /
> Filesystem               Size  Used Avail Use% Mounted on
> /dev/mapper/banana-root  6.9G  3.6G  2.9G  56% /
> [37/533]mh@banana:~$
> 
> The first kernel that was ever booted on the device was 4.1, I am
> therefore reasonably sure that the filesystem was also created with a
> recent kernel. Is there any possibility to find out about the kernel
> version that a filesystem was created with?
> 
> However, the FAQ
> https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_Btrfs_claims_I.27m_out_of_space.2C_but_it_looks_like_I_should_have_lots_left.21
> suggests that for small filesystems (<16 GB), the best solution would
> be to upgrade to at least 2.6.37 and recreate the filesystem. 2.6.37
> is ancient, from 2011, so I am pretty sure that the filesystem _was_
> created at least with a kernel more recent than that.

   You missed the most important thing from that paragraph: Use mixed
block groups. That's "mkfs.btrfs --mixed ..." (which I realise is
missing from the text, and I'll be adding it after I send this email).

> My normal way to recover from this situation is to btrfs add a new
> device, btrfs balance, btrfs --convert=single --force balance, btfs
> device remove, btr balance start -mconvert=dup --force and finally
> balance start again.
> 
> Is there any solution to solve this more elegantly?

   Recreate the FS with --mixed, and that should deal with it.

   Hugo.

-- 
Hugo Mills             | There isn't a noun that can't be verbed.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--3MtLaQwm2ZGHj8IC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWWwkeAAoJEFheFHXiqx3kyYYQAJVMyV1sssFyJgv8weL63Lzp
itDRWzttDdxCV1AkI/Vpv3hrIptl8gtKp/chP+X46GP6/GYCSDE+ChJ0SG9aMekz
ho7i7VsIaOjak51tFQ1lbJj0CTXSe9CHQiuS7EHIHuSppFOQfkH1bKis4N6fDOfI
9eQAFI7R2HHyU9QiUVHu7QxsSUoC2zZsrH5B4We31pdBbZA/sVc7enxUL/d7dI8S
R1xqvMhqyutnCgpZnpynzSQCl6bolFxbqCn7VnqZfxHDQMNAnFgXVKkt1hJ6Vts/
n2ksRvYKxmoGdIWJBvt2wAbU+6HpfxvDiKnc5e3OwquQWAhEzKGSRpwvK5sNyCzZ
1h3Y9+Su6v3DjCJ2WTXVpS8xbvIkj7mN/yNG7HltGgEBnIVbuSjXiN7Iy6F1GMld
ZjoEgbkbrmT+GGmFbm3AYsizp+DOSXgLcay6yW39W7x8+QkhUCkfvdd4FYqtO5dG
Jppfr1AzaBHdortDOjOFqfe7HylMKIcg2N6NUaSTICSKzjPMMRIThKM/bwPisdjz
s8SQ4qzJfZdEwy2/kUCV5rHPcSRyLScX8Y5tT4Fzn/8jF3IOftXRCF51S2gpBtkP
tH5oj8tzwY28rSQ2ClKZV7StL4Uu/uu+JWbQq5pTuOkyW8PpcbVB2frsi74H9iAr
AGYu9UL97KLSXDK/t2K8
=OPBn
-----END PGP SIGNATURE-----

--3MtLaQwm2ZGHj8IC--
