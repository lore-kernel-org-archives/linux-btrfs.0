Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:48060 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941235AbcJSREK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 13:04:10 -0400
Date: Wed, 19 Oct 2016 17:04:08 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Cross subvolume "cp --reflink"?
Message-ID: <20161019170408.GA16645@carfax.org.uk>
References: <678dcd2e-13ca-0b83-6561-b7c6c10468b9@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
In-Reply-To: <678dcd2e-13ca-0b83-6561-b7c6c10468b9@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 19, 2016 at 07:52:14PM +0300, Andrei Borzenkov wrote:
> I get "Failed to clone: Invalid cross-device link". Is it expected?
> Basically this is (on openSUSE TW which has root on subvolume)
> 
> mount -o subvol=/ /dev/vda1 /mnt
> btrfs sub create /mnt/var/cache
> cp -a --reflink=always /var/cache/* /mnt/var/cache
> 
> Kernel 4.7.5-1-default.

   Yes, you're trying to copy across a mountpoint boundary. This isn't
going to work. You'll need to mount subvolid=0 on /mnt, and then use
the source and target of the cp *both* from within the /mnt subtree.

   Reflink operations (including cp --reflink=always, and the
reflink-aware mv) work across subvol boundaries, but not mount
boundaries.

   Hugo.

-- 
Hugo Mills             | For months now, we have been making triumphant
hugo@... carfax.org.uk | retreats before a demoralised enemy who is advancing
http://carfax.org.uk/  | in utter disorder.
PGP: E2AB1DE4          |                              Eric Frank Russell, Wasp

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJYB6eIAAoJEFheFHXiqx3kI9EP/1qgHRliNJ4JMG/XQb5heVqF
jKFBhUXoObEKnLxEZbqdPlHEpk+l4GpjWiGXAzpSay2OZ7dvNAzyTrbozwwWVd1J
UutApO7EfAETK6s5RC8C0KjmGyXwRqv9uy4kMTDtXoKH2Fpyb6TEY0xL+UQyPcnt
bghBOgEjVQKhoxvtNvcVesW/lmASN/cuwd8xyWbtL1bs4cCVG9io/Nj4FweOl8yp
kAV+g36SG0na+9+U0Br3ADrqW4uW78KbPzZnkUjbsmtdpAX4kAS+c95w2xk/BF1n
s0WFupkzUL7/XE0W4wtinFRue8/8Rbey2YDdX2f7cYG+XHo/at6eVqIkgh2SizYl
c/RmeRVLIDX4ZmrN8Nd/e+AjhPGKB3zLaPEMdhllKLGHOkY6YyAglzJ3+XxTsTV2
mBBoWqFP53/CQV+4/3gWjIDfGgDbB8isQsXvhWaN8E//uXlfHcaBHBDVqwr9/nvF
ilhQSCilXaHuOYWaeh03TIRAveHu6s8tR7ZjJkDaRbhcGGl8I2as70UWgO/mPlLh
8wIwf5GJ+eSN8JbU0Uq7Lq7P85VbTbRv2zEkhrzicL9VvB+V3lLr20nTAQAfxdSH
0m1Hep+fG+odnOgUO6AMPyEpi3HvDybzmMDxedkDVJ4lJCLl1oxXqL/BluxbX3//
yToaaJyj+Mv2gFD2lIgD
=NdXi
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
