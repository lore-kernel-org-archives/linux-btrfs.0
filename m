Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38219 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbbKOHkz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Nov 2015 02:40:55 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zxrvh-0004QF-F4
	for linux-btrfs@vger.kernel.org; Sun, 15 Nov 2015 08:40:53 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Nov 2015 08:40:53 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Nov 2015 08:40:53 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: More memory more jitters?
Date: Sun, 15 Nov 2015 07:40:46 +0000 (UTC)
Message-ID: <pan$84138$fa440c28$ee6e0667$85b79136@cox.net>
References: <CAOcLnUfVNvRLYdeQG_kTZyXaceaLCez=XsQ8PXwEyaXPeYiMwg@mail.gmail.com>
	<20151114143112.GK24333@carfax.org.uk>
	<pan$ce09f$d4f4e93$fd67914e$33e263e1@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Sat, 14 Nov 2015 16:37:14 +0000 as excerpted:

> Hugo Mills posted on Sat, 14 Nov 2015 14:31:12 +0000 as excerpted:
> 
>>> I have read the Gotcha[1] page:
>>> 
>>>    Files with a lot of random writes can become heavily fragmented
>>> (10000+ extents) causing trashing on HDDs and excessive multi-second
>>> spikes of CPU load on systems with an SSD or **large amount a RAM**.
>>> 
>>> Why could large amount of memory worsen the problem?
>> 
>>    Because the kernel will hang on to lots of changes in RAM for
>> longer. With less memory, there's more pressure to write out dirty
>> pages to disk, so the changes get written out in smaller pieces more
>> often. With more memory, the changes being written out get "lumpier".
>> 
>>> If **too much** memory is a problem, is it possible to limit the
>>> memory btrfs use?
>> 
>>    There's some VM knobs you can twiddle, I believe, but I haven't
>> really played with them myself -- I'm sure there's more knowledgable
>> people around here who can suggest suitable things to play with.
> 
> Yes.  Don't have time to explain now, but I will later, if nobody beats
> me to it.

And now it's later... =:^)

