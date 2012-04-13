From: "A. James Lewis" <james@fsck.co.uk>
Subject: Can lgetxattr legally return ENODATA?
Date: Sat, 14 Apr 2012 00:06:02 +0100
Message-ID: <4F88B15A.5080200@fsck.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


Please excuse my ignorance here, but I wondered if this could be a BTRFS
related issue... and perhaps one which might not often be spotted if it is.

A friend of mine has been having trouble with a backup application on a
BTRFS filesystem, and recently sent me this, which made me think that
there might be an edge case where something weird is happening:-

> Not sure if your interested but I thought I'd get my hands dirty and
try and figure this boxbackup problem out. stracing the problem gave me
this as the cause:
>
> lgetxattr("/srv/WWW/Stuff/includes/CI-application/views/objects/items",
"system.posix_acl_default", 0x0, 0) = -1 ENODATA (No data available)
>
> I looked up the call here:
> http://linux.die.net/man/2/lgetxattr
>
> But unfortunately it doesn't have the ENODATA error listed
> (its not on the stat page it refers to either)
>
> Boxbackup assumes it can only be caused by a file permissions problem
and so gives that error I had, but the fact that a folder next to it
with identical permissions is fine is odd.
>
> In the end I copied all the files out with SAMBA, deleted them on the
BTRFS volume and put them back in again. After setting the permissions
the same as they were before and restarting boxbackup the problem vanished.

- -- 
A. James Lewis (james@fsck.co.uk)
Engineering does not require science. Science helps a lot but people
built perfectly good brick walls long before they knew why cement works.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk+IsT0ACgkQ1OQXXvP2GMFl4wCbB+bcK5gtkgOhHXYsOV2DV7wG
RWgAnj+6rX3RogB8gopEkxhV4EVlaxaZ
=o9Xj
-----END PGP SIGNATURE-----

