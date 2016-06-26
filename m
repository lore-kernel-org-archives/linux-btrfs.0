Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:36829 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbcFZTaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jun 2016 15:30:07 -0400
Received: by mail-oi0-f44.google.com with SMTP id f189so176523810oig.3
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jun 2016 12:30:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <576F8A28.7060808@gmail.com>
References: <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org> <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org> <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <20160622203504.GQ15597@hungrycats.org> <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
 <CAJCQCtRXqSCFZTca+Vwraa0vS-MzLQKEkr=s41Vypc-O0ZDdxQ@mail.gmail.com>
 <20160624014752.GB14667@hungrycats.org> <576CB0DA.6030409@gmail.com>
 <20160624085014.GH3325@carfax.org.uk> <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
 <CAJCQCtQBQAng5_mNJZev+64Z15BSkBkG9f2qmz=ckPRqXRbbWA@mail.gmail.com>
 <576D6C0A.7070502@gmail.com> <CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
 <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com> <CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
 <CAJCQCtQhRbL_AWpspudPZzkkGkHT3O9T0QL94Of5LD8agmonwg@mail.gmail.com> <576F8A28.7060808@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 26 Jun 2016 13:30:03 -0600
Message-ID: <CAJCQCtSTau3D39TarW2gag0HgW6U9tj8u3gXVTBMTNRy7wMUbg@mail.gmail.com>
Subject: Re: Adventures in btrfs raid5 disk recovery
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, kreijack@inwind.it,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 26, 2016 at 1:54 AM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> 26.06.2016 00:52, Chris Murphy пишет:
>> Interestingly enough, so far I'm finding with full stripe writes, i.e.
>> 3x raid5, exactly 128KiB data writes, devid 3 is always parity. This
>> is raid4.
>
> That's not what code suggests and what I see in practice - parity seems
> to be distributed across all disks; each new 128KiB file (extent) has
> parity on new disk. At least as long as we can trust btrfs-map-logical
> to always show parity as "mirror 2".


tl;dr Andrei is correct there's no raid4 behavior here.

Looks like mirror 2 is always parity, more on that below.


>
> Do you see consecutive full stripes in your tests? Or how do you
> determine which devid has parity for a given full stripe?

I do see consecutive full stripe writes, but it doesn't always happen.
But not checking the consecutivity is where I became confused.

