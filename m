From: Kirk Wolff <kirk@wolffelectronicdesign.com>
Subject: Suggestion for sticky-compression mount setting (default mount
 options)
Date: Fri, 04 Feb 2011 20:44:03 -0600
Message-ID: <1296873843.7800.36.camel@KWOLFF03>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OiAJ36vW0zwtS0renyKe"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--=-OiAJ36vW0zwtS0renyKe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

As I've been using btrfs with an external USB drive, I wonder how to
handle efficiently the compression setting.  When I plug a drive in to
ubuntu, it is automatically mounted.  Its mounted without the
compression option as its not in fstab.  I don't see it as desirable to
install each usb drive in fstab on each computer that it may be used
just so that compression is automatically enabled.  In discussion with
cjb on irc, I came to realize that the compression setting shouldn't be
filesystem-wide therefore it doesn't make sense to have default mount
options for an entire btrfs filesystem as you may want compression on
one subvolume and not on another.  Therefore, it seems to me that
default mount options should be able to be configured for each
subvolume.  If you follow this idea through, this means that you would
need to be able to both override each of the default mount options from
the mount command (or fstab).  For example, if a subvolume has its
default mount option set to compress, you should be able to disable
compression if you manually mount it with "-o nocompress".  If mount
default mount options were able to be configured through btrfs for each
subvolume, then for the case when you have a simple USB drive that
you're using for backups, the default subvolume could have compress
automatically set when its plugged into a PC.  Then you can use
snapshots alongside the default subvolume to perform a type of
differential backups (similar to rsnapshot, but using COW instead of
hard links).  I can guess there are people out there that may want other
mount options to be carried around with the subvolume such as disabling
COW or whatever.  What are your thoughts on the above?  Please advise.

- Kirk

--=-OiAJ36vW0zwtS0renyKe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAABAgAGBQJNTLlvAAoJEExhjctVAnO4E6YH/juEVYqRbeeh14NipLlM8MJO
81zyAVfm8RdhwS8RyG4tRZxOW6e1gK4m9wQo0SN1IkbKbPegcBTtZ1nttLw13qrI
zQJ+zsbhxSLM8vgfZRx9J0ReQw0r7JBp0q1HTo47851GtWLZGXLPYSPChqkcpkDm
eL/uqvVCzezuNAGF+U3KctXLxBeQsfyjaiwjVxS03G54TAamOSq/dmqSZ1oQD41/
1g7Qwh0dzYqT7H3bcQ32pm3bVKdob8hTAOmAuWa+ze3oAOmFzx9N6yjIRYVzABKt
ZZDSS9unPg9FPbKm6hIFhWFwr1uyW0jsL0g6+nDRxRzNtp8Dpfyx/B5LGDRv/hM=
=KQ8W
-----END PGP SIGNATURE-----

--=-OiAJ36vW0zwtS0renyKe--

