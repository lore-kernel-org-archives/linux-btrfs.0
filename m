Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36240 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757293AbdIILAa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Sep 2017 07:00:30 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1dqdUz-0007O8-Q5
        for linux-btrfs@vger.kernel.org; Sat, 09 Sep 2017 11:00:29 +0000
Date: Sat, 9 Sep 2017 11:00:29 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Subject: Re: generic name for volume and subvolume root?
Message-ID: <20170909110029.GF23980@carfax.org.uk>
References: <20170909083551.GC22060@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3yNHWXBV/QO9xKNm"
In-Reply-To: <20170909083551.GC22060@rus.uni-stuttgart.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--3yNHWXBV/QO9xKNm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 09, 2017 at 10:35:51AM +0200, Ulli Horlacher wrote:
> As I am writing some documentation abount creating snapshots:
> Is there a generic name for both volume and subvolume root?
> 
> Example:
> 
> root@fex:~# btrfs subvol show /mnt
> ERROR: not a subvolume: /mnt
> 
> root@fex:~# btrfs subvol show /mnt/test
> /mnt/test is toplevel subvolume
> 
> root@fex:~# btrfs subvol show /mnt/test/data
> /mnt/test/data
>         Name:                   data
>         UUID:                   b32a5949-dfd6-ef45-8616-34ae4cdf6fb8
> (...)
> 
> root@fex:~# btrfs subvol show /mnt/test/data/sw
> ERROR: not a subvolume: /mnt/test/data/sw
> 
> 
> I can create snapshots of /mnt/test and /mnt/test/data, but not of /mnt
> and /mnt/test/data/sw
> 
> Is there a simple name for directories I can snapshot?

   Subvolume. If you can snapshot it, it's a subvolume. Some
subvolumes are also snapshots. (And all snapshots are subvolumes).

   The subvolume with ID 5 (or ID 0, which is an alias) is the "top
level subvolume", and has the unique property that it can't be
renamed, deleted or replaced, where all other subvolumes can be.

   Hugo.

-- 
Hugo Mills             | Well, you don't get to be a kernel hacker simply by
hugo@... carfax.org.uk | looking good in Speedos.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                         Rusty Russell

--3yNHWXBV/QO9xKNm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZs8nNAAoJEFheFHXiqx3kYMAP/2epPkkbbCc89PZXZHKM//iJ
8MlEVvOGaX7nh1V3Ag4K+JQWBdG3yMjq4Y7shsRFI3Soz9EuIS35z3LZwfg0uPIu
SySO0jjUjiYTR5P0B3esNkMbH01L08+BGcAUF1ffxMu1+ATxhe8SXUCx2BSgYd2S
c6XEVNObd1TNrf26LbckyXgf8cCMJQMC0INM/x8joVHvDzt4i65DDpbojVBk0Je5
9Ux09hMChrea1KvYwPWG0zyUpPFIgUMa2gh7po1cZd2VIx1kYZuYvk4/Q7elFOLo
t7rZrvfaQ6r8JiG5eVu4SiikX38twZ4JS/UxeGz6p32L3vpk7ppLWen6t3pKIZDp
6kFesxNch+b/q1sIVsPSFj9xpfUqmyRZFYERmW+rTgIcZZvRl44mV81qONZ9rcEB
7czu1lKY+4RwgFVzK1BfG8KKS4LgPRbP54dp9c1n6wAYRoAlL6iXgno4p4gfk7hP
SzxTimskorkcu1rSd9ggyULfiDdMpkWNzH8sjl3AIM0Q0QV/VNmnIgam6VBOtMYD
eMYM9ua7uhI+DlBptbu7ONRVCtXUH3D45Q2bj/6Wa3bhZXRT2NfvNNjdoUdufF+w
WbWfVzGDxjjaw0R933IyKfGHligjH4Q8AhKqHQZRyz1rkxB8e3s4Z++xD41zDmco
oqQPW4M9RIZP0nDdagEc
=e10i
-----END PGP SIGNATURE-----

--3yNHWXBV/QO9xKNm--
