Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37073 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964817Ab3FTJQY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 05:16:24 -0400
Date: Thu, 20 Jun 2013 10:16:22 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Clemens Eisserer <linuxhippy@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Two identical copies of an image mounted result in changes to
 both images if only one is modified
Message-ID: <20130620091622.GL11290@carfax.org.uk>
References: <CAFvQSYRgvsqMxk_yZf6cPyoECJsUzn2g+cW-j7ktrWnhRL+0jA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="c8JyeaiReRNoiMDS"
In-Reply-To: <CAFvQSYRgvsqMxk_yZf6cPyoECJsUzn2g+cW-j7ktrWnhRL+0jA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--c8JyeaiReRNoiMDS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 20, 2013 at 10:47:53AM +0200, Clemens Eisserer wrote:
> Hi,
> 
> I've observed a rather strange behaviour while trying to mount two
> identical copies of the same image to different mount points.
> Each modification to one image is also performed in the second one.
> 
> Example:
> dd if=/dev/sda? of=image1 bs=1M
> cp image1 image2
> mount -o loop image1 m1
> mount -o loop image2 m2
> 
> touch m2/hello
> ls -la m1  //will now also include a file calles "hello"
> 
> Is this behaviour intentional and known or should I create a bug-report?

   It's known, and not desired behaviour. The problem is that you've
ended up with two filesystems with the same UUID, and the FS code gets
rather confused about that. The same problem exists with LVM snapshots
(or other block-device-layer copies).

   The solution is a combination of a tool to scan an image and change
the UUID (offline), and of some code in the kernel that detects when
it's being told about a duplicate image (rather than an additional
device in the same FS). Neither of these has been written yet, I'm
afraid.

> I've deleted quite a bunch of files on my production system because of this...

   Oops. I'm sorry to hear that. :(

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
              --- Welcome to Rivendell,  Mr Anderson... ---              

--c8JyeaiReRNoiMDS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUcLIZlheFHXiqx3kAQIBkA/9HCN4y1j8Efv/LiQ4PziYPWXT5pOoVVW1
IBskIWCamFvURcPLXiY6gQx8qKpZ0ARvnp8Iw5K+ABnXo9Q+BHBvIdpuQrVYABH1
4vqw/8i/BM/pCneHB/viuYS1EkhLbtXq0swtJTAXNybRJt4WssTcTMu2IOqtRKeK
g/5MFJ/ZAunbqF0ABFIckAl/3tKk7Q9arB4ttXEeyL++htmdO3c+XCqetLdTeh61
Etwz5hFLCDxt+k68EszQxv+6RHW6Q1JrfSZVboixmjOJeT9BEHzcVNvdXArs+ka2
XwlE5HHzh9xUxFbGQntX14OfDSnWZ5g9MMQlXJJK/AMq1+iBg0WB6cztc7pIaYCf
e40L/eiiVUlt1Y3rAFadYzhvjk+EAm469fApDomo9wDxmRdoNxRfd8F0hp7EHnf5
4R1Hs/u/onTBQZwR6p05YYmMO128dWuLH6dnQL9/HjAQLMSYNaSzAPBz7axzFCZj
Y2/JUDkinE3xkoMDrBabsheyS9zVbObkkx98dKiTVXRXLW2kfYwnl6QKMa6nIEdb
bNSeznkXwmNTxItLPll724ZxtuDE646N43rl/hcuEioSHzagfXbAc6dnNKURklhd
JNyqf0sy6mtiZERayF1k3n8FJtKasfMXglmU7u6IVBqUwwi3Mc1lcPGJplWIuDen
qATP7bp88jY=
=e9V7
-----END PGP SIGNATURE-----

--c8JyeaiReRNoiMDS--
