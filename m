Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46908 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbbBSW6E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Feb 2015 17:58:04 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YOa2j-0003vS-6P
	for linux-btrfs@vger.kernel.org; Thu, 19 Feb 2015 23:58:01 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Feb 2015 23:58:01 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Feb 2015 23:58:01 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Systemd 219 journald now sets the FS_NOCOW file flag for its
 journal files, possibly breaking RAID repairs.
Date: Thu, 19 Feb 2015 22:57:55 +0000 (UTC)
Message-ID: <pan$2d7cc$e0bdaf95$2e0adb00$bdd0af46@cox.net>
References: <54E5F38D.4070104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Konstantinos Skarlatos posted on Thu, 19 Feb 2015 16:30:37 +0200 as
excerpted:

> Systemd 219 now sets the special FS_NOCOW file flag for its journal
> files[1]. This unfortunately breaks the ability to repair the journal on
> RAID 1/5/6 btrfs volumes, should a bad sector happen to appear there. Is
> this something that can be configured for systemd?

IIRC I suggested that it be configurable, but default to nocow, in the 
original discussion here, some months ago.  But while I saw the 219 
announcement, I've not upgraded to it yet, to know whether that 
suggestion was implemented or not.

What I can say with some confidence is that if it's implemented, it 
should be quite well documented, as systemd gets VERY high marks here for 
generally high configurability and even better consistency in documenting 
that configurability, almost to an extreme, but that's the way I like it 
and the one thing that made the switch to systemd as easy as it was here, 
since I'm a gentooer, with the famous gentooer like of extreme 
customization, such that I'd have been unlikely to switch and griping all 
the way if I did, without that documentation. =:^)

Try the journald.conf manpage.  If the option exists, journald.conf is 
almost certainly where it's located, and thus that manpage where it'll 
almost certainly be documented.  If there's nothing about it there, then 
I'd put chances at better than 98% that there's no such option, beyond 
patching one in yourself, of course, systemd being freedomware as it is. 
=:^)

Meanwhile...

Insert customary gripe about binary-format log-files here...

What I've done here (and posted before, with someone else saying it was a 
good idea he'd try, so I'm posting a bit more detail this time, hopefully 
saving some duplicated trial and error to arrive at workable settings) is 
this:

1) Journald is configured for single-session mode, journaling to tmpfs 
only.

This give me the best of the journald benefits, getting the last few log 
entries for a service when I run a systemctl status on it, etc, without 
having to hassle the binary journal format on permanent storage.

2) My previous syslog service (syslog-ng) remains installed, writing its 
usual text-based logs to permanent storage in traditional log append-only 
fashion.  That works as it always has, with my syslog-ng config for 
sorting messages to various logfiles after dumping any "noise" straight 
to /dev/null.

Additional notes:

3) Logrotate is still used, now with a systemd timer job instead of the 
old cron job (I unmerged cron after switching everything to systemd 
timers), to handle log rotation.

4) Noise:  Unfortunately I've not found a way to tell journald to simply 
dump certain "noise" messages to /dev/null, without tracking them or 
writing them anywhere else.  There's a reasonable variety of options to 
filter message display, but they're all post-storage (tmpfs and if 
configured, permanent), so such noise continues to bulk up the journals 
unnecessarily, even when it really *IS* noise that I don't want tracked 
or stored AT ALL.  An example would be a job I have that executes an sudo 
every few seconds, multiple times per minute.  There's a way to tell sudo 
not to log it, but pam still logs it and I never found a way to tell it 
not to.  Back when I was running only syslog-ng, it was easy enough to 
setup a filter that dumped that "noise" to /dev/null and never actually 
logged it anywhere, so the logs didn't quickly fill up with this stupid 
pam noise.  Unfortunately, I've not figured out a way to tell journald 
the same thing, so it still tracks all that pam noise.  I can filter the 
post-journal output, but it's still in the journal; no way I can see to 
kill that.

Fortunately, however, the journal's binary format is compressed, and it 
apparently compresses that down to one instance, with all the rest being 
effectively a compressed timestamp and a reference back to the first one 
for the other tracked details.  So that doesn't affect the tmpfs size of 
the journals so badly, and the writes to permanent storage don't happen 
since journald has that turned off, and systemd-ng has it filtered out 
*before* it gets logged.

5) FWIW, notes on my config:

5a) journald.conf non-default settings:

ForwardToSyslog=yes
RuntimeKeepFree=48M
RuntimeMaxFileSize=64M
RuntimeMaxUse=448M
Storage=volatile
TTYPath=/dev/tty12

5b) syslog-ng, as I guess most sysloggers, now has a build-time configure 
option for systemd, which links it to the journald libs and eases 
cooperation between journald and the traditional syslogger.  On gentoo 
that's controlled by the systemd USE flag.  Naturally I have it on (as 
will most systemd-based binary distros, for their logger packages, I 
imagine).  I believe something similar could be configured without that, 
but it'd be much more difficult and could result in some stuff appearing 
in syslog twice, while other stuff might get missed.

5c) The tmpfs I had mounted on /run, which is where journald stores its 
volatile journals, was originally too small, as all it used to handle was 
a few tiny pid files and some zero-size lock files.  With journald 
logging a full sometimes several day boot session to tmpfs-only, I had to 
increase the maximum tmpfs size for /run.  It's now 512 MiB (half a gig), 
still small enough not to have to worry about too much on a 16 GiB memory 
system, but large enough to handle several days worth of journals, 
including the "noise" I griped about in #4.  But that's the reason behind 
the RuntimeMaxUse and RuntimeKeepFree options above, as with that strict 
a tmpfs limit /designed/ to have journald use /most/ of it, the journald's 
default size settings, designed to shut down logging when space gets too 
tight, shut it down when there's still plenty of space left on the tmpfs.

Obviously you can adjust the tmpfs size and Runtime* settings in 
journald.conf as necessary for your system.

5d) I mentioned using systemd timers instead of cron to trigger 
logrotate.  That's out of scope for this post, but if someone's 
interested enough to request them, I can post them...


I've been happy with this setup and believe it gives me the best of both 
worlds, journald's nice log output in service status reports for the 
current session, only what I want logged to permanent storage, in my 
preferred text format and sorted in my preferred way into various files, 
both for this session and previous sessions, until I logrotate the logs 
out, just as I was doing before systemd.

And I don't have to worry about systemd's binary journal format on btrfs! 
=:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

