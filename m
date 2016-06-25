Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34577 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbcFYWdY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jun 2016 18:33:24 -0400
Received: by mail-oi0-f65.google.com with SMTP id s17so24528019oih.1
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jun 2016 15:33:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <268f4f78-c277-43e9-a621-fc32d5fad172@inwind.it>
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
 <CAJCQCtTXJhgKsmQGUXrppntYj8u6vk3jzP9Q4UMBomJ255QTQw@mail.gmail.com>
 <CAJCQCtSF3WTxOkrgdWL78DqxYf-kLzXr4vnKPLoe2mhURhqkOA@mail.gmail.com> <268f4f78-c277-43e9-a621-fc32d5fad172@inwind.it>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 25 Jun 2016 16:33:23 -0600
Message-ID: <CAJCQCtRWfWXruAJTbCsh7dKc=2iRk6CHMOMTUBbh7JGH6SaXtA@mail.gmail.com>
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
To: kreijack@inwind.it
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 25, 2016 at 12:42 PM, Goffredo Baroncelli
<kreijack@inwind.it> wrote:
> On 2016-06-25 19:58, Chris Murphy wrote:
> [...]
>>> Wow. So it sees the data strip corruption, uses good parity on disk to
>>> fix it, writes the fix to disk, recomputes parity for some reason but
>>> does it wrongly, and then overwrites good parity with bad parity?
>>
>> The wrong parity, is it valid for the data strips that includes the
>> (intentionally) corrupt data?
>>
>> Can parity computation happen before the csum check? Where sometimes you get:
>>
>> read data strips > computer parity > check csum fails > read good
>> parity from disk > fix up the bad data chunk > write wrong parity
>> (based on wrong data)?
>>
>> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/fs/btrfs/raid56.c?id=refs/tags/v4.6.3
>>
>> 2371-2383 suggest that there's a parity check, it's not always being
>> rewritten to disk if it's already correct. But it doesn't know it's
>> not correct, it thinks it's wrong so writes out the wrongly computed
>> parity?
>
> The parity is not valid for both the corrected data and the corrupted data. It seems that the scrub process copy the contents of the disk2 to disk3. It could happens only if the contents of disk1 is zero.

I'm not sure what it takes to hit this exactly. I just tested 3x
raid5, where two files 128KiB "a" and 128KiB "b", so that's a full
stripe write for each. I corrupted devid 1 64KiB of "a" and devid2
64KiB of "b" did a scrub, error is detected, and corrected, and parity
is still correct.

I also tried to corrupt both parities and scrub, and like you I get no
messages from scrub in user space or kernel but the parity is
corrected.

The fixup is also not cow'd. It is an overwrite, which seems
unproblematic to me at face value. But?

Next I corrupted parities, failed one drive, mounted degraded, and
read in both files. If there is a write hole, I should get back
corrupt data from parity reconstruction blindly being trusted and
wrongly reconstructed.

[root@f24s ~]# cp /mnt/5/* /mnt/1/tmp
cp: error reading '/mnt/5/a128.txt': Input/output error
cp: error reading '/mnt/5/b128.txt': Input/output error

[607594.478720] BTRFS warning (device dm-7): csum failed ino 295 off 0
csum 1940348404 expected csum 650595490
[607594.478818] BTRFS warning (device dm-7): csum failed ino 295 off
4096 csum 463855480 expected csum 650595490
[607594.478869] BTRFS warning (device dm-7): csum failed ino 295 off
8192 csum 3317251692 expected csum 650595490
[607594.479227] BTRFS warning (device dm-7): csum failed ino 295 off
12288 csum 2973611336 expected csum 650595490
[607594.479244] BTRFS warning (device dm-7): csum failed ino 295 off
16384 csum 2556299655 expected csum 650595490
[607594.479254] BTRFS warning (device dm-7): csum failed ino 295 off
20480 csum 1098993191 expected csum 650595490
[607594.479263] BTRFS warning (device dm-7): csum failed ino 295 off
24576 csum 1503293813 expected csum 650595490
[607594.479272] BTRFS warning (device dm-7): csum failed ino 295 off
28672 csum 1538866238 expected csum 650595490
[607594.479282] BTRFS warning (device dm-7): csum failed ino 295 off
36864 csum 2855931166 expected csum 650595490
[607594.479292] BTRFS warning (device dm-7): csum failed ino 295 off
32768 csum 3351364818 expected csum 650595490


