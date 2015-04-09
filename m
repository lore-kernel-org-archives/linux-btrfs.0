Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:38865 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933311AbbDIJ1z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 05:27:55 -0400
Received: by igbqf9 with SMTP id qf9so59910750igb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2015 02:27:55 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <537844F2.1040507@gmail.com>
References: <537844F2.1040507@gmail.com>
Date: Thu, 9 Apr 2015 10:27:54 +0100
Message-ID: <CAL3q7H7ovr1Ai54ptt+0qofU_T4TZYG15LT4e2K3zN2VHoDD9w@mail.gmail.com>
Subject: Re: BTRFS corruption w/kernel 3.13 while using docker -s btrfs
From: Filipe David Manana <fdmanana@gmail.com>
To: Paul Harvey <csirac2@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 18, 2014 at 6:28 AM, Paul Harvey <csirac2@gmail.com> wrote:
> This is a "Damnit! I held the power button in and now it won't mount!"
> story, but I'm sharing what I found to learn what I can. And in case it's
> useful for btrfs development.
>
> Also curious if my usage of Docker (an LXC thing, http://docker.io) has
> exacerbated things. I ask because it seems some btrfs mount options are
> breaking docker:
> https://github.com/dotcloud/docker/issues/5429#issuecomment-42443919 -
> however, I'm not using space_cache or inode_cache myself.
>
> Notes:
> - I've taken a dd copy of the btrfs partition so that I can perform anything
> extra people would like to see.
> - The following output is taken from the same machine, same partition layout
> but a fresh/working Debian testing install on a different disk. It should be
> reporting the same as it did before the corruption (it was definitely Linux
> 3.13).
> - /dev/sda is a new disk, /dev/sdb3 is the corrupted btrfs partition.
> - I have a single btrfs partition which contains the rootfs. I use
> subvolumes to separately snapshot /home, /vms, etc.
> - mount options were: noatime,autodefrag,discard,compress=lzo

Don't use the discard option on this kernel release. There are 2 know
bugs that made btrfs issue a discard on extents when it shouldn't,
which results in those messages you are seeing "btrfs bad tree block
start 0 xxxxxxxxxxx" (the key part is the 0 following the word start).
The fixes are:

1) https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=678886bdc6378c1cbd5072da2c5a3035000214e3
    Happens both with -o discard and without it if you run fstrim
after the fs went into readonly mode. This is included in most stable
releases afaik, but certainly not in the kernel version you are using.
The btrfs-zero-log tool won't help here;

2) https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=dcc82f4783ad91d4ab654f89f37ae9291cdc846a
   Happens only with -o discard, and affects only the fsync log. You
can get your fs mountable again after using btrfs-zero-log (but losing
all data fsynced in the transaction that was open when a crash/reboot
happened). Not yet in any kernel release, only on linux-next at the
moment.

