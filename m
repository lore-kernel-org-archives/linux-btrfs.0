From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: data integrity in btrfs
Date: Fri, 30 Dec 2011 13:38:26 +0000
Message-ID: <20111230133826.GA2509@carfax.org.uk>
References: <135528.24428.61333-23184-1070446607-1325251786@email.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Cc: linux-btrfs@vger.kernel.org
To: Jaromir Zdrazil <jaromir.zdrazil@email.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <135528.24428.61333-23184-1070446607-1325251786@email.cz>
List-ID: <linux-btrfs.vger.kernel.org>


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 30, 2011 at 02:29:46PM +0100, Jaromir Zdrazil wrote:
> Hi again,
> 
>    I know that ZFS include data integrity verification against data corruption modes using propably SHA256.
> 
>    By sketchy readings at https://btrfs.wiki.kernel.org/index.html , http://en.wikipedia.org/wiki/Btrfs and other sources I have found just that there is Sha32C used and that it should be similar to ZFS.
> 
>    How are data faults detected and repaired ni BRTFS? If the answer could be simple and precize, I would be more than happy.
> 
> Thank you! Gone to lunch ;O)

   Every 4k block in btrfs is checksummed (using CRC32, so it's not
cryptographically robust against malicious modification, but should
spot most random errors).

   If you use RAID-1 or RAID-10 storage, then you get two copies of
each piece of data, stored on different devices. Each copy is
independently checksummed. When data is read, the checksum is verified
as well, and a failed checksum is logged to syslog. In this case, the
filesystem will attempt to read the other copy. If both copies are
bad, an I/O error is returned; if one of the copies is good, that data
is returned.

   With recent kernels and an up-to-date userspace, there is a feature
called scrub which will read both copies of all of the data blocks in
the filesystem and compare them to each other. If there is a mismatch
with a failed checksum, scrub will rewrite the broken block to fix it.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- "Are you the man who rules the Universe?" "Well,  I ---       
                              try not to."                               

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFO/b7SIKyzvlFcI40RAvu8AJwMAPKsecHzJZlGSBK28QUN0+KHfACeNMRK
lERNo0wUdD66NKHoI+Ngx0w=
=/SB6
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
