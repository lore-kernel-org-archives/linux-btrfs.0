Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56351 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbbBOG2R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Feb 2015 01:28:17 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YMsgh-000893-F4
	for linux-btrfs@vger.kernel.org; Sun, 15 Feb 2015 07:28:15 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Feb 2015 07:28:15 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Feb 2015 07:28:15 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs raid-1 uuid-fstab
Date: Sun, 15 Feb 2015 06:28:10 +0000 (UTC)
Message-ID: <pan$61fb6$e370d823$43b0d70$79a222c6@cox.net>
References: <loom.20150214T001556-40@post.gmane.org>
	<CAJCQCtSRgOmUfNFdvxoU1m77m-K_oKvp-nFeyaR8VtuYZbacyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sat, 14 Feb 2015 04:52:12 -0700 as excerpted:

> On Fri, Feb 13, 2015 at 7:31 PM, James <wireless@tampabay.rr.com> wrote:

>> What I want is if a drive fails,
>> I can just replace it, or pull one drive out, replace it with a second
>> blank, 2T new drive. Them move the removed drive into a second
>> (identical) system to build a cloned workstation. From what I've read,
>> uuid numbers are suppose to be use with fstab + btrfs Partuuid is still
>> flaky. But the UUID numbers to not appear uniq (due to raid-1)? Do the
>> only get listed once in fstab?
> 
> Once is enough. Kernel code will find both devices.

[Preliminary note. FWIW, gentooer here too, running a btrfs raid1 root, 
altho I strongly prefer several smaller filesystems over a single large 
filesystem, so all my data eggs aren't in the same filesystem basket if 
the proverbial bottom drops out of it.  So /home is a separate 
filesystem, as is /var/log, as is my updates stuff (gentoo and other 
repos, including kernel, sources, binpkgs, ccache, everything I use to 
update the system on a single filesystem, kept unmounted unless I'm 
updating), as is my media partition, and of course /tmp, which is tmpfs.  
But of interest here is that I'm running a btrfs raid1 root.]

CM is correct. =:^)

But in addition, for a btrfs raid1 root (or any multi-device btrfs root, 
for that matter), you *WILL* need an initr*, because normally the kernel 
must run a userspace (initr* to mount root) btrfs device scan, before it 
can actually assemble a multi-device btrfs properly.  As I don't believe 
Chris is a gentooer, I'm guessing he's used to an initr* and thus forgot 
about this requirement, which can be a big one for a gentooer, since we 
build our own kernels and often build in at least the modules required to 
mount root, thus in many cases making an initr* unnecessary.  
Unfortunately, for a multi-device btrfs root, it's necessary. =:^(

While in theory btrfs has the device= mount option, and the kernel has 
rootflags= to tell it what mount options to use, at least last I checked 
a few kernel cycles ago (I'd say last summer, so 3-5 kernel cycles ago), 
for some reason rootflags=device= doesn't appear to work correctly.  My 
theory is that the kernel commandline parser breaks at the second/last = 
instead of the first, so instead of seeing settings for the rootflags 
parameter, it sees settings for the rootflags=device parameter, which of 
course makes no sense to the kernel and is ignored.  But that's just my 
best theory.  All I know for sure is that the subject has come up a 
number of times here and has been acknowledged by the btrfs devs, I had 
to set up an initr* to get a raid1 btrfs root to mount when I originally 
set it up here, and some time later when I decided to try an initr*-less 
rootflags= boot again and see if the problem had been fixed, it still 
didn't work.

So for a multi-device btrfs root, plan on that initr*.  If you'd never 
really learned how to set one up, as was the case here, you will probably 
either have to learn, or skip the idea of a multi-device btrfs root until 
the problem is, eventually/hopefully, fixed.

FWIW, I use dracut to create my initr* here, and have the kernel options 
set such that the dracut-pre-created initr* is attached to each kernel I 
build as an initramfs, so I don't have to have an initr* setting in grub2 
-- each kernel image has its own, attached.

And FWIW, when I first setup the btrfs root (and dracut-based initr*), I 
was running openrc (and thus using sysv-init as my init).  I've since 
switched to systemd and activated the appropriate dracut systemd module.  
So I know from personal experience, a dracut-based initr* can be setup to 
boot either openrc/sysvinit, or systemd.  Both work. =:^)

> For degraded use, this gets tricky, you have to use boot param
> rootflags=degraded to get it to mount, otherwise mount fails and you'll
> be dropped to a pre-mount shell in the initramfs.

See, assumed initr*. =:^\

But while on the topic of rootflags=degraded, in my experimentation, 
without an initr* with its pre-mount btrfs device scan, since it /was/ a 
two-device btrfs raid1 both data and metadata, thus with copies of 
everything on each device, the only way to boot without an initr* was to 
set rootflags=degraded, since the kernel would only know about the root= 
device in that case.

And that worked, so the kernel certainly could parse rootflags= and pass 
the mount options to btrfs as it should.  It simply broke when device= 
was passed in those rootflags.  Thus my theory about the parser breaking 
at the wrong =.

> Also, there's a nasty
> little gotcha, there is no equivalent for mdadm bitmap. So once one
> member drive is mounted degraded+rw, it's changed, and there's no way to
> "catch up" the other drive - if you reconnect, it might seem things are
> OK but there's a good chance of corruption in such a case. You have to
> make sure you wipe the "lost" drive (the older version one). wipefs -a
> should be sufficient, then use 'device add' and 'device delete missing'
> to rebuild it.

I caught this in my initial btrfs experimentation, before I set it up 
permanently.  It's worth repeating for emphasis, with a bit more 
information as well.

