Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33980 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598AbbEVWWR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 May 2015 18:22:17 -0400
Date: Fri, 22 May 2015 22:22:16 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Arnaud Kapp <kapp.arno@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Removing a device from a metadata raid1 - data raid0
Message-ID: <20150522222216.GH25778@carfax.org.uk>
References: <CAOQP4cGzX6knmXjaYcO=JB=VycidG7LS0GWA+N2x+f680ATGnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHbokkKX1kTiQeDC"
In-Reply-To: <CAOQP4cGzX6knmXjaYcO=JB=VycidG7LS0GWA+N2x+f680ATGnA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--xHbokkKX1kTiQeDC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 23, 2015 at 12:15:13AM +0200, Arnaud Kapp wrote:
> Hello,
> 
> I've setup a filesystem with 2 devices. The metadata are in raid1.
> Data is in raid0.
> 
> I wish to remove one of this device from the filesystem (to use for an
> unrelated purpose) but I am not able to do so.
> It *seems* that attempting to balance metadata to dup is not allowed
> (btrfs -mconvert=dup) because they currently are raid1.
> The metadata in raid1 prevents me from removing the device because the
> filesystem can't go below one device in raid1.
> 
> Could someone please advise me about my options here?

   The RAID-0 data is also going to be a problem here. You'll have to
convert that to single, because RAID-0 requires a minimum of two
devices.

   For the metadata, one approach is to convert to single, delete the
device, then convert to DUP. That at least will work, if be a little
risky.

   IMO, we should definitely support conversion to DUP, and prevent
the automatic "upgrade" to RAID-1, but I think we don't at the moment.

   Hugo.

-- 
Hugo Mills             | Two things came out of Berkeley in the 1960s: LSD
hugo@... carfax.org.uk | and Unix. This is not a coincidence.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--xHbokkKX1kTiQeDC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVX6wYAAoJEFheFHXiqx3kkxYQAJoSdjcKJiDcvnNLnizwlRM8
fc7C0O+Kn7TjM7YA1KqESuldu5nHFZdEuqS5/dAiPiRyIt9aTOUEkRsFweu/IeCg
+DaidZ/WzoV0ZVhyw8gEoGpDR4Np8yncIdhX4heUqH/CGz5NmGbtdYVdw/pZrXpq
S34I49X+27KcHS1OEITuK/2HbOuSej0Os2tTkdJqLgTH0dAxsGQ8AzZZICTeUMt1
yfTNycrk7OZitF0tXQl9VbVgQn4wlEcK0lyfEcmhyZNPUHv9eVkuGUMiQixDWHlb
xrUImg2DGKqF/zWTIrP8vtvrQklxiCS/4jnRzbzQPDJmymYJwxwIfWDC6AfI6uBR
2jhMNjeSrAr5ReSGlykcxHG07hm2YMt/sZ2nyyFB7c78DHspWdwbA09gXzfoSnGx
g5XQipDUrGyFl+HzUsDFZIgb7yt6vsRcCO9Lrhb34+0HpzyJTL8lrous0M1kP1eE
W70ArS0k0uDvOs4bnCFWPvqINnN53xuAKaXRsILBLICBQHu9l16ZSM2xkbUihRWw
6qbgD9BBNU7Y/ak2XjvB/G9QxXVuKuTQ5ay1dy9vkymFASMWvwSrCGynj2oyHDiu
RQLbhbTHSC5lYymMZUZNf94myXwsCVXI7M7JZPjCnSf6Q/JgHGp0+vCH+5Sg+mkH
U545zIztxwjqMY8eXX8c
=ZEkG
-----END PGP SIGNATURE-----

--xHbokkKX1kTiQeDC--
