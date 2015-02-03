Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:54939 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbbBCW0B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Feb 2015 17:26:01 -0500
Received: by mail-ie0-f175.google.com with SMTP id ar1so28891258iec.6
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Feb 2015 14:26:00 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 3 Feb 2015 22:26:00 +0000
Message-ID: <CALOYprUOeeeeXTZwCjBDvC5rapM-Dk5xwQ26S9nVZWKaG2c1mA@mail.gmail.com>
Subject: Btrfs-progs 3.19rc1 issues
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

I've been watching the 3.19.x branch with interest, and noticed that
you've tagged rc1. Unfortunately, I think I've found a few problems
with it. I will try to explain here:

For the record, I'm building using devtools (a set of clean chroot
build scripts) on an up-to-date Arch Linux box.

1) Building with the following:

./autogen.sh
configure --prefix="/usr"
make
...
make DESTDIR="/path/to/destdir" install

Results in binaries and libraries being installed to
/path/to/destdir/bin and /path/to/destdir/lib respectively.

If I want things to be installed into /path/to/destdir/usr/{lib,bin},
I have to 'export exec_prefix="/usr"'. That's not what I would expect.

Incidentally, --exec-prefix seems to have no effect, the same as --prefix.


2) No matter how you build, the installed btrfsck symlink points to
the build dir's btrfs binary. e.g.

$ ls -l bin/btrfsck
lrwxrwxrwx 1 wormzy users 52 Feb  3 21:14 bin/btrfsck ->
/build/btrfs-progs-git/pkg/btrfs-progs-git/

Assuming that btrfs and btrfsck will always be installed into the same
directory, it should just be a relative symlink to the btrfs binary.


3) By default, 'make test' tries to use installed btrfs-progs shared
object and btrfs-image, rather than the built ones:

$ make test
    [TEST]   fsck-tests.sh
    [TEST]   001-bad-file-extent-bytenr
/build/btrfs-progs-git/src/btrfs-progs-unstable/btrfs-image: error
while loading shared libraries: libbtrfs.so.0: cannot open shared
object file: No such file or directory
failed to extract image
/build/btrfs-progs-git/src/btrfs-progs-unstable/tests/fsck-tests/001-bad-file-extent-bytenr/default_case.img
Makefile:159: recipe for target 'test' failed
make: *** [test] Error 1

...

$ export LD_LIBRARY_PATH="$(pwd):$LD_LIBRARY_PATH"
$ make test
    [TEST]   fsck-tests.sh
    [TEST]   001-bad-file-extent-bytenr
    [TEST]   002-bad-transid
    [TEST]   003-shift-offsets
    [TEST]   004-no-dir-index
    [TEST]   005-bad-item-offset
    [TEST]   006-bad-root-items
    [TEST]   007-bad-offset-snapshots
    [TEST]   008-bad-dir-index-name
    [TEST]   009-no-dir-item-or-index
    [TEST]   010-no-rootdir-inode-item
    [TEST]   011-no-inode-item
    [TEST]   012-leaf-corruption
./test.sh: line 40: btrfs-image: command not found
failed to extract leaf_corrupt_no_data_ext.btrfs-image
test failed for case 012-leaf-corruption
Makefile:159: recipe for target 'test' failed
make: *** [test] Error 1

...

$ export LD_LIBRARY_PATH="$(pwd):$LD_LIBRARY_PATH"
$ export PATH="$(pwd):$PATH"
$ make test
    [TEST]   fsck-tests.sh
    [TEST]   001-bad-file-extent-bytenr
    [TEST]   002-bad-transid
    [TEST]   003-shift-offsets
    [TEST]   004-no-dir-index
    [TEST]   005-bad-item-offset
    [TEST]   006-bad-root-items
    [TEST]   007-bad-offset-snapshots
    [TEST]   008-bad-dir-index-name
    [TEST]   009-no-dir-item-or-index
    [TEST]   010-no-rootdir-inode-item
    [TEST]   011-no-inode-item
    [TEST]   012-leaf-corruption
sudo: a password is required
sudo: a password is required
inode 1862 not recovered correctly
test failed for case 012-leaf-corruption
Makefile:159: recipe for target 'test' failed
make: *** [test] Error 1

The sudo thing has been discussed in another thread, so I'll not
comment on that. Thankfully, it will skip the test if sudo isn't
installed. Unfortunately sudo is installed when using Arch's devtools
scripts, so I usually force-skip this test by "rm -rf"-ing
tests/012-leaf-corruption before running 'make test'. I believe that
the PATH/LD_LIBRARY_PATH problem is still something that needs fixing
regardless.

I'm hoping these problems are just easily fixed bugs, but if I'm
misunderstanding something about the build process (especially
regarding --{exec-,}prefix), please let me know.

Cheers,


WorMzy
