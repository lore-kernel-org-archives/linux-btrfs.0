Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:38273 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751712AbcILEgX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 00:36:23 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bjIyf-00023x-Op
        for linux-btrfs@vger.kernel.org; Mon, 12 Sep 2016 06:36:17 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: compress=lzo safe to use?
Date: Mon, 12 Sep 2016 04:36:07 +0000 (UTC)
Message-ID: <pan$56316$8902276c$b806652$f5dac40c@cox.net>
References: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
        <pan$e8a2$15460093$3bb59e30$70ebaf89@cox.net>
        <21b8852b-fba6-6f8f-feed-7bbfa12312d2@crc.id.au>
        <4096253.hu8ZAHGEqT@merkaba>
        <6ef80ffd-6a56-3538-0778-a99cb4b9851e@mendix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hans van Kranenburg posted on Sun, 11 Sep 2016 22:49:58 +0200 as
excerpted:

> So, you can use a lot of compress without problems for years.
> 
> Only if your hardware is starting to break in a specific way, causing
> lots and lots of checksum errors, the kernel might not be able to handle
> all of them at the same time currently.
> 
> The compress might be super stable itself, but in this case another part
> of the filesystem is not perfecty able to handle certain failure
> scenario's involving it.

Well put.

In my case I had problems trigger due to exactly two things, tho there 
are obviously other ways of triggering the same issues, including a crash 
in the middle of a commit, with one copy of the raid1 already updated 
while the other is still being written.:

1) I first discovered the problem when one of my pair of ssds was going 
bad.  Because I had btrfs raid1 and could normally scrub-fix things, and 
because I had backups anyway, I chose to continue running it for some 
time, just to see how it handled things, as more and more sectors became 
unwritable and were replaced by spares.  By the end I had several MiB 
worth of spares in-use, altho smart reported I had only used about 15% of 
the available spares, but by then it was getting bad enough and the 
newness had worn off, so I just replaced it and got rid of the hassle.

But as a result of the above, I had a *LOT* of practice with btrfs 
recovery, mostly running scrub.

And what I found was that if btrfs raid1 encounters too many checksum 
errors in compressed data it will crash btrfs and the kernel, even when 
it *SHOULD* recover from the other device because it has a good copy, as 
demonstrated by the fact that after a reboot, I could run a scrub and fix 
everything, no uncorrected errors at all.

At first I thought it was just the way btrfs worked -- that it could 
handle a few checksum errors but not too many at once.  I had no idea it 
was compression related.  But nobody else seemed to mention the problem, 
which I though a bit strange, until someone /did/ mention it, and 
furthermore, actually tested both compressed and uncompressed btrfs, and 
found the problem only when btrfs was reading compressed data.  If the 
data wasn't compressed, btrfs went ahead and read the second copy 
correctly, without crashing the system, every time.

The extra kink in this is that at the time, I had a boot-time service 
setup to cache (via cat > /dev/null) a bunch of files in a particular 
directory.  This particular directory is a cache for news archives, with 
articles on some groups going back over a decade to 2002, and my news 
client (pan) is slow to startup with several gigs of cached messages like 
that, so I had the boot-time service pre-cache everything, so by the time 
I started X and pan, it would be done or nearly so and I'd not have to 
wait for pan to startup.

The problem was that many of the new files were in this directory, and 
all that activity tended to hit the going-bad sectors on that ssd rather 
frequently, making one copy often bad.  Additionally, these are mostly 
text messages, so they compress quite well, meaning compress=lzo would 
trigger compression on many of them.

And because I had it reading them at boot, the kernel tended to overload 
on checksum errors before it finished booting, far more frequently than 
it would have otherwise.  Of course, that would crash the system before I 
could get a login in ordered to run btrfs scrub and fix the problem.

What I had to do then was boot to rescue mode, with the filesystems 
mounted but before normal services (including this caching service) ran, 
run the scrub from there, and then continue boot, which would then work 
just fine because I'd fixed all the checksum errors.

But, as I said I eventually got tired of the hassle and just replaced the 
failing device.  Btrfs replace worked nicely. =:^)

2a) My second trigger is that I've found that with multiple devices, as 
in multi-device btrfs, but also when I used to run mdraid, don't always 
resume from suspend-to-RAM very well.  Often one device takes longer to 
wake up than the other(s), and the kernel will try to resume while one 
still isn't responding properly.  (FWIW, I ran into this problem on 
spinning rust back on mdraid, but I see it now on ssds on btrfs as well, 
so it seems to be a common issue, which probably remains relatively 
obscure I'd guess because relatively few people with multi-device btrfs 
or mdraid do suspend-to-ram.)

The result is that btrfs will try to write to the remaining device(s), 
getting them out of sync with the one that isn't responding properly 
yet.  Ultimately this leads to a crash if I don't catch it and complete a 
controlled shutdown before that, and sometimes I see the same crash-on-
boot-due-to-too-many-checksum-errors problem I saw with #1.  I no longer 
have that caching job running at boot and thus don't see it as often, but 
it still happens occasionally.  Again, once I boot to rescue mode and run 
scrub, it fixes the problem and I can resume the normal mode boot without 
further issue.

So I pretty much quit suspending to RAM, at least for any longer period, 
and just shutdown and reboot, now.  With systemd and ssds, the boot 
doesn't take significantly longer anyway, tho it does mean I can't simply 
resume and pick up where I was, I have to reopen my work, etc.

2b) Closely related to #2a and most recent, since I'm no longer trying to 
suspend to RAM, I think one of the ssds now has a bad backup capacitor or 
something, as if I leave it idle for too long it'll fail to respond once 
I start trying to use it again.  Same story, the other device gets writes 
that the unresponsive device is missing, and eventually if I don't reboot 
I crash.  Upon reboot, again, if there were too many things written to 
the device that stayed up that didn't make it to the other one, it can 
trigger a crash due to checksum failure.  However, if I can get a command 
prompt, either because it boots all the way or because I boot to rescue 
mode, I can run a scrub and update the bad device from the good one, and 
then everything works fine once again... until the device goes 
unresponsive, again.


Again, I once thought all this was just the stage at which btrfs was, 
until I found out that it doesn't seem to happen if btrfs compression 
isn't being used.  Something about the way it recovers from checksum 
errors on compressed data differs from the way it recovers from checksum 
errors on uncompressed data, and there's a bug in the compressed data 
processing path.  But beyond that, I'm not a dev and it gets a bit fuzzy, 
which also explains why I've not gone code diving and submitted patches 
to try to fix it, myself.

But if I'm correct, it probably doesn't matter what the compression type 
is, only how much of it there is.  So compress-force would tend to 
trigger the issue far more frequently than simply compress, unless of 
course your use-case is a corner-case like my trying to read all those 
compressible text messages into cache at boot was, but compress (or 
compress-force) =lzo vs =zlib shouldn't matter.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

