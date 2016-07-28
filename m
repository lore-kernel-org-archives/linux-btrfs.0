Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:35328 "EHLO
	mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757694AbcG1OBj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 10:01:39 -0400
Received: by mail-vk0-f65.google.com with SMTP id x130so1814889vkc.2
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 07:01:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160728122439.GW30795@twin.jikos.cz>
References: <CADxRZqyXtmf7LMB4ogwp8Af4Nd+Md7YtiTWRpC2xjM_fG3YKJw@mail.gmail.com>
 <20160727195609.GN30795@twin.jikos.cz> <20160728094441.GO30795@twin.jikos.cz>
 <CADxRZqwTUaZyDipvmGcfk8Q9P2X_NLQ=9svtc8BbKeFqoFVPdw@mail.gmail.com>
 <5cef3bff-a0bf-e4f9-7906-1b784171e266@physik.fu-berlin.de> <20160728122439.GW30795@twin.jikos.cz>
From: Anatoly Pugachev <matorola@gmail.com>
Date: Thu, 28 Jul 2016 17:01:37 +0300
Message-ID: <CADxRZqyzOtHmpaO9FHhvi0DJjmabRYL0eGYBXBPXSaYa0WcWEw@mail.gmail.com>
Subject: Re: [sparc64] mkfs.btrfs bus error / align issue?
To: dsterba@suse.cz
Cc: debian-sparc <debian-sparc@lists.debian.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 28, 2016 at 3:24 PM, David Sterba <dsterba@suse.cz> wrote:
> On Thu, Jul 28, 2016 at 02:09:03PM +0200, John Paul Adrian Glaubitz wrote:
>> Hi David!
>>
>> On 07/28/2016 01:58 PM, Anatoly Pugachev wrote:
>> >> Can you please test with the current 'devel' branch? Fixed by the patch
>> >> "btrfs-progs: fix unaligned access calculating raid56 data" (depends on
>> >> another patch in devel). Thanks.
>>
>> Are you sure you pushed these changes? I don't see them in the devel branch [1].
>
> Oh shame, of course not. Now pushed.

David,

after checkout of devel tree:

mator@nvg5120:~/devel$ git describe
v4.6.1-64-g6d1564c
mator@nvg5120:~/devel$ git remote -v
origin  git://repo.or.cz/btrfs-progs-unstable/devel.git (fetch)
origin  git://repo.or.cz/btrfs-progs-unstable/devel.git (push)
mator@nvg5120:~/devel$ git branch
* devel
  master


a new place discovered:

Reading symbols from /opt/btrfs/bin/mkfs.btrfs...done.
(gdb) set args -f -draid6 -mraid6 /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3
(gdb) run
Starting program: /opt/btrfs/bin/mkfs.btrfs -f -draid6 -mraid6
/dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/sparc64-linux-gnu/libthread_db.so.1".
btrfs-progs v4.6.1-64-g6d1564c
See http://btrfs.wiki.kernel.org for more information.

ERROR: superblock checksum mismatch
ERROR: superblock checksum mismatch
ERROR: superblock checksum mismatch
Performing full device TRIM (2.00GiB) ...
Performing full device TRIM (2.00GiB) ...
Performing full device TRIM (2.00GiB) ...
Performing full device TRIM (2.00GiB) ...

Program received signal SIGBUS, Bus error.
0x0000000000177dfc in raid6_gen_syndrome (disks=4, bytes=65536,
ptrs=0x2c4510) at raid6.c:87
87                      wq0 = wp0 = *(unative_t *)&dptr[z0][d+0*NSIZE];
(gdb) bt
#0  0x0000000000177dfc in raid6_gen_syndrome (disks=4, bytes=65536,
ptrs=0x2c4510) at raid6.c:87
#1  0x000000000015e174 in write_raid56_with_parity (info=0x2b37b0,
eb=0x2c9fe0, multi=0x2c4870, stripe_len=65536, raid_map=0x2c4570)
    at volumes.c:2151
#2  0x0000000000119bd0 in write_and_map_eb (trans=0x2ce250,
root=0x2c9d80, eb=0x2c9fe0) at disk-io.c:426
#3  0x0000000000119f14 in write_tree_block (trans=0x2ce250,
root=0x2c9d80, eb=0x2c9fe0) at disk-io.c:459
#4  0x000000000011a54c in __commit_transaction (trans=0x2ce250,
root=0x2c9d80) at disk-io.c:562
#5  0x000000000011a858 in btrfs_commit_transaction (trans=0x2ce250,
root=0x2c9d80) at disk-io.c:598
#6  0x00000000001a52e8 in main (argc=8, argv=0x7fefffff698) at mkfs.c:1809
(gdb)
