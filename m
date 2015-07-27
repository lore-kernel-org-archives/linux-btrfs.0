Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:32849 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbbG0FUr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 01:20:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZJaqD-0005V4-44
	for linux-btrfs@vger.kernel.org; Mon, 27 Jul 2015 07:20:45 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2015 07:20:45 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2015 07:20:45 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: systemd : Timed out waiting for defice
 =?CP1251?Q?dev-disk-by=85?=
Date: Mon, 27 Jul 2015 05:20:38 +0000 (UTC)
Message-ID: <pan$a902b$10dd7fbd$f0ca0693$dc0cc8e3@cox.net>
References: <1437763277.673610371@apps.rackspace.com>
	<55B54568.5060902@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Philip Seeger posted on Sun, 26 Jul 2015 22:39:04 +0200 as excerpted:

> Hi,
> 
>> 50% of the time when booting, the system go in safe mode because my 12x
>> 4TB RAID10 btrfs is taking too long to mount from fstab.
> 
> This won't help, but I've seen this exact behavior too (some time ago).
> Except that it wasn't 50% that it didn't work, more like almost
> everytime.
> Commenting out the fstab entry "fixed" it, mounting using a cronjob
> (@reboot) worked without a problem.
> 
> (As far as I remember, options like x-systemd.device-timeout didn't
> change anything.)
> 
> If someone has the answer, I'd be interested too.

You mean something like a custom systemd *.service unit file?  That's 
what I'd do here. =:^)

Were I to have that issue here[1], I'd use the usual an fstab entry, but 
I'd set the noauto option in fstab, so it doesn't get mounted with the 
rest of the partitions.  The reason to still have it in fstab is so I can 
easily set and track mount options, without having to feed them to mount 
on the commandline.  FWIW, I've been using entries with noauto in fstab 
that way, for more than a decade now, since I switched from MS when they 
jumped the "we demand the right to authorize you on your own system" 
shark with eXPrivacy, so _waaayyyy_ before systemd, and I still consider 
myself a relative Linux/Unix newbie.  That's the way it has always 
worked, and systemd doesn't change that.

Now, all my noauto filesystems I actually mount only when I'm going to 
use them, then umount them afterward.[2]  So I don't actually want them 
mounted at boot anyway.

But if I had the issue with mounts taking too long for normal processing 
at boot, but I still wanted them mounted more or less at boot so they 
were ready when I wanted to use them, I'd do what I've done for a few 
other custom services, setup my own custom systemd unit for them, with 
systemd options setup so it started either with or after everything else, 
but the system was considered booted before it actually finished, so I 
didn't have to wait for it to finish to login and start working.

