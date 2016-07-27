Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35014 "EHLO
	mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbcG0Ujh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jul 2016 16:39:37 -0400
Received: by mail-qk0-f195.google.com with SMTP id q62so3451627qkf.2
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jul 2016 13:39:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADxRZqyXtmf7LMB4ogwp8Af4Nd+Md7YtiTWRpC2xjM_fG3YKJw@mail.gmail.com>
References: <CADxRZqyXtmf7LMB4ogwp8Af4Nd+Md7YtiTWRpC2xjM_fG3YKJw@mail.gmail.com>
From: Patrick Baggett <baggett.patrick@gmail.com>
Date: Wed, 27 Jul 2016 15:39:35 -0500
Message-ID: <CAEk2StmNnMag9+ve7brmG+=JCFasgNcR+RubVfYqbnhvqKCMtw@mail.gmail.com>
Subject: Re: [sparc64] mkfs.btrfs bus error / align issue?
To: Anatoly Pugachev <matorola@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 27, 2016 at 8:59 AM, Anatoly Pugachev <matorola@gmail.com> wrote:
>
> Hello!
>
> Running xfstests suite, got in logs mkfs.btrfs bus error, debugging it
> shows the following :
>
> mator@nvg5120:~/btrfs-progs$ git log -1 --oneline
> 40650bf Btrfs progs v4.6.1
>
> root@nvg5120:/home/mator/xfstests# gdb
> GNU gdb (Debian 7.11.1-2) 7.11.1
> (gdb) file /opt/btrfs/bin/mkfs.btrfs
> Reading symbols from /opt/btrfs/bin/mkfs.btrfs...done.
> (gdb) set args -f -draid5 -mraid5 /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3
> (gdb) run
> Starting program: /opt/btrfs/bin/mkfs.btrfs -f -draid5 -mraid5
> /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3
> [Thread debugging using libthread_db enabled]
> Using host libthread_db library "/lib/sparc64-linux-gnu/libthread_db.so.1".
> btrfs-progs v4.6.1
> See http://btrfs.wiki.kernel.org for more information.
>
> ERROR: superblock checksum mismatch
> ERROR: superblock checksum mismatch
> ERROR: superblock checksum mismatch
> Performing full device TRIM (2.00GiB) ...
> Performing full device TRIM (2.00GiB) ...
> Performing full device TRIM (2.00GiB) ...
> Performing full device TRIM (2.00GiB) ...
>
> Program received signal SIGBUS, Bus error.
> 0x000000000015e160 in write_raid56_with_parity (info=0x2b17b0,
> eb=0x2c7fe0, multi=0x2c2870, stripe_len=65536, raid_map=0x2c2570) at
> volumes.c:2156
> 2156                                    *(unsigned long *)(p_eb->data + i) ^=
> (gdb) bt
> #0  0x000000000015e160 in write_raid56_with_parity (info=0x2b17b0,
> eb=0x2c7fe0, multi=0x2c2870, stripe_len=65536, raid_map=0x2c2570)
>     at volumes.c:2156
> #1  0x0000000000119b30 in write_and_map_eb (trans=0x2cc250,
> root=0x2c7d80, eb=0x2c7fe0) at disk-io.c:426
> #2  0x0000000000119e74 in write_tree_block (trans=0x2cc250,
> root=0x2c7d80, eb=0x2c7fe0) at disk-io.c:459
> #3  0x000000000011a4ac in __commit_transaction (trans=0x2cc250,
> root=0x2c7d80) at disk-io.c:562
> #4  0x000000000011a7b8 in btrfs_commit_transaction (trans=0x2cc250,
> root=0x2c7d80) at disk-io.c:598
> #5  0x00000000001a2b04 in main (argc=8, argv=0x7fefffff698) at mkfs.c:1786
> (gdb)
>
> Can someone help please? Thanks.
>

The code that faults:

(unsigned long *)(p_eb->data + i) ^= *(unsigned long *)(ebs[j]->data + i);

Because struct extent_buffer has 'data' as a char[], this will always
fault on sparc64 and probably a number of other RISC architectures. It
increments the address by 1, then reads an 8-byte chunk, XORs, and
writes the 8-byte chunk, repeat. In other words, 7 out of 8 reads
would fault, even if both `data` pointers were 8-byte aligned.

This would probably fix it, though it looks ugly.
unsigned long a, b;
memcpy(&a, p_eb->data + i, sizeof(a));  /* Read 8 bytes from p_eb->data+i */
memcpy(&b, ebs[j]->data + i, sizeof(b)); /* Read 8 bytes from ebs[j]->data+i */
a ^= b; /* XOR */
memcpy(p_eb->data + i, &a, sizeof(a)); /* Write back to p_eb->data+i */

I'm not familiar with btrfs, but the results seems like they depend on
the sizeof(unsigned long). Given that they used parentheses, I assume
it was intentional. However, if this was supposed to do an XOR
operation 8 bytes at a time, then it would need to be something like:

*(((unsigned long *)p_eb->data)+i) ^= *(((unsigned long *)ebs[j]->data) + i);

i.e. cast pointer to unsigned long*, then add i (which would index
array of unsigned long, not char).

--Patrick
