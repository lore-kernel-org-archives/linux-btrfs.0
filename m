Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60081 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab3LQRUR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 12:20:17 -0500
Date: Tue, 17 Dec 2013 17:20:02 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: Simon Wilkinson <simonxwilkinson@gmail.com>, jaltman@your-file-system.com,
        "openafs-devel@openafs.org" <openafs-devel@openafs.org>,
        linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: What is needed to build an AFS fileserver on top of BTRFS?
Message-ID: <20131217172002.GE11281@carfax.org.uk>
References: <14884.1387299196@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Oiv9uiLrevHtW1RS"
In-Reply-To: <14884.1387299196@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Oiv9uiLrevHtW1RS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2013 at 04:53:16PM +0000, David Howells wrote:
> It has occurred to me and others that something like BTRFS could be
> a good fit to build an AFS fileserver directly on top of. The
> question is what facilities would be needed from BTRFS to make this
> work? So I thought I'd kick off a shopping list;-)

>  (1) 64-bit data version numbers that increase monotonically with
> each write. Yes, this is likely to cause some performance
> degredation as it introduces an ordering over data writes and
> metadata writes to a file. Maybe writes can be batched to improve
> performance?

   Do these have to be per-file? If not, then you might be able to get
away with using the transid, which is a filesystem-global
monotonically-increasing number.

   btrfs batches disk writes already, and uses the transid to
differentiate these -- the writes come at 30 second intervals (by
default, although there's an option to change the period). There may
be multiple distinct changes to a single file within that transaction
(although obviously, only the state of the file after the last one
gets written to disk). I don't know exactly what you need it for, so
this may or may not be appropriate here.

   Ceph uses transids for [something, mumble, wavy-hand] -- I don't
know if the use-case for Ceph is equivalent to the use-case for AFS.

>  (2) Storage for ACLs and AFS UIDs. Having shareable ACLs might also
> be useful. Xattrs would likely do for this.

   This would seem like a reasonable place to put them, given that
that's what POSIX ACLs do, and we have POSIX ACL support already.

>  (3) The ability to snapshot a filesystem to make backups and for
>      pushing to read-only volume servers.

   We have snapshots of subvolumes, but not the filesystem as a whole.

>  (4) A 32-bit vnode number and 32-bit vnode uniquifier/generation
> number. These don't necessarily have to be stored by BTRFS directly
> but could instead be in a separate database file that gets
> snapshotted also.
> 
>  (5) The ability to set the vnode number, vnode uniquifier and data
>      version number to specific values. Necessary to clone volumes
>      and restore volume dumps.

   What's a vnode meant to represent? I'm not familiar with the
terminology.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- "Are you the man who rules the Universe?" "Well,  I ---       
                              try not to."                               

--Oiv9uiLrevHtW1RS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUrCHwlheFHXiqx3kAQJkJw//Rby5HNleZkZx0aiGrcMKxQ63m6IBUtuT
xHGrZgGIc0uhU3Z3hnjSUS462IN1tHRcpB380UXjoxjrNWkghHIGWzuduQ0K63OR
a1pRzgOcseWWoAqy79q/D5/2yWrmZZSPObTgKGAifzkvPGwEUdphg6TndnO/jUfQ
7sTwtyID30H3aOy88pmiW0/RAk/T6ri3TA4V39XydvlxBYFlEUJPuL0N/NxCiImG
RBNv1x5Gwzm57jgs0PqEwchodSKopzaCMAi89fmpSYyGKOatNngadU5eF1MICjpU
2yw5mcoZt32EOu1t30egwLd3K1hcJymCz+9aG6et2rtNa4fogL1RJBFrQFjT6Nm/
JbCL1ChSvX1xD7WRPI3D5SmCFF2Rbmu6AXEy6/HJsoQdBWq/KbJjv8kc/PEZqxix
w09ELd7OsjC/DjX8ONTZeH0ZZ+NEI5sUnd9V98OSPqmE/TPpMzpUa1FSTe8SusRE
xZhaVaOIr0yeoDDxrzAC3lKcN+FecfnEUWF3CX+xqSGeB327ywW0N+W7HL3o7W+F
BMAupy9dwSGthOgndl4vF3MDPvZgszXl1LsLdtC0hALEX4zrTP448EnBO0AmB+hJ
V5giHuTWz+ATVAyQMhYGDyeoEBNFvCn976kQkoLa2o5iRu091TzGuQzvsKkbJO3n
11TaxxzFxNI=
=TcMC
-----END PGP SIGNATURE-----

--Oiv9uiLrevHtW1RS--