The official kernel documentation for this is in
$KERNELDIR/Documentation/filesystems/proc.txt, in
CHAPTER 2: MODIFYING SYSTEM PARAMETERS
(starting at line 1378 in the file as it exists in kernel 4.3), tho 
that's little more than an intro.  As it states,
$KERNELDIR/Documentation/sysctl/* contains rather more information.

Of course there's also various resources on the net covering this 
material, and if google finds this post I suppose it might become one of 
them. =:^]


So in that Documentation/sysctl dir, the README file contains an intro, 
but what we're primarily interested in is covered in vm.txt.  The files 
discussed there are found in /proc/sys/vm, tho your distro almost 
certainly has an init service, sysctl (the systemd-sysctl.service on 
systemd based systems, configured with *.conf files in /usr/lib/ssctl.d/ 
and /etc/sysctl.d/), that pokes non-kernel-default distro-configured and 
admin-configured values into the appropriate /proc/sys/vm/* files at 
boot.  Also check /etc/sysctl.conf, which at least here is symlinked 
from /etc/sysctl.d/99-sysctl.conf so systemd-sysctl loads it.  That's 
actually the file with my settings, here.

So (as root) you can poke the files directly for experimentation, and 
when you've settled on values that work for you, you can put them in /etc/
sysctl.d/*.conf or in /etc/sysctl.conf, or whatever your distro uses 
instead.  But keep in mind that (for systemd based systems anyway) the 
settings in /usr/lib/sysctl.d/*.conf will be loaded first and thus will 
apply if not overridden by your own config, so you might want to check 
there too, to see what's being applied there, before going too wild on 
your overrides.

Of course the sysctl mechanism loads various other settings as well, 
network, core-file, magic-srq, others, but what we're focused on here are 
the vm files and settings.

In particular, our files of interest are the /proc/sys/vm/dirty_* files 
and corresponding vm.dirty_* settings, tho while we're here, I'll mention 
that /proc/sys/vm/swappiness and the corresponding vm.swappiness setting 
is also quite commonly changed by users.

Basically, these dirty_* files control the amount of cached writes that 
can accumulate before the kernel will start writing them to storage at 
two different priority levels, the maximum time they are allowed to age 
before they're written back regardless, and the balance between these two 
writeback priorities.

Now, one thing that's important to keep in mind here is that the kernel 
defaults were originally setup back when 128 MiB RAM was a *LOT* of 
memory, and they aren't necessarily appropriate for systems with the GiB 
or often double-digit GiB RAM that most non-embedded systems come with 
today, particularly where people are still using legacy spinning rust -- 
SSDs are enough faster that the problem doesn't show up to the same 
degree, tho admins may still want to tweak the defaults in some cases.

Another thing to keep in mind for mobile systems in particular is that 
writing data out will of course spin up the drives, so you might want 
rather larger caches and longer timeouts on laptops and the like, and/or 
if you spin down your drives.  But balance that against the knowledge 
that data still in the write cache will be lost if the system crashes 
before it hits storage, so don't go /too/ overboard on extending your 
timeouts.  Timeouts of an hour could well save quite a bit of power, but 
they also risk losing an hour's worth of writes!


OK, from that rather high level view, let's jump to the lower level 
actual settings, tho not yet the actual values.  I'll group the settings 
in my discussion, but you can read the description for each individual 
setting in the vm.txt file mentioned above, if you like.

Note that there's a two-dimension parallel among the four files/settings, 
dirty*_bytes and dirty*_ratio:

dirty_background_bytes
dirty_background_ratio
dirty_bytes
dirty_ratio

In the one dimension you have ratio vs. bytes.  Choose one to use and 
ignore the other.  The kernel defaults to the ratio settings, percent of 
/available/ memory that's dirty (write-cached data waiting to be written 
to storage), but if you prefer to deal in specific sizes, you can write 
your settings to the bytes file, and the kernel will use them instead.  
It uses whichever of the two files/settings, ratio vs. bytes, was written 
last, and the other one will always read as zero if you read it, 
indicating that the other one of the pair is being used.

Note with the ratio files/settings that it's percentage of total 
/available/ memory, which will be rather less than total /system/ 
memory.  But for most modern systems you can estimate initial settings 
using total memory, and then tweak a bit from there if you need to.

In the other dimension you have background, low priority, start writing 
but let other things come first, vs. foreground, higher priority, get 
much more pushy about the writes as they're building up.

But sizes/ratios don't make a lot of sense unless we know the time frame 
we're dealing with, so before we discuss size values, let's talk about 
time.

The other two dirty_* files/settings deal with time (in hundredths of a 
second), not size, and are:

dirty_expire_centisecs
dirty_writeback_centisecs

The expire setting/file controls how long data is cached before the low 
priority writeback kicks in due to time, but does NOT actually trigger 
the writeback itself.

The writeback setting/file controls how often the kernel wakes those low 
priority flusher threads to see if they have anything to do.  If 
something has expired or the background size is too large, they'll start 
working, otherwise they go back to sleep and wait until the next time 
around.

Expire defaults to 2999, basically 30 seconds.
Writeback defaults to 499, 5 seconds.

So unless enough is being written to trigger the size settings, writes 
are allowed to age for 30 seconds by default, then then next time the low 
priority flusher threads wake up, within another five seconds by default, 
they'll start actually writing the data -- at low priority -- back to 
storage.

Here, on my line-powered workstation, I decided that I'm willing to risk 
losing 30 seconds or so of data, so kept the defaults for expire.  
However, I decided I probably didn't need the flushers waking up every 
five seconds to see if there's anything to do, so doubled that to 10 
seconds, 1000 (or 999) centiseconds.

On a laptop, people are very likely to want to power down the storage in 
ordered to save power, and will probably be willing to risk loss of a bit 
more time's worth of data if a crash happens, in ordered to both allow 
that and to ensure that when the storage powerup does happen, they have 
as much to write as possible.  Here, perhaps a five or ten minute (300 or 
600 seconds, 30000 or 60000 centiseconds) expire might be appropriate, if 
they're willing to risk loss of that much work in the event of a crash to 
save power, in which case waking up the flushers every five seconds to 
check if there's something to do doesn't make much sense either, so 
setting that to something like 30 seconds or a minute (3000, 6000 
centiseconds) might make sense.  Few folks will want to risk a full 
hour's worth of work, tho, or even a half hour, no matter the power 
savings it might allow.  Still, I've read of people doing it, and if 
you're for instance playing a game that would be lost on crash anyway (or 
watching a movie that's either coming in off the net or already cached in 
memory so you're not spinning up to /read/ from storage) and not writing 
a paper, it might even make sense.


OK, with the time frame established, we can now look at what sizes make 
sense, and here's where the age of the defaults that are arguably not 
particularly appropriate on modern hardware, comes into the picture.

As I said, the kernel defaults to using ratios, not bytes.  As I also 
said, the ratios are percentages of available memory, not total memory, 
that can be dirty write cache, before the corresponding low or high 
priority writeback to actual storage kicks off, but for first estimates, 
total memory (RAM, not including swap) works just fine.

dirty_ratio is the foreground (high priority) setting, defaulting to 10%.
dirty_background_ratio (low priority) defaults to 5%.

For discussion, I'll use as an example my own workstation, with its 16 
gig of RAM.  I'll also give the 2 gig figure, for those with older 
systems or chromebooks, etc, and use the 64 meg figure as an example of 
what the figures might have looked like when the defaults were picked, 
tho for all I know 16 meg or 256 meg might have been more common at the 
time.

Here's a table.  Approximate figures, rounded down a bit due to available 
vs. total.

Memory size		10% foreground		5% background
-------------------------------------------------------------
64 MiB			6 MiB			3 MiB
2 GiB			200 MiB			100 MiB
16 GiB			1500 MiB		750 MiB

Now I don't remember and am not going to attempt to look up what disk 
speeds were back then, but we know that (for non-SSDs) while they've 
increased, the increases in disk speed have nowhere near kept up with 
size increases, either of disks or of memory.  But we're really only 
concerned with the modern numbers anyway, so we'll look at that.

A reasonably fast disk (not SSD) today can do, ballpark maybe
120 MiB/sec, sequential, average across the disk.  (At the edge, speeds 
are higher, near the center, they'll be lower.)  But make that random, 
like a well used and rather fragmented disk, and speed will be much 
lower.  A few years ago I used to figure 30 MiB/sec, so we'll pick a nice 
round 50 MiB/sec from between the two.


At 50 MiB/sec, that default 10% foreground will take four seconds to 
write out that 200 MiB, a full 30 seconds to write out that 1500 MiB.  
Remember, that's the foreground "high priority do this first" level, so 
as soon as it's hit...

Well, let's just say we know where people's system pauses while writes to 
disk block reading in what they're actually waiting for, come from!

And of course at the 16 GiB RAM level that's also about a gig and a half 
of dirty writes that can be lost in the event of a crash, tho the low 
priority flusher should obviously have kicked in before that, writing 
some of the data at lower priority.

The question then becomes, OK, how much system delay while it writes out 
all that accumulated data are you willing to suffer, vs. writing out out 
sooner, before the backlog gets too big and the pause to write it out 
gets too long?

Meanwhile, until the backlog hits the background number, unless the 
expire timer discussed above expires first, the system will be just 
sitting there, not attempting to write anything at the lower priority 
level.

On a 2 GiB memory system it'll accumulate about a 100 MiB, a couple 
seconds worth of writeout, before it kicks off even low priority flusher 
writes.  On a 16 GiB system, that's already close to 15 seconds worth of 
writing, half the expiry time, for even *LOW* priority writes!!

So particularly as memory sizes increase, we need to lower the background 
number so low priority writes kick off sooner and hopefully get things 
taken care of before high priority writes kick in, and we need to lower 
the foreground number so the backlog doesn't take so long to write out, 
blocking almost all other access to the disk for tens of seconds at a 
time, if the high priority threshold /is/ reached.

What I settled on here, again, with 16 GiB memory, was
1% dirty_background_ratio or about 150 MiB, about 3 seconds worth of 
writes, and 3% dirty_ratio, about 450 MiB or 9 seconds worth of writes.  
9 seconds... I'll tolerate that if I need to.

Note that with background already at 1%, about 150 MiB, if I wanted to go 
lower, I'd have to switch to dirty_background_bytes, as I've read nothing 
indicating the kernel will take fractions of percentages, here, and I 
suspect that would simply give me whatever was set before, the defaults 
if I tried to set it in sysctl at boot.

As a result, I don't really feel comfortable lowering dirty_ratio below 
3%, because it'd be getting uncomfortably close to the background value, 
tho arguably 2%, double the background value, should be fine, as the 
default is double the background value.

So if I decided to upgrade to say 32 GiB RAM or more (and hadn't switched 
to SSD already), I'd probably switch to the bytes settings and try to 
keep it near say 128 MiB background, half a GiB foreground (which would 
give me a 4X ratio between them, while I now have 3X).


Obviously those on laptops may want to increase these numbers, instead, 
tho again, consider how much data you're willing to lose in a crash, and 
don't go hog wild unless you really are willing to lose that data.

Meanwhile, it's also worth noting that there's laptop-mode-tools for 
commandline use, and various graphical tools as well, that can be 
configured to toggle between plugged-in and battery power mode, and 
sometimes have a whole set of different profiles, for toggling these and 
many (many!) other settings between save-power-mode and performance-mode, 
if you'd rather not have your laptop set to 10 minutes expiry and 
gigabytes worth of write-cache /all/ the time, but still want it /some/ 
of the time, when you're really trying to save that power!


OK, but what about those on SSD?  Obviously many SSDs are FAR faster, and 
what's more, they don't suffer the same dropoff between sequential and 
random access modes that spinning rust does.  Here, I upgraded the main 
system to SSD a couple years ago or so, but I do still keep my multimedia 
files on spinning rust.  And while I probably don't need those tight 1% 
background, 3% foreground ratios any more, the SSD writes fast enough 
it's not hurting things, and it still helps when for example doing 
backups to the media drive.  So I've kept them where I had them, tho I'd 
probably not bother changing them from kernel defaults on an all-SSD 
system, or if I upgraded to 32 GiB RAM or something.  (Tho with a mostly 
SSD system, the pressure to upgrade RAM beyond my already 16 GiB is 
pretty much non-existent, tho I do wonder sometimes what it'd be like to 
go say 256 GiB of battery-backed RAM and access stuff at RAM speed 
instead of SSD speed, tho it's not really cost-effective to but dream...)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

