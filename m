From: Goffredo Baroncelli <kreijack@libero.it>
Subject: [RFC] aptitude & BTRFS slowness
Date: Wed, 19 Oct 2011 23:24:59 +0200
Message-ID: <3728579.PMSEXudObp@venice>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3538775.mvkHm7GXmK"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Cc: stewart@flamingspork.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart3538775.mvkHm7GXmK
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi all,

I suffered a lot for the terrific performance of aptitude on a BTRFS filesystem.
I don't think that BTRFS is a slow filesystem, but it seems that some aptitude 
(or dpkg) patterns are capable to highlight the btrfs slowness in some corner 
case.

In order to alleviate this problem, I wrote a small script which calls 
aptitude with the LD_PRELOAD libeatmyadata library. And now I want to share 
this idea (which is not my own, you can see several suggestion about that in 
the net) in order to collect suggestions and/or critics.

For who which don't know what is libeatmydata, the package info says:

"This package contains a small LD_PRELOAD library (libeatmydata) and a couple 
of helper utilities designed to transparently disable fsync and friends (like 
open(O_SYNC)). This has two side-effects: making software that writes data 
safely to disk a lot quicker and making this software no longer crash 
safe...."

In order to reduce the risk of data loss, my script create a snapshot of the 
root filesystem before calling the aptitude. After the end of aptitude a double 
call to sync, flush all the data on the disk. Finally the snapshot is removed.

The root of my filesystem is a btrfs subvolume (not the real root one). 
Inspired by ArchLinux I called it "__active", and it is placed on the real 
root of the btrfs filesystem. In order to manage the subvolume and its 
snapshots I mount the real root of the btrfs filesystem under /var/btrfs

Before running aptitude my script creates a snapshot of "__active" subvolume 
called "__rollback", and put it in the root of the btrfs filesystem.

During the boot I have two entry in the grub menu, the first one starts the 
system using as root the "__active" subvolume. The other one starts the system 
using the "__rollback" subvolume.

The idea is that if something goes wrong before calling the sync command, I 
can safely start the system from a coherent (i.e. no half package 
installation) system.

The next step is to automatically start from a "__rollback" subvolume if 
present (remember that the subvolume "__rollback" is automatically removed 
after the two sync) during the execution of the initramfs.  Another idea is to 
maintain the last 3-4-5...N rollbacks in order to be able to go back to old 
configuration.

Now, during a packages update the performances with btrfs are comparable to 
the ext4 ones. Obviously what I says about dpkg/aptitude, should be true also 
for other packages manager (like urpm/yum/rpm, pacman....)

Of course there are some caveats:
a) the filesystem must use only one subvolume (the snapshotting is not 
recursive)
b) if a package [re]starts a daemon (like a DB), it inherited the LD_PRELOAD 
environment variable, so the daemon  has the sync disabled

For the second point I am looking a way to enable the libeatmydata only for 
the dpkg program. I found that it is possible to pass --force-unsafe-io to 
dpkg in order to reduce the sync calls. But it seems that some sync are anyway 
performed.

Comments are welcome.

BR
G.Baroncelli


-------------------------------------------
$ cat btrfs-aptitude
#!/bin/bash

ROLLBACK=/var/btrfs/__rollback
ACTIVE=/var/btrfs/__active

if [ ! -d "$ACTIVE" ]; then
        echo "Cannot find $ACTIVE"
        exit
fi

if [ -d "$ROLLBACK" ]; then
        echo "Found $ROLLBACK; remove it"
        btrfs subvolume delete "$ROLLBACK" || exit
fi

echo "Snap shot $ACTIVE -> $ROLLBACK"
btrfs subvolume snapshot "$ACTIVE" "$ROLLBACK" || exit
sync

( 
        export LD_PRELOAD=/usr/lib/libeatmydata/libeatmydata.so
        aptitude
)

echo "Syncing..."
sync 
sleep 5s
sync

echo "Remove $ROLLBACK"
btrfs subvolume delete "$ROLLBACK"
------------------------------------------------------------





-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--nextPart3538775.mvkHm7GXmK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQBOn0ArvwTxYT3FBRIRAttBAJ4iFIeTlPIIy5jOkw/5xVnGMX6szgCfcgH1
S2gkxqStx2SJ65oNiZU4/xc=
=mtdB
-----END PGP SIGNATURE-----

--nextPart3538775.mvkHm7GXmK--