Soo.....no write hole? Clearly it must reconstruct from corrupt
parity, and then checks the csum tree for EXTENT_CSUM and it doesn't
match so it fails to propagate upstream. And doesn't result in a
fixup. Good.

What happens if I umount, make the missing device visible again, and
mount not degraded?

[607775.394504] BTRFS error (device dm-7): parent transid verify
failed on 18517852160 wanted 143 found 140
[607775.424505] BTRFS info (device dm-7): read error corrected: ino 1
off 18517852160 (dev /dev/mapper/VG-a sector 67584)
[607775.425055] BTRFS info (device dm-7): read error corrected: ino 1
off 18517856256 (dev /dev/mapper/VG-a sector 67592)
[607775.425560] BTRFS info (device dm-7): read error corrected: ino 1
off 18517860352 (dev /dev/mapper/VG-a sector 67600)
[607775.425850] BTRFS info (device dm-7): read error corrected: ino 1
off 18517864448 (dev /dev/mapper/VG-a sector 67608)
[607775.431867] BTRFS error (device dm-7): parent transid verify
failed on 16303439872 wanted 145 found 139
[607775.432973] BTRFS info (device dm-7): read error corrected: ino 1
off 16303439872 (dev /dev/mapper/VG-a sector 4262240)
[607775.433438] BTRFS info (device dm-7): read error corrected: ino 1
off 16303443968 (dev /dev/mapper/VG-a sector 4262248)
[607775.433842] BTRFS info (device dm-7): read error corrected: ino 1
off 16303448064 (dev /dev/mapper/VG-a sector 4262256)
[607775.434220] BTRFS info (device dm-7): read error corrected: ino 1
off 16303452160 (dev /dev/mapper/VG-a sector 4262264)
[607775.434847] BTRFS error (device dm-7): parent transid verify
failed on 16303456256 wanted 145 found 139
[607775.435972] BTRFS info (device dm-7): read error corrected: ino 1
off 16303456256 (dev /dev/mapper/VG-a sector 4262272)
[607775.436426] BTRFS info (device dm-7): read error corrected: ino 1
off 16303460352 (dev /dev/mapper/VG-a sector 4262280)
[607775.439786] BTRFS error (device dm-7): parent transid verify
failed on 16303259648 wanted 143 found 140
[607775.441974] BTRFS error (device dm-7): parent transid verify
failed on 16303472640 wanted 145 found 139
[607775.453652] BTRFS error (device dm-7): parent transid verify
failed on 16303341568 wanted 144 found 138

OK? Btrfs sees the wrong generation on the now readded device, and
looks like it's doing fixups of missing metadata on the missing device
also. Good.

Can I copy the files? Yes, no complaints. But it's parity that's bad
not data. What happens if I scrub?

Parity is fixed, no messages in user space or kernel. But I do see for
formerly "failed" and missing disk from scrub -BdR:
[...snip...]
    super_errors: 2
    malloc_errors: 0
    uncorrectable_errors: 0
    unverified_errors: 0
    corrected_errors: 0

Curious. Super errors, but neither uncorrected nor uncorrected?

[root@f24s ~]# btrfs rescue super-recover -v /dev/VG/c
All Devices:
    Device: id = 1, name = /dev/mapper/VG-a
    Device: id = 2, name = /dev/mapper/VG-b
    Device: id = 3, name = /dev/VG/c

Before Recovering:
    [All good supers]:
        device name = /dev/mapper/VG-a
        superblock bytenr = 65536

        device name = /dev/mapper/VG-a
        superblock bytenr = 67108864

        device name = /dev/mapper/VG-b
        superblock bytenr = 65536

        device name = /dev/mapper/VG-b
        superblock bytenr = 67108864

        device name = /dev/VG/c
        superblock bytenr = 65536

        device name = /dev/VG/c
        superblock bytenr = 67108864

    [All bad supers]:

All supers are valid, no need to recover. There are only two supers on
these devices because they're 250GiB each, and the 3rd super would
have been at 256GiB.


Alright so the errors were fixed. *shrug*


-- 
Chris Murphy
