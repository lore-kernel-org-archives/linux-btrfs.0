Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45002 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753019AbdAZJ0B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jan 2017 04:26:01 -0500
Date: Thu, 26 Jan 2017 09:25:59 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Oliver Freyermuth <o.freyermuth@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs recovery
Message-ID: <20170126092559.GD24076@carfax.org.uk>
References: <961e2f81-40e6-cced-f14a-7af7effe1e5e@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+B+y8wtTXqdUj1xM"
In-Reply-To: <961e2f81-40e6-cced-f14a-7af7effe1e5e@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+B+y8wtTXqdUj1xM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 26, 2017 at 10:18:40AM +0100, Oliver Freyermuth wrote:
> Hi, 
> 
> I have just encountered on mount of one of my filesystems (after a clean reboot...): 
> [  495.303313] BTRFS critical (device sdb1): corrupt node, bad key order: block=35028992, root=1, slot=243
> [  495.315642] BTRFS critical (device sdb1): corrupt node, bad key order: block=35028992, root=1, slot=243
> [  495.315694] BTRFS error (device sdb1): failed to read block groups: -5
> [  495.327865] BTRFS error (device sdb1): open_ctree failed

   Can you post the output of "btrfs-debug-tree -b 35028992
/dev/sdb1", specifically the 5 or so entries around item 243. It is
quite likely that you have bad RAM, and the output will help confirm
that.

> The system is using a 4.9.0 kernel, and I have btrfs-progs 4.9 installed. 
> 
> Since the last backup is a few weeks old (but the data is not so crucial), I'd like to attempt to recover at least some of the files. 
> 
> btrfs check tells me:
> # btrfs check /dev/sdb1
> Checking filesystem on /dev/sdb1
> UUID: cfd16c65-7f3b-4f5e-9029-971f2433d7ab
> checking extents
> bad block 35028992
> ERROR: errors found in extent allocation tree or chunk allocation
> 
> IIRC, the FS has DUP metadata (but single DATA). It's on a classic spinning disk. 
> I use: "space_cache,noatime,compress=lzo,commit=120" as mount options. 
> 
> What is the best way to go? 
> 
> Should I:
> - reinit extent tree
> - or collect debug info
> - or is there a better way to go?

   Check and fix your hardware first. :)

   If it is bad RAM, then the error is likely to be a simple bitflip,
and there are patches for btrfs check which will fix those in most
cases.

   Hugo.

> Cheers and thanks for any suggestions, 
> 	Oliver
> 
> PS: Please put my mail in CC, I'm not subscribed to the list. Thanks! 

-- 
Hugo Mills             | This: Rock. You throw rock.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                          Graeme Swann on fast bowlers

--+B+y8wtTXqdUj1xM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJYicCnAAoJEFheFHXiqx3k3d8P+gOFD6aMUJ5H4+idfQ05oG+k
CbZy6PPnateGsCf7HGdflYnBAAlfl0OmUNqK3tuF5gapcQQKh0hxioyYci/1omUj
FDAMYDWcH+y5fso08b4uefme9rrtBXTzzSTXRWRinp8/zT4tzpE1lEpmxJDYFQKd
qbbkqetWzTECGPTd3KJJnHhY2Vhx5UXtAAGfi4pwvBiYIQgLvBZtxFfWx1p9+yCr
vn25imNGNgkYKZFm/6Afk6vqnjXLNxbF8u1FpcW0PoKFHNoGcO+v8E1dWG38lAyI
idQ+WD2+3GpGGfexPhFYFd3WA1JtdqMqlB6EsEAj/4nABsMLN3ndRI+lxjICSqG9
ucE1jUVAd528UyAmXh1rhza4MacA8eUlFAIrpO9b70isLrWju5bErV4yJ/jX2rAH
9OzmRS3m6bJBzp/cMAkmJaljBiDK+9qIICDPVwiocrOcnoYFDvyox1bY4azlgWrX
2NZir/pQDHgUnmBCk5xKuvlB69cWobxOFT6Sql7ZTKJg33SVC8ynMKNCunV+Yi6y
pFsr7UoYSYVtBJcb9QKAUK2PQNVOR8eW/RnhURfqkMFB+dfRH29uAe4+Cxrk43Ey
kTuKxTB+nVWEJRUFMCa81KlBvdMXq+Y5nLDrS40ihkmhS2BL2uNxaGDsfHRtnrma
JQjBc6dGGw36GGe0sxsc
=Wd2i
-----END PGP SIGNATURE-----

--+B+y8wtTXqdUj1xM--
