Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35004 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbcFXFUn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 01:20:43 -0400
Received: by mail-oi0-f51.google.com with SMTP id r2so101509649oih.2
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 22:20:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160624020712.GC14667@hungrycats.org>
References: <20160620034427.GK15597@hungrycats.org> <20160620231351.1833a341@natsu>
 <20160620191112.GL15597@hungrycats.org> <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org> <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org> <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <CAJCQCtT57k7Mirq=d6wTewY6EzvJE0g28EbmG9wLk+6cTASEEg@mail.gmail.com> <20160624020712.GC14667@hungrycats.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 23 Jun 2016 23:20:40 -0600
Message-ID: <CAJCQCtSt832VcaKanj9cn9wY6+FZ68G9mOuSS=8i-AzmGQuV9g@mail.gmail.com>
Subject: Re: Adventures in btrfs raid5 disk recovery
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Chris Murphy <lists@colorremedies.com>, Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2016 at 8:07 PM, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:

>> With simple files changing one character with vi and gedit,
>> I get completely different logical and physical numbers with each
>> change, so it's clearly cowing the entire stripe (192KiB in my 3 dev
>> raid5).
>
> You are COWing the entire file because vi and gedit do truncate followed
> by full-file write.

I'm seeing the file inode changes with either a vi or gedit
modification, even when file size is exactly the same, just character
substitute. So as far as VFS and Btrfs are concerned, it's an entirely
different file, so it's like faux-CoW that would have happened on any
file system, not an overwrite.


> Try again with 'dd conv=notrunc bs=4k count=1 seek=N of=...' or
> edit the file with a sector-level hex editor.

The inode is now the same, one of the 4096 byte blocks is
dereferenced, a new 4096 byte block is referenced, and written, the
other 3 blocks remain untouched, the other files in the stripe remain
untouched. So it's pretty clearly cow'd in this case.

