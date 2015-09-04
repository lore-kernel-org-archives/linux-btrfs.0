Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36478 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932856AbbIDVSB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Sep 2015 17:18:01 -0400
Date: Fri, 4 Sep 2015 21:17:38 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Ivan <ivan@ipplus.rs>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: unable to mount multi disk volume with recovery mode
Message-ID: <20150904211738.GB23944@carfax.org.uk>
References: <loom.20150904T230705-944@post.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xo44VMWPx7vlQ2+2"
In-Reply-To: <loom.20150904T230705-944@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--xo44VMWPx7vlQ2+2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 04, 2015 at 09:07:34PM +0000, Ivan wrote:
> 
> Just to add this:
> 
> ivan@ipplus-dev:~$ sudo btrfs filesystem df /mnt/ambis/
> Data, single: total=108.76GiB, used=107.11GiB
> System, single: total=32.00MiB, used=20.00KiB
> Metadata, single: total=3.00GiB, used=2.34GiB
> ivan@ipplus-dev:~$ 

   (If you can't mount the FS, how did you get this output? -- In what
I say below, I'm asuming that this was the last output from btrfs fi
df on the broken filesystem before it broke).

   This is the problem: You're using single for everything. That means
that with the loss of one device, approximately one part in three of
your filesystem is missing, including the metadata. If the missing
drive is truly broken, this filesystem is dead, without any good means
of recovery. You'll need to use your backups.

   You would have to have RAID-1 system and metadata for the FS to be
even partly recoverable with a missing device. (Or RAID-10, -5 or -6).

   Hugo.

-- 
Hugo Mills             | "There's more than one way to do it" is not a
hugo@... carfax.org.uk | commandment. It is a dire warning.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--xo44VMWPx7vlQ2+2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV6gpyAAoJEFheFHXiqx3k8NwP/RuuI5ghTUevkPrLPNimbIPc
mCTqdiTskCtgbaU0pY/Ss3Zw5kpIZQ3iN0orxMXrYZW4JQbmNw9nx5dfRBb+iBi9
xc0nSEtQNXWn/P+88Ar7OIVOP/AGoCbXdPw5nbsWaJkQNzxyuBJZrwpJFQ8N+m9+
jVm0WJWMDVAmz+Q9UqbWvlJxCvYsSmqwok+uX8+hNQrO5Q3zj2tlltrKyhEf9Jcn
DCmIEe4g0MRnGRoDyAwE1unXEO80/AhTUNqgBm2WUb6lILZqkLyqoWNtFk4OIQRy
c+rfyZcHyKuBtRh5JvXqst98NQPdshpWNIlpeL9A1O6HLRMtfL845Jilrq2BUTTu
tHM+hwlcBDjL9xOJ6vR+yxEit3TMYnq/RrySQVe+nApmbQIMH74qimQVVan+Ef0n
poWwP7STwskz8i36rE6EPjbBG1vIK3RwR4FI3TS5p8bIdxLm8LwIYuRnQnyqgfR9
CN7TUvt5n2EW2G6I77aSJFgNHlk5ntIM9kLdWTL0othr57LSi48Wfdg1MbVAqTGF
KgkCo10bhQ2KT837mn5R85o7CATtFupUb6xvsldogCbA1euPHwp4aRI4LZFglnnY
Oq0ILqLIZmhgpoj8KI4kmJxg+71YE7Itbuue7QRihL6xHb1C+1Rf52c1BoaHAiMA
H6phlDf9bvRm9I9CmF41
=3G/p
-----END PGP SIGNATURE-----

--xo44VMWPx7vlQ2+2--
