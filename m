Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43846 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3G0Tox (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Jul 2013 15:44:53 -0400
Date: Sat, 27 Jul 2013 20:44:48 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Mount multiple-device-filesystem by UUID
Message-ID: <20130727194448.GO20517@carfax.org.uk>
References: <51F41660.1070405@friedels.name>
 <51F41702.2000508@friedels.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9DptZICXTlJ7FQ09"
In-Reply-To: <51F41702.2000508@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--9DptZICXTlJ7FQ09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 27, 2013 at 08:52:50PM +0200, Hendrik Friedel wrote:
> As stated in the wiki, multiple-device filesystems (e.g. raid 1)
> will only mount after a btfs device scan, or if all devices are
> passed with the mount options.
> 
> I remember, that for Ubuntu 12.04 I changed the initrd. But after a
> re-install, I have to do this again, and I don't remember how I did
> it.

   With Ubuntu, just install the btrfs-tools package. It should modify
the initrd correctly.

> So, the other option would be passing the devices in the fstab. But
> here, I'd prefer UUIDs rather than device names, as they can change.

   This is why we don't recommend using device= mount flags.

> Is this possible? What is the syntax?

   I don't believe it is possible. Finding filesystems by UUID is (I
think) a userspace-based thing, so you'd have to have an initrd
anyway.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- "No!  My collection of rare, incurable diseases! Violated!" ---   

--9DptZICXTlJ7FQ09
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUfQjL1heFHXiqx3kAQIekhAAgHi0mNjL+DS9uSbXnAihJc6TPumAPsD5
uX9Yon7a9MbMhPAY4xe/fc74L3p30b3mSbodH5hC3g/cSH9qdJiOzzv/rFIIplzQ
e/n8w2KX/CPqhz7TSVE7+u5dJHCJIdhV19+uTOim1kCbW4lCwFN7PfIH5XYSwTlQ
mBdpNES4IQz0Auw7JEp8cqQ3aq03iBW/4ngFp1O8rA24rdhgEKSoi9HL4Md/ijyj
YNiwfBY3rqSQjVtORE6qvPvGyGQsdnfcbWJRfHmmPwMSiYXeruYOutUXy4gNihux
Kh6Q2178SizFJ8QdTPczcyws3CCGE02nQnZvdlTSS3ZytitLEJbraodnZDLqmRVo
4I4GHPMKJI4M/9dlEU6IArf3BtLxeQJLe4Cxql3TV29rYhuhn+LOLOgHHlaDcbup
yFcm/9/S74qrTeMLDYZRf3cNRneJgDsVuHz7gUPO+74dKT0irH74Y3MS16UpQu7b
QX6awKyLntxhYAW40BalSA2t1TRIzzYlIRz1pXdmp3DFWpwOP2HYfeJOFXmX2HcW
9f6mQHUcO8/4eZ3fpkPJTVgwcu5jxN6LXSm9ZVXqIVVGrHPN4ZvXSuDgwqTGt14E
/UIpxR7LwyroTwn7VxARdPtGW4brNv7fIixXcSdyh0pdBTgrpSvdwvRryi33LNDe
vb0mVEQcZTU=
=OFiP
-----END PGP SIGNATURE-----

--9DptZICXTlJ7FQ09--