With the mount options, including noauto, set in fstab, I'd simply setup 
a service unit that ran mount as its action, feeding mount LABEL= or the 
mountpoint or devicepath or whatever else I used to refer to the device, 
but letting it get the options and the other path (mountpoint or 
devicepath, the one I didn't feed it) from fstab, based on the one I did 
feed it.  IOW, the mount command would be basically the same thing I'd do 
to mount a filesystem listed in fstab, manually, only here it'd be setup 
as the operative command in a custom systemd service file.

Something like this (untested for mount, but based on a non-mount custom 
service unit I have):

Filename: /etc/systemd/system/local.boot.mount.bigpool.service

(Here, I'd name it jed.boot.mount.whatever.service, jed being my initials 
and thus a very common "custom config" file identifier, .service of 
course to identify it as a systems service, and /etc/systemd/system/ is 
the place such custom services normally go.)


File contents (between ---- delimiters):

-----------------------------------------
[Unit]
Description=Local boottime bigpool mounting
After=multi-user.target graphical.target

[Service]
Type=idle
RemainAfterExit=yes
ExecStart=/bin/mount LABEL=whatever
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
-----------------------------------------

Explanation, Unit section:

Description is what systemd will say it's starting/started.

After= is optional and tells it to run /after/ these targets.  multi-
user.target is the normal CLI target, for CLI login and servers, 
graphical.target is the normal graphical login target (*DM).  Thus, this 
says wait until the system is otherwise up, before running this service.

If you want systemd to wait until the system is otherwise up to run the 
service, use an after= similar to my setting above.  Do this if you want 
as fast a boot as possible and don't really consider this service part of 
boot but just want it already mounted when you need it, and/or if don't 
care if it takes a bit longer to actually process this service.

If OTOH, running this service won't interfere with starting other 
services (say the filesystem is all separate physical devices, not 
partitions on the same devices already busy starting other services), and 
you want it to start as soon as possible so it's running in parallel with 
the rest of the boot process, omit the after=.

Service section:

Type=idle is optional and should have a similar effect to the after= line 
in the unit section.  It'll wait until all other jobs are dispatched 
before this one runs.  However, I believe this is a fairly new service 
section option (I'm running systemd 222), and I've not used it before, 
while I have used the combination of after=multi-user.target in the unit 
section, along with wantedby=multi-user.target in the install section, to 
get what should be a similar effect.

If type= isn't set, it defaults to type=simple, which is otherwise what 
we want here.  The systemd.service manpage has more info on this and 
other service section options.

RemainAfterExit=yes tells systemd to consider the service still running 
after the executed process (mount in our case) exits.  It'll use exit 
status to track success/fail, and log STDOUT/STDERR to the journal, so 
checking service status works as expected, even after mount has exited.

ExecStart=/bin/mount LABEL=whatever is of course the main command that 
the service runs.  /bin/mount may of course be /sbin/mount or /usr/bin/
mount, etc, depending on where your distro puts it, and you'd replace 
LABEL=whatever with whatever you're using to ID that filesystem, 
mountpoint, label, UUID, devicepath, etc.  Again, with the entry in fstab 
already, but with noauto in the options, the normal mount service won't 
mount the filesystem, but you only have to supply mount the one bit of 
identifying info (here I used LABEL=) it needs to look it up in fstab, 
where it gets all the other info it needs, including mount options.

TimeoutStartSec=0 disables the usual service timeout.  Optionally, set it 
to some value longer than the system-default (see the systemd-system.conf 
manpage under DefaultTimeoutStartSec), that's long enough the mount 
should have normally completed by then.

Many services would have an ExecStop= entry as well, the command to run 
when shutting down the system.  But for mounts, systemd will 
automatically take care of that when it does the normal umounts, so you 
don't need an explicit execstop=umount whatever line.

Install section:

WantedBy=multi-user.target tells systemd where to hook in the service at 
installation so it starts at the desired time.  As explained above, 
multi-user.target is the main system CLI target, which is where most 
services go.  When the service is installed/enabled in systemd, systemd 
will place a symlink to our service in the appropriate systemd/system/
*.target.wants/ subdir, in this case /etc/systemd/system/multi-
user.target.wants/local.boot.mount.bigpool.service, pointing at 
/etc/systemd/system/local.boot.mount.bigpool.service.

Of course since you're creating the custom service unit yourself, you 
could in theory simply place the service file itself directly in the 
*.target.wants location, instead of placing it in /etc/systemd/system.  
That would enable it automatically, without an install section, but then 
you couldn't enable/disable it, except by manually moving the file.  With 
the install section in place, and with the file in the usual system 
location, you can systemctl enable/disable it, and systemd will manage 
the symlinks for it as it does with other services when you enable/
disable them.

Don't forget to enable the new service. =:^)

systemctl enable local.boot.mount.bigpool.service

(If you have systemd shell tab/autocompletion turned on, you can of 
course use it to avoid having to type in the whole thing, as well as 
helping to avoid typos.  And of course, if it's not yet mounted (or you 
can quick-umount it so you can test the service), you can start the 
service right then if desired, standard systemctl start ... .)

For more information and other unit file options available to you, and 
for the details on how the above lines work, see the usual systemd 
manpages, systemd.unit, systemd.service, systemd.exec, systemd.mount, 
etc, plus the mount and fstab manpages, and other systemd and mount 
documentation.

---
[1] I don't have the issue here as I have multiple independent btrfs, all 
on a pair of fast ssds, partitioned identically, with the btrfs raid1 
data/metadata on parallel partitions on each ssd (save for /boot and its 
backup, which are btrfs mixed-bg in dup mode, one to each device).

[2] No, I _don't_ trust this new-fangled automount stuff.  Too much like 
MS for my tastes.  I mount and umount manually, altho I do have helper 
scripts setup so it's only 3-5  keys (mt m to toggle mounting of my 
multimedia partition, for instance, or mt m m/u to specifically mount/
umount it), and some of my other scripts do mount as part of their work, 
too.  (My update script tests and mounts if necessary the filesystem 
containing the package repo, for instance, before updating it.  It also 
remounts / rw, since it's normally ro and attempted system updates would 
thus fail.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

