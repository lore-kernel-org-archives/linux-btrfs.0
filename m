Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51097 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2IQK2L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 06:28:11 -0400
Date: Mon, 17 Sep 2012 11:28:08 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs + Btrfs-progs:  make pipe functions re-usable
Message-ID: <20120917102808.GE1129@carfax.org.uk>
References: <5052C5A0.4090803@oracle.com>
 <20120914110432.GE17430@twin.jikos.cz>
 <5056AB8A.6000500@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+SfteS7bOf3dGlBC"
In-Reply-To: <5056AB8A.6000500@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+SfteS7bOf3dGlBC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 17, 2012 at 12:48:10PM +0800, Anand Jain wrote:
> 
> >>  btrfs send introduced a part of code to read kernel-data
> >>  from user-end using pipe. We need this part of code to be
> >>  useable outside of send sub-cmd, so that developing
> >>  service sub-cmd can use it.
> >
> >What's 'service sub-cmd' please?
> 
>   at the moment 'btrfs service history <mnt>|<dev>'
>   to show logs of maintenance.
>   comments/suggestions welcome.

   As I said in our private email exchange some months ago, I don't
think this is the right way to be doing this. For example, if you use
an alternative tool (such as btrfs-gui) which uses the ioctls
directly, you've lost that logging information.

   Keeping a log of what's been done to the FS is much better done by
extending the available logging in the kernel (and making it a
compile-time option for those who don't want or need it). You can then
write a simple shell script to chomp through the normal kernel logs to
extract this information.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- I'll take your bet, but make it ten thousand francs. I'm only ---  
                       a _poor_ corrupt official.                        

--+SfteS7bOf3dGlBC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUFb7N79z9OVl50rAAQJAsQ/9FcKYc1QRCiAeTjPVQI7nly4XSg0IUZ+Y
P9NnQcDombQhacnV9+YxuV9Ph5y1bfZGFWxzaAqTclVXaB4wLQmzzXu59Wrqwlv0
Sf857f7Oh5DmuQWQdbVxf7VRknEg3GkDqAl4SHGW+VmZcA/o39tBlIlVOvPnb/kj
D3wzQ2wes9RZ0pHCRlriPpM/uBK7SHD1fCljhViORTQ+d4XcXxwyR5kodzyaDNZX
igYLfkJBmdOX4SA2QhxEc3srn3mrijOEG+LCNEt+RDiycNDwwwV+bD6Ar8+BSmjZ
4/JAnde24VZOsF+SqatQRJYJZMW0SC3hZ1qc4hE4QnnaXlS84fkS8CyoEa4oj4mh
BVAqhoDPs0z7Kt+AmiSnxqvL7vzcbK6j9le9vZEV3D76v5gqo5jfBIWkE78ZvJgQ
0kq6lD4ChJJMdfVzWw8m8XEt8tCYSaExHT/D41lWwbLN25zJHDyd8Zwj0rSmuwpL
0UXk+b7szUhDhrF2zeTng4HuwRaUIcyCdBTeTBk2sK6Y756YtUpE+vSwwYA4W09/
pqcCYPEQbwJv15w+BRL9sJ4oknYXsAquYXI+sm8DB2Ibmlb6P+oG1T+Cft9fbyZv
hAJCrPDdm0Dx2Hvm938z+3dNNU6/V8yXx3AY3Z1hraIh4VWxq6KgeRbZwvf+QVO7
VGOnys4zI9g=
=jkOj
-----END PGP SIGNATURE-----

--+SfteS7bOf3dGlBC--
