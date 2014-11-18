Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60907 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbaKRK7h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 05:59:37 -0500
Date: Tue, 18 Nov 2014 10:59:34 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Robert White <rwhite@pobox.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs filesystem show _exact_ freaking size?
Message-ID: <20141118105934.GK32735@carfax.org.uk>
References: <546B21F4.8060203@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6d1KVhp94hk3Jrm"
In-Reply-To: <546B21F4.8060203@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--d6d1KVhp94hk3Jrm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 18, 2014 at 02:39:48AM -0800, Robert White wrote:
> Howdy,
> 
> How does one get the exact size (in blocks preferably, but bytes
> okay) of the filesystem inside a partition? I know how to get the
> partition size, but that's not useful when shrinking a partition...
> 
> So, for example, you successfully do
> 
> btrfs filesystem resize -32G /dev/sdz2
> 
> now you've got "some space" zero idea how many sectors can be
> trimmed off the end of the partition, you can do the math but thats
> a little iffy, especially if the file system didn't originally fill
> the partition to begin with.
> 
> The current methodology for most such actions is to way over-trim
> the file system, then reallocate the space using your partition tool
> of choice, then re-grow the filesystem to fit. This has been the way
> of things forever and it blows...
> 
> There needs to be an option to btrfs filesystem show that will tell
> you XXXXXblocks, not Y.ZZ terabytes.

   The 3.17 userspace tools should now support flags to select the
display units in some detail, including bytes.

   Even without that, though, for your use case, I would recommend
shrinking the FS by *more* than you wanted to shrink, resizing the
partition, and then resizing the FS back up to fit the partition
exactly (with btrfs fi resize n:max).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                 --- Stick them with the pointy end ---                  

--d6d1KVhp94hk3Jrm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUayaWAAoJEFheFHXiqx3kTjgP/2JpnvcDDyMO6RUT6TFlLuuR
8tGuZu2nTV1ucyRIyxWhPKdzbuy4lK8ZN+QL1JiqfUpSKBR7pdSbdn80ky75KxUP
a8gy7DGKAMzhYsmIrYYnPrrv6DQsenBib6xyP9iixD+JYL7vAisf1d58jI++qalz
AiBrChm/SoJ9O3u0Vviuci9cqkoGiBFkXufUss+lJKD7Gx5wHWG7CMGb8OSTjRaZ
B+xHfEydxaYiY4Wl0KHcLTeEIAjNZv7gxW4OtgNT7EUVdUAHkh5b7y+xVuQ8zS+6
VDTCdEs9UihMXbl69osXc0k1VxJKKVY/cRHNOI48OycmmF0t+bi+6wI2sSlpE2XY
sLIFyAfnT3lrThrpnofeF3lzaEP0DU/cIrQv/D0f7py/Shih0A2tfB7CuJESEGc/
Qf/uMfALzJhkEcEYaEBie6Ap7JCNy4ymOt64HjN4mM/hO8QWENlV+9xJebZO01dy
OmIB64Ft7Xdap/DAgoC+acYID42PSoXbparYwq3/yjtXGsU5ATyemVeoSva4Yw1v
gX9bZdx2/p07lJEq5Ug2fMVc5dxdQPUgne+xbUonYYHkyYv2gkR70RhXqe0igAtB
q7KqCV5ZlV0nbR1HpSPU8KuIaAu/hb/dEUZwliyuJ7QH7jic/S8qLy4+RJXXjgwA
19Bf3+95b+dRAN6pFGRo
=WYu1
-----END PGP SIGNATURE-----

--d6d1KVhp94hk3Jrm--
