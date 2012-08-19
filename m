Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43238 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2HSOPS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Aug 2012 10:15:18 -0400
Date: Sun, 19 Aug 2012 15:15:13 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Daniel Pocock <daniel@pocock.com.au>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: fail to mount after first reboot
Message-ID: <20120819141513.GE30735@carfax.org.uk>
References: <5030F351.6030807@pocock.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="imjhCm/Pyz7Rq5F2"
In-Reply-To: <5030F351.6030807@pocock.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--imjhCm/Pyz7Rq5F2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 19, 2012 at 02:08:17PM +0000, Daniel Pocock wrote:
> 
> 
> I created a 1TB RAID1.  So far it is just for testing, no important data
> on there.
> 
> 
> After a reboot, I tried to mount it again
> 
> # mount /dev/mapper/vg00-btrfsvol0_0 /mnt/btrfs0
> mount: wrong fs type, bad option, bad superblock on
> /dev/mapper/vg00-btrfsvol0_0,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so

   With multi-volume btrfs filesystems, you have to run "btrfs dev
scan" before trying to mount it. Usually, the distribution will do
this in the initrd (if you've installed its btrfs-progs package).

> Then I did btrfsck - it reported no errors, but mounted OK:
> 
> # btrfsck /dev/mapper/vg00-btrfsvol0_0
[...]

   The first thing that btrfsck does is to do a device scan.

[...]
> Can anyone comment on this?

   See above.

> Also, df is reporting double the actual RAID1 volume size, and double
> the amount of data stored in this filesystem:
> 
> # df -lh .
> Filesystem                    Size  Used Avail Use% Mounted on
> /dev/mapper/vg00-btrfsvol0_0  1.9T   51G  1.8T   3% /mnt/btrfs0
> 
> I would expect to see Size=1T, Used=25G
> 
> # strace -v -e trace=statfs df -lh /mnt/btrfs0
> statfs("/mnt/btrfs0", {f_type=0x9123683e, f_bsize=4096,
> f_blocks=488374272, f_bfree=475264720, f_bavail=474749786, f_files=0,
> f_ffree=0, f_fsid={2083217090, -1714407264}, f_namelen=255,
> f_frsize=4096}) = 0
> Filesystem                    Size  Used Avail Use% Mounted on
> /dev/mapper/vg00-btrfsvol0_0  1.9T   51G  1.8T   3% /mnt/btrfs0

   This is an FAQ:

   https://btrfs.wiki.kernel.org/index.php/FAQ#Why_is_free_space_so_complicated.3F

   tl;dr: It's reporting the total number of raw storage bytes,
because it's impossible to compute actual usable space in the general
case.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- In one respect at least, the Martians are a happy people: ---    
                          they have no lawyers.                          

--imjhCm/Pyz7Rq5F2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQMPTxIKyzvlFcI40RAnBNAJwLzT/q3XbSY/qkpaGxbFZXxiBemACgmPz5
80QB33K+uLVTucKJvqm/ntc=
=epBU
-----END PGP SIGNATURE-----

--imjhCm/Pyz7Rq5F2--
