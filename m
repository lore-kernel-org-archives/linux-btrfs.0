Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:45868 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704AbaJ2XCP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Oct 2014 19:02:15 -0400
Received: by mail-qg0-f54.google.com with SMTP id q108so3189406qgd.27
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Oct 2014 16:02:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPL5yKfQ1s4w9LbXwxGrJ-coSy8G1p=hpkkwhPT8oU8cqWS1eg@mail.gmail.com>
References: <544FC921.2090900@tevsa.net>
	<CAPL5yKfQ1s4w9LbXwxGrJ-coSy8G1p=hpkkwhPT8oU8cqWS1eg@mail.gmail.com>
Date: Wed, 29 Oct 2014 19:02:12 -0400
Message-ID: <CAPL5yKc6ccuSRjWjHs2mCNiZm1JfQ=LGY+ftM=+FZmTy3WFgLw@mail.gmail.com>
Subject: Re: Btrfs raid1 array has issues with rtorrent usage pattern.
From: Dan Merillat <dan.merillat@gmail.com>
To: Alec Blayne <ab@tevsa.net>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following code reliably throws a SIGBUS in the memset, and cat
testfile > /dev/null returns an IO error.

I've sometimes gotten as high as iteration 900 before a SIGBUS, so
don't assume a single clear is OK.

linux 3.17.0, SATA -> MD(raid5) -> bcache (ssd) -> btrfs

Working on eliminating more variables.

#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define MB      (1024ull * 1024)
#define GB      (1024ull * MB)
#define TEST_SIZE       (4096)

int main() {
        int fd;
        srandom(1024);
        fd=open("testfile", O_RDWR|O_CREAT, 0600);
        posix_fallocate(fd, 0, TEST_SIZE * MB);

        uint8_t * map = 0;

        int i;
        for(i=0;i<1000;i++) {
                size_t location=(random() % (TEST_SIZE-1)) * MB;
                map = (uint8_t *) mmap(map, MB, PROT_READ|PROT_WRITE,
MAP_SHARED,
                                fd, location);

                printf("%d: writing at %04zd mb\n", i, location);

                memset(map, 0x5a, 1 * MB);
                msync(map, 1*MB, MS_ASYNC);

                munmap(map, MB);
        }
}

On Wed, Oct 29, 2014 at 5:50 PM, Dan Merillat <dan.merillat@gmail.com> wrote:
> I'm in the middle of debugging the exact same thing.  3.17.0 -
> rtorrent dies with SIGBUS.
>
> I've done some debugging, the sequence is something like this:
> open a new file
> fallocate() to the final size
> mmap() all (or a portion) of the file
> write to the region
> run SHA1 on that mmap'd region to validate the chink
> crash, eventually.  Generally not at the same point.
>
> Reading that file (cat > /dev/null) returns -EIO.
>
> Looking up the process maps, the SIGBUS appears to be happening in the
> middle of a mapped region of a pre-allocated file - I.E. it shouldn't
> be.  I'm not completely ruling out a rtorrent bug but it appears sane
> to me.
>
> Weirder: "old" files, that have been around a while, work just fine for seeding.
> I've re-hashed my entire collection without an error.
>
> Seeing this on both inherit-COW and no-inherit-COW files, and the
> filesystem is not using compression.
>
> The interesting part is going back and attempting to read the files
> later they sometimes don't throw an IO error.
>
> Absolutely nothing in dmesg.
>
> Working on a testcase that triggers it reliably but no luck so far.  I
> thought I had bad RAM but two people upgrading to 3.17 and seeing the
> same bug at around the same time can't be a coincidence.  I rebooted
> to 3.17 on the 25th, the first new download was on the 28th and that
> failed.
>
> Working on a testcase for it that's more reproducable than "go grab
> torrent files with rtorrent".
>
> On Tue, Oct 28, 2014 at 12:49 PM, Alec Blayne <ab@tevsa.net> wrote:
>> Hi, it seems that when using rtorrent to download into a btrfs system,
>> it leads to the creation of files that fail to read properly.
>> For instance, I get rtorrent to crash, but if I try to rsync the file he
>> was writting into someplace else, rsync also fails with the message
>> "can't map file "$file": Input/Output error (5)".
>> If I give it time, eventually the file gets into a good state and I can
>> rsync it somewhere else (as long as rtorrent doesn't keep writting into
>> it). This doesn't happen using ext4 on the same system.
>>
>> No btrfs errors, or any other errors, show up in any log. Scrubbing or
>> balancing don't turn up any issues. I've tried using a subvolume mounted
>> with nodatacow and/or flushoncommit, which didn't help. I'm not using
>> quotas and at some point had a single snapshot that I deleted. The
>> filesystem was originally created recently (on a 3.16.4+ kernel).
>>
>> Here's what the array looks like:
>>
>> Label: 'data'  uuid: ffe83a3d-f4ba-46b7-8424-4ec3380cb811
>>         Total devices 4 FS bytes used 3.14TiB
>>         devid    4 size 2.73TiB used 2.36TiB path /dev/sdd1
>>         devid    5 size 1.82TiB used 1.45TiB path /dev/sdc1
>>         devid    6 size 1.82TiB used 1.45TiB path /dev/sdb1
>>         devid    7 size 1.82TiB used 1.45TiB path /dev/sda1
>>
>> Btrfs v3.17
>>
>> Data, RAID1: total=3.34TiB, used=3.13TiB
>> System, RAID1: total=32.00MiB, used=512.00KiB
>> Metadata, RAID1: total=10.00GiB, used=7.31GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>
>>
>> On linux 3.17.1: Linux 3.17.1-gentoo-r1 #3 SMP PREEMPT Tue Oct 28
>> 02:43:11 WET 2014 x86_64 AMD Athlon(tm) 5350 APU with Radeon(tm) R3
>> AuthenticAMD GNU/Linux
>>
>> I'm utterly puzzled and clueless at how to dig into this issue.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
