Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45088 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab2LROfZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 09:35:25 -0500
Date: Tue, 18 Dec 2012 14:35:21 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Eugene Crosser <crosser@average.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs in the kernel 2.6.31
Message-ID: <20121218143521.GN19051@carfax.org.uk>
References: <50D079AB.2030805@average.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/JIF1IJL1ITjxcV4"
In-Reply-To: <50D079AB.2030805@average.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--/JIF1IJL1ITjxcV4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 18, 2012 at 06:11:55PM +0400, Eugene Crosser wrote:
> I have a board based on PLX7821 aka OX820 ARM SoC. It is not
> supported in the mainline kernel; the vendor supplied the source of
> the kernel 2.6.31 with necessary updates for this platform, and it
> works. I understand that there have been no successful attempts to
> bring support of this platform to newer kernels.

> I would like to use btrfs on this system, but it is labelled
> "experimental" in the kernel. My question is: is it "safe" to use
> btrfs as it is in 2.6.31? In other words, where there "data
> destroying" bugs found and fixed since then? If the answer is yes,
> then is it possible (and how difficult) to compile newer btrfs code
> against this kernel, or backport the fixes?

   2.6.31 is *insanely* old in btrfs terms, and definitely contains
serious filesystem-corrupting bugs that have been fixed since. You
should be looking at running 3.7 (right now) or 3.8-rc1 (when that
comes out next week), from a btrfs point of view. I really wouldn't
recommend running the btrfs code from 2.6.31.

   Backporting current btrfs code to a kernel that old is likely to be
a difficult proposition, simply because other things (in the VFS and
block layers) will have changed underneath it. Similarly, if the
patches for your board haven't been updated as the kernel progressed,
you're going to have a hard time forward-porting them. Given the
option of where to put in the work, I'd recommend forward-porting the
hardware support to a more recent kernel, and getting that pushed to
mainline, as it's more likely to be useful in the future, and useful
to more people.

   Hugo.


-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Our so-called leaders speak/with words they try to jail ya/ ---   
        They subjugate the meek/but it's the rhetoric of failure.        
                                                                         

--/JIF1IJL1ITjxcV4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUNB/Kb9z9OVl50rAAQJGRw/+OF/DFe+M9M2aierLK/9Wd+HiZBJQV+5k
9/hwqzyB06YwcOIhic1Ds8Q5u2P+KJVfwDWbFi/1S3GivdW0tt+iv/x9HPm2zHXe
z3HzedkekbY7RD8G0XoaO3eWcolh2RZDrO3zj1Hz7aWedLydy4XoZ8bs+yLF1KvO
EZIUqURubqdFnoZH8S9lXs3nALRORGCHpvCW6ZI+55+9jI83Hv0w/TlBLjj0kQMm
NVikFZThsY8/qSvjmKAqWDWTwrJ/ie0jbhdequpCLLdEHlyX6DSc3nhGOUzAq7qW
0iNy2zvo8BzcRTdWSoDD0PP22CQlj01OqRridkrXfiX+15jnQm0VaFU3NdlBk/Te
K3QC3hyEgSwmdn0QN7Gqg0KImBsoM5NYIr2qwHyEZaWEF7f/lgkpd/V4xc0EAE3p
Wq4nGW3QMfnKfbZ9RZR4AvOUNuhSRE9abhWYz3tBo6SHe0XAzOCCgxhGKyYd+ybt
3C0pkdzYm9IiLYSQp5LLs2gBaCfFZBOu361bAlTpOxDgRoERtw9GRamGNNRF130W
SEp7BgC6uwbAuw6UMU8aQUYUROWo/eQHUnQQfPGm/nNyQnvEbcs4SOCED+zwKPrd
GKm71ES0Fknh8qw/uZkMc3KBSanKuRU8X520cwlfBZUBlgpdpHsTPfJ6nu/AQ9Zy
UB7/zkTrE9c=
=mH/o
-----END PGP SIGNATURE-----

--/JIF1IJL1ITjxcV4--
