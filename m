Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42024 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbaFLEjT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 00:39:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WuwnC-0002EC-JJ
	for linux-btrfs@vger.kernel.org; Thu, 12 Jun 2014 06:39:14 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jun 2014 06:39:14 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jun 2014 06:39:14 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Slow startup of systemd-journal on BTRFS
Date: Thu, 12 Jun 2014 04:39:00 +0000 (UTC)
Message-ID: <pan$114e$cb58c121$34286c85$f093cbbf@cox.net>
References: <5398CA16.3030609@libero.it> <1751055.d79eDl77JG@xev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: systemd-devel@lists.freedesktop.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Thu, 12 Jun 2014 11:18:37 +1000 as excerpted:

> On Wed, 11 Jun 2014 23:28:54 Goffredo Baroncelli wrote:
>>         https://bugzilla.redhat.com/show_bug.cgi?id=1006386
>> 
>> suggested me that the problem could be due to a bad interaction between
>> systemd and btrfs. NetworkManager was innocent.  It seems that
>> systemd-journal create a very hight fragmented files when it stores its
>> log. And BTRFS it is know to behave slowly when a file is highly
>> fragmented. This had caused a slow startup of systemd-journal, which in
>> turn had blocked the services which depend by the loggin system.
> 
> On my BTRFS/systemd systems I edit /etc/systemd/journald.conf and put
> "SystemMaxUse=50M".  That doesn't solve the fragmentation problem but
> reduces it enough that it doesn't bother me.

FWIW, as a relatively new switcher to systemd, that is, after switching 
to btrfs only a year or so ago...  Two comments:

1) Having seen a few reports of journald's journal fragmentation on this 
list, I was worried about those journals here as well.

My solution to both this problem and to an unrelated frustration with 
journald[1] was to:

a) confine journald to only a volatile (memory-only) log, first on a 
temporary basis while I was only experimenting with and setting up systemd 
(using the kernel command-line's init= to point at systemd while /sbin/
init still pointed at sysv's init for openrc), then later permanently, 
once I got enough of my systemd and journald config setup to actually 
switch to it.

b) configure my former syslogger (syslog-ng, in my case) to continue in 
that role under systemd, with journald relaying to it for non-volatile 
logging.

Here's the /etc/journald.conf changes I ended up with to accomplish (a), 
see the journald.conf(5) manpage for the documentation, as well as the 
below explanation:

Storage=volatile
RuntimeMaxUse=448M
RuntimeKeepFree=48M
RuntimeMaxFileSize=64M

Storage=volatile is the important one.  As the manpage notes, that means 
journald stores files under /run/log/journal only, where /run is normally 
setup by systemd as a tmpfs mount, so these files are tmpfs and thus 
memory-only.

The other three must be read in the context of a 512 MiB /run on tmpfs
[2].  From that and the information in the journald.conf manpage, it 
should be possible to see that my setup is (runtime* settings apply to 
the volatile files under /run):

An individual journal filesize (MaxFileSize) of 64 MiB, with seven such 
files in rotation (the default if MaxFileSize is unset is eight), 
totaling 448 MiB (MaxUse, the default being 10% of the filesystem, too 
small here since the journals are basically the only thing taking 
space).  On a 512 MiB filesystem, that will leave 64 MiB for other uses 
(pretty much all 0-byte lock and pidfiles, IIRC I was running something 
like a 2 MiB /run before systemd without issue).

It's worth noting that UNLIKE MaxUse, which will trigger journal file 
rotation when hit, hitting the KeepFree forces journald to stop 
journaling entirely -- *NOT* just to stop writing them here, but to stop 
forwarding to syslog (syslog-ng here) as well.  I FOUND THIS OUT THE HARD 
WAY!  Thus, in ordered to keep journald still functional, make sure 
journald runs into the MaxUse limit before it runs into KeepFree.  The 
KeepFree default is 15% of the filesystem, just under 77 MiB on a 512 MiB 
filesystem which is why I found this out the hard way with settings that 
would otherwise keep only 64 MiB free.  The 48 MiB setting I chose leaves 
16 MiB of room for other files before journald shuts down journaling, 
which should be plenty, since under normal circumstances the other files 
should all be 0-byte lock and pidfiles.  Just in case, however, there's 
still 48 MiB of room for other files after journald shuts down, before 
the filesystem itself fills up.

Configuring the syslogger to work with journald is "left as an exercise 
for the reader", as they say, since for all I know the OP is using 
something other than the syslog-ng I'm familiar with anyway.  But if 
hints for syslog-ng are needed too, let me know. =:^)


2) Someone else mentioned btrfs' autodefrag mount-option.  Given #1 above 
I've obviously not had a lot of experience with journald logs and 
autodefrag, but based on all I know about btrfs fragmentation behavior as 
well as journald journal file behavior from this list, as long as 
journald's non-volatile files are kept significantly under 1 GiB and 
preferably under half a GiB each, it shouldn't be a problem, with a 
/possible/ exception if you get something run-away-journaling multiple 
messages a second for a reasonably long period, such that the I/O can't 
keep up with both the journaling and autodefrag.

If you do choose to keep a persistent journal with autodefrag, then, I'd 
recommend journald.conf settings that keep individual journal files to 
perhaps 128 MiB each.  (System* settings apply to the non-volatile files 
under /var, in /var/log/journal/.)

SystemMaxFileSize=128M

AFAIK, that wouldn't affect the total journal size and thus the number of 
journal files, which would remain 10% of the filesystem size by default.

Alternatively, given the default 8-file rotation if MaxFileSize is unset, 
you could limit the total journal size to 1 GiB, for the same 128 MiB 
individual file size.

SystemMaxUse=1G

Of course if you want/need more control set both and/or other settings as 
I did for my volatile-only configuration above.

---
[1] Unrelated journald frustration:  Being a syslog-ng user I've been 
accustomed to being able to pre-filter incoming messages *BEFORE* they 
get written to the files.  This ability has been the important bit of my 
run-away-log coping strategy when I have no direct way to reconfigure the 
source to reduce the rate at which it's spitting out "noise" that's 
otherwise overwhelming my logs.

Unfortunately, while it seems journald has all /sorts/ of file-grep-style 
filtering tools to focus in like a laser on what you want to see AFTER 
the journal is written, I found absolutely NO documentation on setting up 
PREWRITE journal filters (except log-level, and there's global rate-
limiting as well, but I didn't want to use those, I wanted to filter 
specific "noise" messages), which means runaway journaling simply runs 
away, and if I use the size restriction stuff to turn it down, I quickly 
lose the important stuff I want to keep around when the files size-rotate 
due to that runaway!

Thus my solution, keep journald storage volatile only, relatively small 
but still big enough I can use the great systemctl status integration to 
get the last few journal entries from each service, then feed it to 
syslog-ng to pre-write filter the noise out before actual write to 
permanent storage. =:^)

[2] 512 MiB /run tmpfs.  This is on a 16 GiB RAM system, so default tmpfs 
size would be 8 GiB.  But I have several such tmpfs including a big /tmp 
that I use for scratch space when I'm building stuff (gentoo's 
PORTAGE_TMPDIR, and for fully in-memory DVD ISOs too), and I don't have 
swap configured at all, so keeping a reasonable lid on things by 
limiting /run and its major journal-file space user to half a GiB seems 
prudent.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

