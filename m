From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Calculating/estimating the process of an ongoing balance
Date: Sat, 19 Mar 2011 12:02:03 +0100
Message-ID: <4D848D2B.9000303@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
Hi all,

During a btrfs filesystem balance there are lines like the following
one in dmesg
btrfs: relocating block group 2122280075264 flags 9
Since the "big" number is strictly decreasing, I wonder whether this
can be used as some progress counter? For example,
do I get something like a percentage of what has been done/balanced by
the following formula:
(h-l)/h
where h is the highest, i.e. first, value and l is the last, i.e.
smallest, value?

Just for interest: There are two types of these lines appearing. One
type with 'flags 9' and one with 'flags 20'. Do the first ones refer
to block groups holding metadata and the second ones to block groups
holding data or is it totally different (and more complicated)?

Thanks,
Andreas Philipp
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJNhI0qAAoJEJIcBJ3+XkgiwhEP/A/6I3y9+oNckdx0tvwHjQM2
lFJvPSv6F5jZPY3fzzgPVhq1jg/92/ixWr1S2vWAKZc1V6Jt0+DOlNbLgEBXnywD
U9nxWGvuddkb4pgXV7kvTh6a4jjhmN8Wx9oc5jvpN3ThqKcoEqnA2DUj9PcfIuhv
enF1w57RKPGWRwp21Zg88GKCFrC0/oNfEg0SImG42wm/n5QE6/AY8V8yXGim8nCD
MgjHGRxGtJ2IMTrusw9htlUrpPnZ6GNeLeShLSDipMxHTrFvg2MyQ8l6l+AKqLzo
jHVUGpFnS3pm6zK0JbEyKqOEFkVtrilc4sGbdtslv5lp+HD93mT6IcPp3FgnLApF
em1Mf1jWiXHMRpbwxJXq0n+9I3I8w3zix8fY+dmb5oGDR8tO5jz3oQxm9JWUCrXn
M8eScNE0KgydZU1/F6vP4vsc5rB3Wi6ZGCkKxcsIfdVJAdYdUBvAwLRXTc6w5kJI
goR3bswyiWb93eNJfODaUEpt3EXuZJ0hTgSANADb22TxBZqszey5mydgkY6cAa1a
7nWARcs1vdZzStmTbSp0YAkUjE8IIjAIgwuISB9/s5tYVc3TEC1Nqgiz81eqfcIE
ezdIXNsKf+6ZJFW9XbSMZ9OMSC1p4kQn+QyUvwcbmxl8iXyjM08iaw7/tj62U2ev
bZ4nen4cKMS2ACgGnwLE
=Gjkc
-----END PGP SIGNATURE-----

