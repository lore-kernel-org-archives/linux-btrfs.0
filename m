Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45340 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbbDAPmE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 11:42:04 -0400
Date: Wed, 1 Apr 2015 15:42:02 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Andy Smith <andy@strugglers.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is this normal? Should I use scrub?
Message-ID: <20150401154202.GD32078@carfax.org.uk>
References: <20150401151114.GR4327@bitfolk.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7DO5AaGCk89r4vaK"
In-Reply-To: <20150401151114.GR4327@bitfolk.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7DO5AaGCk89r4vaK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi, Andy,

On Wed, Apr 01, 2015 at 03:11:14PM +0000, Andy Smith wrote:
> I have a 6 device RAID-1 filesystem:

[snip tale of a filesystem with out of data data on one copy of the RAID]

> I have now got a new enclosure and put this system back together
> with all six devices. I was not expecting this filesystem to mount
> without assistance on boot because of /dev/sdk being "stale"
> compared to the other devices. I suppose this incorrect view is a
> holdover from my experience with mdadm.
> 
> Anyway, I booted it and /srv/tank was mounted automatically with all
> six devices.  I got a bunch of these messages as soon as it was
> mounted:
> 
>     http://pastie.org/private/2ghahjwtzlcm6hwp66hkg
> 
> There's lots more of it but it's all like that. That paste is from
> the end of the log and there haven't been any more such message
> since, so that's about 20 minutes (the times are in GMT).
> 
> Is that normal output indicating that btrfs is repairing the
> "staleness" of sdk from the other copy?

   Yes, exactly. That output you pasted looks pretty much exactly like
what I'd expect to see in the situation described above. You might
also expect to see some checksum errors corrected in the data, as well
as the metadata messages you're getting.

> I seem to be able to use the filesystem and a cursory inspection
> isn't turning up anything that I can't read or that seems
> corrupted. I will now run checksums against my last good backup.
> 
> Should I run a scrub as well?

   Yes. The output you've had so far will be just the pieces that the
FS has tried to read, and where, as a result, it's been able to detect
the out-of-date data. A scrub will check and fix everything.

   Hugo.

-- 
Hugo Mills             | My karma has run over my dogma.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: 65E74AC0          |

--7DO5AaGCk89r4vaK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVHBHJAAoJEFheFHXiqx3klJ4P/iwuiXnsWM+4S568jf7XqqZe
iEqQTp7n8Vlh3DerW6riIW+DoBfhBe7r1wNUkV5lu2VohSVuOEUIa9U1FKr+TxIj
FS2oFIz7Y0Y+KhImpj6Ow8qy+ew4N/EghMzu3l/W48DFarkgG1byVSBeDJ2/fjvb
+jyEqcV6NNS+VgrCoyiTa8R4TjAIfnO1M1XaZPjxqo3ZIAEk8EbwzRIc7y8yQYJN
ubd0V+WKDlyt/IsjVxqTs+x//1lY5QwGJO3iLk7nNt6PKUZW/pNSOSql7ojYCJyD
y5YFr9bNRU8Lknj7UFWapnKfNRkhTS+0uUWfKpGmXAFQA9Uqyu00LUxwdxrVdV7X
HujHA/UNzbSVvM3NuJA0e8W/etWpdG29G/aqxUIS3fGXtC1CwD5JftQtcKV9fHnW
gBziWPxuaIY33fD4kcV+NZ0tIdUf72jMrd2YGZRD9/ECcAWueFdbDDIvWd3DfZgZ
23Mgc2lRjdFNOODQ5OvynasZbn6PF/xodZIhB9UVPAxBFCxkSTg3EOvc7whV//hY
hU9UapwtdcPIArE91RvCHQlh8lPyJ/b0o0BHjUIlq36kGF1v3YoIRl9OpW2nh1gM
+kDlo16LIsHyvvr2KGgRIWZDvt8buDZnYEJbmxsv/ti5eGl9zZzKWwcYJ0eVGLRI
TM6hAKkyyJXJKd2dhKM7
=i4nk
-----END PGP SIGNATURE-----

--7DO5AaGCk89r4vaK--
