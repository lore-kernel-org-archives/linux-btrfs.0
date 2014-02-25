Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47422 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbaBYUTt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 15:19:49 -0500
Date: Tue, 25 Feb 2014 20:19:21 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Jim Salter <jim@jrs-s.net>
Cc: Marcus Sundman <sundman@iki.fi>, linux-btrfs@vger.kernel.org
Subject: Re: No space left on device (again)
Message-ID: <20140225201921.GB13899@carfax.org.uk>
References: <530CC9B0.1080703@iki.fi>
 <530CDB7F.9020807@jrs-s.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
In-Reply-To: <530CDB7F.9020807@jrs-s.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 25, 2014 at 01:05:51PM -0500, Jim Salter wrote:
> 370GB of 410GB used isn't really "fine", it's over 90% usage.
> 
> That said, I'd be interested to know why btrfs fi show /dev/sda3
> shows 412.54G used, but btrfs fi df /home shows 379G used...

   This is an FAQ...

   btrfs fi show tells you how much is allocated out of the available
pool on each disk. btrfs fi df then shows how much of that allocated
space (in each category) is used.

   The problem here is also in the FAQ: the metadata is close to full
-- typically something like 500-750 MiB of headroom is needed in
metadata. The FS can't allocate more metadata because it's allocated
everything already (total=used in btrfs fi show), so the solution is
to do a filtered balance:

btrfs balance start -dusage=5 /mountpoint

   Hugo.

> 
> On 02/25/2014 11:49 AM, Marcus Sundman wrote:
> >Hi
> >
> >I get "No space left on device" and it is unclear why:
> >
> >># df -h|grep sda3
> >>/dev/sda3       413G  368G   45G  90% /home
> >># btrfs filesystem show /dev/sda3
> >>Label: 'home'  uuid: 46279061-51f4-40c2-afd0-61d6faab7f60
> >>    Total devices 1 FS bytes used 371.11GB
> >>    devid    1 size 412.54GB used 412.54GB path /dev/sda3
> >>
> >>Btrfs v0.20-rc1
> >># btrfs filesystem df /home
> >>Data: total=410.52GB, used=369.61GB
> >>System: total=4.00MB, used=64.00KB
> >>Metadata: total=2.01GB, used=1.50GB
> >>#
> >
> >So, 'data' and 'metadata' seem to be fine(?), but 'system' is a
> >bit low. Is that it? If so, can I do something about it? Or should
> >I look somewhere else?
> >
> >I really wish I could get a warning before running out of disk
> >space, instead of everything breaking suddenly when there seems to
> >be lots and lots of space left.
> >
> >- Marcus
> >

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Jazz is the sort of music where no-one plays anything the ---    
                             same way once.                              

--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUwz6yVheFHXiqx3kAQLTXhAAhh+Wtok3YILBfg6fLWn1nbgBrFk87b7w
v+zfsUSFCZTyR6NGJUQ2Ca9b2QcEuwypHnAX1mjKomxkn+QCKuWEACE8Zb282B7R
hIQY4idHKWr83UWDoDySj2cd1iunmkvyEYR9eTYzJYNCcSKkuidXg9lc67G/pJO2
9BmsDnX1iF/2k7sICPjt7dAwTzKryNzCSuE5dxVC9IPq9PlvuSxdsZYe5yBZIHPB
uRGs/N06qeyDBN9YQgWSn8eKfvp263wZsyDAgRRl4ZYdjt4GI74DiMvUdHjkZWXp
Q2dkTRF9o88NTLwXgL+zOcJ+ZoKfwTLZLlnN9HuvOaSaIFr/7uP4b72aAu0sW4E7
X/72pmM2833zKbTenJ52nU4IV0OoKuFptTvSjEwMZfdFyyiDYmZFfDI6JeWg6vA1
uOIkmAzenPfEetwV+zD7eWzsnVO3wltQ1Q2W8aQqNErvTpRqBtI6vEGJu0fSZXgm
7JU6qjdp+7fuiSDInMXNE7vm+zIUQOVy/CqDqdbGcPnr/2jsegMEUYOBCFDV1clZ
Ok3gY8PCH5SuTxLG/X+fZBjpzrMLvpep+I7J1tRKJ/XkIIMemwcIN7qGF7JigKGA
cJyfmD0rgNojiQ8HvRb4BDJtdJ2tO/u5IJ5cBog6ugR7v75d7TgT/g7GlDdqTw+g
UTs7yTqGymQ=
=TQ+/
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--
