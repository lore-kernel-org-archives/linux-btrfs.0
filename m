Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54813 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbaHKPhN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 11:37:13 -0400
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.80)
	(envelope-from <hrm@carfax.org.uk>)
	id 1XGref-0004hf-3W
	for linux-btrfs@vger.kernel.org; Mon, 11 Aug 2014 15:37:11 +0000
Received: from hrm by ruthven.carfax.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <hrm@carfax.org.uk>)
	id 1XGree-0000DJ-Mb
	for linux-btrfs@vger.kernel.org; Mon, 11 Aug 2014 16:37:00 +0100
Date: Mon, 11 Aug 2014 16:37:00 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Subject: Re: File system stuck in scrub
Message-ID: <20140811153700.GE11049@carfax.org.uk>
References: <87mwbbnjpt.fsf@vostro.rath.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HeFlAV5LIbMFYYuh"
In-Reply-To: <87mwbbnjpt.fsf@vostro.rath.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--HeFlAV5LIbMFYYuh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 11, 2014 at 08:12:46AM -0700, Nikolaus Rath wrote:
> I started a scrub of one of my btrfs filesystem and then had to restart
> the system. `systemctl restart` seemed to terminate all processes, but
> then got stuck at the end. The disk activity led was still flashing
> rapidly at that point, so I assume that the active scrub was preventing
> the reboot (is that a bug or a feature?).

   Shouldn't have stopped it.

> In any case, I could not wait for that so I power cycled. But now my
> file system seems to be stuck in a scrub that can neither be completed
> nor cancelled:
> 
> $ sudo btrfs scrub status /home/nikratio/
> scrub status for 8742472d-a9b0-4ab6-b67a-5d21f14f7a38
>         scrub started at Sun Aug 10 18:36:43 2014, running for 1562 seconds
>         total bytes scrubbed: 209.97GiB with 0 errors
> 
> $ date
> Sun Aug 10 22:00:44 PDT 2014
> 
> $ sudo btrfs scrub cancel /home/nikratio/
> ERROR: scrub cancel failed on /home/nikratio/: not running
> 
> $ sudo btrfs scrub start /home/nikratio/
> ERROR: scrub is already running.
> To cancel use 'btrfs scrub cancel /home/nikratio/'.
> To see the status use 'btrfs scrub status [-d] /home/nikratio/'.
> 
> Note that the scrub was started more than 3 hours ago, but claims to
> have been running for only 1562 seconds.

   This is a regrettably common problem -- fortunately with a simple
solution. The userspace scrub monitor died in the reboot, leaving the
status file present. If you delete the status file, which is in
/var/lib/btrfs/, that should allow you to start a new scrub.

> I then figured that maybe I need to run btrfsck. This gave the following
> output:
> 
> checking extents
> checking free space cache
> checking fs roots
> root 5 inode 3149791 errors 400, nbytes wrong
> root 5 inode 3150233 errors 400, nbytes wrong
> root 5 inode 3150238 errors 400, nbytes wrong
> [102 similar lines]
> Checking filesystem on /dev/mapper/vg0-nikratio_crypt
> UUID: 8742472d-a9b0-4ab6-b67a-5d21f14f7a38
> free space inode generation (0) did not match free space cache generation (161262)
[snip]
> found 216444746042 bytes used err is 1
> total csum bytes: 383160676
> total tree bytes: 875753472
> total fs tree bytes: 284246016
> total extent tree bytes: 69320704
> btree space waste bytes: 205021777
> file data blocks allocated: 3701556121600
>  referenced 388107321344
> Btrfs v3.14.1
> 
> So nothing about the scrub, but apparently some other errors.

   The free space inode generation errors are harmless. The wrong
nbytes is probably not horrifically damaging, but I don't know so much
about that one.

> Can someone tell me:
> 
>  * Should I be able to restart while a scrub is in progress, or is that
>    deliberately prevented by btrfs?

   Restart the machine? Yes.

>  * How can I resume or cancel the scrub?

   It's probably simply not running -- see above.

>  * Is it more risky to leave the above errors uncorrected, or to run
>    btrfsck with --repair?

   I would, I think, leave them.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- We are all lying in the gutter,  but some of us are looking ---   
                              at the stars.                              

--HeFlAV5LIbMFYYuh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU+jjHFheFHXiqx3kAQLWXg//RYG8DLvfZ02FW4sAeJHQT58dsAk89HaU
nOFTdpBq9wwpzhXmOEKw6wl+2nbMZ0Gahc0s531hMkFp3IxEnfw06Eh+/kZHoYLB
pWQj5f1LIDGj05iMDg4dxmNPWsoO4bLwP53W3wXf8XJ6ehQiVHDYdCe435wZW+PH
RqQJ1ZI9yXOOSXqw5Qt/886q/ingJwAxjW0n42dFlSlzhKTc5WnIhCD5V99Z2Gqp
CRXmZ165fZy6oLV4F8w7BdmOqytFagXSmGwX8UNDxLcTHZvsi9q9WprzvMWod2Rr
CUjxlwabc2KyQjjDejAfbn+ohTGZvAKqTkmRvz2kYE8Vy9K0C4jSWBsCpIVcr0sd
kS7D5aHWpwfY2EXcERz2uc1FRpZ8uRJlNJBN9bzMtWzJ4rLgx2waanEjWTTIZRR8
Yv/BxM9Ad3tVUWXxvSKjNem0Z155y9QbfrFCFP9MlToLZNbtE/6WRaxYhzgYJXOx
cbfd1WO56HUR+TNwC/umO6hN2ytrikS46MD0sRCgRq0J/FVT4hwY37FAOzP3vtHp
7N7sWsUAzZSvEAFh0WtveaCKy+JEwDDYjW/sHTp1xfXX6A83gQyZwqcMom0hIgOg
eXtFWImUGNY4IAtMjv8r2oN0WirYiAyeY3DUjq0YtVSrmrKkUKR0i3NBcTXVjId6
JXBtdq6wpKY=
=05Cf
-----END PGP SIGNATURE-----

--HeFlAV5LIbMFYYuh--
