Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:33658 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbbK1Shc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Nov 2015 13:37:32 -0500
Received: by lfaz4 with SMTP id z4so157367158lfa.0
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Nov 2015 10:37:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1448684040.6837.18.camel@scientia.net>
References: <1448643790.11377.39.camel@scientia.net>
	<CAPmG0jZDHkvFq8_f__2p2net3Qu_rfvxBeyRHNZPZ3tekbhMMQ@mail.gmail.com>
	<1448684040.6837.18.camel@scientia.net>
Date: Sat, 28 Nov 2015 19:37:31 +0100
Message-ID: <CAPmG0jbso5RM4UW_urBKa02LOKreCTx2PjX7YyUp6nuqOONo=Q@mail.gmail.com>
Subject: Re: slowness when cp respectively send/receiving on top of dm-crypt
From: Henk Slager <eye1tm@gmail.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

some more comments after I have done some fresh tests.

On Sat, Nov 28, 2015 at 5:14 AM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
> On Fri, 2015-11-27 at 20:00 +0100, Henk Slager wrote:
>> As far as I can guess this is transfers between Seagate Archive 8TB
>> SMR drives.
> Yes it is,... and I though about SMR being the reason at first, too,
> but:
> - As far as I understood SMR, it shouldn't kick in when I do what is
> mostly streaming data. Okay I don't know exactly how btrfs writes it's
> data, but when I send/receive 7GB I'd have expected that a great deal
> of it is just sequential writing.
>
> - When these disks move data from their non shingled areas to the
> shingled ones, that - or at least that's my impression - produces some
> typical sounds from the mechanical movements, which I didn't hear
>
> - Bust most importantly,... if the reason was SMR, why should always
> when no IO happens dmcrypt_write be at basically full CPU.
I did not know iotop, I installed it and did run it next to ksysguard
where I display CPU load and block I/O of the various disk/objects.
I also see quite often 99% dmcrypt_write in iotop and at the same time
no 'external' activity of the SMR drive. I did cp a 165G file to the
SMR drive. The source had 130 extents and just uncompressed btrfs
raid10 fs, steadily 150+MB/s throughput. The fs on the SMR disk is
mounted like this:
/dev/mapper/dmcrypt_smr on /mnt/smr type btrfs
(rw,noatime,compress-force=zlib,nossd,space_cache,subvolid=5,subvol=/)
If I look at the throughput graph, I also see seconds timeframes of no
disk activity, but the diskhead makes movements (I have no LEDs).
iotop shows I/O load, not CPU load; if dmcrypt_write does write a
datablock to disk, there are many times that the SMR disk has to do
internal 'rewrites' during which there is no traffic on the SATA lanes
(so no LED flashing) until the SMR disk indicates towards
dmcrypt_write that it has finished the current block and is able to
accept new blocks. I/O load nowadays is not CPU PIO, but the DMA HW
etc doing the work.

The result of the cp action is that the destination is 1018391
extents, so a diff operation afterwards results in quite slow read
from the SMR drive (even slower than the write) and not the 150+MB/s
sustained advertised throughput. The fs on the SMR drive is almost
exclusively adding files, so assume enough un-fragmented free space
available still.
If you would do the same without compress-force-zlib, (also no other
compression), you will see that btrfs can really do well (like 1
extent per GB or so) even with dm-crypt

>> I must say that adding compression (compress-force=zlib mount option)
>> makes the whole transferchain tend to not pipeline.
> Ah? Well if I'd have known that in advance ^^ (although I just use
> compress)...
> Didn't marketing tell people that compression may even speed up IO
> because the CPUs are so much faster than the disks?
They did not tell that it can cause this million extent creation. And
LZO might be different and force or not also has impact.
I am sorry that the statement might have confused you, but I tried
various compression options the last 2 years, this non-pipelining is I
think from kernel 3.x experience, it made a 3T sized fs more or less
useless and many crashes.
But now with kernel 4.3, I don't see anything wrong w.r.t. throughput
performance. If I write to a fast destination, it is just 100% CPU
load for all 8 CPU threads and expected write I/O throughput. Only if
I use forced zlib, I get enough compression so that it makes sense for
my data. For archiving, or backup of backups, I am fine with the heavy
extent creation (and so likely also on-disk fragmentation) and reduced
I/O rates etc.

/Henk
