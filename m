Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:39204 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750740AbdDACEb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 22:04:31 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cu8Oj-0003ST-D3
        for linux-btrfs@vger.kernel.org; Sat, 01 Apr 2017 04:04:13 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Do different btrfs volumes compete for CPU?
Date: Sat, 1 Apr 2017 02:04:01 +0000 (UTC)
Message-ID: <pan$89325$30d3a2b2$bbf713e5$4e33555f@cox.net>
References: <43a14754-1047-552e-78a9-6503dfc0d121@rqc.ru>
        <pan$8edd9$3260f40b$e8e8873f$59ccb7af@cox.net>
        <ef8ec943-6d26-d7e9-d4ac-05e2ce7a8532@rqc.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marat Khalili posted on Fri, 31 Mar 2017 15:28:20 +0300 as excerpted:

>> and that if you try the same thing with one of the filesystems being
>> for instance ext4, you'll see the same problem there as well

> Not sure if it's possible to reproduce the problem with ext4, since it's
> not possible to perform such extensive metadata operations there, and
> simply moving large amount of data never created any problems for me
> regardless of filesystem.

Try ext4 as the one hosting the innocent process...

And you said moving large amounts of data never triggered problems, but 
were you doing that over USB?

As for knobs I mentioned...

I'm not particularly sure about the knobs on USB, but...

For instance on my old PCI-X (pre-PCIE) server board, the BIOS had a 
setting for size of PCI transfer.  Given that each transfer has an 
effectively fixed overhead and the bus itself has a maximum bandwidth, 
the actually reasonably common elsewhere as well tradeoff was between 
high thruput (due to lower transfer overhead) at larger transfer sizes, 
but at the expense of interactivity and other processes having to wait 
for the transfer to complete, and better interactivity and shorter waits 
on a full bus at lower transfer sizes, at the expense of thruput due to 
higher transfer overhead.

I was having trouble with music cutouts and tried various Linux and ALSA 
settings to no avail, but once I set the BIOS to a much lower PCI 
transfer size, everything functioned much more smoothly, not just the 
music, but the mouse, less waiting on disk reads (because the writes were 
shorter), etc.

I /think/ the USB knobs are all in the kernel, but believe there's 
similar transfer size knobs there, if you know where to look.

Beyond that, there's more generic IO knobs as listed below, but if it was 
CPU not IO blocking, then they might not help in this context, but it's 
worth knowing about them, particularly the dirty_* stuff mentioned last, 
anyway.  (USB is much more CPU intensive than most transfer buses, one 
reason Intel pushed it so hard as opposed to say firewire, which offloads 
far more to the bus hardware and thus isn't as CPU intensive.  So the USB 
knobs may well be worth investigating even if it was CPU.  I just wish I 
knew more about them.)

There's also the IO-scheduler.  CFQ has long been the default, but you 
might try deadline, and there's now multiqueue-deadline (aka MQ deadline) 
as well.  NoOp is occasionally recommended for certain SSD use-cases, but 
it's not appropriate for spinning rust.  Of course most of the schedulers 
have detail knobs you can twist too, but I'm not sufficiently 
knowledgeable about those to say much about them.

And 4.10 introduced the block-device writeback throttling global option 
(BLK_WBT) along with separate options underneath it for single-queue and 
multi-queue writeback throttling.  I turned those on here, but as most of 
my system's on fast ssd, I didn't notice, nor did I expect to notice, 
much difference.  However, in theory it could make quite some difference 
with USB-based storage, particularly slow thumb-drives and spinning rust.

Last but certainly not least as it can make quite a difference, and 
indeed did make a difference here back when I was on spinning rust, 
there's the dirty-data write-caching typically configured via the 
distro's sysctrl mechanism, but which can be manually configured via 
the /proc/sys/vm/dirty_* files.  The writeback-throttling features 
mentioned above may eventually reduce the need to tweak these, but until 
they're in commonly deployed kernels, tweaking these settings can make 
QUITE a big difference, because the percentage-of-RAM defaults were 
configured back in the day when 64 MB of RAM was big, and they simply 
aren't appropriate to modern systems with often double-digit GiB RAM.  
I'll skip the details here as there's plenty of writeups on the web about 
tweaking these, as well as kernel text-file documentation, but you may 
want to look into this if you haven't, because as I said it can make a 
HUGE difference in effective system interactivity.


That's what I know of.  I'd be a lot more comfortable with things if 
someone else had confirmed my original post as I'm not a dev, just a 
btrfs user and list regular, but I do know we've not had a lot of reports 
of this sort of problem posted, and when we have in the past and it was 
actually separate btrfss, it turned out it was /not/ btrfs, so I'm 
/reasonably/ sure about it.  I also run multiple btrfs here and haven't 
seen the issue, but they're all on the same pair of partitioned quite 
fast ssds on SATA, so the comparison is admittedly of highly limited 
value.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

