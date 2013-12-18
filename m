Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37923 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab3LRLFa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 06:05:30 -0500
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.80)
	(envelope-from <hrm@carfax.org.uk>)
	id 1VtEwR-0000jJ-QP
	for linux-btrfs@vger.kernel.org; Wed, 18 Dec 2013 11:05:28 +0000
Received: from hrm by ruthven.carfax.org.uk with local (Exim 4.80)
	(envelope-from <hrm@carfax.org.uk>)
	id 1VtEwT-0001TT-1Y
	for linux-btrfs@vger.kernel.org; Wed, 18 Dec 2013 11:05:29 +0000
Date: Wed, 18 Dec 2013 11:05:29 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs balance on single device
Message-ID: <20131218110528.GK11281@carfax.org.uk>
References: <CAAeznTpG6A7ygKg1AUx_pAMs_SNwG4a4C5gHPeT+HcKRsD+TWA@mail.gmail.com>
 <20131215202456.GA11281@carfax.org.uk>
 <CAAeznTryb7kyuvEyBFniv-UtGCQwdNtZMhpxm=-2MtKZSOj9Tw@mail.gmail.com>
 <pan$138cb$448d68e$2d9dcb10$fc6a898a@cox.net>
 <CAAeznTpZ6p1_ZR6xy-YGynAJu88jZ_52AQURuxT4qTeEYLOjdg@mail.gmail.com>
 <20131218104442.GA28559@pdb1.th.formicary.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJAclU0AInkryoed"
In-Reply-To: <20131218104442.GA28559@pdb1.th.formicary.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--IJAclU0AInkryoed
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 18, 2013 at 10:44:43AM +0000, Leonidas Spyropoulos wrote:
> I'm using the same subject as it might be relevant, feel free to change it.#
> 
> I'm trying to do some maintenance to the system running over a btrfs file system on root (/). I started a balance on the '/' partition and it failed with the below information:
> $ sudo btrfs balance start /
> [sudo] password for inglor:
> ERROR: error during balancing '/' - No space left on device
> There may be more info in syslog - try dmesg | tail
> $ dmesg | tail
> [93827.115887] btrfs: found 29461 extents
> [93827.481849] btrfs: relocating block group 29855055872 flags 1
> [93841.646011] btrfs: found 33171 extents
> [93851.421207] btrfs: found 33171 extents
> [93851.782054] btrfs: relocating block group 28781314048 flags 1
> [93866.815342] btrfs: found 52535 extents
> [93877.159354] btrfs: found 52534 extents
> [93877.356805] btrfs: relocating block group 28747759616 flags 34
> [93880.287185] btrfs: found 1 extents
> [93880.608798] btrfs: 1 enospc errors during balance

   You don't specify your kernel version, but if it's older than 3.11
or so, you should probably upgrade -- 3.10 and earlier had occasional
bugs where the block reserve system never kept enough blocks free to
add a new metadata chunk when it was needed, which led to exactly this
kind of symptom.

   Alternatively, and this is a bit of a long shot given that the
error seems to have been while relocating your system chunk (which
argues against this particular diagnosis), but:

   Do you have a large file on that filesystem (larger than 1 GiB)?

   If so, I would recommend switching to a 3.12 kernel, and running a
defrag on the file. There's a known and now-fixed bug where you can
get ENOSPC while balancing, if a file has an extent larger than 1 GiB
in size. (The bug being that there's an extent over 1 GiB in size in
the first place).

   Hugo.

> $ df |grep sda2
> /dev/sda2       20971520  13980396   5797124  71% /
> 
> 
> $ sudo btrfs fi show
> [sudo] password for inglor:
> Label: none  uuid: 699d671b-7064-441d-95ec-c616049fe287
>         Total devices 1 FS bytes used 12.75GB
>         devid    1 size 20.00GB used 15.31GB path /dev/sda2
> 
> Btrfs v0.20-rc1-358-g194aa4a-dirty
> 
> $ sudo btrfs fi df /
> [sudo] password for inglor:
> Data: total=13.00GB, used=12.16GB
> System, DUP: total=32.00MB, used=4.00KB
> Metadata, DUP: total=1.12GB, used=601.54MB
> 
> Does it really needs more than 5.7GB to do a balance? I though it suppose to move chunks one by one and considering the chunks for Data is 1GB and for MetaData 512MB (256 x2 for dublication) it should be more than enough.
> Also I had less space before and the dmesg reported 7 enospc errors. With cleaning a bit of packages installed now it reports only 1 enospc. Is that anywhere relevant?
> 
> Thanks,
> Leonidas

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- I'd make a joke about UDP,  but I don't know if ---         
                     anyone's actually listening...                      

--IJAclU0AInkryoed
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUrGBeFheFHXiqx3kAQLjlw/8Ci06h4KWA38UhSAOldEdba1yzTl05XS+
MC8qIiCRheMesPLD2VRj+BnTJMAhwS2OoZO6hfmIT+LAUKuRCu9pgR+cdOWF8ImE
uDt3b1lf6vxzX8IP0iLrk+dHEzQmzbNTZKdV5dgdrjXrIbjWkOXI0TPM/mkWovPR
VsyyuIfx2ypuCKmgLD4BclJM3LYZCb3bubf6rVl0dUvswpvWAEa/CeG8tjjxbpg3
Ss69m1TJnw7WcoXDZXf2/k1KNwUfYOBBrg2eWi70hRJC2z84FK0WCN8F7iFTahXs
4nxUwBounO17SN/36h0TQ/bXl5c4OrVu5uM+6Htbs7qHtrjY3M5DbaxiCx9n5/Oz
xXcgQU+UaMhQV5SKHtPDSSIl42Ljvi+ZOaxIJJeBWupFiZxBetkYlCl40H8uVb/G
Zb4lRBws+2YVzeDCdf3MwdRXOfdNTaKk9ORRIVkUyzK5qLAgjrHu9nYfrxRV49oO
o/Dpr8zRHlv81KLEULYlzdzMIfSn79oTFnPcT4VWRQWYK3GvnsXjjZecGw8bH8W8
PLrqMh4vBy/3WA3YL7T8nrjRH6azy33TDhVz+FegeZ9jNzHex5ovod77kQTZjm7q
kfY1UIqZ/3oNiusDhGiC3xjZl0KoolLNiJAVUfmxauhWTYQvhfpB14r7yULas9vP
3V7VvXRH36A=
=CcLJ
-----END PGP SIGNATURE-----

--IJAclU0AInkryoed--
