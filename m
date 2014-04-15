Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59698 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaDOOQP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 10:16:15 -0400
Date: Tue, 15 Apr 2014 15:16:12 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Bob Williams <linux@barrowhillfarm.org.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can I convert an existing directory into a subvolume?
Message-ID: <20140415141612.GN27956@carfax.org.uk>
References: <lijb4u$57s$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cy9Nn4fUvYST66Pl"
In-Reply-To: <lijb4u$57s$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--cy9Nn4fUvYST66Pl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 15, 2014 at 02:10:54PM +0100, Bob Williams wrote:
> Hi,
> 
> I'm new to btrfs, just dipping my toes in the water...
> 
> I've got two partitions, / on /dev/sda2 and /home on /dev/sda3, both
> formatted as btrfs in a new openSUSE 13.1 installation. I copied the
> whole of /home (4 users) into the btrfs formatted /home partition from
> an ext4 backup.
> 
> I would like to create snapshots of /home/user/Documents for example,
> but I understand these have to be subvolumes first. Googling tells me I
> can't convert a conventional subdirectory into a subvolume, so I'm
> guessing I'll have to create a new /home/user/Documents subvolume and
> then copy all the contents from the subdirectory. Correct? Then delete
> the subdirectory?

   That's one way. You can refine the "copy all the contents" step by
using cp --reflink=always, which will make reflink (CoW) copies of the
data, which is vastly faster than an ordinary copy, as long as you're
not trying to take the data across a mount point.

   Another way is to make a snapshot of the subvolume containing the
thing you want to convert, and then delete the pieces you don't want
(possibly rearranging the contents of the new subvol in the process).
So, assuming you have your original subvol mounted on /home, and you
want to turn /home/bob into a subvol, it would go something like this:

# btrfs sub snap /home /home/bob-temp
# rm -rf /home/bob-temp/hugo /home/bob-temp/fred /home/bob-temp/wilma
# mv /home/bob-temp/bob/* /home/bob-temp/
# rmdir /home/bob-temp/bob
# mv /home/bob /home/bob-old
# mv /home/bob-temp /home/bob

   Both your approach and the one above involve deleting large
quantities of things, so be careful you don't delete too much. :)

> Can the subvolume have the same name as the subdirectory it is
> replacing, or should it be called something like 'tempDocs', and then
> renamed back to 'Documents' after the original has gone?

   It'll have to have a different name temporarily. Subvolumes live in
the same namespace as the rest of the filesystem objects (like files
and directories).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- I believe that it's closely correlated with ---           
                       the aeroswine coefficient.                        

--cy9Nn4fUvYST66Pl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU00/LFheFHXiqx3kAQJYDxAAkMa7HOt7ERvci1pGQ3WLj4eOflUNqdO6
UG/LPKaDVKNT8a5WSqaxf7+ACxaX9XON2vGNcdBMT0FmQShIwjHpFxn+5ynWdAVK
zRiYzMR96npPryaKOtkOExYmv4P5UqB+MCANrwYljoqhXevB6lnt5aLWX15PnVpW
Hhrs5qB/L1oPMeXY2by13bbJhUmIuZu5VB2T2hNkU25EoJABMFZkl+y/oa68AENz
dQjS9QG/uZLqhf6odPG+KEeWKpZMhH/UeVFCG4dNfFrJJUeMiJzQSHyr1IqSWUMz
hEwNml5B3ZtLm0wMOKpLVMzrTOw0kOMdzBXIN++KzTtoA1f7fup17yyasgY+QjxN
nZ08/WtbFIlRQhZEMlyimp/5aTPmxNiHm8f3ut8uyZ/ku+cRfshsm3GD1oKD3yq1
7BpFfAlIB6zFMbNf/QEWza4pidqdKYVVA9d1QwLnEydCXh04XpfLRedDufuquGyD
VA1OBrgle8wBlt8cCQnrpFJsvW08jF9+ZOW3BygH5/pfKfrQLr9we0GsjMRjKMdi
HpKNdfV2ykCXJTj9zSQfpnG4K9veZdaqMsgv6m/LewzGGdwXPZbYstKoXpeInGlV
SETwug9j4/Q4/taChZ/8t/fGGHNhJcLC2yQxmFGKzhN6yp8Y9sSmZfkzk7FwW571
h1cFUgfqS40=
=ttKJ
-----END PGP SIGNATURE-----

--cy9Nn4fUvYST66Pl--
