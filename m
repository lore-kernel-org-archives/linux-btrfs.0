From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Wiki update request: source repo page   Was: [PATCH] Btrfs: use
 i_version instead of our own sequence
Date: Fri, 13 Apr 2012 18:48:49 +0000 (UTC)
Message-ID: <pan.2012.04.13.18.48.48@cox.net>
References: <1333986794-6525-1-git-send-email-josef@redhat.com>
	<CALLzPKY0ViBnaH8PVOmxad+oPpbWiYOz24+Lc8CWNuzKbyHHng@mail.gmail.com>
	<20120412133107.GC1924@localhost.localdomain>
	<pan.2012.04.12.21.41.17@cox.net> <20120412215546.GB4856@carfax.org.uk>
	<pan.2012.04.12.22.56.00@cox.net> <20120413131632.GG4856@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Fri, 13 Apr 2012 14:16:32 +0100 as excerpted:

> On Thu, Apr 12, 2012 at 10:56:00PM +0000, Duncan wrote:
>> Hugo Mills posted on Thu, 12 Apr 2012 22:55:46 +0100 as excerpted:
>> > The general advice is -- use a single-device root filesystem, or an
>> > initramfs. These are simple, supported, and will generally get good
>> > help. Any other configuration will cause you to be told to use an
>> > initramfs. So far, I've not heard any concrete reason why one
>> > shouldn't be used except "ooh, I don't understand them, and they're
>> > scary!".
>> 
>> FWIW, device names appear to be reasonably stable, here.  Stable enough
>> that I currently have this built into the kernel as part of my kernel
>> command line:
> 
> That's all well and good for you, but my point is that in the
> general case, device names are *not* stable, and the kernel does *not*
> claim to guarantee this. If you assume that they are stable, and your
> system breaks as a result, then you get to keep both pieces. Your
> choice, but your risk as well. The recommendation for a stable reliable
> system is to run btrfs dev scan before mounting a btrfs filesystem.

BTW, I don't believe I've thanked you for the replies, yet.  Thanks, and 
I don't disagree with the rest.

I guess I generally agree here, too... with /generally/ stressed.  But 
the wiki should cover more than the default, "general" case.

Meanwhile [kernel command line] ...

>> md=3,/dev/sda6,/dev/sdb6,/dev/sdc6,/dev/sdd6 root=/dev/md3p1

> So you're doing the same thing as btrfs's "device=" mount option.

Same general thing, yes.

> Again, if this works, all well and good, but it'll break if devices move
> around, requiring the manual step. If you want to avoid that and have it
> all Just Work, use an initrd (for both MD and btrfs).

Obviously, for systems where it all moves around at every boot, this 
isn't going to be a very useful alternative, I'll agree.  But that's not 
the case on a lot of hardware.

And the trouble with "just works" isn't when it does INDEED "just work", 
but when it doesn't.  In that case, the admin needs to be comfortable 
enough with the system and his understanding of it to get things back 
into operational condition.  The more layers of unnecessary complexity 
(like a shouldn't be necessary initr*) there are, the more difficult that 
"grok the system well enough to be reasonably confident in one's ability 
to restore it" status is to achieve, and the higher the risk of failure, 
should the admin's disaster recovery skills actually be needed.


> As far as I recall, MD also requires userspace help in order to
> reassemble a device correctly, except when v0.9 superblocks are used
> (which have limitations on the set of other features they support).

I've read that is true, altho I've not tested it, I've simply gone with 
0.90 superblocks, because here, the cost of 0.90 is rather low compared 
to the benefits of no-userspace-required assembly from kernel commandline 
and detected data.

If btrfs (or md) should lose that ability, it'd be a shame.

>> So while I'd agree that multi-device noinitr* btrfs builtin might not
>> be appropriate as a general distro-wide solution, it does seem quite
>> reasonable (here) for sysadmins familiar enough with their own systems
>> to have custom-built no-module-loading kernels in general, to be able
>> to do the same with btrfs.
> 
> I disagree. You could conceivably get the kernel to scan every
> single block device it knows about as the device is discovered, but then
> the kernel would take unnecessarily long to boot (consider something
> with a stack of DVD drives -- you'd have to wait for each one to spin up
> before scanning it). If you were to restrict the set of devices scanned,
> you're putting policy into the kernel, which would get rejected pretty
> much instantly by anyone upstream.

No need to have the kernel scan everything (certainly not by default) OR 
limit policy... while still retaining flexibility.  Simply keep the 
ability to have it specified on the kernel commandline, for systems with 
a stable enough device layout that it works.

Actually, with a flexible enough bootloader, and grub2 certainly seems at 
least close to that already, as with its modules it already supports both 
mdraid and lvm2 as well as btrfs (and apparently zfs as well), any 
scanning ability as well as site configuration and policy, could be and 
already is to some degree, built into the bootloader's modules, as long 
as the kernel commandline (or other similar mechanism) remains available 
to handle the necessary data passed to it from the bootloader.

> I have had my initrd (for root on LVM on MD) fail precisely once in
> 8 years or so, and that was down to my upgrading some LVM tools manually
> and not rebuilding the initrd. If you stick to your distribution's
> packages (at least for boot-critical things), then I would think it
> highly unlikely you'll end up with a system that fails to boot. If you
> muck around with it manually and it breaks, then I would suggest you
> treat it as a learning experience.

Stick to a distro's packages?

How are people only running distro packages supposed to run the patches 
they're asked to test on the list, talk the distro package maintainer 
into including possibly one-shot debugging patches into a new general 
rollout?

True, some distros are packaging and even supporting btrfs already, and 
some users, their own admins, are reckless enough to dive right in, 
without checking project status, or the wiki, or the list... but that can 
hardly be the /target/ audience for btrfs at this point, right?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

