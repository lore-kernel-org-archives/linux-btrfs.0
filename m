Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56531 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752330AbaHVJC5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 05:02:57 -0400
Message-ID: <1408698148.26519.9.camel@localhost.localdomain>
Subject: Re: btrfs restore memory corruption (bug: 82701)
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Marc Dietrich <marvin24@gmx.de>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Date: Fri, 22 Aug 2014 17:02:28 +0800
In-Reply-To: <2743777.ssdxK72F8y@fb07-iapwap2>
References: <2058629.ulFxBAG3Lx@fb07-iapwap2>
	 <2196812.uedtk6DxDd@fb07-iapwap2>
	 <1408689825.22226.14.camel@localhost.localdomain>
	 <2743777.ssdxK72F8y@fb07-iapwap2>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2014-08-22 at 10:42 +0200, Marc Dietrich wrote:
> Am Freitag, 22. August 2014, 14:43:45 schrieb Gui Hecheng:
> > On Thu, 2014-08-21 at 16:19 +0200, Marc Dietrich wrote:
> > > Am Donnerstag, 21. August 2014, 17:52:16 schrieb Gui Hecheng:
> > > > On Mon, 2014-08-18 at 11:25 +0200, Marc Dietrich wrote:
> > > > > Hi,
> > > > > 
> > > > > I did a checkout of the latest btrfs progs to repair my damaged
> > > > > filesystem.
> > > > > Running btrfs restore gives me several failed to inflate: -6 and
> > > > > crashes
> > > > > with some memory corruption. I ran it again with valgrind and got:
> > > > > 
> > > > > valgrind --log-file=x2 -v --leak-check=yes btrfs restore /dev/sda9
> > > > > /mnt/backup
> > > > > 
> > > > > ==8528== Memcheck, a memory error detector
> > > > > ==8528== Copyright (C) 2002-2012, and GNU GPL'd, by Julian Seward et
> > > > > al.
> > > > > ==8528== Using Valgrind-3.8.1 and LibVEX; rerun with -h for copyright
> > > > > info
> > > > > ==8528== Command: btrfs restore /dev/sda9 /mnt/backup
> > > > > ==8528== Parent PID: 8453
> > > > > ==8528==
> > > > > ==8528== Syscall param pwrite64(buf) points to uninitialised byte(s)
> > > > > ==8528==    at 0x59BE3C3: __pwrite_nocancel (in
> > > > > /lib64/libpthread-2.18.so)
> > > > > ==8528==    by 0x41F22F: search_dir (cmds-restore.c:392)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x4204B8: cmd_restore (cmds-restore.c:1284)
> > > > > ==8528==    by 0x4043FE: main (btrfs.c:286)
> > > > > ==8528==  Address 0x66956a0 is 7,056 bytes inside a block of size
> > > > > 8,192
> > > > > alloc'd
> > > > > ==8528==    at 0x4C277AB: malloc (in
> > > > > /usr/lib64/valgrind/vgpreload_memcheck- amd64-linux.so)
> > > > > ==8528==    by 0x41EEAD: search_dir (cmds-restore.c:316)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x4204B8: cmd_restore (cmds-restore.c:1284)
> > > > > ==8528==    by 0x4043FE: main (btrfs.c:286)
> > > > 
> > > > -------------------[snip]---------------------------------
> > > > .... leaks ...
> > > > ----------------------------------------------------------
> >
> > For the leak below...
> > I've no idea why the @decompress_lzo() is not statisfied with @inbuf
> > with the exact size of the disk bytes.
> > Or maybe the compressed data had just sufferred damages...
> > 
> > BTW, when you wrote your data, did that kernel has the following commit
> > for btrfs?
> > 	commit: 59516f6017c589e7316418fda6128ba8f829a77f
> 
> mmh, I used the master branch which is still on 3.14.2 (from k.org).
> 
> Ah, there is a development branch on another repo (repo.or.cz). Why oh why?

There is a development branch for btrfs-progs from david:
http://github.com/kdave/btrfs-progs.git if you would like to try.

