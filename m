Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43306 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932361AbdC2Vz4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 17:55:56 -0400
Date: Wed, 29 Mar 2017 21:55:54 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Tim Cuthbertson <ratcheer@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Confusion about snapshots containers
Message-ID: <20170329215554.GT11714@carfax.org.uk>
References: <CAAKzf7ngoK27K=7gtUJR83QoPOwLAxQNK9NcOunNDX0-ijQ5_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BVQ1RKc6+nLPB5pT"
In-Reply-To: <CAAKzf7ngoK27K=7gtUJR83QoPOwLAxQNK9NcOunNDX0-ijQ5_w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--BVQ1RKc6+nLPB5pT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 29, 2017 at 04:27:30PM -0500, Tim Cuthbertson wrote:
> I have recently switched from multiple partitions with multiple
> btrfs's to a flat layout. I will try to keep my question concise.
> 
> I am confused as to whether a snapshots container should be a normal
> directory or a mountable subvolume. I do not understand how it can be
> a normal directory while being at the same level as, for example, a
> rootfs subvolume. This is with the understanding that the rootfs is
> NOT at the btrfs top level.
> 
> Which should it be, a normal directory or a mountable subvolume
> directly under btrfs top level? If either way can work, what are the
> pros and cons of each?

   The current best practice recommendation is that it should be a
normal directory, not contained within any of the subvolumes that are
being snapshotted. So (using the @-prefix convention to indicate a
subvol), you'd have something like this:

<top-level>
   @root
   @home
   snapshots
      root
         @2017-03-28
         @2017-03-29
      home
         @2017-03-28
         @2017-03-29

   To use this, mount the top level of the FS (-o subvolid=0) on a
known path, such as /media/btrfs/<fslabel>/, and do the subvol
management, and nothing else, under that mount.

(Optionally, you can flatten the dir hierarchy to
/snapshots/@root-2017-03-28, but I prefer the slightly deeper version
above).

   The snapshots container can be either a dir or a subvol, but you
gain almost nothing from it being a subvol, and you lose the ability
to move subvols/snapshots in and out of it cheaply with mv. Hence the
recommendation to use a directory.

   Hugo.

-- 
Hugo Mills             | O tempura! O moresushi!
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--BVQ1RKc6+nLPB5pT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJY3C1pAAoJEFheFHXiqx3kEWwQAL4A9K77SijLVGDfnqwIL/ZV
2DLkSZ7PXAICBgAdDeEsDyWIm4BRZ6l/oNFQdIhU/NDwkhRUuOLwRot8SmkiGB3F
Iy/OjfFzIBhlMlyU+EXRC+bS89D2Yvad+HIdzxIbfOHLOoIa2LpLyyedqu926vtu
x6bMrI4c5s9wbhI6O1gx89mQGGX6zDFQcJpohawWlym4b4XzchXF5MldlaXfezWh
7grR/v1EEr4gd1ins5hURlog17OteQN8AV1fSSTKR2w6p1STuFDW+3nlOIMAtPqH
2c24HuHPgnB5D8StNo2ku3QbN2jUt9qxFiQBgt6wSQbg47jNlXLSnxohtmqne7sH
p9IroYz8C66+2zEmEllDClYzl8YiAmFZJPgKv7J+QFYUImInIXmzAWXD7vkAyXNf
LRuKRAxJum6ORk5hX3rSc1tEAG5+8aWMtwE6mIAwQ9ovq3N2zT17gHV2fyeXmrz0
WKXJ7rRzVZW5Az0DPxc+AjWrsEwaAxZDtg3eYjMEcoBCdgeJPPuQi2bISKX+Xcmt
UW+OFZfNi5C2xeVvICJjSC0LEShvsvZwwAtItjafI35UFDAKDYJ1LFMkkKtDMqWG
LX0dMtULOuVPQ98JOz1h8YDBtp7IvjmYBX+ypbR6MIGtWct/eRiYcR2qguYmY+zW
EeTOUDvKq3avIas7xuA0
=DqaS
-----END PGP SIGNATURE-----

--BVQ1RKc6+nLPB5pT--
