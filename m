Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55744 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbdHMRm2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Aug 2017 13:42:28 -0400
Date: Sun, 13 Aug 2017 17:42:27 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christian Rene Thelen <the@len.li>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs data recovery
Message-ID: <20170813174227.GB7140@carfax.org.uk>
References: <1386d7aa-10c2-4463-a26b-50f2b022f6b6@email.android.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6IGTAXksYJqONypD"
In-Reply-To: <1386d7aa-10c2-4463-a26b-50f2b022f6b6@email.android.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--6IGTAXksYJqONypD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 13, 2017 at 07:12:48PM +0200, Christian Rene Thelen wrote:
> I have formated an encrypted disk, containing a LVM with a btrfs system.

   What did you format it as? (i.e. what are the locations of the
damaged blocks?)

> All superblocks appear to be destroyed; the btrfs-progs tools can't
> find the root tree anymore and scalpel, binwalk, foremost & co
> return only scrap. The filesystem was on an ssd and mounted with -o
> compression=lzo.

   The compression would explain the junk you're getting from the
carving tools. They tend to rely on being able to identify sequences
of bytes as something recognisable -- compression defeats that by
reducing everything to (statistically) random bits.

> How screwed am I?

   Quite badly.

> Any chances to recover some files?

   The compression isn't helping, as noted above.

   The metadata will be uncompressed, though, so that should be
readable, depending on how much was formatted/damaged in the original
incident.

> Is there a plausible way to rebuild the superblock manually?
> Checking the raw image with xxd gives me not a single readable word.

   That's unsurprising. Metadata isn't human-readable, and nor is
compressed data.

   Did you ever balance this filesystem? More particularly, did you
ever balance the metadata? If you did, then there's a good chance it
wasn't at the front of the device, and so has a much smaller chance of
being damaged.

> I managed to decrypt the LV and dd it to an image. What can I do?

   btrfs-find-root may be able to find some of the tree heads. That at
minimum is the information you need in order to reconstruct the
superblock (well, that plus the UUID, but the UUID is going to be all
over the place -- it shouldn't be hard to find that if the rest is
discoverable).

   That said, recovering this is going to be somewhere between very
hard and miraculous.

   Hugo.

-- 
Hugo Mills             | But somewhere along the line, it seems
hugo@... carfax.org.uk | That pimp became cool, and punk mainstream.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                              Machinae Supremacy, Rise

--6IGTAXksYJqONypD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZkI+DAAoJEFheFHXiqx3kG1kQAKMMH4N+aZI6wMuhkos+hpID
Ni8KMbjFqKtJvDPlo43fDVltCRB1ZgABNHk6qKbAKhJ5QWiA5vhY9Sz/LFSfWGQw
bxs6duPABUYJeLHppegdTUU558CA9exvriwEpD5IhLA7eCqEZA//lxLjEleDuDWf
ux5LEbkqphiaW5mMlzbRYcjrEGD9pXKbH9SrVMbHmCNVmGA5zPrVa4HhSH3zYOY4
r/zDRU+xArV5Bs/KrbROHG72FjV177O3pjvruyGxRUELp4i2McaJiRpPSH5Mt2EB
mpY4c0H5OXJhGs2aNAnD9Ik0GxUal7C2YaMwwXMPZPpIsnSyUQ35H5wLyeJJgSN0
ASo8EN1HLtOqUkflWMrKbBU7GAHmXyoW3tqrW9HkefWi/wo1htFEzr9+bV2rQt4m
xX5XJVJklsxgGXU5TdCX1o/Wmdh7hD94MMiSMnopSHLawk/nCKjClzEwLxdHNLIj
1vsRtDHeoNY5CqDCNLJUFCIDFQJ3Qj5PRYyOe1JbfFwTjnZr3Em9BfRvmGNzBcCG
j+pJ+mwz5IOeI9IWbjlIp8l7BAhttOZLDlzY/KwaJASIjhVWXWQPZo2yC37Z6FOg
ai+8Pm9dpPNZNXkAaFlAlrB+pt3PCGYYS9tFs4kINL23daTC010cztM1TnoOy2Tz
MENtKqBblJvs74pmoukD
=lVVu
-----END PGP SIGNATURE-----

--6IGTAXksYJqONypD--
