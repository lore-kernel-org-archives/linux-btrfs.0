From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: time for "balance"
Date: Tue, 9 Nov 2010 15:23:57 +0000
Message-ID: <20101109152357.GA12681@vlad.carfax.org.uk>
References: <B$YEgUvD1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <B$YEgUvD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

B1;2401;0cOn Tue, Nov 09, 2010 at 04:09:00PM +0100, Helmut Hullen wrote:
>         btrfs device add /dev/sdc1 /srv/MM
>         btrfs filesystem balance /srv/MM
> 
> adds /dev/sdc1 with about 1,5 TByte ("df" tells so), and the system  
> works the second line ("balance") since about 12 hours. How much time  
> needs this "balance" command?

   Enough time to rewrite every piece of data in the filesystem.

   There are patches [1,2] for the kernel and userspace tools to allow
you to monitor the progress of a balance. I'll be putting out a new
revision of them either tonight or tomorrow (depending on how awkward
git is feeling).

[1] http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg06558.html
[2] http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg06561.html

> If the machine hangs somewhere and I have to restart it: how can/must I  
> repair the btrfs system?

   No need. Even while the balance is running, the filesystem should
remain in a consistent state (assuming that you have working
barriers). Note that if you restart the balance process, it will
effectively start from the beginning again.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Anyone using a computer to generate random numbers is, of ---    
                       course,  in a state of sin.                       

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM2WeNIKyzvlFcI40RAl8xAJ96PEL8Macp0onkZryH01cii+/cmQCgoWpw
T/WqIhh9qpmlOsOkUI+/zl0=
=z6d6
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
