From: Alex Dedul <rotmer@gmail.com>
Subject: Permissions issues on gentoo with sandbox and not only after
	conversion from ext4
Date: Tue, 15 Sep 2009 20:56:25 +0300
Message-ID: <5f8586d40909151056w5a1ee847wd92de4c00d07e111@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi there!

I recently converted from ext4 with btrfs-convert and right after i
rebooted or so i started to get permissions issues when emerging many
packages, but this happens not with all of them. So it writes
something like this:

strip: x86_64-pc-linux-gnu-strip --strip-unneeded -R .comment
   usr/lib64/python2.6/site-packages/gajim/trayicon.so
ecompressdir: bzip2 -9 /usr/share/man
QA Security Notice:
- /usr/share/gajim/src/common/xmpp/auth_nb.pyc will be a world writable file.
- This may or may not be a security problem, most of the time it is one.
- Please double check that gajim-9999-r2 really needs a world
writeable bit and file bugs accordingly.
QA Security Notice:
- /usr/share/gajim/src/common/xmpp/bosh.pyc will be a world writable file.
- This may or may not be a security problem, most of the time it is one.
- Please double check that gajim-9999-r2 really needs a world
writeable bit and file bugs accordingly.
[...]

Emerge uses sandbox which wraps chmod and seems like lots of other
syscalls so i guess maybe this somehow related how sandbox
inter-operates with btrfs or vice versa.. And this seems like happens
only with files that were created during compilation phase or the
like, not those that was just unpacked from distribution archive. So
looks like umask issue maybe..

Also when i run btrfsck it gives me lots of weird stuff, log file is
22Mb for ~8Gb filesystem.. In a "compressed" way log looks like this:

---
found 5608325374 bytes used err is 1
total csum bytes: 4917240
total tree bytes: 587296768
btree space waste bytes: 165011603
file data blocks allocated: 5036728320
 referenced 5035507712
Btrfs Btrfs v0.18
 key incorrect 6327492608
bad block 6327492608
leaf parent key incorrect 6327549952
bad block 6327549952
leaf parent key incorrect 6327586816
bad block 6327586816
[... quite a bit of such stuff ...]
leaf parent key incorrect 6329454592
bad block 6329454592
block 6330466304 rec extent_item_refs 1, passed 1
block 6330470400 rec extent_item_refs 1, passed 1
block 6330474496 rec extent_item_refs 1, passed 1
[... quite a bit of this kind of stuff ...]
block 6331682816 rec extent_item_refs 1, passed 1
Backref 33591296 parent 6326005760 [7 4544 0 0] not found in extent tree
Incorrect local backref count on 33591296 parent 6326005760 found 1 wanted 0
backpointer mismatch on [33591296 4096]
Backref 33705984 parent 67608576 [5 3556 0 0] not found in extent tree
Incorrect local backref count on 33705984 parent 67608576 found 1 wanted 0
backpointer mismatch on [33705984 4096]
[... and almost all 22Mb of these nice stuff ...]
Backref 8385318912 parent 4278104064 [5 358 429024 0] not found in extent tree
Incorrect local backref count on 8385318912 parent 4278104064 found 1 wanted 0
backpointer mismatch on [8385318912 8192]
---

So here is how situation looks like here.. Any tips how to fix those
permissions issues and as a bonus that stuff from btrfsck ?

With best regards from the Soul, Alex.
