Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54901 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756506AbaKSX7g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Nov 2014 18:59:36 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XrF9q-0004y3-4e
	for linux-btrfs@vger.kernel.org; Thu, 20 Nov 2014 00:59:34 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Nov 2014 00:59:34 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Nov 2014 00:59:34 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
Date: Wed, 19 Nov 2014 23:59:23 +0000 (UTC)
Message-ID: <pan$440ce$23845ab3$4bdb3665$b30296cb@cox.net>
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>
	<546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org>
	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>
	<546BB2EA.5080809@ubuntu.com>
	<pan$7c051$a7c25939$cafa59e$f63379c9@cox.net>
	<546CC04F.6040207@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Phillip Susi posted on Wed, 19 Nov 2014 11:07:43 -0500 as excerpted:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 11/18/2014 9:46 PM, Duncan wrote:
>> I'm not sure about normal operation, but certainly, many drives take
>> longer than 30 seconds to stabilize after power-on, and I routinely see
>> resets during this time.
> 
> As far as I have seen, typical drive spin up time is on the order of 3-7
> seconds.  Hell, I remember my pair of first generation seagate cheetah
> 15,000 rpm drives seemed to take *forever* to spin up and that still was
> maybe only 15 seconds.  If a drive takes longer than 30 seconds, then
> there is something wrong with it.  I figure there is a reason why spin
> up time is tracked by SMART so it seems like long spin up time is a sign
> of a sick drive.

It's not physical spinup, but electronic device-ready.  It happens on 
SSDs too and they don't have anything to spinup.

But, for instance on my old seagate 300-gigs that I used to have in 4-way 
mdraid, when I tried to resume from hibernate the drives would be spunup 
and talking to the kernel, but for some seconds to a couple minutes or so 
after spinup, they'd sometimes return something like (example) 
"Seagrte3x0" instead of "Seagate300".  Of course that wasn't the exact 
string, I think it was the model number or perhaps the serial number or 
something, but looking at dmsg I could see the ATA layer up for each of 
the four devices, the connection establish and seem to be returning good 
data, then the mdraid layer would try to assemble and would kick out a 
drive or two due to the device string mismatch compared to what was there 
before the hibernate.  With the string mismatch, from its perspective the 
device had disappeared and been replaced with something else.

But if I held it at the grub prompt for a couple minutes and /then/ let 
it go, or part of the time on its own, all four drives would match and 
it'd work fine.  For just short hibernates (as when testing hibernate/
resume), it'd come back just fine; as it would nearly all the time out to 
two hours or so.  Beyond that, out to 10 or 12 hours, the longer it sat 
the more likely it would be to fail, if it didn't hold it at the grub 
prompt for a few minutes to let it stabilize.

