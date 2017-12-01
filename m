Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:44750 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751236AbdLAHS6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Dec 2017 02:18:58 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eKfay-000784-HP
        for linux-btrfs@vger.kernel.org; Fri, 01 Dec 2017 08:18:48 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-progs - failed btrfs replace on RAID1 seems to have left
 things in a wrong state
Date: Fri, 1 Dec 2017 07:18:39 +0000 (UTC)
Message-ID: <pan$5abb1$c7dbef76$8f3acd4$8912c489@cox.net>
References: <CAKYHq8+crFyGA7UjaTQehOY5BcKnFLXPVMQ=VZqbeV-XhU63Yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Eric Mesa posted on Thu, 30 Nov 2017 07:43:59 -0500 as excerpted:

> Hello,
> 
> Not sure if this is a reportable bug, so I figured I'd start on the
> mailing list and then report a bug if it is a bug and not user error.
> 
> Here is the original state of a RAID1 in which I wanted to replace the
> smaller drive (except the /dev/sdX was different):
> 
>      btrfs filesystem show
> 
>      Label: 'Photos'  uuid: 27cc1330-c4e3-404f-98f6-f23becec76b5
>             Total devices 2 FS bytes used 2.56TiB
>            devid    1 size 2.73TiB used 2.57TiB path /dev/sde1
>            devid    2 size 3.64TiB used 2.57TiB path /dev/sdb1
> 
> I added a 6TB HD to the system via a Zalman "toaster"-like external
> hard drive via USB2.0. I ran the command:
> 
> btrfs replace start -f 1 /dev/sdl /media/Photos/
> 
> For some reason - perhaps pertaining to the USB enclosure having
> errors, I ended up with this as the output of status:
> 
> Started on 29.Nov 21:32:46, canceled on 29.Nov 21:52:31 at 0.0%,
> 236415 write errs, 0 uncorr. read errs

Your guess as to the culprit there being the USB is likely correct.
Based on many reports on-list and apparently even more on the btrfs
IRC channel (I don't personally do IRC so that's based on comments
from list regulars that volunteer there as well), USB, or arguably
USB hardware, simply isn't error-robust enough to work well with
multi-device.  People using other filesystems which don't do multi-
device, or indeed, btrfs in single-device mode, don't seem to have
the same problem, in part because in that case the entire filesystem
is either there or not atomically, with no chance for one part that's
still there to get out of sync with another part that's missing.

So the below move to SATA/internal was wise, and would be my first
recommendation as well. =:^)  Unfortunately...

> So I moved the computer inside by disconnected an optical drive and
> connected the drive via its SATA data and power cables. The system now
> recognizes it as /dev/sda.
> 
> When I do a btrfs fi show, I get the same output as above.
> 
> But when I try to go again:
> 
> btrfs replace start -f 1 /dev/sda /media/Photos/
> 
> ERROR: /dev/sda is mounted
> 
> And when I do a dmesg | grep sda
> 
> [    1.448727] sd 0:0:0:0: [sda] Attached SCSI disk
> 
> [    3.920449] BTRFS: device label Photos devid 0 transid 158105 /dev/sda
> 
> btrfs device delete 0 /media/Photos/
> 
> ERROR: error removing devid 0: unable to go below two devices on raid1

OK, this is (partly) because btrfs doesn't really have dynamic/runtime
device-management to speak of.  When udev sees a device it triggers
a btrfs device scan, which lets btrfs know which devices belong to which
individual btrfs.  But once it associates a device with a particular
btrfs, there's nothing to unassociate it -- the only way to do that on
a running kernel is to successfully complete a btrfs device remove or
replacement... and your replace didn't complete due to error.

Of course the other way to do it is to reboot, fresh kernel, fresh
btrfs state, and it learns again what devices go with which btrfs
when the appearing devices trigger the udev rule that triggers a
btrfs scan.

Yes, that's a bug, or more correctly, a known unimplemented feature, tho
there are patches now in the pipeline to change that (I'm not sure the
state but I /think/ they might actually hit 4.15)... btrfs being
still under active development and stabilizing, but not yet fully stable
and mature, of course, with this being one of several still missing
features.

So to cope with that part of the problem you need to blank the device
well enough to ensure that btrfs device scan won't count it as still
part of that filesystem (more on that to follow) when starting clean,
and reboot, so btrfs forgets about what it thinks it knows about the
current state and actually /does/ start clean.

Meanwhile, the other part of the problem would seem to be that the
failed btrfs replace (the first USB one) got at least as far as
writing the superblock, identifying the btrfs it belonged to, before
it started failing, and that's what btrfs device scan uses to register
that device as part of the filesystem in question.

