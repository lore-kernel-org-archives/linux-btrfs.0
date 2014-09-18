Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49434 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440AbaIRPjg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 11:39:36 -0400
Date: Thu, 18 Sep 2014 16:39:34 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs receive: could not find parent subvolume
Message-ID: <20140918153934.GA9830@carfax.org.uk>
References: <20140918152718.GA27983@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
In-Reply-To: <20140918152718.GA27983@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 18, 2014 at 08:27:18AM -0700, Marc MERLIN wrote:
> While debugging a btrfs send/receive slow problem, I now getting this:
> legolas:/mnt/btrfs_pool1# btrfs send -p tmp_ggm_daily_ro.20140917_06:29:58 tmp_ggm_daily_ro.20140918_02:48:24 | ssh gargamel btrfs receive -v /mnt/btrfs_pool2/backup/debian64/legolas
> At subvol tmp_ggm_daily_ro.20140918_02:48:24
> At snapshot tmp_ggm_daily_ro.20140918_02:48:24
> receiving snapshot tmp_ggm_daily_ro.20140918_02:48:24 uuid=5d1f0454-1be3-b648-9ea5-dc427cd62d98, ctransid=310713 parent_uuid=d86e69bf-e17f-7f4c-bfb7-e571d5824687, parent_ctransid=308332
> ERROR: could not find parent subvolume
> 
> The parent is there on the other side, but UUID is different:
> gargamel:/mnt/btrfs_pool2/backup/debian64/legolas# btrfs subvolume show tmp_ggm_daily_ro.20140917_06:29:58
> /mnt/btrfs_pool2/backup/debian64/legolas/tmp_ggm_daily_ro.20140917_06:29:58
>         Name:                   tmp_ggm_daily_ro.20140917_06:29:58
>         uuid:                   3d424a2b-69da-244c-bfcc-c283f9cc1f34
>         Parent uuid:            05d3b9be-bfe2-bb4a-9f6a-64b9d44896c7
>         Creation time:          2014-09-17 06:30:01
>         Object ID:              7873
>         Generation (Gen):       83621
>         Gen at creation:        83476
>         Parent:                 263
>         Top Level:              263
>         Flags:                  -
>         Snapshot(s):
> 
> Now it seems that the UUID is different on all my snapshots created by
> btrfs send, so maybe it doesn't match UUID?
> 
> Given that, what is btrfs receive using to get a match?

   There's a "recieved UUID" field on each subvolume. I posted a patch
to userspace a couple of weeks ago which adds a -R option to show it.
I don't think it's filtered through David's backlog yet.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- "I will not be pushed,  filed, stamped, indexed, briefed, ---    
               debriefed or numbered.  My life is my own."               

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVBr8tVheFHXiqx3kAQJM1xAAgfLhACmcy5XXjJtk8eg/XQ8tL3aU0FKA
fqO2LZ+yjYIXDZTiNFH4q+0mUzRGYefq2js2AhCpe4tYmVosoxlZCNAeZMo0q1dR
CRjAeZNX8fpbjKV6bxpKTmrATxa4Elt5CQtHgdPnqArxfWjkZdHlWl0ko/04+Sbf
cupfKWKcEKfbM9Mm+sQJMi7NYWY5UgUELcd+96m/pvU4g5N7uOTYTGpZiP1vMIyd
nWwuJlzDeRfcIuKdaCfLqP3CXYkeF5PxLMAebfA1usPnV5fm2AqHMNQRDIDTK9yV
drCBKuWJeVveezuVUIOsZy80mElptxevJ9s2krQyT/3cI/fb/RO5yaHVmBkEFGZ1
tCExoSenxUWcV1qoke6+UqS/MwQ0xUBWq5u8V/Yq0QxQuvNf0OngpU6k6TU5pTxb
fVFO03UkJ9nFpTU4whKNFk3j+km4b837vabslZDCrUvEbUr5+q0GGvgjYeAeePWP
9l4S7dGOvfFJearLQlfmMLnii29blTjDYgNQ5UK2BYSZTO0zbPYgcT3ImuyyQ8wc
46ahEvNnsxP2twUzVaehqs4JIHoXkSMWrnQT1x4ud/hyaeo9W5Jr4+QlGkZ1g9s5
5jgN+yEZSXOm33nUO0LX51hnyvwTn1ZNrOsU1NYi2iy0uCqrurNWOGrpqgXiuhwe
LNyxMuJ3G3Y=
=5+bm
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