[root@f24s ~]# filefrag -v /mnt/5/*
Filesystem type is: 9123683e
File size of /mnt/5/a.txt is 16383 (4 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       3:    2931712..   2931715:      4:             last,eof
/mnt/5/a.txt: 1 extent found
File size of /mnt/5/b.txt is 16383 (4 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       3:    2931716..   2931719:      4:             last,eof
/mnt/5/b.txt: 1 extent found
File size of /mnt/5/c.txt is 16383 (4 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       3:    2931720..   2931723:      4:             last,eof
/mnt/5/c.txt: 1 extent found
File size of /mnt/5/d.txt is 16383 (4 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       3:    2931724..   2931727:      4:             last,eof
/mnt/5/d.txt: 1 extent found
File size of /mnt/5/e.txt is 16383 (4 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       3:    2931728..   2931731:      4:             last,eof
/mnt/5/e.txt: 1 extent found

[root@f24s ~]# ls -li /mnt/5/*
285 -rw-r--r--. 1 root root 16383 Jun 23 22:57 /mnt/5/a.txt
286 -rw-r--r--. 1 root root 16383 Jun 23 22:57 /mnt/5/b.txt
287 -rw-r--r--. 1 root root 16383 Jun 23 22:57 /mnt/5/c.txt
288 -rw-r--r--. 1 root root 16383 Jun 23 22:57 /mnt/5/d.txt
289 -rw-r--r--. 1 root root 16383 Jun 23 22:57 /mnt/5/e.txt

[root@f24s ~]# btrfs-map-logical -l $[4096*2931712] /dev/VG/a
mirror 1 logical 12008292352 physical 34603008 device /dev/mapper/VG-a
mirror 2 logical 12008292352 physical 1108344832 device /dev/mapper/VG-c
[root@f24s ~]# btrfs-map-logical -l $[4096*2931716] /dev/VG/a
mirror 1 logical 12008308736 physical 34619392 device /dev/mapper/VG-a
mirror 2 logical 12008308736 physical 1108361216 device /dev/mapper/VG-c
[root@f24s ~]# btrfs-map-logical -l $[4096*2931720] /dev/VG/a
mirror 1 logical 12008325120 physical 34635776 device /dev/mapper/VG-a
mirror 2 logical 12008325120 physical 1108377600 device /dev/mapper/VG-c
[root@f24s ~]# btrfs-map-logical -l $[4096*2931724] /dev/VG/a
mirror 1 logical 12008341504 physical 34652160 device /dev/mapper/VG-a
mirror 2 logical 12008341504 physical 1108393984 device /dev/mapper/VG-c
[root@f24s ~]# btrfs-map-logical -l $[4096*2931728] /dev/VG/a
mirror 1 logical 12008357888 physical 1048576 device /dev/mapper/VG-b
mirror 2 logical 12008357888 physical 1108344832 device /dev/mapper/VG-c


[root@f24s ~]# echo -n "g" | dd of=/mnt/5/a.txt conv=notrunc
0+1 records in
0+1 records out
1 byte copied, 0.000314582 s, 3.2 kB/s
[root@f24s ~]# ls -li /mnt/5/*
285 -rw-r--r--. 1 root root 16383 Jun 23 23:06 /mnt/5/a.txt
286 -rw-r--r--. 1 root root 16383 Jun 23 22:57 /mnt/5/b.txt
287 -rw-r--r--. 1 root root 16383 Jun 23 22:57 /mnt/5/c.txt
288 -rw-r--r--. 1 root root 16383 Jun 23 22:57 /mnt/5/d.txt
289 -rw-r--r--. 1 root root 16383 Jun 23 22:57 /mnt/5/e.txt

[root@f24s ~]# filefrag -v /mnt/5/*
Filesystem type is: 9123683e
File size of /mnt/5/a.txt is 16383 (4 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       0:    2931732..   2931732:      1:
   1:        1..       3:    2931713..   2931715:      3:    2931733: last,eof
/mnt/5/a.txt: 2 extents found
File size of /mnt/5/b.txt is 16383 (4 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       3:    2931716..   2931719:      4:             last,eof
/mnt/5/b.txt: 1 extent found
File size of /mnt/5/c.txt is 16383 (4 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       3:    2931720..   2931723:      4:             last,eof
/mnt/5/c.txt: 1 extent found
File size of /mnt/5/d.txt is 16383 (4 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       3:    2931724..   2931727:      4:             last,eof
/mnt/5/d.txt: 1 extent found
File size of /mnt/5/e.txt is 16383 (4 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       3:    2931728..   2931731:      4:             last,eof
/mnt/5/e.txt: 1 extent found

[root@f24s ~]# btrfs-map-logical -l $[4096*2931732] /dev/VG/a
mirror 1 logical 12008374272 physical 1064960 device /dev/mapper/VG-b
mirror 2 logical 12008374272 physical 1108361216 device /dev/mapper/VG-c


It has been cow'd.

[root@f24s ~]# dd if=/dev/VG/b bs=1 skip=1064960 count=4096
2>/dev/null | hexdump -C
00000000  67 61 61 61 61 61 61 61  61 61 61 61 61 61 61 61  |gaaaaaaaaaaaaaaa|
00000010  61 61 61 61 61 61 61 61  61 61 61 61 61 61 61 61  |aaaaaaaaaaaaaaaa|
*
00001000
[root@f24s ~]# dd if=/dev/VG/c bs=1 skip=1108361216 count=4096
2>/dev/null | hexdump -C
00000000  05 03 03 03 03 03 03 03  03 03 03 03 03 03 03 03  |................|
00000010  03 03 03 03 03 03 03 03  03 03 03 03 03 03 03 03  |................|
*
00001000
[root@f24s ~]# btrfs-map-logical -l $[4096*2931712] /dev/VG/a
mirror 1 logical 12008292352 physical 34603008 device /dev/mapper/VG-a
mirror 2 logical 12008292352 physical 1108344832 device /dev/mapper/VG-c
[root@f24s ~]# dd if=/dev/VG/a bs=1 skip=34603008 count=4096
2>/dev/null | hexdump -C
00000000  61 61 61 61 61 61 61 61  61 61 61 61 61 61 61 61  |aaaaaaaaaaaaaaaa|
*
00001000


So at the old address, it shows the "aaaaa..." is still there. And at
the added single block for this file at new logical and physical
addresses, is the modification substituting the first "a" for "g".

In this case, no rmw, no partial stripe modification, and no data
already on-disk is at risk. Even the metadata leaf/node is cow'd, it
has a new logical and physical address as well, which contains
information for all five files.


-- 
Chris Murphy