But here, what I mean is your *kernel* version when you wrote your data.
There is a change for btrfs-restore which depends on a kernel commit.
If you wrote your data with a older kernel and apply the 3.14.2
btrfs-progs to restore, then there may be wandering stuffs.
Now, I am just suspecting such a scenario.

Thanks,
-Gui

> > 
> > If *NO*, then you may try the following and see if it makes any
> > difference:
> > ---------------------------------------------------------
> > diff --git a/cmds-restore.c b/cmds-restore.c
> > index dde7de8..ae1ea72 100644
> > --- a/cmds-restore.c
> > +++ b/cmds-restore.c
> > @@ -297,7 +297,7 @@ static int copy_one_extent(struct btrfs_root *root,
> > int fd,
> >         ram_size = btrfs_file_extent_ram_bytes(leaf, fi);
> >         offset = btrfs_file_extent_offset(leaf, fi);
> >         num_bytes = btrfs_file_extent_num_bytes(leaf, fi);
> > -       size_left = disk_size;
> > +       size_left = num_bytes;
> >         if (compress == BTRFS_COMPRESS_NONE)
> >                 bytenr += offset;
> > 
> > @@ -376,7 +376,7 @@ again:
> >                 goto out;
> >         }
> > 
> > -       ret = decompress(inbuf, outbuf, disk_size, &ram_size, compress);
> > +       ret = decompress(inbuf, outbuf, num_bytes, &ram_size, compress);
> >         if (ret) {
> >                 num_copies =
> > btrfs_num_copies(&root->fs_info->mapping_tree,
> >                                               bytenr, length);
> > ------------------------------------------------------------------------
> > *NOTE*: the above is just a trial, it is actually not proper, but please
> > don't worry, it does no harm.
> 
> well, my restore finished after 1 week (~ 400 GB of compressed data), from 
> which 100 GB got lost. It wasn't important data so I'm willing to redo the 
> complete restore again if you (or the the btrfs team) is interested in fixing 
> these bugs in the near future.
> 
> I will upload the latest valgrind log for the finial run to the bugzilla on 
> kernel.org (https://bugzilla.kernel.org/show_bug.cgi?id=82701).
> 
> I wonder if there is a corrupted btrfs disk image which can be used as a 
> reference and which triggers all the current error paths (or maybe several 
> images with one error in each one as other projects do). On the other hand, I 
> guess this would be a huge pill of work.
> 
> Marc
> 
> 
> 
> > -Gui
> > 
> > > ==3007== Invalid read of size 1
> > > ==3007==    at 0x57A11B1: lzo1x_decompress_safe (in
> > > /usr/lib64/liblzo2.so.2.0.0)
> > > ==3007==    by 0x41E2C4: decompress (cmds-restore.c:122)
> > > ==3007==    by 0x41F19D: search_dir (cmds-restore.c:378)
> > > ==3007==    by 0x41F8D7: search_dir (cmds-restore.c:895)
> > > ==3007==    by 0x41F8D7: search_dir (cmds-restore.c:895)
> > > ==3007==    by 0x41F8D7: search_dir (cmds-restore.c:895)
> > > ==3007==    by 0x41F8D7: search_dir (cmds-restore.c:895)
> > > ==3007==    by 0x41F8D7: search_dir (cmds-restore.c:895)
> > > ==3007==    by 0x41F8D7: search_dir (cmds-restore.c:895)
> > > ==3007==    by 0x41F8D7: search_dir (cmds-restore.c:895)
> > > ==3007==    by 0x41F8D7: search_dir (cmds-restore.c:895)
> > > ==3007==    by 0x41F8D7: search_dir (cmds-restore.c:895)
> > > ==3007==  Address 0x6887774 is 4 bytes after a block of size 4,096 alloc'd
> > > ==3007==    at 0x4C277AB: malloc (in
> > > /usr/lib64/valgrind/vgpreload_memcheck- amd64-linux.so)
> > > ==3007==    by 0x41EE61: search_dir (cmds-restore.c:309)
> > > ==3007==    by 0x41F8D7: search_dir (cmds-restore.c:895)
> > > ==3007==    by 0x41F8D7: search_dir (cmds-restore.c:895)
> > > ==3007==    by 0x41F8D7: search_dir (cmds-restore.c:895)
> > > ==3007==    by 0x41F8D7: search_dir (cmds-restore.c:895)
> > > ==3007==    by 0x41F8D7: search_dir (cmds-restore.c:895)
> > > ==3007==    by 0x41F8D7: search_dir (cmds-restore.c:895)
> > > ==3007==    by 0x41F8D7: search_dir (cmds-restore.c:895)
> > > ==3007==    by 0x41F8D7: search_dir (cmds-restore.c:895)
> > > ==3007==    by 0x41F8D7: search_dir (cmds-restore.c:895)
> > > ==3007==    by 0x41F8D7: search_dir (cmds-restore.c:895)
> > > 
> > > Thanks so far!
> > > 
> > > Marc
> > > 
> > > > > ==8528== Invalid read of size 2
> > > > > ==8528==    at 0x4C2BFA0: memcpy@@GLIBC_2.14 (in
> > > > > /usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
> > > > > ==8528==    by 0x43818F: read_extent_buffer (string3.h:51)
> > > > > ==8528==    by 0x41EC66: search_dir (cmds-restore.c:233)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x4204B8: cmd_restore (cmds-restore.c:1284)
> > > > > ==8528==    by 0x4043FE: main (btrfs.c:286)
> > > > > ==8528==  Address 0x6b0bfb8 is 632 bytes inside a block of size 4,224
> > > > > free'd ==8528==    at 0x4C28ADC: free (in
> > > > > /usr/lib64/valgrind/vgpreload_memcheck- amd64-linux.so)
> > > > > ==8528==    by 0x437895: free_extent_buffer (extent_io.c:618)
> > > > > ==8528==    by 0x4261CA: btrfs_release_path (ctree.c:61)
> > > > > ==8528==    by 0x426212: btrfs_free_path (ctree.c:51)
> > > > > ==8528==    by 0x41F93B: search_dir (cmds-restore.c:911)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==
> > > > > ==8528== Invalid read of size 2
> > > > > ==8528==    at 0x4C2BFB3: memcpy@@GLIBC_2.14 (in
> > > > > /usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
> > > > > ==8528==    by 0x43818F: read_extent_buffer (string3.h:51)
> > > > > ==8528==    by 0x41EC66: search_dir (cmds-restore.c:233)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x4204B8: cmd_restore (cmds-restore.c:1284)
> > > > > ==8528==    by 0x4043FE: main (btrfs.c:286)
> > > > > ==8528==  Address 0x6b0bfb4 is 628 bytes inside a block of size 4,224
> > > > > free'd ==8528==    at 0x4C28ADC: free (in
> > > > > /usr/lib64/valgrind/vgpreload_memcheck- amd64-linux.so)
> > > > > ==8528==    by 0x437895: free_extent_buffer (extent_io.c:618)
> > > > > ==8528==    by 0x4261CA: btrfs_release_path (ctree.c:61)
> > > > > ==8528==    by 0x426212: btrfs_free_path (ctree.c:51)
> > > > > ==8528==    by 0x41F93B: search_dir (cmds-restore.c:911)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > ==8528==
> > > > > ==8528==
> > > > > ==8528== HEAP SUMMARY:
> > > > > ==8528==     in use at exit: 0 bytes in 0 blocks
> > > > > ==8528==   total heap usage: 260,452 allocs, 260,452 frees,
> > > > > 278,189,550
> > > > > bytes allocated
> > > > > ==8528==
> > > > > ==8528== All heap blocks were freed -- no leaks are possible
> > > > > ==8528==
> > > > > ==8528== For counts of detected and suppressed errors, rerun with: -v
> > > > > ==8528== Use --track-origins=yes to see where uninitialised values
> > > > > come
> > > > > from ==8528== ERROR SUMMARY: 16597 errors from 7 contexts (suppressed:
> > > > > 2
> > > > > from 2)
> > > > > 
> > > > > see: https://bugzilla.kernel.org/show_bug.cgi?id=82701
> > > > > 
> > > > > Marc
> > > > > 
> > > > > p.s.
> > > > > 
> > > > > I wonder if this list should be autosubscribed to btrfs related bugs
> > > > > 
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
> > > > > in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html


