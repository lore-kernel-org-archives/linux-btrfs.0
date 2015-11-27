Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:35887 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220AbbK0TAD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 14:00:03 -0500
Received: by lfs39 with SMTP id 39so135344474lfs.3
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 11:00:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1448643790.11377.39.camel@scientia.net>
References: <1448643790.11377.39.camel@scientia.net>
Date: Fri, 27 Nov 2015 20:00:01 +0100
Message-ID: <CAPmG0jZDHkvFq8_f__2p2net3Qu_rfvxBeyRHNZPZ3tekbhMMQ@mail.gmail.com>
Subject: Re: slowness when cp respectively send/receiving on top of dm-crypt
From: Henk Slager <eye1tm@gmail.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I'm just copying (via send/receive) a large filesystem (~7TB) from on
> HDD over to another.
> The devices are both connected via USB3, and each of the btrfs is on
> top of dm-crypt.
As far as I can guess this is transfers between Seagate Archive 8TB
SMR drives. For max 250GB in new/clean state you would get >100MB/s
write speed. However, due to SMR, you will experience large internal
disk 'rewrites', so throughput will go down to roughly 30MB/s. On
avarage for 8TB, expect something like 50MB/s
I think you know this:
https://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg47341.html
and certainly this:
https://bugzilla.kernel.org/show_bug.cgi?id=93581

> It's already obvious that things are slowed down, compared to "normal"
> circumstances, but from looking at iotop for a while (and the best disk
> IO measuring tool ever: the LEDs on the USB/SATA bridge) it seems that
> there are always times when basically no IO happens to disk.
The USB/SATA bridges somehow add some latency to ATA command
read/write (or might prevent queuing things, it is not clear to me in
detail), but saves you from the typical ATA errors as reported in bug
93581, as you also suggested yourself.

> There seems to be a repeating schema like this:
> - First, there is some heavy disk IO (200-250 M/s), mostly on btrfs
I think it is MByte/s (and not Mbit/s) right?

> send and receive processes
> - Then there are times when send/receive seem to not do anything, but
> either btrfs-transaction (this I see far less however, and the IO% is
> far lower, while that of dmcrypt_write is usually to 99%) or
> dmcrypt_write eat up all IO (I mean the percent value shown in iotop)
> with now total/actual disk write and read being basically zero during
> that.
>
> Kinda feels as if there would be some large buffer written first, then
> when that gets full, dm-crypt starts encrypting it during which there
> is no disk-IO (since it waits for the encryption).
I must say that adding compression (compress-force=zlib mount option)
makes the whole transferchain tend to not pipeline. Just dm-crypt I
have not seen it on Core-i7 systems. A test between 2 modern SSDs
(SATA3 connected ) is likely needed to see if there really is tendency
for hiccups in processing/pipelining. On kernels 3.11 to 4.0 I have
seen and experienced far from optimal behavior, but with 4.3 it is
quite OK, although I use large bcache which can mitigate HDD seeks
quite well.

On the tools level, you could insert mbuffer or buffer:
... send <snapshot spec> | mbuffer -m 2G | btrfs receive ...
to help pipelining things, but I am more or less sure that the SMR
disk writing is the weakest link (and also at the end of the transfer
chain).

> Not sure if this is something that could be optimised or maybe it's
> even a non issue that happens for example while many small files are
> read/written (the data consists of both, many small files as well as
> many big files), which may explain why sometimes the actual IO goes up
> to large >200M/s or at least > 150M/s and sometimes it caps at around
> 40-80M/s
Indeed typical behavior of SMR drive

> Obviously, since I use dm-crypt and compression on both devices, it may
> be a CPU issue, but it's a 8 core machine with i7-3612QM CPU @
> 2.10GHz... not the fastest, but not the slowest either... and looking
> at top/htop is happens quite often that there is only very little CPU
> utilisation, so it doesn't seem as if CPU would be the killing factor
> here.
Yes, your CPU should not be the bottleneck here.