But...

> I tried reformatting the drive, but still have this issue.

"Reformat"??  Meaning precisely???

Strictly speaking, "reformat" as used in the MS world generally refers to
"mkfs" as used in the Linux/Unix world.  There's also fdisk (or gdisk or
some other variant), which is normally used for partitioning, so multiple
filesystems can be created on the same (normally) physical device (tho
creating lower level compound block-devices using lvm/dmraid/mdraid/etc is
also possible, with each of the volume's component devices itself either a
physical device, or a partition on a physical device).

But it's worth noting that neither type of "reformatting", either at the
filesystem or partitioning level normally entirely blanks the device (tho
modern filesystem mkfs' may take advantage of trim/discard to blank the
device on devices such as ssds that support it, mkfs.btrfs will, if it
detects a device that supports it).  Instead, they do a "quick format",
which involves writing out the superblock and some filesystem initialization
information to tell the filesystem what parts of the device are actually
used, and ignoring the rest.

And indeed, it's often possible to recover data off a "formatted" device
by simply raw-reading the "garbage" data remaining from a previous
filesystem off the device itself, then using various techniques such as
detailed knowledge of that particular filesystem's storage structure and
individual file type structures to reconstruct some data, with at least
a few files often recoverable, and sometimes, nearly the entire filesystem.

So depending on exactly what you did that you called "reformatting", chances
are very high that the old btrfs superblock remained on the "reformatted"
filesystem, and that's what the normally automated and triggered by udev
btrfs device scan is seeing, that continues to associate it with the
filesystem, despite not enough of it actually being there to show up in
the below reports.

> Here are some outputs of commands I ran:
> 
>     # umount /media/Photos
> 
>     # btrfs check --readonly /dev/sda
>     parent transid verify failed on 3486916509696 wanted 158105 found 158107
>     parent transid verify failed on 3486916509696 wanted 158105 found 158107
>     parent transid verify failed on 3486916509696 wanted 158105 found 158107
>     parent transid verify failed on 3486916509696 wanted 158105 found 158107
>     Ignoring transid failure

Note that the transid found is two transactions later than the transid wanted.
This is quite typical of one device getting out of sync with others on a
multi-device btrfs.  In an otherwise normally functioning raid1 that can still
mount, a btrfs scrub will usually fix the problem, but of course your situation
is more complex than that, since parts of the filesystem think there are
devices that don't appear to the rest of the filesystem.

>     # btrfs fi show
 [omitting other btrfs... and a couple other commands with similar results]
> 
>     Label: 'Photos'  uuid: 27cc1330-c4e3-404f-98f6-f23becec76b5
>             Total devices 2 FS bytes used 2.56TiB
>             devid    1 size 2.73TiB used 2.57TiB path /dev/sde1
>             devid    2 size 3.64TiB used 2.57TiB path /dev/sdb1

>     # btrfs replace start -f 1 /dev/sda /media/Photos/
>     ERROR: /dev/sda is mounted

>     # cat /proc/mounts  | grep sda
>     #

Note that the normal kernel mount table only has a single device slot, and
therefore can only show a single device for a multi-device btrfs.  As such,
a missing device there does *NOT* mean the (multi-device) btrfs (partially)
hosted on that device isn't mounted, because it can simply be listed there
with one of the other component device names.

And of course as we've already established above, in your case btrfs is
internally tracking three devices for the filesystem, tho it's only showing
two, due to the incomplete replace.

> 
>     # btrfs dev usage /media/Photos/
>     /dev/sdb1, ID: 2
>     Device size:             3.64TiB
>     Device slack:              0.00B
>     Data,single:             1.00GiB
>     Data,RAID1:              2.56TiB
>     Metadata,single:         1.00GiB
>     Metadata,RAID1:          5.00GiB
>     System,single:          32.00MiB
>     System,RAID1:           32.00MiB
>     Unallocated:             1.07TiB
> 
>     /dev/sde1, ID: 1
>     Device size:             2.73TiB
>     Device slack:              0.00B
>     Data,RAID1:              2.56TiB
>     Metadata,RAID1:          5.00GiB
>     System,RAID1:           32.00MiB
>     Unallocated:           166.49GiB


With both btrfs dev show and btrfs dev usage displaying only two
devices for the filesystem, you appear to be in luck, with all
data intact on the two devices.  All you should have to do is
properly erase the other device so btrfs device scan doesn't
get mixed up, reboot to clean up the old/invalid scan state,
and you should be able to do a proper replace, this time hopefully
completing successfully since it's on SATA now.

See below for how...

