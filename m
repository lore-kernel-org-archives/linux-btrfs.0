Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43847 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaBJNsM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 08:48:12 -0500
Date: Mon, 10 Feb 2014 13:47:48 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Frank Kingswood <frank@kingswood-consulting.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send runs out of memory and file handles
Message-ID: <20140210134748.GI6490@carfax.org.uk>
References: <52F8D406.7000207@kingswood-consulting.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WR+jf/RUebEcofwt"
In-Reply-To: <52F8D406.7000207@kingswood-consulting.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--WR+jf/RUebEcofwt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 10, 2014 at 01:28:38PM +0000, Frank Kingswood wrote:
> Hi,
> 
> I'm attempting to back up a btrfs subvolume with
> 
>   $ btrfs send /path/to/subvol | nc
> 
> and the receiving end does
> 
>   $ nc -l | btrfs receive /path/to/volume
> 
> This subvolume holds ~250 GB of data, about half full, and uses RAID1.
> 
> Doing so runs out of file descriptors on the sending machine (having
> over 100k files open) and eventually runs out of memory and gets
> killed by the OOM killer.

   This sounds like a known bug, and I think it was fixed in 3.13.
What kernel version are you using?

   Hugo.

> What are the memory requirements of btrfs send?
> This is the initial send so the entire volume must be transferred.
> Are later send operations equally memory-intensive?
> 
> Is it possible to do an incremental send, or send partial snapshots
> and combine them later on?

   

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Everything simple is false. Everything which is ---         
                          complex is unusable.                           

--WR+jf/RUebEcofwt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUvjYhFheFHXiqx3kAQIo7RAAmvVxbZfnWdcdlqKBJv2swEQgsVDvZVmS
dQFHJqGeaVta/E/4rtUzB01NvCCmTnF/E73KokQku4Um6++LfnInBLDzp5agv3lc
r3W5V73NqTUF7AzF/jqML9zGfrWuz/PwDo8UPDyUye5iy7XJA3XUCpKwSExmNPo/
uJZYoWAUSXI2kEh/dV3PT6k7wdgucfYJbRSdUl0VbqZebggrn5f/9RpFDxSbFMvI
tpoWtJNomIz0xO/7+JkL7sF6UH9qOlqpILKLsTtEDUM8JYqgXXXrJIGJj+oJgXg5
qPVI3hGd8ffGEtQWXU/xft6PoH4YQ6o3RJtLUHuuYHKexAKFAjgw7k41ozb/QUfd
Aq/GlqGdseYBYauJDuqY/tZKu1udqd6ZfwpPmVeO2tvkHfkjq4iapYrpWMRpjYmu
f/Z94gByuOtpcZlnZqd5POLPSp9WwiI1IOyJZzV+ZL7ea+maW1aPrZM87rFoXMDc
EKsZA4SwhitGmESD5KFcQsTMd1BNydi2W5yY1G6dUULtOIkQTwCcMZsob7QNijAW
INc6Yn/Hi/PBQJsJqNHN3HtZVhGGezGxFp3tkYfz0DC0+aJ5OUyLX5uNnDfSEfgi
khJUs40LE+qlyjTmY+0krKzvg3q2scqp5Ucg6NZTqEP13otxN9fFCIqO9agoTOeb
5Dwd84HrkN8=
=MzKw
-----END PGP SIGNATURE-----

--WR+jf/RUebEcofwt--
