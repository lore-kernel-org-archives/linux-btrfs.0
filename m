Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41824 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbbJNJPs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 05:15:48 -0400
Date: Wed, 14 Oct 2015 09:15:47 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: EJ Parker <ejparker12@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can't mount btrfs: corrupt leaf, slot offset bad
Message-ID: <20151014091547.GM25907@carfax.org.uk>
References: <CAMVDA=xRykyzftfXckGZGOfqnYr8XyyxvjoqKcwQwa0eKku_LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="F4Nz7zOi0wR5AkzI"
In-Reply-To: <CAMVDA=xRykyzftfXckGZGOfqnYr8XyyxvjoqKcwQwa0eKku_LQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--F4Nz7zOi0wR5AkzI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 13, 2015 at 06:25:54PM -0500, EJ Parker wrote:
> I rebooted my server last night and discovered that my btrfs
> filesystem (3 disk raid1) would not mount anymore. After doing some
> research and getting nowhere I went to IRC and user darkling asked me
> a few questions and asked for output of btrfs-debug-tree and
> ultimately sent me here saying I should include a handful of things:
> 
> Before I go further, let's get required info out of the way:
> 
> uname -a:
>         Linux archhost1 4.2.3-1-ARCH #1 SMP PREEMPT Sat Oct 3 18:52:50
> CEST 2015 x86_64 GNU/Linux
> btrfs --version:
>         btrfs-progs v4.2.1
> output from "btrfs fi show":
>     Label: none  uuid: 5470630f-39f4-4d39-90a2-277d7991722a
>         Total devices 3 FS bytes used 3.10TiB
>         devid    1 size 3.64TiB used 2.12TiB path /dev/sdd
>         devid    2 size 3.64TiB used 2.12TiB path /dev/sde
>         devid    3 size 3.64TiB used 2.12TiB path /dev/sdc
> 
> First, I am able to mount with -o ro,recovery, but not with just -o
> recovery. When I attempt to mount w/o ro, I get this in dmesg:
[snip]
> darklink also mentioned that btrfs-zero-log might help too, but that I
> should get confirmation from one of the devs on that.

   I suggested the zero-log might work because the FS is mountable
with -o ro, but not without, which suggests a corrupt log. However,
it's not obvious to me what tree the corruption is in, and whether
zeroing the log might actually hurt the recovery process.

   Hugo.

-- 
Hugo Mills             | There's an infinite number of monkeys outside who
hugo@... carfax.org.uk | want to talk to us about this new script for Hamlet
http://carfax.org.uk/  | they've worked out!
PGP: E2AB1DE4          |                                           Arthur Dent

--F4Nz7zOi0wR5AkzI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWHh1DAAoJEFheFHXiqx3kKuwP/RAYck656Gdm/lzPbH8nl5Cx
V6GOjJg3LDH/EEcJSyIPVhDwCZexu2il83uw75EFg6lva0FZmS8PTdzX04Z0iPKu
pK8F3w/yfG3wFvJsCrVJTH1q8yU/JylABso6JHbYME+wPDydiRCYqne+Am/KNmKD
yw/yyO6SRZslF1bqLUBU1ljjHX1D95HOSRkbOOaW4oesIABEWqpj0x3H+mKnKZwQ
BzFwDSHZEaoNZyNIwEXMOJiOUao2uolVEudTCEvGiz7y4u0SqHz6QtajvIwx9gwz
rK0sCoPnsF6F40c2RQ+9PFwKQ92dWNQWzW60mcyXlTsDILm5c+6Hzev+4pOXdrz5
5kwYlUgZm+iTzzpBFkHGaoh82UaYp7XQD9V9rbzlR2MZTFCBQ5SiM8xWey6t8HyA
PfYPacxsEwIIv0GGkvXY2PZ9++jh4YddV08+IUHcL3G43IY7nVdaK5H20A1trBSC
Zf9Y8v18/+/Af410ivFGbpWOV5hB+drAjrIlcsBBFub+LYiGbL41aHT1wDsyr1U4
laJ1fI7hbQNcfqaBmHIPp2pfNstoOfGRwB+6f48h0jezHBOzOtPj0j2Bdbe16w/J
fpieqjPxLRITBlVurXRPjDA+kBuTnqrJyhsApEJQKRKNzqrPl7Qsa+XGqxK9iD5J
lrox/jViLP+olKZqoOBa
=0SWT
-----END PGP SIGNATURE-----

--F4Nz7zOi0wR5AkzI--