> There appears to be some kind of weird situation going on:
> 
>      # btrfs device remove /dev/sda /media/Photos/
>      ERROR: error removing device '/dev/sda': unable to go below two
> devices on raid1
>      # btrfs device remove /dev/sdb /media/Photos/
>      ERROR: error removing device '/dev/sdb': unable to go below two
> devices on raid1
>      # btrfs device remove /dev/sde /media/Photos/
>      ERROR: error removing device '/dev/sde': unable to go below two
> devices on raid1

> who (filesystem? disk? some program?) maintains the info on what was
> going on with /dev/sda? I feel like there's some kind bit I need to
> clear and then it'll work correctly.
> 
> ---
> 
> So my question is two-fold.
> 
> 1) Where do I go from here to get things working for me? I have my
> photos on these drives (which is why I went RAID1 so I could have high
> availability backup-ish situation) so I don't want to do anything
> destructive to the two drives currently working fine in the array.

Before I actually answer that...

It's worth stressing that raid is *NOT* backup.  In particular, while
it /can/ save you from a device failure, it will /not/ normally save
you from fat-fingering, making a mistake and deleting something, or
doing a rm -rf that removes too much, or doing a mkfs or fdisk on
the wrong device, etc.  And it's not going to save you from filesystem
bugs that take down the entire filesystem, either, a particular
consideration when you're using a filesystem like btrfs that's not yet
entirely stable and mature.

I often reference here the sysadmin's first rule of backups.  The true
value you place on a set of data is measured not by any empty claims
about its value, but by the number of backups you consider it worth
having of that data.  If it's not worth having at least one true
backup, on a separate physical device, not mounted in normal use
so it's more difficult to fat-finger it, the data is demonstrably
of only trivial value, not worth the time/resources/hassle to do
that backup.

By extension the same applies to backup updating.  As soon as the data
is enough different from the previous backup to make it more valuable
than the time/resources/hassle of updating the backup, the backup will
be updated.  Thus, if it's not updated, the value of the data in the delta
between the last backup and the working copy was demonstrably less than
the value of the time/resources/hassle of updating that backup would
have been.

Of course the corresponding data recovery rule is that regardless of
whether there was a backup or not, or even if there was and all the
backups happened to fail at the same time as well, what was demonstrably
of *MOST* value is *ALWAYS* saved, because by the fact that there wasn't
at least one more level of backup, it is demonstrated that the data was
considered more trivial and of less value than the time/resources/hassle
of creating that one additional backup that would have saved the data.

Thus, even in the event of data loss one can still be happy... because
what was defined as of MOST value, the time/resources/hassle of that
backup that wasn't, was saved! =:^)


FWIW, I use btrfs raid1 here too, but I have multiple btrfs raid1, setup
on different devices, with backups such that if my working btrfs raid1
copy is fat-fingered or otherwise goes bad, I still have at least one
backup available, and for most things, two. (The exception is the log
btrfs, I do have a second one to fall back to if necessary, but it's
not a backup, just a different place to log if the one is unavailable.
The log data is ephemeral and trivial enough that it's not worth backing up.)

And I recently updated even my backups and media partition devices to ssd,
in large part so it'd be easier to do those backups, bringing down the hassle
factor cost so I could update the backups more frequently/regularly as I
wasn't entirely happy with the amount of unbacked-up data I was leaving
exposed in that data delta.  And indeed, I /have/ been doing more frequent
backups as a result. =:^)


So don't let raid be an excuse for not doing backups.  It can be an important
and useful part of a data protection solution, particularly with the added
value of btrfs checksumming and repair from the second copy, but as you're
finding out, it's *NOT* a replacement for a proper backup!


As for the solution to your "there yet not there" device, the Problem FAQ
on the wiki deals with it:

https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#How_to_clean_up_old_superblock_.3F

Very briefly, use wipefs (easiest) or dd to clear the btrfs "magic" in the
superblock, so btrfs dev scan won't recognize it.  The details are in the link.


BTW, once you get back operational, please consider doing a balance-conversion
to get rid of those single-mode chunks on ID 2 (/dev/sdb1, in your dev usage).
Should a device go out, those will severely complicate repair.  I'll refer you
to the wiki or the btrfs-balance manpage for the details on that, as well, and
indeed, I recommend that you spend some time on the wiki reading up in general,
as it can save you some serious headaches later, if things go wrong.

> 2) The fact that a failed replace left the (system|disks|filesystem)
> thinking that the drive is both part of and not part of the RAID1 -
> does that need to be reported as a bug?

As covered above, the biggest problem, known, and actually a not yet implemented
feature as opposed to a bug, is that btrfs doesn't yet really understand
devices going away and doesn't deal with it properly.  There are patches
already in the pipeline for that.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

