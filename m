Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35863 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab3KNVA6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 16:00:58 -0500
Date: Thu, 14 Nov 2013 21:00:56 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Leonidas Spyropoulos <artafinde@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: "No space left on device"
Message-ID: <20131114210056.GN4315@carfax.org.uk>
References: <ecb3dcc9-c636-4fa7-b41f-e9021411a09a@email.android.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="37nyS7qXrnu4wN2o"
In-Reply-To: <ecb3dcc9-c636-4fa7-b41f-e9021411a09a@email.android.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--37nyS7qXrnu4wN2o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 14, 2013 at 07:54:21PM +0000, Leonidas Spyropoulos wrote:
> Hello,
> 
> I've been following this list for years and I see during various situations
> this message coming up. Some times it's a genuine problem that there is
> actually not enough space. In other cases it's some by-product of something
> else. I have seen this error personality on a broken system ( which I never
> figured out what had happened).
> I know this is still experimental but I just want to make sure my
> expectations are not really out on sync with the others.
> 
> As an end user when I see an error like this the first thing I will do is
> check the space (using 'df' command) [1]. If I see more that 7% I usually
> think it's OK, (depends on the size of partition as well).

   The problem is that there's two kinds of space (data and metadata),
and either could run out. The FS won't, currently, attempt to
reallocate between one and the other -- hence the recommendation for a
filtered balance to fix it (one of the side-effects of a balance is to
be able to free up unused or little-used chunks of allocation).

> - Is this unreasonable in btrfs filesystem? Is there a formula to calculate
> how much space btrfs _might_ need?

   Not really. I'd expect to need something in the range 250-1500 GiB
of headroom, depending on the size of the filesystem (and on the size
of the metadata).

> - It's probably not your job but can df reports correct sizes for btrfs?
> I've seen some threads on trying to show the actual space occupied by data
> and/or metadata with btrfs command. Can we expect this someone to be
> incorporated into df command?

   Sadly, no. The POSIX API for df doesn't contain enough information
to give an accurate representation of the space on the FS.

> - In cases that btrfs reports this error but there's something else that's
> causing it, can we expect better error handling from btrfs so the end user
> is pointed to the correct direction?

   Again, we're constrained by the POSIX API here -- we only have
ENOSPC to represent the error condition. I suspect the best we could
do (possibly) is print something in dmesg, where users don't tend to
look anyway.

   There's a future project on the books to make the FS attempt to
recover unused or little-used chunks, which should reduce the odds of
the ENOSPC showing up in an "unexpected" way (i.e. running out of
metadata).

   Hugo.

> [1]: one could argue that an end user should use the btrfs commands instead
> but let's leave that for now.
> 
> Apologies if these have already been answered or are already on roadmap.
> 
> Thanks in advanced, your comments are appreciated.
> 
> Kind regards,
> Leonidas
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                 --- emacs: Eats Memory and Crashes. ---                 

--37nyS7qXrnu4wN2o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUoU6CFheFHXiqx3kAQKCIQ/5ATH+Y9hU+1K1Y98V/to55w7LajTmdB0B
y5iAdhhBHQimvzyOICzGRKZDYMW3uZ9atJGnJMhO4JOik7C3jO4CrhqL7vtY/UWp
4eovJy3Njku1jmCzOtVrwIZiHGn4SKUnYVTHwqhsEmVdhnbMQV9/qoLzTRxKnw7y
sIs5mCkh0qZQkUD9cagRztl/Y4ZaOgZqHr7LKiUMwGPzLZ4uZDlHF4k+/xUx61rt
enr8Uskf5zfGzs4v/2eyULtera8Z/GY8vutvVKNlCr3PeZiYkncDlKIA49kNmRUV
8x27nbuix204o2AZDg2s6AwgFqSiNFX/Qju+Qg1XI3s7sSN8YL9HNfw8P4GDrnJm
9gJ39NelYFm48vNXg9uWDci66fkvkbB4cdyKhi5BYp/VqhQtNe3jb2UUqRl4aS9f
lc6vIkvcWBZt6Ywz8+9/iwcpUffig/BHXrmrBWGddsre8fWCcptu2vHJ3485xxmG
WVpC06L9YHMD5NqkesT2YgvqKpsz5JmtzyG2sapO3tBIgpCzTTbOY469Nep/n+rc
iVtG97aayVyPHQDCW7VLNnSoclr45cWHvXwolgqZ0Nxez7E4woDd5zay7cl1phlR
fI7/f3WTQC8AljmvWKBjpWmxBl2s8v996jnuBqIwaFsXd3Cuny3kdOX3wbNrOBld
UntSZ0rmj4s=
=zgzp
-----END PGP SIGNATURE-----

--37nyS7qXrnu4wN2o--