[root@f24s ~]# filefrag -v /mnt/5/ab*
Filesystem type is: 9123683e
File size of /mnt/5/ab128_2.txt is 131072 (32 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..      31:    3456128..   3456159:     32:             last,eof
/mnt/5/ab128_2.txt: 1 extent found
File size of /mnt/5/ab128_3.txt is 131072 (32 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..      31:    3456224..   3456255:     32:             last,eof
/mnt/5/ab128_3.txt: 1 extent found
File size of /mnt/5/ab128_4.txt is 131072 (32 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..      31:    3456320..   3456351:     32:             last,eof
/mnt/5/ab128_4.txt: 1 extent found
File size of /mnt/5/ab128_5.txt is 131072 (32 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..      31:    3456352..   3456383:     32:             last,eof
/mnt/5/ab128_5.txt: 1 extent found
File size of /mnt/5/ab128_6.txt is 131072 (32 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..      31:    3456384..   3456415:     32:             last,eof
/mnt/5/ab128_6.txt: 1 extent found
File size of /mnt/5/ab128_7.txt is 131072 (32 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..      31:    3456416..   3456447:     32:             last,eof
/mnt/5/ab128_7.txt: 1 extent found
File size of /mnt/5/ab128_8.txt is 131072 (32 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..      31:    3456448..   3456479:     32:             last,eof
/mnt/5/ab128_8.txt: 1 extent found
File size of /mnt/5/ab128_9.txt is 131072 (32 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..      31:    3456480..   3456511:     32:             last,eof
/mnt/5/ab128_9.txt: 1 extent found
File size of /mnt/5/ab128.txt is 131072 (32 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..      31:    3456096..   3456127:     32:             last,eof
/mnt/5/ab128.txt: 1 extent found

Starting with the bottom file then from the top so they're in 4096
byte block order; and the 2nd column is the difference in value:

3456096
3456128 32
3456224 96
3456320 96
3456352 32
3456384 32
3456416 32
3456448 32
3456480 32

So the first two files are consecutive full stripe writes. The next
two aren't. The next five are. They were all copied at the same time.
I don't know why they aren't always consecutive writes.


[root@f24s ~]# btrfs-map-logical -l $[4096*3456096] /dev/VG/a
mirror 1 logical 14156169216 physical 1108541440 device /dev/mapper/VG-a
mirror 2 logical 14156169216 physical 2182283264 device /dev/mapper/VG-c
[root@f24s ~]# btrfs-map-logical -l $[4096*3456128] /dev/VG/a
mirror 1 logical 14156300288 physical 1075052544 device /dev/mapper/VG-b
mirror 2 logical 14156300288 physical 1108606976 device /dev/mapper/VG-a
[root@f24s ~]# btrfs-map-logical -l $[4096*3456224] /dev/VG/a
mirror 1 logical 14156693504 physical 1075249152 device /dev/mapper/VG-b
mirror 2 logical 14156693504 physical 1108803584 device /dev/mapper/VG-a
[root@f24s ~]# btrfs-map-logical -l $[4096*3456320] /dev/VG/a
mirror 1 logical 14157086720 physical 1075445760 device /dev/mapper/VG-b
mirror 2 logical 14157086720 physical 1109000192 device /dev/mapper/VG-a
[root@f24s ~]# btrfs-map-logical -l $[4096*3456352] /dev/VG/a
mirror 1 logical 14157217792 physical 2182807552 device /dev/mapper/VG-c
mirror 2 logical 14157217792 physical 1075511296 device /dev/mapper/VG-b
[root@f24s ~]# btrfs-map-logical -l $[4096*3456384] /dev/VG/a
mirror 1 logical 14157348864 physical 1109131264 device /dev/mapper/VG-a
mirror 2 logical 14157348864 physical 2182873088 device /dev/mapper/VG-c
[root@f24s ~]# btrfs-map-logical -l $[4096*3456416] /dev/VG/a
mirror 1 logical 14157479936 physical 1075642368 device /dev/mapper/VG-b
mirror 2 logical 14157479936 physical 1109196800 device /dev/mapper/VG-a
[root@f24s ~]# btrfs-map-logical -l $[4096*3456448] /dev/VG/a
mirror 1 logical 14157611008 physical 2183004160 device /dev/mapper/VG-c
mirror 2 logical 14157611008 physical 1075707904 device /dev/mapper/VG-b
[root@f24s ~]# btrfs-map-logical -l $[4096*3456480] /dev/VG/a
mirror 1 logical 14157742080 physical 1109327872 device /dev/mapper/VG-a
mirror 2 logical 14157742080 physical 2183069696 device /dev/mapper/VG-c


To confirm/deny mirror 2 is parity (128KiB file is 64KiB "a", 64KiB
"b", so expected parity is 0x03; if it's always 128KiB of the same
value then parity is 0x00 and can result in confusion/mistakes with
unwritten free space).

[root@f24s ~]# dd if=/dev/VG/c bs=1 count=65536 skip=2182283264
2>/dev/null | hexdump -C
00000000  03 03 03 03 03 03 03 03  03 03 03 03 03 03 03 03  |................|
*
00010000
[root@f24s ~]# dd if=/dev/VG/a bs=1 count=65536 skip=1108606976
2>/dev/null | hexdump -C
00000000  03 03 03 03 03 03 03 03  03 03 03 03 03 03 03 03  |................|
*
00010000
[root@f24s ~]# dd if=/dev/VG/a bs=1 count=65536 skip=1108803584
2>/dev/null | hexdump -C
00000000  03 03 03 03 03 03 03 03  03 03 03 03 03 03 03 03  |................|
*
00010000
[root@f24s ~]# dd if=/dev/VG/a bs=1 count=65536 skip=1109000192
2>/dev/null | hexdump -C
00000000  03 03 03 03 03 03 03 03  03 03 03 03 03 03 03 03  |................|
*
00010000
[root@f24s ~]# dd if=/dev/VG/b bs=1 count=65536 skip=1075511296
2>/dev/null | hexdump -C
00000000  03 03 03 03 03 03 03 03  03 03 03 03 03 03 03 03  |................|
*
00010000
[root@f24s ~]# dd if=/dev/VG/c bs=1 count=65536 skip=2182873088
2>/dev/null | hexdump -C
00000000  03 03 03 03 03 03 03 03  03 03 03 03 03 03 03 03  |................|
*
00010000
[root@f24s ~]# dd if=/dev/VG/a bs=1 count=65536 skip=1109196800
2>/dev/null | hexdump -C
00000000  03 03 03 03 03 03 03 03  03 03 03 03 03 03 03 03  |................|
*
00010000
[root@f24s ~]# dd if=/dev/VG/b bs=1 count=65536 skip=1075707904
2>/dev/null | hexdump -C
00000000  03 03 03 03 03 03 03 03  03 03 03 03 03 03 03 03  |................|
*
00010000
[root@f24s ~]# dd if=/dev/VG/c bs=1 count=65536 skip=2183069696
2>/dev/null | hexdump -C
00000000  03 03 03 03 03 03 03 03  03 03 03 03 03 03 03 03  |................|
*
00010000

Ok so in particular the last five, parity is on device b, c, a, b, c -
that suggests it's distributing parity on consecutive full stripe
writes.

Where I became confused is, there's not always a consecutive write,
and that's what ends up causing parity to end up on one device less
often. In the above example, parity goes 4x VG/a, 3x VG/c, and 2x
VG/b.

Basically it's a bad test. The sample size is too small. I'd need to
increase the sample size by a ton in order to know for sure if this is
really a problem.


>This
> information is not actually stored anywhere, it is computed based on
> block group geometry and logical stripe offset.

I think you're right. A better test is a scrub or balance on a raid5
that's exhibiting slowness, and find out if there's disk contention on
that system, and whether it's the result of parity not being
distributed enough.


> P.S. usage of "stripe" to mean "stripe element" actually adds to
> confusion when reading code :)

It's confusing everywhere. mdadm chunk = strip = stripe element. And
then LVM introduces -i --stripes which means "data strips" i.e. if you
choose -i 3 with raid6 segment type, you get 5 strips per stripe (3
data 2 parity). It's horrible.




-- 
Chris Murphy
