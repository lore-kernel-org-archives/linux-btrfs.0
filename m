Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47939 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355AbcECK1r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2016 06:27:47 -0400
Date: Tue, 3 May 2016 10:27:46 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Hasse Hagen Johansen <hasse@hagenjohansen.dk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Subvolumes cannot be mounted after raid1 conversion
Message-ID: <20160503102746.GN7228@carfax.org.uk>
References: <983F0471-51E8-47EC-B5A0-FBA9040F634B@hagenjohansen.dk>
 <20160503095515.GM7228@carfax.org.uk>
 <B66776EA-68EA-490F-862E-C49A1D51FCE5@hagenjohansen.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CQDko/0aYvuiEzgn"
In-Reply-To: <B66776EA-68EA-490F-862E-C49A1D51FCE5@hagenjohansen.dk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--CQDko/0aYvuiEzgn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 03, 2016 at 12:24:52PM +0200, Hasse Hagen Johansen wrote:
> Ok.  I can mount it manually just fine now using this command : sudo mount -t btrfs -o subvol=music /dev/sde /mnt/temp
> 
> But somehow I cannot mount it at /music anymore(and I just found out that is what has been tricking me) 
> 
> I have also tried with this in fstab 
> 
> /dev/sde  /music          btrfs device=/dev/sdd,device=/dev/sde,subvol=music          0       2
> 
> But I don't get any errors anyway (and no errors in dmesg) 
> 
> The exact thing I did was having the subvols mounted. Then mounted top-level volume on /mbt/temp. And then ran balance to convert to raid1.. When finished I umounted /mnt/temp (the top-level) and then my 3 subvolumes was unmounted and a cannot mount them at the same mountpoints again... No errors and it says that it is not mounted when trying to umount them. So it seems they don't get mounted at all and without throwing an error
> 
> I will look into it more thoroughly now that I can at least mount the subvols on other mountpoints than the original 

   Given those symptoms (mount doesn't report errors, but no mount
happens), I would guess that your problem is with systemd. It has a
bug where it sometimes unmounts things immediately after you've
mounted them.

   Hugo.

-- 
Hugo Mills             | "You know, the British have always been nice to mad
hugo@... carfax.org.uk | people."
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                         Laura Jesson, Brief Encounter

--CQDko/0aYvuiEzgn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXKH0hAAoJEFheFHXiqx3k9XEP/0Zw0Y8ZFHc5SZBNX0YXMRMH
frQMUdqpg+Jd2ImZsFuSXppJy6iP9SibKWwHuhrlEuGJYTF6AkwrQtEaqnGq/itK
lXbmiWjXrDcYG8feLFHEhFIyGTN6qKh4UKiHeVbZypKHMuopYCF3xWEzg2SCQLHN
DFDeZKTlQv94b77e+B8EIyj7C4sKDRqGYAqEUgjIxNc5gMIVRGhlJBeIbcxRE+KG
x3Id6HbakVDnYRTZKhO6LlRn+vu4FDUtydTcK4VZ+VDNdVTx6g2RHUTjaCe5kRZ1
8fs41pJJf/7vQp748HoXyUDful2LU1K4azxMsWt10G0d75NjBoRNVOjSB/z7RriU
n2ztR/1PQVF/auIuktLKSblzmibW92iL4LitC6OwNqnJ2MccH5gZXpMJvD893L4M
cks1RLG24fjSs2jXl157GnCs9ygy1Pv7EKjyR/VCxZcpnlo4vhnNbHtuIFY1nX5p
YJBfDahEoBqCco80jtSxhysD16oZNnDtU/0oq1wUVMGljLhjTDssBb9QN5fLuRWF
lfqhsHkCAa/UM8sPQYY1wf8IUk7jGro7rfg8gVlcl202BFWaS3zItb/pJlVfms+S
TMp1Swr+Y/qR4gf54ENQ9GbQIyQqfMD46XYTq0PtoY0u3YQQfHH+ZvSNhGQUPVUl
Za4BJ96olhhQgoOOu1AG
=Sx0E
-----END PGP SIGNATURE-----

--CQDko/0aYvuiEzgn--