>
> $ uname -a
> Linux weatherwax 3.13-1-amd64 #1 SMP Debian 3.13.10-1 (2014-04-15)
> x86_64 GNU/Linux
> $ sudo btrfs version
> Btrfs v3.14.1
> $ sudo btrfs fi show /dev/sdb3
> Label: 'weatherwax 0'  uuid: 721926c3-147a-44a0-8c82-62534dd6ee94
>          Total devices 1 FS bytes used 246.14GiB
>          devid    1 size 357.63GiB used 313.06GiB path /dev/sdb3
>
> Btrfs v3.14.1
> $ dmesg # see attached dmesg.txt, includes connecting corrupted disk via USB
> $ sudo mount -o recovery,ro /dev/sdb3 /mnt
> mount: wrong fs type, bad option, bad superblock on /dev/sdb3,
>         missing codepage or helper program, or other error
>         In some cases useful info is found in syslog - try
>         dmesg | tail  or so
> [ 1297.632057] btrfs: device label weatherwax 0 devid 1 transid 504075
> /dev/sdb3
> [ 1297.633042] btrfs: enabling auto recovery
> [ 1297.633045] btrfs: disk space caching is enabled
> [ 1297.830793] btrfs bad tree block start 0 632081858560
> [ 1297.831012] btrfs bad tree block start 0 632081858560
> [ 1297.831016] btrfs: failed to read log tree
> [ 1297.892241] btrfs: open_ctree failed
> $ sudo btrfs-find-root /dev/sdb3
> Super think's the tree root is at 632081670144, chunk root 386274426880
> Went past the fs size, exiting
> $ sudo btrfs-image -c9 -t4 /dev/sdb3 /mnt/sdb3.img
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> read block failed check_tree_block
> Couldn't setup log root tree
> Open ctree failed
> create failed (Success)
> $ du /mnt/sdb3.img
> 0       /mnt/sdb3.img
> $ sudo btrfs rescue chunk-recover /dev/sdb3 # Takes a few hours at
> 30MiB/sec, reports 326 (IIRC) good chunks, no bad or orphaned chunks.
> $ sudo btrfs restore -i /dev/sdb3 /mnt # recovers ~3.2GB of /var from
> the old rootfs, nothing useful. A lot of "failed to inflate: -6"
> $ sudo btrfs restore -l /dev/sdb3
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> read block failed check_tree_block
> Couldn't setup log root tree
>   tree key (EXTENT_TREE ROOT_ITEM 0) 632081240064 level 3
>   tree key (DEV_TREE ROOT_ITEM 0) 631709724672 level 1
>   tree key (FS_TREE ROOT_ITEM 0) 632081072128 level 3
>   tree key (CSUM_TREE ROOT_ITEM 0) 632079880192 level 3
>   tree key (UUID_TREE ROOT_ITEM 0) 632070057984 level 0
>   tree key (262 ROOT_ITEM 0) 632079863808 level 3
>   tree key (263 ROOT_ITEM 0) 530849677312 level 2
>   tree key (264 ROOT_ITEM 0) 632081104896 level 3
>   tree key (265 ROOT_ITEM 0) 632070590464 level 3
>   tree key (577 ROOT_ITEM 0) 633083752448 level 2
> # ... ~80 more lines of similar output
> $ sudo btrfsck /dev/sdb3 # exits quickly, < 2s
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> read block failed check_tree_block
> Couldn't setup log root tree
> Checking filesystem on /dev/sdb3
> UUID: 721926c3-147a-44a0-8c82-62534dd6ee94
> checking extents
> btrfsck[5378]: segfault at 1d8 ip 00000000004176d4 sp 00007fff50ed58a0 error
> 4 in btrfsck[400000+57000] # from dmesg
> $ sudo btrfsck --backup /dev/sdb3 # same output as above, exits just as
> quickly
> btrfsck[5384]: segfault at 1d8 ip 00000000004176d4 sp 00007fff1bf37df0 error
> 4 in btrfsck[400000+57000] # from dmesg
> $ sudo btrfsck --repair -s 1 /dev/sdb3
> using SB copy 1, bytenr 274877906944
> Checking filesystem on /dev/sdb3
> UUID: 721926c3-147a-44a0-8c82-62534dd6ee94
> checking extents
> checking free space cache
> checking fs roots
> root 5 inode 374153 errors 400, nbytes wrong
> root 5 inode 374156 errors 400, nbytes wrong
> root 5 inode 374157 errors 400, nbytes wrong
> root 5 inode 374159 errors 400, nbytes wrong
> root 5 inode 374160 errors 400, nbytes wrong
> root 5 inode 374162 errors 400, nbytes wrong
> root 5 inode 374163 errors 400, nbytes wrong
> found 142401001787 bytes used err is 1
> total csum bytes: 254703028
> total tree bytes: 2354339840
> total fs tree bytes: 1903390720
> total extent tree bytes: 145313792
> btree space waste bytes: 541129559
> file data blocks allocated: 1952295919616
>   referenced 257779679232
> Btrfs v3.14.1
> $ sudo mount -o recovery,ro /dev/sdb3 /media/usb1/
> [ 5005.342936] btrfs: device label weatherwax 0 devid 1 transid 504075
> /dev/sdb3
> [ 5005.343763] btrfs: enabling auto recovery
> [ 5005.343767] btrfs: disk space caching is enabled
> [ 5005.541425] btrfs bad tree block start 0 632081858560
> [ 5005.541641] btrfs bad tree block start 0 632081858560
> [ 5005.541646] btrfs: failed to read log tree
> [ 5005.604631] btrfs: open_ctree failed
> $ sudo btrfs restore -i -r 262 /dev/sdb3 /mnt/home/ # This ends up
> recovering most of the subvol I want to recover.
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> read block failed check_tree_block
> Couldn't setup log root tree
> failed to inflate: -6
> $ sudo btrfs restore -i -r 263 /dev/sdb3 /mnt/vms/ # This recovers a fair
> chunk of another subvol, not all...
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> read block failed check_tree_block
> Couldn't setup log root tree
> failed to inflate: -6
> failed to inflate: -6
> failed to inflate: -8
> failed to inflate: -6
> failed to inflate: -6
> failed to inflate: -6
> failed to inflate: -6
> failed to inflate: -8
> failed to inflate: -6
> *** Error in `btrfs': double free or corruption (out): 0x0000000002279f50
> ***
> btrfs: malloc.c:2368: sysmalloc: Assertion `(old_top == (((mbinptr) (((char
> *) &((av)->bins[((1) - 1) * 2])) - __builtin_offsetof (struct
> malloc_chunk, fd)))) && old_size == 0) || ((unsigned long) (old_size) >=
> (unsigned long)((((__builtin_offsetof (struct malloc_chunk,
> fd_nextsize))+((2 * (sizeof(size_t))) - 1)) & ~((2 * (sizeof(size_t))) -
> 1))) && ((old_top)->size & 0x1) && ((unsigned long)old_end &
> pagemask) == 0)' failed.
>
> A timeline, starting around midday yesterday:
> - I had some work to do and the VPN was slow, so on my laptop I upgraded
> docker from ~0.8.1 to 0.11.1.
> - The upgrade stomped on my "-s btrfs" switch in /etc/default/docker which
> meant I was accidentally using docker with aufs for a while.
> - I fixed this then purged all the containers and images (i.e. btrfs
> subvolumes).
> - I did "docker pull debian:testing" which would have created a few new
> btrfs subvolumes.
> - I ran some "docker build"s and at some point I had two builds going at
> once (two docker processes each creating btrfs subvolumes/snapshots at the
> same time).
> - At some point one docker build was completed and the other was stalled
> trying to create a snapshot.
> - Minutes later I noticed that my other applications were freezing up. The
> UI was still responsive and I could use the terminal.
> - I looked at syslog and dmesg output in a terminal. There were no messages,
> ominous or otherwise coinciding with the disk i/o freezing up.
> - I held in the power button.
> - The reboot didn't boot. I ended up with the dreaded busybox shell, unable
> to mount btrfs rootfs...
> - Removed disk and took a dd copy of sda3.
>
> Other research...
> Certain BTRFS mount options break docker -s btrfs:
> - https://github.com/dotcloud/docker/issues/5429#issuecomment-42443919
>
> The "AUFS on btrfs" thing has a few mentions in docker issues, perhaps it's
> nothing to do with btrfs though:
> - https://github.com/dotcloud/docker/issues/829 - continued at...
> - https://github.com/dotcloud/docker/issues/1075 - continued at...
> - https://github.com/dotcloud/docker/issues/2961
> - https://github.com/dotcloud/docker/issues/2056 # just another datapoint.
>
> Cheers
>
> --
> Paul Harvey
>
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
