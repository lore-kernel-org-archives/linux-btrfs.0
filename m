Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54257 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754732AbcJUWH3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Oct 2016 18:07:29 -0400
Date: Fri, 21 Oct 2016 22:07:26 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Gareth Pye <gareth@cerberos.id.au>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Drive Replacement
Message-ID: <20161021220726.GC16645@carfax.org.uk>
References: <CA+WRLO-XY2aai7z8436yna14cjbRsPrWgHwxbcf5Kq_-7RENCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lMM8JwqTlfDpEaS6"
In-Reply-To: <CA+WRLO-XY2aai7z8436yna14cjbRsPrWgHwxbcf5Kq_-7RENCQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--lMM8JwqTlfDpEaS6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 22, 2016 at 09:03:16AM +1100, Gareth Pye wrote:
> I've got a BTRFS array that is of mixed size disks:
> 2x750G
> 3x1.5T
> 3x3T
> And it's getting fuller than I'd like. The problem is that adding
> disks is harder than one would like as the computer only has 8 sata
> ports. Is it viable to do the following to upgrade one of the disks?
> 
> A) Take array offline
> B) DD the contents of one of the 750G drives to a new 3T drive
> C) Remove the 750G from the system
> D) btrfs scan
> E) Mount array
> F) Run a balance
> 
> I know that not physically removing the old copy of the drive will
> cause massive issues, but if I do that everything should be fine
> right?

   Yes. The one thing missing here is running 

# btrfs dev resize <devid>:max /mountpoint

on the new device between steps E and F to allow the FS to use the
full amount of the device. Otherwise, it'll still be the same size as
the original.

   Hugo.

-- 
Hugo Mills             | Great films about cricket: Batsman Begins
hugo@... carfax.org.uk | starring Christian Bail
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--lMM8JwqTlfDpEaS6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJYCpGeAAoJEFheFHXiqx3kOLcQAKL8FL+3xIoYLiRdiauHBomi
m/V1OWBM3/L2IMz0FEuAMd9WNqtMFB0AvXLIL6HUkwuM7x7L8JzuyOfn22d3mwsx
fNuRrcbIG9H916CD6XBqr7x/vGFRscPtFvbUErxXZ0KoLWCWo7kzRNXnr3ELU/8J
k+DiDse0OIJiK66UzBVHavqdVeWwzjxCwY0UKGC6+jK18OsZE3E0YPsC+Qpl+fGo
IYQdNSQ/TbePNhx2yVLdWQtcqOWgz4oh8wv0wSQqFNcMB5AU1zSOtGtC5hQsz5U+
PwOOTpRjQRWeqtwro1CY0TVsdWyWQay8BNTYa5Z4d4raDcj/NecxPLEDDeE6/+bg
zKzlqfV88l2fQKn5iRd4yHL1VaFKOKIwcXeOZ8W+wO00qs16egayqZtgBOrgNJPv
1ilVL6PnLJdYU3qfiqI1UotDW1MXoHyMu4IzFGG6j4tjsDFoHFV+G8xv2oHlDhoo
nSByMCoIaV+xXidzworFJ295zYZ/cE2glw78SsdPQJk6aLVnCY9Khu2GTK4Ly3hx
vBxZFhxdEQRPS8LSU2KO/Ztrozb+3uJSps1jgthY34ka2D6RdaOZg5PuzkmMIyZ2
BJFSi+LOuTDg6h91UNw/NS+KiYWU28Kd6LVtPTByAapRRv7psZWKcXjlr0f3s8TS
wQwolpX0sXrq7wyaRBoR
=4+dF
-----END PGP SIGNATURE-----

--lMM8JwqTlfDpEaS6--