And now I seen similar behavior resuming from suspend (the old hardware 
wouldn't resume from suspend to ram, only hibernate, the new hardware 
resumes from suspend to ram just fine, but I had trouble getting it to 
resume from hibernate back when I first setup and tried it; I've not 
tried hibernate since and didn't even setup swap to hibernate to when I 
got the SSDs so I've not tried it for a couple years) on SSDs with btrfs 
raid.  Btrfs isn't as informative as was mdraid on why it kicks a device, 
but dmesg says both devices are up, while btrfs is suddenly spitting 
errors on one device.  A reboot later and both devices are back in the 
btrfs and I can do a scrub to resync, which generally finds and fixes 
errors on the btrfs that were writable (/home and /var/log), but of 
course not on the btrfs mounted as root, since it's read-only by default.

Same pattern.  Immediate suspend and resume is fine.  Out to about 6 
hours it tends to be fine as well.  But at 8-10 hours in suspend, btrfs 
starts spitting errors often enough that I generally quit trying to 
suspend at all, I simply shut down now.  (With SSDs and systemd, shutdown 
and restart is fast enough, and the delay from having to refill cache low 
enough, that the time difference between suspend and full shutdown is 
hardly worth troubling with anyway, certainly not when there's a risk to 
data due to failure to properly resume.)

But it worked fine when I had only a single device to bring back up.  
Nothing to be slower than another device to respond and thus to be kicked 
out as dead.


I finally realized what was happening after I read a study paper 
mentioning capacitor charge time and solid-state stability time, and how 
a lot of cheap devices say they're ready before the electronics have 
actually properly stabilized.  On SSDs, this is a MUCH worse issue than 
it is on spinning rust, because the logical layout isn't practically 
forced to serial like it is on spinning rust, and the firmware can get so 
jumbled it pretty much scrambles the device.  And it's not just the 
normal storage either.  In the study, many devices corrupted their own 
firmware as well!

Now that was definitely a worst-case study in that they were deliberately 
yanking and/or fast-switching the power, not just doing time-on waits, 
but still, a surprisingly high proportion of SSDs not only scrambled the 
storage, but scrambled their firmware as well.  (On those devices the 
firmware may well have been on the same media as the storage, with the 
firmware simply read in first in a hardware bootstrap mode, and the 
firmware programmed to avoid that area in normal operation thus making it 
as easily corrupted as the the normal storage.)

The paper specifically mentioned that it wasn't necessarily the more 
expensive devices that were the best, either, but the ones that faired 
best did tend to have longer device-ready times.  The conclusion was that 
a lot of devices are cutting corners on device-ready, gambling that in 
normal use they'll work fine, leading to an acceptable return rate, and 
evidently, the gamble pays off most of the time.

That being the case, a longer device-ready, if it actually means the 
device /is/ ready, can be a /good/ thing.  If there's a 30-second timeout 
layer getting impatient and resetting the drive multiple times because 
it's not responding as it's not actually ready yet, well...

The spinning rust in that study faired far better, with I think none of 
the devices scrambling their own firmware, and while there was some 
damage to storage, it was generally far better confined.


>> This doesn't happen on single-hardware-device block devices and
>> filesystems because in that case it's either up or down, if the device
>> doesn't come up in time the resume simply fails entirely, instead of
>> coming up with one or more devices there, but others missing as they
>> didn't stabilize in time, as is unfortunately all too common in the
>> multi- device scenario.
> 
> No, the resume doesn't "fail entirely".  The drive is reset, and the IO
> request is retried, and by then it should succeed.

Yes.  I misspoke by abbreviation.  The point I was trying to make is that 
there's only the one device, so ultimately it either works or it 
doesn't.  There's no case of one or more devices coming up correctly and 
one or more still not being entirely ready.

> It certainly is not normal for a drive to take that long to spin up.
> IIRC, the 30 second timeout comes from the ATA specs which state that it
> can take up to 30 seconds for a drive to spin up.

>> That said, I SHOULD say I'd be far *MORE* irritated if the device
>> simply pretended it was stable and started reading/writing data before
>> it really had stabilized, particularly with SSDs where that sort of
>> behavior has been observed and is known to put some devices at risk of
>> complete scrambling of either media or firmware, beyond recovery at
>> times.

That was referencing the study I summarized in a bit more depth, above.
 
> Power supply voltage is stable within milliseconds.  What takes HDDs
> time to start up is mechanically bringing the spinning rust up to speed.
>  On SSDs, I think you are confusing testing done on power *cycling* (
> i.e. yanking the power cord in the middle of a write ) with startup.

But if the startup is showing the symptoms...

FWIW, I wasn't a believer at first either.  But I know what I see on my 
own hardware.

Tho I now suspect we might be in vehement agreement with each other, just 
from different viewpoints and stating it differently. =:^)

>> So, umm... I suspect the 2-minute default is 2 minutes due to power-up
>> stabilizing issues

> The default is 30 seconds, not 2 minutes.

Well, as discussed by others there's an often two-minute default at one 
level, and a 30 second default at another.  I was replying to someone who 
couldn't see the logic behind 2 minutes for sure, or even 30 seconds, 
with a reason why the 2 minute retry timeout might actually make sense.  
Yes, there's a 30 second time at a different level as well, but I was 
addressing why 2 minutes can make sense.

Regardless, with the 2 minute timeout behind the half-minute timeout, the 
2-minute timeout is obviously never going to be seen, which /is/ a 
problem.

> Again, there is no several minute period where voltage stabilizes and
> the drive takes longer to access.  This is a complete red herring.

My experience says otherwise.  Else explain why those problems occur in 
the first two minutes, but don't occur if I hold it at the grub prompt 
"to stabilize"for two minutes, and never during normal "post-
stabilization" operation.  Of course perhaps there's another explanation 
for that, and I'm conflating the two things.  But so far, experience 
matches the theory.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

