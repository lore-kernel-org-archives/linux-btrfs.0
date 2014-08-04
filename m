Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38420 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbaHDUoH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 16:44:07 -0400
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.80)
	(envelope-from <hrm@carfax.org.uk>)
	id 1XEP6z-00082F-C0
	for linux-btrfs@vger.kernel.org; Mon, 04 Aug 2014 20:44:06 +0000
Received: from hrm by ruthven.carfax.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <hrm@carfax.org.uk>)
	id 1XEP6y-0005OB-RP
	for linux-btrfs@vger.kernel.org; Mon, 04 Aug 2014 21:44:04 +0100
Date: Mon, 4 Aug 2014 21:44:04 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: btrfs sub list output
Message-ID: <20140804204404.GG31950@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q5Q2TEEGbX9oWZOX"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Q5Q2TEEGbX9oWZOX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   The output options of btrfs sub list seem a bit... arbitrary?
awkward? unhelpful?

   Here's my problem: Given a path at some arbitrary point into a
mounted btrfs (sub)volume, find all subvolumes visible under that
point, and identify their absolute path names.

   My test btrfs filesystem looks like this:

<TOP_LEVEL>
   root
   home
   test
      subdir (a subdir, not a subvol)
         foo
      bar

# mount -osubvol=test /dev/sda2 /mnt

so I want to be able to go from that configuration (knowing nothing
about the mountpoint), and map (both ways) between UUID and the
(e.g.) /mnt/foo path. But:

# btrfs sub list -oau /mnt  # and
# btrfs sub list -au /mnt
ID 259 gen 549115 top level 5 uuid 6a50af8d-83dd-9943-b5b7-4f8b0a7f3fa7 path <FS_TREE>/root
ID 260 gen 548768 top level 5 uuid c73d4296-7c30-074e-b647-e6e83025a125 path <FS_TREE>/home
ID 11826 gen 549045 top level 272 uuid f78aed0d-db5a-a342-b422-87abfa18efe0 path test/subdir/foo
ID 11827 gen 549046 top level 272 uuid a5cea7ae-3fdd-c247-8905-40cbb7f39017 path test/bar

   Here, I can easily filter out the subvols I want (they're the ones
without <FS_TREE>), but I have to know the mountpoint (which I can
find) and the subvol= parameter (which I think I can't).

# btrfs sub list -ou /mnt/subdir/
ID 11826 gen 549045 top level 272 uuid f78aed0d-db5a-a342-b422-87abfa18efe0 path test/subdir/foo
ID 11827 gen 549046 top level 272 uuid a5cea7ae-3fdd-c247-8905-40cbb7f39017 path test/bar

   This filters the subvols correctly, but otherwise has the same
drawbacks as above.

# btrfs sub list -u /mnt
ID 259 gen 549114 top level 5 uuid 6a50af8d-83dd-9943-b5b7-4f8b0a7f3fa7 path root
ID 260 gen 548768 top level 5 uuid c73d4296-7c30-074e-b647-e6e83025a125 path home
ID 11826 gen 549045 top level 272 uuid f78aed0d-db5a-a342-b422-87abfa18efe0 path subdir/foo
ID 11827 gen 549046 top level 272 uuid a5cea7ae-3fdd-c247-8905-40cbb7f39017 path bar

   Here, I get the paths relative to the mountpoint, which is what I
want, but mixed up with paths outside the mountpoint as well, which I
don't, and have no way of distinguishing the two classes without
making a separate call to btrfs sub list -a and filtering out the
UUIDs with <FS_TREE> in the name.

   Incidentally, if the parameter to btrfs sub list is inside another
subvolume within the mount, then the "relative" effects are all
relative to that subvol, not to the mountpoint.

   I'm finding it hard to work out how the variants with -o or -a (or
both) are actually helpful at all, now that I come to use them in more
than a vague human-readable form. Have I missed something, or is this
actually an awkward furball of confusing and mostly unhelpful options?
Are these options actually doing what the original author intended? If
so, what was that intent?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- Summoning his Cosmic Powers, and glowing slightly ---        
                            from his toes...                             

--Q5Q2TEEGbX9oWZOX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU9/wlFheFHXiqx3kAQIiKA/+Mq0y6Z2dsABXemGIATesP9mYENFs9GjW
q+5/QN554lXXtDK2zrDOXUe2ROCfChBAwe5wXiJtkCajWyPi/ikRcVuBI2QcIO81
FSIZSzRxwp/c5Z9hM17raGCbLjW4O6RmDhe3rq/NXmpVvEOx9r4wduDmlXuxqEO+
o6RneWZtVEHfc9DjYx/agp2T0HmQWNdzuJxNvBUDNVltsws2A/NGr+i6z2wC1iO7
75rXKEOu/MsapKy3TaCy54L3O4vJ997tF/hxdUVSO+cG3gj3F6d6LiHnaf/fX6uO
NCLZyHelqIRRsgHmZOOXCHPsNLVA2eAvwDG6uwYrwCQQp4IeWxwAkw8a6dvum+jk
Kq30kNOvaYmyyVVHiOUZdKG8OSeXvPbg3a5RxS4P5Aiv2S/3tkBYrgqaw5QT09qs
dA/+0Znfn8gObk0cP2WV5AyrKcRYb9LGqSK/Vt8JLr/hc3+c+59lvV+1MgcgBFxg
s8gd/a1UMrlKpHDXzbxot6I9tChtOYN2hsFNpKxG88QaFMaHiGFfQ1O4BTbZBiVw
ry5S8r1Qo5HEYwlu24CBgy3KNxJTwqNu14J+ZFmo3rXtzTaQZ2H5D/qJ4gBZvXgE
v2o7NM6AtQsrLkxr0MQHVNMiQMk+21R3h8MzKaqIlJBksMYxvkpsdHUx9wFfcUkS
An3VRRZvciw=
=yL3g
-----END PGP SIGNATURE-----

--Q5Q2TEEGbX9oWZOX--
