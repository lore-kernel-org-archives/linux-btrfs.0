Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:46075 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731302AbeG1XCo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Jul 2018 19:02:44 -0400
Received: by mail-qk0-f196.google.com with SMTP id c192-v6so5553056qkg.12
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Jul 2018 14:34:51 -0700 (PDT)
Date: Sat, 28 Jul 2018 17:34:49 -0400
From: Nicholas D Steeves <nsteeves@gmail.com>
To: jkexcel <jkexcel@comcast.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-convert missing in btrfs-tools v4.15.1
Message-ID: <20180728213448.GA16016@DigitalMercury.dynalias.net>
References: <1438689914.6655.1532811050018@connect.xfinity.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
In-Reply-To: <1438689914.6655.1532811050018@connect.xfinity.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Resending because I forgot to CC list.

Hi jkexcel,

On 28 July 2018 at 16:50, jkexcel <jkexcel@comcast.net> wrote:
>
> I'm an end user trying to use btrfs-convert but when I installed
> btrfs-tools and its dependency btrfs-progs on kubuntu 18.04, the
> installation was successful, and it shows that v4.15.1-1build1 was
> installed.
>
> However, when using the command  # brtfs-convert  /dev/sda4 (with the
> drive unmounted) the resulting error appears "command not found"
> I also tried command "btrfs convert" in case this was folded into the
> main tool, but this also failed.
>
> 1. Is btrfs-convert still available?
>
> 2. Where can I find it?
>
> 3. Has btrfs-convert been replaced? what is it's new name?
>
> 4. Is it safe to use a downgraded version of btrfs-tools ie: 4.14 or
> older?

You can blame me for that.  In Debian several users had reported
release-critical issues in btrfs-convert, so I submitted a patch to
disable it for the forseable future, eg:

  https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=864798
  https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=854489

Also, please consider the official status "As of 4.0 kernels this feature
is not often used or well tested anymore, and there have been some reports
that the conversion doesn't work reliably. Feel free to try it out, but
make sure you have backups" (
https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3 ).

I'm happy to hear it is still disabled in Ubuntu, where many more
users would be affected.  IIRC OpenSUSE LEAP and SLED 15 reenabled it
(it was previously disabled there), so maybe it needs specific kernel
versions or patches to not trigger RC bugs, and/or very specific
btrfs-progs versions, and/or very specific e2fslibs, and/or specific
combinations?  While I very much look forward to the day when
btrfs-convert can be relied on in Debian, I don't think we're there
yet.  Please take this as an opportunity to test that your backups are
restorable, mkfs.btrfs, and then restore from backup.  P.S. I have no
idea if Ubuntu has additional btrfs support.

Cheers,
Nicholas

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE4qYmHjkArtfNxmcIWogwR199EGEFAltc4XgACgkQWogwR199
EGGyVhAAxVHKYyDTMjk92lHj7fqQPP0m66PEzzMYa7PPc6hjb0pAkuIo1KqsyzJr
cVsgbVHlAuAoIM9De0JWiSz1YMPbgbiNHHfNZuRYb4Qv2DG/wUfp3XEmcvSO8eXo
GP+y/f3tqRJ+w++LfNPqEjFFfQGYcw1OA345thfsu1FAVxUU/z6YGjTgkY4jaFCt
9aP1Om5K0ABd/gWcgYdVxf7BuNhGRyQyYLIGOzb+4auFTY/IEou2Bj8+zeZRNyQ7
1P3IB4UwYHIViKlpcUuU+mQAp0kzZtrg6LC/LDPd2q1ttDUvFpsWnbUTuoo3b5RF
6EyYRXy8qaNNmlfjg7YJg5JmPmiwmyH2nmlRX8w+UAb1BIuZm3hZ5ixKJtQVP/+/
rCEFEAVWo9XuypapyNE8uUm2RRvdZrvILUQkKsZ+VDnEeH+6cVfeA4QMCbgNaB2Z
5QRncgwVhljdj4nW7Og9P/xCqdaPr+8BzyhCCaIcai3LPt8RaOF3LWvDT7xvFlhM
0xaG4l3WmqNJ1NEAwd17fmNx3/4mJPJVGdWn7wp/YY74gUm4InHlzPvVcKRYm9/Q
mgfeX8vaDQXLK/kobIrWKWcKblSd3zZWrQ36RhdpUavHC05HoVId2LpMucInP3Tt
/iON4CpSsK8AFVcdJ3hyRJhykMIS+DDyppntfmzCHyY8TOL9qY0=
=T107
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
