Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46167 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbaANJKo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 04:10:44 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W301C-0003M9-6e
	for linux-btrfs@vger.kernel.org; Tue, 14 Jan 2014 10:10:42 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 10:10:42 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 10:10:42 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID 1 with no data on it when accidentally switched HDD
Date: Tue, 14 Jan 2014 09:10:17 +0000 (UTC)
Message-ID: <pan$a50cc$d2573e20$d506fc0e$a9fb385b@cox.net>
References: <b93a253364541dd18356eaefb64d3168@www.jitmail.de>
	<EF449A1E-2C53-43BB-883E-98EE848E60CB@colorremedies.com>
	<pan$137$6980616b$bce212bf$29519e1a@cox.net>
	<BD7CFF7E-E75E-40D8-92B5-902C2F523A28@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Mon, 13 Jan 2014 09:46:08 -0700 as excerpted:

> On Jan 13, 2014, at 1:18 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>> 
>> I use GPT partitioning (instead of MBR) for better fault tolerance and
>> flexibility here, too,
> 
> Off topic but related to above, you might find it vaguely
> interesting/annoying in that the current kernel behavior actually makes
> GPT less reliable than MBR because it face plants if it finds a problem
> with the primary GPT, rather than use the backup:
> https://bugzilla.kernel.org/show_bug.cgi?id=63591

I wasn't aware of that, and it's troubling. =:^(

Fortunately, however, my recovery plan doesn't assume I can actually boot 
from a drive if its first partition table is corrupt anyway.  Instead, I 
expect to boot to one of my system backups on an entirely different 
device.

Since those backups are effectively copies of the system taken at the 
time they were made, they're fully functional (both theoretically and as 
tested by booting to them, starting X, and generally running them for 
awhile, on occasion), not just function-limited recovery tools.  That 
means I have access to X and the net for googling and other reference, 
all manpages, and all tools I have on my normal system, including 
gptfdisk. =:^)

So my primary recovery plan in case of gpt first partition table 
corruption is to boot to a backup rootfs on a different device, and from 
there run cgdisk or gdisk and use /it/ to retrieve the hopefully intact 
second partition table, and booting from the drive with the corrupted 
first gpt partition table by using the second instead, would be a nice 
surprise, but isn't assumed, so the fact that the kernel breaks and 
refuses to boot if the first partition table is corrupt isn't a deal 
breaker as I wasn't assuming it'd work in the first place. =:^)

If the second partition table is corrupt too, perhaps because the system 
crashed in the middle of updating the tables using gdisk, there's a fair 
chance I can copy the table from a different device, since I often use 
identical devices with identical partitioning, in raid.  If all else 
fails, at least my recent layouts are reasonably easy to remember, with 
all sub-gig partitions in the first gig, and further partitions all of 
whole-GiB sizes on GiB boundaries, so if worse comes to worse, I can 
probably trial and error guess them.  (Tho I actually posted my latest 
main-system layout in a thread right here on this list a few weeks ago, 
so before I went trial and error guessing, I'd go see if I could find 
that.  As Linus says, real (wo)men let the net be their backup. =:^)

>> and it has partition names/labels which can be used in fstab, too.  I
>> use the same label and partlabel scheme, with the filesystem label
>> generally reflecting the partlabel(s) it's created on, however, so it
>> doesn't really matter which I use, except that PARTLABEL=
>> is longer in fstab, so I use the shorter LABEL=, instead.
> 
> While considering how to make Btrfs snapshots bootable in a sane manner
> over on grub-devel@, I'm finding that fstab is almost entirely obsolete
> and we need a more dynamic approach. Any rootfs snapshot contains a
> wrong fstab. So it's almost like we need a revamped format that enables
> some entries to be static and others to be 2nd guessed/dynamically
> altered, so that the right subvolumes are mounted rather than prior
> ones.

I tend to be wary of snapshot-backups (except perhaps for first-level) in 
any case, since btrfs is still immature enough I consider it a primary 
risk point and I don't want all my backup eggs in the same basket.

But I faced the same problem here some years ago, since my backup system 
uses what amounts to snapshot copies (copies of the entire filesystem 
frozen at the time I copied them, a snapshot in time, as it were) to 
other independent filesystems, thus allowing me to boot either the 
working copy or a backup copy by simply switching the kernel commandline 
root= flag.

My solution has evolved a bit over time and may continue to, but as of 
now I have a setup where /etc/fstab is actually a symlink to one of 
several fstab.X files in /etc/fstab.d.  These multiple fstab.X files are 
in turn created by scripts, using stub-sources of just a few lines each, 
as found in /etc/fstab.d/mk/.  Running a single master script runs 
several individual fstab.X creator scripts each in its turn, each 
creating an fstab targeting a different rootfs backup, with each rootfs 
having two fstab.X files, one that mounts the working copy of extra 
filesystems (/home, etc), the other mounting the backup in place of the 
working copy, with each one having the unmounted set manually mountable 
if desired,  Additionally, each stub-source file is identified with a 
#comment listing the filename, so I can trace what file it originates in 
when I'm reading fstab.

After I copy my rootfs to a partition located elsewhere, before I umount 
I switch the /etc/fstab symlink to point at the appropriate fstab with 
the working-copy extra partitions.  So all I have to do to boot it is 
point the kernel's root= option appropriately.

If instead I want to mount the backup copies of the extra partitions as 
the working copies (with the normally working copies in turn available as 
to mount as backups), I add s (single user) to the kernel's command line 
as well, and when I get the singleuser-mode shell, I remount / rw and 
flip the symlink to the fstab.X that loads the backups as the working 
copy.  I can then either reboot or exit single-user and the init system 
will pickup where it left off, except fstab will point at the fstab.X 
file I want now, so those non-rootfs filesystems will be mounted instead.

The arrangement is thus a bunch of fstab stub files, the scripts to 
assemble them into a bunch of fstab.X files, and fstab itself as a 
symlink, pointing to the fstab.X I actually want. =:^)

It ends up working reasonably well, but don't forget the #comments in the 
stub-files identifying what's providing those fstab lines as that's 
critical debug info when you're trying to figure out why the fstab.X file 
doesn't have the lines you thought it should have (is it the script 
catting in the wrong stub file, or is the stub file wrong, and if it's 
the latter, which stubfile?).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

