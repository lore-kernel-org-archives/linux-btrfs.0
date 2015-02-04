Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40078 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752856AbbBDBTx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Feb 2015 20:19:53 -0500
Message-ID: <54D173B4.1080405@cn.fujitsu.com>
Date: Wed, 4 Feb 2015 09:19:48 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: WorMzy Tykashi <wormzy.tykashi@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: Btrfs-progs 3.19rc1 issues
References: <CALOYprUOeeeeXTZwCjBDvC5rapM-Dk5xwQ26S9nVZWKaG2c1mA@mail.gmail.com>
In-Reply-To: <CALOYprUOeeeeXTZwCjBDvC5rapM-Dk5xwQ26S9nVZWKaG2c1mA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Btrfs-progs 3.19rc1 issues
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: linux-btrfs@vger.kernel.org <linux-btrfs@vger.kernel.org>, David 
Sterba <dsterba@suse.cz>
Date: 2015年02月04日 06:26
> Hi David,
>
> I've been watching the 3.19.x branch with interest, and noticed that
> you've tagged rc1. Unfortunately, I think I've found a few problems
> with it. I will try to explain here:
>
> For the record, I'm building using devtools (a set of clean chroot
> build scripts) on an up-to-date Arch Linux box.
>
> 1) Building with the following:
>
> ./autogen.sh
> configure --prefix="/usr"
> make
> ...
> make DESTDIR="/path/to/destdir" install
>
> Results in binaries and libraries being installed to
> /path/to/destdir/bin and /path/to/destdir/lib respectively.
>
> If I want things to be installed into /path/to/destdir/usr/{lib,bin},
> I have to 'export exec_prefix="/usr"'. That's not what I would expect.
>
> Incidentally, --exec-prefix seems to have no effect, the same as --prefix.
>
>
> 2) No matter how you build, the installed btrfsck symlink points to
> the build dir's btrfs binary. e.g.
>
> $ ls -l bin/btrfsck
> lrwxrwxrwx 1 wormzy users 52 Feb  3 21:14 bin/btrfsck ->
> /build/btrfs-progs-git/pkg/btrfs-progs-git/
>
> Assuming that btrfs and btrfsck will always be installed into the same
> directory, it should just be a relative symlink to the btrfs binary.
>
>
> 3) By default, 'make test' tries to use installed btrfs-progs shared
> object and btrfs-image, rather than the built ones:
>
> $ make test
>      [TEST]   fsck-tests.sh
>      [TEST]   001-bad-file-extent-bytenr
> /build/btrfs-progs-git/src/btrfs-progs-unstable/btrfs-image: error
> while loading shared libraries: libbtrfs.so.0: cannot open shared
> object file: No such file or directory
> failed to extract image
> /build/btrfs-progs-git/src/btrfs-progs-unstable/tests/fsck-tests/001-bad-file-extent-bytenr/default_case.img
> Makefile:159: recipe for target 'test' failed
> make: *** [test] Error 1
>
> ...
>
> $ export LD_LIBRARY_PATH="$(pwd):$LD_LIBRARY_PATH"
> $ make test
>      [TEST]   fsck-tests.sh
>      [TEST]   001-bad-file-extent-bytenr
>      [TEST]   002-bad-transid
>      [TEST]   003-shift-offsets
>      [TEST]   004-no-dir-index
>      [TEST]   005-bad-item-offset
>      [TEST]   006-bad-root-items
>      [TEST]   007-bad-offset-snapshots
>      [TEST]   008-bad-dir-index-name
>      [TEST]   009-no-dir-item-or-index
>      [TEST]   010-no-rootdir-inode-item
>      [TEST]   011-no-inode-item
>      [TEST]   012-leaf-corruption
> ./test.sh: line 40: btrfs-image: command not found
> failed to extract leaf_corrupt_no_data_ext.btrfs-image
> test failed for case 012-leaf-corruption
> Makefile:159: recipe for target 'test' failed
> make: *** [test] Error 1
>
> ...
>
> $ export LD_LIBRARY_PATH="$(pwd):$LD_LIBRARY_PATH"
> $ export PATH="$(pwd):$PATH"
> $ make test
>      [TEST]   fsck-tests.sh
>      [TEST]   001-bad-file-extent-bytenr
>      [TEST]   002-bad-transid
>      [TEST]   003-shift-offsets
>      [TEST]   004-no-dir-index
>      [TEST]   005-bad-item-offset
>      [TEST]   006-bad-root-items
>      [TEST]   007-bad-offset-snapshots
>      [TEST]   008-bad-dir-index-name
>      [TEST]   009-no-dir-item-or-index
>      [TEST]   010-no-rootdir-inode-item
>      [TEST]   011-no-inode-item
>      [TEST]   012-leaf-corruption
> sudo: a password is required
> sudo: a password is required
> inode 1862 not recovered correctly
> test failed for case 012-leaf-corruption
> Makefile:159: recipe for target 'test' failed
> make: *** [test] Error 1
>
> The sudo thing has been discussed in another thread, so I'll not
> comment on that. Thankfully, it will skip the test if sudo isn't
> installed. Unfortunately sudo is installed when using Arch's devtools
> scripts, so I usually force-skip this test by "rm -rf"-ing
> tests/012-leaf-corruption before running 'make test'.
I think this can be resolved in several ways:
1) sudo -v to update credentials. (workaround)
If using default timeout, you would have 5 minutes that doesn't need 
password and can pass it.
But anyway, it's not a good idea since user needs extra operation and 
that's current 'sudo -n' want to
avoid.

2) check by 'sudo -n -v' to ensure credentials before using sudo.
IMHO, this should be the best method. Automatically check the 
credentials and if needs password,
just not use sudo and skip the tests.


Other bugs you reported really make sense.
Although not familiar with autoconfig staff, I'll try to fix it if possible.

Thanks,
Qu
>   I believe that
> the PATH/LD_LIBRARY_PATH problem is still something that needs fixing
> regardless.
>
> I'm hoping these problems are just easily fixed bugs, but if I'm
> misunderstanding something about the build process (especially
> regarding --{exec-,}prefix), please let me know.
>
> Cheers,
>
>
> WorMzy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

