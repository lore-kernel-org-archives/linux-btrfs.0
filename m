Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55591 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab3BPWRM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Feb 2013 17:17:12 -0500
Date: Sat, 16 Feb 2013 22:17:09 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Why does "btrfs send /mnt/btrfs-root" fail with "ERROR:
 /mnt/btrfs-root is not read-only." even when mounted with option "ro"?
Message-ID: <20130216221709.GK28997@carfax.org.uk>
References: <510E6714.7040206@statystyka.net>
 <510F0AE4.4070608@cn.fujitsu.com>
 <51200320.4010205@statystyka.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7Ke/meiCZutM6I/"
In-Reply-To: <51200320.4010205@statystyka.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--C7Ke/meiCZutM6I/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 16, 2013 at 11:07:28PM +0100, Adam Ryczkowski wrote:
> Question as in title.
> 
> I did remount my btrfs partition as read-only
> 
> (i.e. I did "sudo mount /dev/sda9 /mnt/btrfs-root -o ro")
> 
> And when I did
>   btrfs send /mnt/btrfs-root >/dev/null
> I received "ERROR: /mnt/adama-docs is not read-only."
> 
> Although, when I
>   sudo touch /mnt/btrfs-root/foo
> I get "touch: cannot touch `/mnt/btrfs-root/foo': Read-only file system"
> 
> 
> My btrfs --version reads
>   Btrfs v0.20-rc1-56-g6cd836d
> 
> And uname -r
>   3.7.8-030708-generic
> 
> Do I miss something obvious? Or should I wait until next kernel version?

   You need to make a read-only snapshot with the -r option to btrfs
sub snap. This is independent of the mount options, and prevents the
resulting subvolume from being modified during the send operation.

   The error message isn't obvious, and should probably be improved.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- If it's December 1941 in Casablanca,  what time is it ---      
                              in New York?                               

--C7Ke/meiCZutM6I/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUSAFZb9z9OVl50rAAQLbEA/+ORDH72ja3ihmmeyg/VdbOrbH872VDrZH
+VybmjqIxBBDiPqcKjOfc2OW79pxxo0tlpEIFK3lpRdJy1BDYHKF8+75q+JDzkwN
f1buYW+cey7oEFbayW+RSDXjy7IvKW7GGz3LFJd2nICqFW0GIvm6J47/DzqUpVCY
T2j5g7FHxi36BpdoJ+f82kF8dhslfGSCsV+rNcK6AgWLf9JT7dVkZevrNsX7nx8k
0//iseWQvi0/mLvkzB79Fleloxvcke9TrsqPJ43EKCf8K7gERLzDLHfuA5hXI27p
EYEMKGf1i66aUrhB87J+Lp8uQkFZG5wLEu8l/KpdNMMgGWUmhVPKXwxbLSj+ASdC
NrCu70+5mEKVnUefUOE+1NDXLpD0EgsMLROvBUcxc+FOl5VDNR0MlVtIp3gxv86x
W1If0qe481VJaokVjoN9KK/XHDVDS3dE49W2MeNtniF8mWMaw8yFmcmM0ia68oSm
tmBtqZ92DlASo4QKPJzPL09qC23kEBB08DRaIKoNvTJKZa7uAe4Gvct0NvWEoS92
8pam8rIzumXghTawzuzqYE9kDZjhYQ4kL54sVO+MaD6oQ1Tk7z5nUqPlsNA9Gild
PFJgh1d3/NhZQvatdv6q35RV65J4TkBf3Uvn/+x0HfBknB4ilbO6kSWk2CHCze0G
Rod0gkx+1pA=
=93ql
-----END PGP SIGNATURE-----

--C7Ke/meiCZutM6I/--
