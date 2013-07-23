Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:63255 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933299Ab3GWQQb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 12:16:31 -0400
Received: by mail-we0-f171.google.com with SMTP id q55so3328265wes.16
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 09:16:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130723143236.GA12119@thinkpad.home.lan>
References: <20130723143236.GA12119@thinkpad.home.lan>
Date: Tue, 23 Jul 2013 12:16:27 -0400
Message-ID: <CAPs0BihEVhGcqiN_-VHigRQTfw-p-MX4wB4T5jx8MG+oXxRUig@mail.gmail.com>
Subject: Re: Different size devices in RAID
From: Sandy McArthur <sandymac@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Curtis Shimamoto <sugar.and.scruffy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 23, 2013 at 10:32 AM, Curtis Shimamoto
<sugar.and.scruffy@gmail.com> wrote:
> [...]
> Additionally, though not quite as much of a concern to me, the machine in
> which these drives live is an Ivy Bridge Laptop, so there are actually
> only two available SATA3 ports.  The odd drive out at this point in time
> is actually an mSATA which is the only SATA2 port.  If I were to add this
> to an array (assuming the above questions have favorable answers), how
> dramatically would the speed of the array be affected?  To be honest, the
> speed of even just the mSATA drive alone is enough to keep me happy.  But
> I have just been very curious about this.  The write speeds of all three
> are relatively close. But the read speeds on the SATA3 are significantly
> faster than the mSATA.
> [...]

I expect instantaneous I/O to be a jittery experience based on if a
particular I/O takes a fast or slow path. I expect the average I/O
performance to be the weighted average of the performance of all
drives involved.

This is my btrfs-noob understanding/observations. Hope it helps:

I currently have a two drives RAID1 setup connected via USB3 on a
3.10.1 kernel. I've observed the following via the `iostat` command.
If I recall correctly my max observed read-only throughput is 160
megs/second and my max observed write throughput is 130 megs/second
combined (65 megs/second per drive).

Here is an `iostat 10` sample for only writing files to the drives in
my btrfs setup:
Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sdb             310.80         0.00     18092.80          0     180928
sdc             312.90        86.40     18099.20        864     180992

You'll see I'm pushing about 18 megs a second to each drive (the copy
here is from DVD to btrfs). Being RAID1 each drive gets a copy of the
data and I expect write performance to be limited by the slowest drive
being written to. I expect write performance to be jittery if multiple
drives are on different speed buses as some writes would wait on the
slow bus to catch up, others would only be on the fast bus.

Here I am reading from files (`cat /btrfs/backups/* >/dev/null`) and
still writing files like from above:
Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sdb            1640.60     89085.60     15230.00     890856     152300
sdc             245.50         3.60     15096.80         36     150968

Note that even though this is RAID1 data being read, only one drive is
feeding all the read I/O. Write speeds slowed a little as I expect the
USB3 bus/controller/whatever to be max out. (89+15+15=~120 megs/second
I/O + plus other overhead) If you had more drives and btrfs decided to
read from the slowest drive that would likely be your bottleneck for
that read.


Another drive arrived today, I'll see what happens when I mix/match
USB3 and SATA connected drives.

--
Sandy McArthur

"He who dares not offend cannot be honest."
- Thomas Paine
