Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:55877 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934387Ab2LITHD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Dec 2012 14:07:03 -0500
Message-ID: <50C4E152.2000102@friedels.name>
Date: Sun, 09 Dec 2012 20:06:58 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Mitch Harder <mitch.harder@sabayonlinux.org>, linux-btrfs@vger.kernel.org
Subject: Re: segmentation-fault in btrfsck (git-version)
References: <50BFB3B2.8040405@friedels.name> <CAKcLGm_44rjGwyKox0xO1SqWP1SkY-z8vpST6n99Q4g6eN9Lrw@mail.gmail.com>
In-Reply-To: <CAKcLGm_44rjGwyKox0xO1SqWP1SkY-z8vpST6n99Q4g6eN9Lrw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear Mich,

thanks for your help and suggestion:
 > It might be interesting for you to try a newer kernel, and use scrub
 > on this volume if you have the two disks RAIDed.

I have now scrubbed the Disk:
./btrfs scrub status /mnt/other/
scrub status for a15eede9-1a92-47d8-940a-adc7cf97352d
         scrub started at Sun Dec  9 13:48:57 2012 and finished after 
3372 seconds
         total bytes scrubbed: 1.10TB with 0 errors


That's odd, as in one folder, data is missing (I could have deleted it, 
but I'd be very surprised...)

Also, when I run btrfsck, I get errors:
On sdc1:
root 261 inode 64370 errors 400
root 261 inode 64373 errors 400
root 261 inode 64375 errors 400
root 261 inode 64376 errors 400
found 1203899371520 bytes used err is 1
total csum bytes: 1173983136
total tree bytes: 1740640256
total fs tree bytes: 280260608
btree space waste bytes: 212383383
file data blocks allocated: 28032005304320
  referenced 1190305632256
Btrfs v0.20-rc1-37-g91d9eec

On sdb1:
root 261 inode 64373 errors 400
root 261 inode 64375 errors 400
root 261 inode 64376 errors 400
found 1203899371520 bytes used err is 1
total csum bytes: 1173983136
total tree bytes: 1740640256
total fs tree bytes: 280260608
btree space waste bytes: 212383383
file data blocks allocated: 28032005304320
  referenced 1190305632256
Btrfs v0.20-rc1-37-g91d9eec



And when I try to mount one of the two raided disks, I get:
[ 1173.773861] device fsid a15eede9-1a92-47d8-940a-adc7cf97352d devid 1 
transid 140194 /dev/sdb1
[ 1173.774695] btrfs: failed to read the system array on sdb1
[ 1173.774854] btrfs: open_ctree failed

while the other works:
[ 1177.927096] device fsid a15eede9-1a92-47d8-940a-adc7cf97352d devid 2 
transid 140194 /dev/sdc1

Do you have hints for me?
The Kernel now is 3.3.7-030307-generic (anything more recent, I would 
have to compile myself, which I will do, if you suggest to)

Greetings,
Hendrik



Am 06.12.2012 20:09, schrieb Mitch Harder:
> On Wed, Dec 5, 2012 at 2:50 PM, Hendrik Friedel <hendrik@friedels.name> wrote:
>> Dear all,
>>
>> thanks for developing btrfsck!
>> Now, I'd like to contribute -as far as I can. I'm not a developer, but I do
>> have some linux-experience.
>> I've been using btrfsck on two 3TB HDDs (mirrored) for a while now under
>> Kernel 3.0. Now it's corrupt. I had some hard resets of the machine -which
>> might have contributed. I do have a backup of the data -at least of the
>> important stuff. Some TV-Recordings are missing. The reason I am writing is,
>> to support the development.
>>
>> Unfortunately, btrfsck (latest git-version) crashes with a segmentation
>> fault, when trying to repair this.
>>
>> Here's the backtrace:
>> root 261 inode 64375 errors 400
>> root 261 inode 64376 errors 400
>> btrfsck: disk-io.c:382: __commit_transaction: Assertion `!(!eb || eb->start
>> != start)' failed.
>>
>> Program received signal SIGABRT, Aborted.
>> 0x00007ffff784c425 in raise () from /lib/x86_64-linux-gnu/libc.so.6
>> (gdb)
>> (gdb) backtrace
>> #0  0x00007ffff784c425 in raise () from /lib/x86_64-linux-gnu/libc.so.6
>> #1  0x00007ffff784fb8b in abort () from /lib/x86_64-linux-gnu/libc.so.6
>> #2  0x00007ffff78450ee in ?? () from /lib/x86_64-linux-gnu/libc.so.6
>> #3  0x00007ffff7845192 in __assert_fail () from
>> /lib/x86_64-linux-gnu/libc.so.6
>> #4  0x000000000040d3ae in __commit_transaction (trans=0x62e010,
>> root=0xb66ae0) at disk-io.c:382
>> #5  0x000000000040d4d8 in btrfs_commit_transaction (trans=0x62e010,
>> root=0xb66ae0) at disk-io.c:415
>> #6  0x000000000040743d in main (ac=<optimized out>, av=<optimized out>) at
>> btrfsck.c:3587
>>
>>
>> Now, here's where my debugging knowledge ends. Are you interested in
>> debugging this further, or is it a known bug?
>>
>
> Line 382 in disk-io.c is:
>
> BUG_ON(!eb || eb->start != start);
>
> So, basically, btrfsck is intentionally crashing because it doesn't
> know how to handle this condition.
>
> Future refinements of btrfsck will probably include proper error
> messages for issues that can't be handled, or perhaps even fix the
> error.
>
> It might be interesting for you to try a newer kernel, and use scrub
> on this volume if you have the two disks RAIDed.
>


-- 
Hendrik Friedel
Auf dem Brink 12
28844 Weyhe
Mobil 0178 1874363
