Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:39341 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750760AbeAWIiO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jan 2018 03:38:14 -0500
Received: by mail-wm0-f47.google.com with SMTP id b21so154682wme.4
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jan 2018 00:38:14 -0800 (PST)
Message-ID: <5A66F475.3010902@gmail.com>
Date: Tue, 23 Jan 2018 09:38:13 +0100
From: ein <ein.net@gmail.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Periodic frame losses when recording to btrfs volume with OBS
References: <f52e20c8-db0d-ffbb-91e3-268c548a544a@cs.uni-bonn.de>        <35acc308-d68d-3a4b-a626-38b9a7820fd4@gmx.com>        <a0b4a2c9-b61c-7f9a-5a24-88e4b83b887c@cs.uni-bonn.de> <pan$ef8df$2d463ba0$6a8d2cfc$bcf35f@cox.net>
In-Reply-To: <pan$ef8df$2d463ba0$6a8d2cfc$bcf35f@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/22/2018 09:59 AM, Duncan wrote:
> Sebastian Ochmann posted on Sun, 21 Jan 2018 16:27:55 +0100 as excerpted:

> [...]

> On 2018年01月20日 18:47, Sebastian Ochmann wrote:
>>>> Hello,
>>>>
>>>> I would like to describe a real-world use case where btrfs does not
>>>> perform well for me. I'm recording 60 fps, larger-than-1080p video
>>>> using OBS Studio [1] where it is important that the video stream is
>>>> encoded and written out to disk in real-time for a prolonged period of
>>>> time (2-5 hours). The result is a H264 video encoded on the GPU with a
>>>> data rate ranging from approximately 10-50 MB/s.
>>>
>>>> The hardware used is powerful enough to handle this task. When I use a
>>>> XFS volume for recording, no matter whether it's a SSD or HDD, the
>>>> recording is smooth and no frame drops are reported (OBS has a nice
>>>> Stats window where it shows the number of frames dropped due to
>>>> encoding lag which seemingly also includes writing the data out to
>>>> disk).
>>>>
>>>> However, when using a btrfs volume I quickly observe severe, periodic
>>>> frame drops. It's not single frames but larger chunks of frames that a
>>>> dropped at a time. I tried mounting the volume with nobarrier but to
>>>> no avail.
>>> What's the drop internal? Something near 30s?
>>> If so, try mount option commit=300 to see if it helps.
>> [...]
> 64 GB RAM...
>
> Do you know about the /proc/sys/vm/dirty_* files and how to use/tweak 
> them?  If not, read $KERNDIR/Documentation/sysctl/vm.txt, focusing on 
> these files.
>
> These tunables control the amount of writeback cache that is allowed to 
> accumulate before the system starts flushing it.  The problem is that the 
> defaults for these tunables were selected back when system memory 
> normally measured in the MiB, not the GiB of today, so the default ratios 
> allow too much dirty data to accumulate before attempting to flush it to 
> storage, resulting in flush storms that hog the available IO and starve 
> other tasks that might be trying to use it.
>
> The fix is to tweak these settings to try to smooth things out, starting 
> background flush earlier, so with a bit of luck the system never hits 
> high priority foreground flush mode, or if it does there's not so much to 
> be written as much of it has already been done in the background.
>
> There are five files, two pairs of files, one pair controlling foreground 
> sizes, the other background, and one file setting the time limit.  The 
> sizes can be set by either ratio, percentage of RAM, or bytes, with the 
> other appearing as zero when read.
>
> To set these temporarily you write to the appropriate file.  Once you 
> have a setting that works well for you, write it to your distro's sysctl 
> configuration (/etc/sysctl.conf or /etc/sysctrl.d/*.conf, usually), and 
> it should be automatically applied at boot for you.
>
> Here's the settings in my /etc/sysctl.conf, complete with notes about the 
> defaults and the values I've chosen for my 16G of RAM.  Note that while I 
> have fast ssds now, I set these values back when I had spinning rust.  I 
> was happy with them then, and while I shouldn't really need the settings 
> on my ssds, I've seen no reason to change them.
>
> At 16G, 1% ~ 160M.  At 64G, it'd be four times larger, 640M, likely too 
> chunky a granularity to be useful, so you'll probably want to set the 
> bytes value instead of ratio.
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
>
>
> Now the other factor in the picture is how fast your actual hardware can 
> write.  hdparm's -t parameter tests sequential write speed and can give 
> you some idea.  You'll need to run it as root:
>
> hdparm -t /dev/sda
>
> /dev/sda:
>  Timing buffered disk reads: 1578 MB in  3.00 seconds = 525.73 MB/sec
>
> ... Like I said, fast ssd...  I believe fast modern spinning rust should 
> be 100 MB/sec or so, tho slower devices may only do 30 MB/sec, likely too 
> slow for your reported 10-50 MB/sec stream, tho you say yours should be 
> fast enough as it's fine with xfs.
>
>
> Now here's the problem.  As Qu mentions elsewhere on-thread, 30 seconds 
> of your 10-50 MB/sec stream is 300-1500 MiB.  Say your available device 
> IO bandwidth is 100 MiB/sec.  That should be fine.  But the default 
> dirty_* settings allow 5% of RAM in dirty writeback cache before even 
> starting low priority background flush, while it won't kick to high 
> priority until 10% of RAM or 30 seconds, whichever comes first.
>
> And at 64 GiB RAM, 1% is as I said, about 640 MiB, so 10% is 6.4 GB dirty 
> before it kicks to high priority, and 3.2 GB is the 5% accumulation 
> before it even starts low priority background writing.  That's assuming 
> the 30 second timeout hasn't expired yet, of course.
>
> But as we established above the write stream maxes out at ~1.5 GiB in 30 
> seconds, and that's well below the ~3.2 GiB @ 64 GiB RAM that would kick 
> in even low priority background writeback!
>
> So at the defaults, the background writeback never kicks in at all, until 
> the 30 second timeout expires, forcing immediate high priority foreground 
> flushing!
>
> Meanwhile, the way the kernel handles /background/ writeback flushing is 
> that it will take the opportunity to writeback what it can while the 
> device is idle.  But as we've just established, background never kicks in.
>
> So then the timeout expires and the kernel kicks in high priority 
> foreground writeback.
>
> And the kernel handles foreground writeback *MUCH* differently!  
> Basically, it stops anything attempting to dirty more writeback cache 
> until it can write the dirty cache out.  And it charges the time it 
> spends doing just that to the thread it stopped in ordered to do that 
> high priority writeback! 
>
> Now as designed this should work well, and it does when the dirty_* 
> values are set correctly, because any process that's trying to dirty the 
> writeback cache faster than it can be written out, thus kicking in 
> foreground mode, gets stopped until the data can be written out, thus 
> preventing it from dirtying even MORE cache faster than the system can 
> handle it, which in /theory/ is what kicked it into high priority 
> foreground mode in the /first/ place.
>
> But as I said, the default ratios were selected when memory was far 
> smaller.  With half a gig of RAM, the default 5% to kick in background 
> mode would be only ~25 MiB, easily writable within a second on modern 
> devices and back then, still writable within say 5-10 seconds.  And if it 
> ever reached foreground mode, that would still be only 50 MiB worth, and 
> it would still complete in well under the 30 seconds before the next 
> expiry.
>
> But with modern RAM levels, my 16 GiB to some extent and your 64 GiB is 
> even worse, as we've seen, even our max ~1500 MiB doesn't kick in 
> background writeback mode, so the stuff just sits there until it expires 
> and then it get slammed into high priority foreground mode, stopping your 
> streaming until it has a chance to write some of that dirty data out.
>
> And at our assumed 100 MiB/sec IO bandwidth, that 300-1500 MiB is going 
> to take 3-15 seconds to write out, well within the 30 seconds before the 
> next expiry, but for a time-critical streaming app, stopping it even the 
> minimal 3 seconds is very likely to drop frames!
>
>
> So try setting something a bit more reasonable and see if it helps.  That 
> 1% ratio at 16 GiB RAM for ~160 MB was fine for me, but I'm not doing 
> critical streaming, and at 64 GiB you're looking at ~640 MB per 1%, as I 
> said, too chunky.  For streaming, I'd suggest something approaching the 
> value of your per-second IO bandwidth, we're assuming 100 MB/sec here so 
> 100 MiB but let's round that up to a nice binary 128 MiB, for the 
> background value, perhaps half a GiB or 5 seconds worth of writeback time 
> for foreground, 4 times the background value.  So:
>
> vm.dirty_background_bytes = 134217728   # 128*1024*1024, 128 MiB
> vm.dirty_bytes = 536870912              # 512*1024*1024, 512 MiB
>
>
> As mentioned, try writing those values directly into /proc/sys/vm/
> dirty_background_bytes and dirty_bytes , first, to see if it helps.  If 
> my guess is correct, that should vastly improve the situation for you.  
> If it does but not quite enough or you just want to try tweaking some 
> more, you can tweak it from there, but those are reasonable starting 
> values and really should work far better than the default 5% and 10% of 
> RAM with 64 GiB of it!
>
>
> Other things to try tweaking include the IO scheduler -- the default is 
> the venerable CFQ but deadline may well be better for a streaming use-
> case, and now there's the new multi-queue stuff and the multi-queue kyber 
> and bfq schedulers, as well -- and setting IO priority -- probably by 
> increasing the IO priority of the streaming app.  The tool to use for the 
> latter is called ionice.  Do note, however, that not all schedulers 
> implement IO priorities.  CFQ does, but while I think deadline should 
> work better for the streaming use-case, it's simpler code and I don't 
> believe it implements IO priority.  Similarly for multi-queue, I'd guess 
> the low-code-designed-for-fast-direct-PCIE-connected-SSD kyber doesn't 
> implement IO priorities, while the more complex and general purpose 
> suitable-for-spinning-rust bfq /might/ implement IO priorities.
>
> But I know less about that stuff and it's googlable, should you decide to 
> try playing with it too.  I know what the dirty_* stuff does from 
> personal experience. =:^)
>
>
> And to tie up a loose end, xfs has somewhat different design principles 
> and may well not be particularly sensitive to the dirty_* settings, while 
> btrfs, due to COW and other design choices, is likely more sensitive to 
> them than the widely used ext* and reiserfs (my old choice and the basis 
> of my own settings, above).

Excellent booklike writeup showing how /proc/sys/vm/ works, but I
wonder, how can you explain why does XFS work in this case?

> -- 
> PGP Public Key (RSA/4096b):
> ID: 0xF2C6EA10
> SHA-1: 51DA 40EE 832A 0572 5AD8 B3C0 7AFF 69E1 F2C6 EA10

