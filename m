Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40750 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750850AbdEBSrX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 May 2017 14:47:23 -0400
Date: Tue, 2 May 2017 11:47:22 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>
Subject: btrfs check --repair: failed to repair damaged filesystem, aborting
Message-ID: <20170502184722.GN3516@merlins.org>
References: <20170501170641.GG3516@merlins.org> <20170501180856.GH3516@merlins.org> <CAJCQCtR4Hr5ekASiqWn2RNju5pHz8itS91N=M29Cz8Nqx8=kqA@mail.gmail.com> <20170502032346.ayhh3n3uh5d5ekbb@merlins.org> <CAJCQCtRaeejj4b+J6M7VTsDAe7Sn4PUtBwcvHXgfLNAFe=8Jqg@mail.gmail.com> <20170502051155.igmbqcqgzi4ukefg@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170502051155.igmbqcqgzi4ukefg@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(cc trimmed)

The one in debian/unstable crashed:
gargamel:~# btrfs --version
btrfs-progs v4.7.3
gargamel:~# btrfs check --repair /dev/mapper/dshelf2
bytenr mismatch, want=2899180224512, have=3981076597540270796
extent-tree.c:2721: alloc_reserved_tree_block: Assertion `ret` failed.
btrfs[0x43e418]
btrfs[0x43e43f]
btrfs[0x43f276]
btrfs[0x43f46f]
btrfs[0x4407ef]
btrfs[0x440963]
btrfs(btrfs_inc_extent_ref+0x513)[0x44107a]
btrfs[0x420053]
btrfs[0x4265eb]
btrfs(cmd_check+0x1111)[0x427d6d]
btrfs(main+0x12f)[0x40a341]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7f6b632e82b1]
btrfs(_start+0x2a)[0x40a37a]

Ok, it's old, let's take git from today:
gargamel:~# btrfs --version
btrfs-progs v4.10.2
As a note, 
gargamel:~# btrfs check --mode=lowmem --repair /dev/mapper/dshelf2
enabling repair mode
ERROR: low memory mode doesn't support repair yet

As a note, a 32bit binary on a 64bit kernel:
gargamel:~# btrfs check --repair /dev/mapper/dshelf2
enabling repair mode
Checking filesystem on /dev/mapper/dshelf2
UUID: 03e9a50c-1ae6-4782-ab9c-5f310a98e653
checking extents
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
checksum verify failed on 2899180224512 found ABBE39B0 wanted E0735D0E
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
bytenr mismatch, want=2899180224512, have=3981076597540270796
checksum verify failed on 1449488023552 found CECC36AF wanted 199FE6C5
checksum verify failed on 1449488023552 found CECC36AF wanted 199FE6C5
checksum verify failed on 1449544613888 found 895D691B wanted A0C64D2B
checksum verify failed on 1449544613888 found 895D691B wanted A0C64D2B
parent transid verify failed on 1671538819072 wanted 293964 found 293902
parent transid verify failed on 1671538819072 wanted 293964 found 293902
checksum verify failed on 1671603781632 found 18BC28D6 wanted 372655A0
checksum verify failed on 1671603781632 found 18BC28D6 wanted 372655A0
cmds-check.c:6291: add_data_backref: BUG_ON `!back` triggered, value 1
Aborted

let's try again with a 64bit binary built from git:
(...)
Repaired extent references for 4227617038336
ref mismatch on [4227872751616 4096] extent item 1, found 0
Incorrect local backref count on 4227872751616 parent 3493071667200 owner 0
offset 0 found 0 wanted 1 back 0x56470b18e7f0  
Backref disk bytenr does not match extent record, bytenr=4227872751616, ref
bytenr=0
backpointer mismatch on [4227872751616 4096]
owner ref check failed [4227872751616 4096]
repair deleting extent record: key 4227872751616 168 4096
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
checksum verify failed on 2899180224512 found ABBE39B0 wanted E0735D0E
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
bytenr mismatch, want=2899180224512, have=3981076597540270796
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
checksum verify failed on 2899180224512 found ABBE39B0 wanted E0735D0E  
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
bytenr mismatch, want=2899180224512, have=3981076597540270796
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
checksum verify failed on 2899180224512 found ABBE39B0 wanted E0735D0E
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
bytenr mismatch, want=2899180224512, have=3981076597540270796
Repaired extent references for 4227872751616
ref mismatch on [6674127745024 32768] extent item 0, found 1
Backref 6674127745024 parent 7566652473344 owner 0 offset 0 num_refs 0 not
found in extent tree
Incorrect local backref count on 6674127745024 parent 7566652473344 owner 0
offset 0 found 1 wanted 0 back 0x5648afda0f20  
backpointer mismatch on [6674127745024 32768]
checksum verify failed on 6983266418688 found 393B112A wanted 2B19CD5C
checksum verify failed on 6983266418688 found 393B112A wanted 2B19CD5C
checksum verify failed on 6983266418688 found BCBF9E15 wanted 785FF67E
checksum verify failed on 6983266418688 found 393B112A wanted 2B19CD5C
bytenr mismatch, want=6983266418688, have=13671317608077697645
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
checksum verify failed on 2899180224512 found ABBE39B0 wanted E0735D0E
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
bytenr mismatch, want=2899180224512, have=3981076597540270796
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
checksum verify failed on 2899180224512 found ABBE39B0 wanted E0735D0E
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
bytenr mismatch, want=2899180224512, have=3981076597540270796
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
checksum verify failed on 2899180224512 found ABBE39B0 wanted E0735D0E
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
bytenr mismatch, want=2899180224512, have=3981076597540270796
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
checksum verify failed on 2899180224512 found ABBE39B0 wanted E0735D0E
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
bytenr mismatch, want=2899180224512, have=3981076597540270796
failed to repair damaged filesystem, aborting


So, I'm out of luck now, full wipe and 3-5 day rebuild?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
