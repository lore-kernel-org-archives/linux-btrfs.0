Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:62698 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3J0BoT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Oct 2013 21:44:19 -0400
Received: by mail-qc0-f176.google.com with SMTP id s19so3136634qcw.35
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Oct 2013 18:44:18 -0700 (PDT)
References: <1382724100-5276-1-git-send-email-jbacik@fusionio.com> <l4ed62$8r3$1@ger.gmane.org> <20131025183134.GA4543@localhost.localdomain> <l4hifj$ni1$1@ger.gmane.org>
Mime-Version: 1.0 (1.0)
In-Reply-To: <l4hifj$ni1$1@ger.gmane.org>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <F0A6315A-D147-4EE3-B491-AE829E336743@toxicpanda.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Josef Back <josef@toxicpanda.com>
Subject: Re: [PATCH] Btrfs-progs: allow --init-extent-tree to work when extent tree is borked
Date: Sat, 26 Oct 2013 21:44:15 -0400
To: Martin <m_btrfs@ml1.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yup I have another plan for your situation, I will wire it up Monday and send it out.  Thanks,

Josef

> On Oct 26, 2013, at 7:16 PM, Martin <m_btrfs@ml1.co.uk> wrote:
> 
>> On 25/10/13 19:31, Josef Bacik wrote:
>>> On Fri, Oct 25, 2013 at 07:27:24PM +0100, Martin wrote:
>>>> On 25/10/13 19:01, Josef Bacik wrote:
>>>> Unfortunately you can't run --init-extent-tree if you can't actually read the
>>>> extent root.  Fix this by allowing partial starts with no extent root and then
>>>> have fsck only check to see if the extent root is uptodate _after_ the check to
>>>> see if we are init'ing the extent tree.  Thanks,
>>>> 
>>>> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
>>>> ---
>>>> cmds-check.c |  9 ++++++---
>>>> disk-io.c    | 16 ++++++++++++++--
>>>> 2 files changed, 20 insertions(+), 5 deletions(-)
>>>> 
>>>> diff --git a/cmds-check.c b/cmds-check.c
>>>> index 69b0327..8ed7baa 100644
>>>> --- a/cmds-check.c
>>>> +++ b/cmds-check.c
>>> 
>>> Hey! Quick work!...
>>> 
>>> Is that worth patching locally and trying against my example?
>> 
>> Yes, I'm a little worried about your particular case so I'd like to see if it
>> works.  If you don't see a lot of output after say 5 minutes let's assume I
>> didn't fix your problem and let me know so I can make the other change I
>> considered.  Thanks,
> 
> Nope... No-go.
> 
> parent transid verify failed on 911904604160 wanted 17448 found 17449
> parent transid verify failed on 911904604160 wanted 17448 found 17449
> parent transid verify failed on 911904604160 wanted 17448 found 17449
> parent transid verify failed on 911904604160 wanted 17448 found 17449
> Ignoring transid failure
> 
> ...And nothing more. Looped.
> 
> 
> # gdb /sbin/btrfsck 31887
> GNU gdb (Gentoo 7.5.1 p2) 7.5.1
> Copyright (C) 2012 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later
> <http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
> and "show warranty" for details.
> This GDB was configured as "x86_64-pc-linux-gnu".
> For bug reporting instructions, please see:
> <http://bugs.gentoo.org/>...
> Reading symbols from /sbin/btrfsck...Reading symbols from
> /usr/lib64/debug/sbin/btrfsck.debug...(no debugging symbols found)...done.
> (no debugging symbols found)...done.
> Attaching to program: /sbin/btrfsck, process 31887
> 
> warning: Could not load shared library symbols for linux-vdso.so.1.
> Do you need "set solib-search-path" or "set sysroot"?
> Reading symbols from /lib64/libuuid.so.1...(no debugging symbols
> found)...done.
> Loaded symbols for /lib64/libuuid.so.1
> Reading symbols from /lib64/libblkid.so.1...(no debugging symbols
> found)...done.
> Loaded symbols for /lib64/libblkid.so.1
> Reading symbols from /lib64/libz.so.1...(no debugging symbols found)...done.
> Loaded symbols for /lib64/libz.so.1
> Reading symbols from /usr/lib64/liblzo2.so.2...(no debugging symbols
> found)...done.
> Loaded symbols for /usr/lib64/liblzo2.so.2
> Reading symbols from /lib64/libpthread.so.0...(no debugging symbols
> found)...done.
> [Thread debugging using libthread_db enabled]
> Using host libthread_db library "/lib64/libthread_db.so.1".
> Loaded symbols for /lib64/libpthread.so.0
> Reading symbols from /lib64/libc.so.6...(no debugging symbols found)...done.
> Loaded symbols for /lib64/libc.so.6
> Reading symbols from /lib64/ld-linux-x86-64.so.2...(no debugging symbols
> found)...done.
> Loaded symbols for /lib64/ld-linux-x86-64.so.2
> 0x000000000042b7a9 in read_extent_buffer ()
> (gdb)
> (gdb) bt
> #0  0x000000000042b7a9 in read_extent_buffer ()
> #1  0x000000000041ccfd in btrfs_check_node ()
> #2  0x000000000041e0a2 in check_block ()
> #3  0x000000000041e69e in btrfs_search_slot ()
> #4  0x0000000000425a6e in find_first_block_group ()
> #5  0x0000000000425b28 in btrfs_read_block_groups ()
> #6  0x0000000000421c40 in btrfs_setup_all_roots ()
> #7  0x0000000000421e3f in __open_ctree_fd ()
> #8  0x0000000000421f19 in open_ctree_fs_info ()
> #9  0x00000000004169b4 in cmd_check ()
> #10 0x000000000040443b in main ()
> (gdb)
> 
> 
> # btrfs version
> Btrfs v0.20-rc1-358-g194aa4a-dirty
> 
> 
>>>> Emerging (1 of 1) sys-fs/btrfs-progs-9999
>>>> Unpacking source...
> GIT update -->
>   repository:
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
>   at the commit:            194aa4a1bd6447bb545286d0bcb0b0be8204d79f
>   branch:                   master
>   storage directory:
> "/usr/portage/distfiles/egit-src/btrfs-progs.git"
>   checkout type:            bare repository
> Cloning into
> '/var/tmp/portage/sys-fs/btrfs-progs-9999/work/btrfs-progs-9999'...
> done.
> Branch branch-master set up to track remote branch master from origin.
> Switched to a new branch 'branch-master'
>>>> Unpacked to
> /var/tmp/portage/sys-fs/btrfs-progs-9999/work/btrfs-progs-9999
>>>> Source unpacked in /var/tmp/portage/sys-fs/btrfs-progs-9999/work
>>>> Preparing source in
> /var/tmp/portage/sys-fs/btrfs-progs-9999/work/btrfs-progs-9999 ...
>>>> Source prepared.
> * Applying user patches from
> /etc/portage/patches//sys-fs/btrfs-progs-9999 ...
> *   jbpatch2013-10-25-extents-fix.patch ...
> 
> 
> [ ok ]
> * Done with patching
>>>> Configuring source in
> /var/tmp/portage/sys-fs/btrfs-progs-9999/work/btrfs-progs-9999 ...
>>>> Source configured.
> [...]
> 
> Note the compile warnings:
> 
> 
> * QA Notice: Package triggers severe warnings which indicate that it
> *            may exhibit random runtime failures.
> * disk-io.c:91:5: warning: dereferencing type-punned pointer will break
> strict-aliasing rules [-Wstrict-aliasing]
> * volumes.c:1905:5: warning: dereferencing type-punned pointer will
> break strict-aliasing rules [-Wstrict-aliasing]
> * volumes.c:1906:6: warning: dereferencing type-punned pointer will
> break strict-aliasing rules [-Wstrict-aliasing]
> 
> 
> * QA Notice: Package triggers severe warnings which indicate that it
> *            may exhibit random runtime failures.
> * cmds-chunk.c:1343:8: warning: array subscript is above array bounds
> [-Warray-bounds]
> 
> 
> 
> (The "jbpatch2013-10-25-extents-fix.patch" is the diff txt of your
> earlier posting.)
> 
> Hope that helps.
> 
> Next?
> 
> Regards,
> Martin
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
