Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:35464 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbcEBNNt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 09:13:49 -0400
Received: by mail-ig0-f172.google.com with SMTP id bi2so83360127igb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 02 May 2016 06:13:49 -0700 (PDT)
Subject: Re: commands like "du", "df", and "btrfs fs sync" hang
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <20160501090046.638fc2c6@jupiter.sol.kaishome.de>
 <pan$1c3f$713ccc59$ba5354e3$ceefdfd6@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <13265330-f402-8c50-4bb0-5ae41d3ca8cb@gmail.com>
Date: Mon, 2 May 2016 09:13:41 -0400
MIME-Version: 1.0
In-Reply-To: <pan$1c3f$713ccc59$ba5354e3$ceefdfd6@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-01 08:47, Duncan wrote:
> Meanwhile, what kernel IO scheduler do you use (deadline, noop,
> cfq,... cfq is the normal default)?  Do you use either normal
> process nice/priority or ionice to control the rsync?  What
> about cgroups?
CFQ is the default on many systems, unless you are using a new enough 
kernel, in which case the blk-mq code is used instead, which has no real 
I/O scheduler yet (although in my experience, it really doesn't need 
it).  As of right now, the SCSI layer (which in turn means USB and SATA 
as well,as they are routed through the SCSI layer), and the 
device-mapper code have the option of using this code (some distros may 
be using it already, there's a kconfig option to enable it by default 
for each of them), and the NVMe driver is unconditionally using it. 
There's also talk of the MMC driver adding support, although I don't 
know how soon.
>
> And finally, what are your sysctl aka /proc/sys/vm settings for
> dirty_* and vfs_cache_pressure?  Have you modified these from
> defaults at all, either by changing your /etc/sysctl.(d|conf)
> vm.* settings, or by writing directly to the files in
> /proc/sys/vm, say at bootup (which is what changing the sysctl
> config actually does)?
>
> Because the default cache settings as a percent of memory were
> setup back when memory was much smaller, and many people argue
> that on today's multi-GiB memory machines, they allow far too
> much dirty content to accumulate in cache before triggering
> writeback, particularly for slow spinning rust.  When the time
> expiry is set to 30 seconds but the amount of dirty data allowed
> to accumulate before triggering high priority writeback is near
> a minute's worth of writeback activity, something's wrong,
> and that's very often a large part of the reason people see
> IO related freezes in other processes trying to read stuff
> off disk, as well as other lagginess on occasion (tho as
> touched on above, that's rarer these days, due to point-to-
> point buses such as PCIE and SATA, as opposed to the old
> shared buses of PCI and EIDE).
>
>
> FWIW, while I have ssds for the main system now, I already
> had my system tuned in this regard:
>
> 1) I set things like emerge, kernel building, rsync, etc,
> to idle/batch priority (19 niceness), which is more
> efficient for cpu scheduling batch processes as they get
> longer time slices but at idle/lowest priority so they
> don't disturb other tasks much.
>
> Additionally, for the cfq IO scheduler, it sees the idle
> cpu priority and automatically lowers IO priority as well,
> so manual use of ionice isn't necessary.  (I don't believe
> the other schedulers account for this, however, which is
> one reason I asked about them, above.)
The deadline scheduler doesn't have a concept of I/O priority, no-op by 
definition can't, and blk-mq code seems to honor it, but I'm not sure in 
what way.
>
> For something like rsync that's normally IO-bound anyway,
> the primary effect would be the automatic IO-nicing due
> to the process nicing.
>
> That was pretty effective at that level.  But combined
> with #2, it's even more so.
>
> 2) I tuned my vm.dirty settings to trigger at much
> lower sizes for both low priority background writeback
> and higher priority foreground writeback.  You can
> check the kernel's procfs documentation for the
> specific settings if you like, but here's what I have
> for my 16 GiB system (ssd now as I said, but I saw
> no reason to change it from the spinning rust settings
> I had, particularly since I still use spinning rust
> for my media partition).
>
> Direct from that section of my /etc/sysctl.conf:
>
> ################################################################################
> # Virtual-machine: swap, write-cache
>
> # vm.vfs_cache_pressure = 100
> # vm.laptop_mode = 0
> # vm.swappiness = 60
> vm.swappiness = 100
>
> # write-cache, foreground/background flushing
> # vm.dirty_ratio = 10 (% of RAM)
> # make it 3% of 16G ~ half a gig
> vm.dirty_ratio = 3
> # vm.dirty_bytes = 0
>
> # vm.dirty_background_ratio = 5 (% of RAM)
> # make it 1% of 16G ~ 160 M
> vm.dirty_background_ratio = 1
> # vm.dirty_background_bytes = 0
>
> # vm.dirty_expire_centisecs = 2999 (30 sec)
> # vm.dirty_writeback_centisecs = 499 (5 sec)
> # make it 10 sec
> vm.dirty_writeback_centisecs = 1000
> ################################################################################
>
> The commented values are normal defaults.  Either ratio, percentage of RAM, or
> direct bytes can be set.  Setting one clears (zeros) the other.  While the
> ratio isn't of total RAM but of available RAM, total RAM's a reasonable
> approximation on most modern systems.
>
> Taking the foreground, vm.dirty_ratio setting first:
>
> Spinning rust may be as low as 30 MiB/sec thruput, and 10% of 16 gig of RAM
> is 1.6 gig, ~1600+ meg.  Doing the math that's ~53 seconds worth of writeback
> accumulated by default, before it kicks into high priority writeback mode.
> With a 30 second default timeout, that makes no sense at all as it's almost
> double the timeout!
>
> Besides, who wants to wait nearly a minute for it to dump all that?
>
> So I set that to 3%, which with 16 gigs of RAM is ~half a gig, or about 16
> seconds worth of writeback at 30 MB/sec.  That's only about half the 30
> second time expiry and isn't /too/ bad to wait, tho you'll probably notice
> if it takes that full 16 seconds.  But it's reasonable, and given
> the integer setting and that we want background set lower, 3% is getting
> about as low as practical.  (Obviously if I upped to 32 GiB RAM, I'd
> want to switch to the bytes setting for this very reason.)
>
> The background vm.dirty_background_ratio setting is where the lower
> priority background writeback kicks in, so with luck the higher priority
> foreground limit is never reached, tho it obviously will be for something
> doing a lot of writing, like rsync often will.  So this should be lower
> than foreground.
>
> With foreground set to 3%, that doesn't leave much room for background, but 1%
> is still reasonable.  That's about 160 MB or 5 seconds worth of writeback at
> 30 MB/sec, so it's reasonable.
I think you've got things a bit confused here (at least, what you are 
saying doesn't match the documentation, and also doesn't match my 
(limited) understanding of the code).  The background values are 
system-wide values, while the unlabeled ones (what you call foreground) 
are per-process.  IOW, the background value provides an upper bound for 
the whole system, while the foreground ones provide an upper bound for 
each individual process.  As a result, it is actually somewhat 
nonsensical to use a background value that is lower than the foreground 
value unless you don't want to limit things per-process as well as 
system wide.