*** If you break up a btrfs raid1 and attempt to recombine afterward, be 
*SURE* you *ONLY* mount the one side writable after that.  As long as 
ONLY one side is written to, that one side will consistently have a later 
generation than the device that was dropped out, and you can add the 
dropped device back in, with the caveat that you should then immediately 
run a btrfs scrub, which will scan both the updated devices and the 
behind one, and catch up the behind one.

Never, ever, separately mount both devices writable, and then try to 
recombine them, without first wiping the one.

Because at least in theory (that is, barring bugs), if one device had 
more transactions and is thus at a later transaction generation (an 
integral part of btrfs and tracked in the superblock), the filesystem 
should pick the later generation and a scrub will update the older one as 
necessary.  This is how things work if only one side was written to or if 
they were both written to, how btrfs picks which side to consider valid.  
However, if the two sides were both written to separately, and the 
generation happens to be the same on both, the filesystem will consider 
them both valid even tho they differ, and "bad things can happen."

The best way to avoid those "bad things" is to avoid splitting and 
recombining where possible.  If it must be done, be sure btrfs only sees 
one side updated since the split, either by only mounting the one side 
writable and doing a scrub after recombine to update the other one, or if 
for some reason they were both mounted writable, wipe the one before 
reattaching it, so btrfs never sees the diverged writes and there's never 
a chance of corruption as a result.

> This should not be formatted ext4, it's strictly for GRUB, it doesn't
> get a file system. You should use wipefs -a on this.

"This" referring of course to the grub2 bios boot.

What grub2 actually uses this for is to store the grub-core, with the 
various modules it needs to read /boot builtin.  This was what grub1 
called stage-1.5.

On a BIOS system, the firmware reads and loads the boot sector, but 
that's only 512 bytes, far too small to contain the main grub binary.  
All it has room for is a small stub and a pointer to a larger core.

On the simplest /boot filesystems, this pointer can be directly to the 
binary on /boot, but that only works as long as the filesystem doesn't 
move that binary around (defrag or for btrfs, balance), and as long as 
that binary was stored serially, in terms of device LBA addressing.  In 
the grub1 era, these filesystems were the ones that didn't require a 
stage-1.5, with the grub binary on /boot being the stage2.

With now legacy mbr-based partitioning, the only place grub could put a 
stage-1.5, if needed to read the stage-2 on /boot, was in the clear space 
many partitioners left at the beginning of the partition.

With grub2 and gpt partitioning, as long as there's a grub2biosboot 
partition reserved, that's where grub2 now places this core, formerly 
stage-1.5, with grub2 updated to dynamically add any grub modules (for 
gpt, the filesystem, raid, lvm, etc) necessary to access /boot to the 
core dynamically, before it places it in this reserved partition.

But the gpt reserved biosboot partition should not have a filesystem and 
is never mounted -- grub2 writes the core-plus-necessary-modules binary 
directly to the reserved partition without a filesystem, in LBA address 
order so it can be read serially by the very simple code that's still 
held in that 512-byte boot sector.

In fact, that very simple 512-byte boot-sector code knows nothing about 
gpt, it simply knows how to read the pointer that points to the LBA 
address of the first grubcore sector, and starts reading from there until 
it hits the magic sequence that tells it to stop.  Only after it has read 
and loaded that grub2-core code, does grub as we know it start to execute.

And in fact, as long as the grub2-core code can be read and loaded, even 
if grub can't find and load its config file and the other modules on 
/boot for some reason, you'll still get a rescue shell, and with a bit of 
grub knowledge, can point grub either at its /boot config and additional 
modules manually, or at a backup /boot, possibly on another device, and 
load normal mode and hopefully be able to continue booting normally, from 
there.

What's nice about gpt is that it has a dedicated bios-boot reserved 
partition for grub2, or other boot loader, to use.  This is far more 
reliable than hoping the partitioner and filesystem left enough room at 
the beginning of the partition to store the stage-1.5, as grub1 used to 
have to do, and as grub2 still has to do on legacy mbr-formatted systems.

> This fstab has lots of problems. Based on your partition scheme it
> should only have two entries total. A btrfs /boot UUID="d67a... and a
> btrfs / UUID="b7753... There is no mountpoint for biosboot, it's used by
> GRUB and is never formatted or mounted.

Spot on.

>> First I notice the last partition (sdb1) seems to be missing the ext4
>> file system I guess when I exit the chroot I can just fix that to match
>> sda1.
> 
> No the problem is sda1 is wrongly formatted ext4, you should use wipefs
> -a on it.

Spot on.

>> Any help or guidance would be keen,
>> to help salvage the installation and get a few partitions installed
>> with btrfs. Maybe I can somehow migrate to a raid-1 configuration under
>> btrfs.
> 
> Good luck. Make backups often. Btrfs raid1 is not a backup. Btrfs
> snapshots are not a backup. And use recent kernels. Recent on this list
> means 3.18.3 or newer, and is listed unstable on this list
> http://packages.gentoo.org/package/sys-kernel/gentoo-sources Based on
> the kernel.org change log, you'd probably be fine running 3.14.31, but
> if you have problems and ask about it on this list, there's a decent
> chance the first question will be "can you reproduce the problem on a
> current kernel?"
> 
> Anyway, I suggest reading the entire btrfs wiki.

Absolutely.  Well, the entire user documentation section, anyway.  If 
you're not a dev, you can skip that stuff unless you're curious.

Just as reading the rest of the gentoo handbook, not just the install 
section, can save you a lot of needlessly wasted time and headaches on 
gentoo, so reading the entire user documentation section on the btrfs 
wiki can save you lots of wasted time and headaches, and since it's a 
filesystem on which you're placing data presumably of some value, very 
possibly needlessly lost data, as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