I find on my systems that setting a 64M limit per-process and 256M 
system wide gives a good balance between throughput and latency (I see a 
slight slowdown on my SSD's, but see reduced write latency on flash 
drives and traditional HDD's).

As for the timeouts, dirty_expire_centisecs is the longest time that a 
writeback buffer can sit around before being flushed (note that this is 
an upper bound, not something telling the kernel to wait this long 
before flushing it), and dirty_writeback_centisecs is how often the 
kernel will flush a chunk of the buffer once it starts flushing 
writeback buffers.

On my systems, I actually have those set way below the default values, 
at roughly 1 second for expiration, and 0.1 seconds for periodic 
writeback.  Based on testing, I've found that this is roughly the amount 
of time it takes for most desktop apps to fill a 64M buffer and how long 
on average it takes for my systems to flush it under light load 
respectively.

All of this will of course change if Linux ever gets the ability to set 
per-device write-back settings (OS X and newer versions of Windows for 
example automatically disable write-back buffering on flash drives).
> As you can see, with the size triggers lowered to something reasonable, I
> decided I could actually up the background time expiry from the default 5
> seconds to 10.  That's still well and safely under the 30 second foreground
> time expiry, and with the stronger size triggers I thought it was reasonable.
>
> I haven't actually touched vfs_cache_pressure, but that's another related
> knob you can twist.
I wouldn't touch this much, it's mostly or fine-tuning for specific 
applications (for example, on a system with very little RAM and 
unpredictable file access patterns, increasing this might increase 
performance).
>
> I don't actually have any swap configured on my current machine (and
> indeed, have it disabled in the kernel config) so the swappiness setting
> doesn't matter, but I did have swap setup on my old 8 GiB machine.  I was
> actually using the priority= option to set four swap partitions, one
> each on four different devices, to the same priority, effectively
> raid0-striping them.  My system was mdraid1 on the same four devices.
> So I upped swappiness to 100 (it's more or less percentage, 0-100 range)
> from its default 60, to force swapping out over dumping cache.  Even still,
> I seldom went more than a few hundred MiB into swap, so the 8 GiB was
> just about perfect for that 4-cores system.  (My new system has 6
> cores and I figured the same 2 GiB per core.  I think now a more realistic
> figure for my usage at least is say 4 GiB, plus a GiB per core, which
> seems to work out for both my old 4-core system with 8 gig RAM, and
> my newer 6-core system where 12 gig of RAM would hit about the same
> usage.  I have 16 gig, but seldom actually use the last 4 gig at all,
> so 12 gig would be perfect, and then I might configure swap, just in
> case.  But swap would be a waste with 16 gig since I literally seldom
> use that last 4 gig even for cache anyway, so it's effectively my
> overflow area.)
>
> I used laptop mode, with laptop-mode-tools, on my netbook, the reason
> it's comment-listed there as of-interest, but I've no reason to use
> it on my main machine, which is wall-plug powered.  IIRC when active
> it would try to flush everything possible once the disk was already
> active, so it could spin down for longer between activations.
> Laptop-mode-tools allows configuring a bunch of other stuff to toggle
> between wall power and battery power as well, and of course one of
> the other settings it changed was the above vm.dirty_* settings, to
> much larger triggers and longer timeouts (upto 5 minutes or so,
> tho I've read of people going to extremes and setting it to 15
> minutes or even longer, tho that of course risks losing all that work
> in a crash (!!)), again, to let the drive stay spun down for longer.
If you're using an SSD, then deferring write-back has limited value. 
Good SSD's usually use no more than 2W when writing and less than 1W 
when reading (and milliwatts when idle even when not in standby or 
powered down), as compared to usually greater than 5W power spikes to 
spin up traditional disks and roughly 2 to keep them spinning.

As far as the other things covered by 'laptop-mode', the standard 
scripts in pm-utils cover pretty much everything there.
>
>
> Between the two, setting much lower writeback cache size triggers,
> and using a nice of 19 to set idle/batch mode for stuff like emerge
> and rsync, after setting that bios setting on the old system as well,
> responsiveness under heavy load, either IO or CPU, was MUCH better.
>
> Hopefully you'll find it's similarly effective for you, assuming
> you don't already have similar settings and are STILL seeing
> the problem.
>
> Of course for things like rsync, you could probably use ionice (with
> the cfq io scheduler) instead and not bother doing normal nice on
> rsync, but because the cfq scheduler already effectively does ionice
> on strongly niced processes, I didn't need to worry about it here.
>
> As I said, with ssds I don't really need it that strict any more,
> but I saw no need to change it, and indeed, with spinning rust still
> for my media drive, it's still useful there.
>
> So there it is.  Hope it's useful. =:^)
>

