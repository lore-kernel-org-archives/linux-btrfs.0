Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40081 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaFOLcP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Jun 2014 07:32:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ww8fV-00017A-SG
	for linux-btrfs@vger.kernel.org; Sun, 15 Jun 2014 13:32:13 +0200
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Jun 2014 13:32:13 +0200
Received: from hurikhan77 by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Jun 2014 13:32:13 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Slow startup of systemd-journal on BTRFS
Date: Sun, 15 Jun 2014 13:18:51 +0200
Message-ID: <r1c07b-9fm.ln1@hurikhan77.spdns.de>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost> <pan$22693$6b452195$976b783a$e4956372@cox.net> <20140612232453.GR9508@dastard> <539B78F3.9070607@libero.it> <pan$625ac$a8aa7477$d0179ebe$c66ba817@cox.net> <jhmt6b-j4j.ln1@hurikhan77.spdns.de> <pan$ad44b$2c1071b2$aca734b5$a4151968@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Cc: systemd-devel@lists.freedesktop.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan@cox.net> schrieb:

>> Back to the extents counts: What I did next was implementing a defrag
>> job that regularly defrags the journal (actually, the complete log
>> directory as other log files suffer the same problem):
>> 
>> $ cat /usr/local/sbin/defrag-logs.rb #!/bin/sh exec btrfs filesystem
>> defragment -czlib -r /var/log
>> 
>> It can be easily converted into a timer job with systemd. This is left
>> as an excercise to the reader.
>> 
>> BTW: Actually, that job isn't currently executed on my system which
>> makes the numbers above pretty impressive... However, autodefrag is
>> turned on which may play into the mix. I'm not sure. I stopped
>> automatically running those defrag jobs a while ago (I have a few more).
> 
> Thanks for the timer hint, BTW.  I actually already created an hourly and
> a daily timer job here (turns out that's all I needed, no weekly/monthly/
> whatever needed so I didn't create those) as I switched over to systemd
> and got rid of crond, and I'll definitely keep the defrag-journals timer
> idea up my sleeve in case I decide to set journald back to keeping non-
> volatile journals as well, plus as a helpful hint for others.  Tho I
> won't be using it myself currently as the volatile journals only while
> handing off to syslog-ng for the longer term logs is working very well
> for me ATM, a good sysadmin likes to have a set of tricks such as that
> ready in case they're needed, and I'm certainly no exception! =:^)

I did not yet get rid of cron. The systemd devs once noted that timers are 
not a cron replacement - tho I'm sure this was meant for running user jobs 
not system jobs. The idea back then was to use systemd user session spawning 
with timers and the devs stated that such a usage is different from how cron 
spawns user jobs, and one should just stick to cron for that because the 
purpose of systemd user sessions is different.

I already created timer targets for daily, hourly, monthly so I could just 
symlink service units there. What's needed is some sort of systemd generator 
to auto-create services from /etc/cron.{hourly,daily,monthly,weekly} and 
auto-install them in the matching targets which are:

$ for i in $(find -type f -name "timer-*");do echo "# $i:";cat $i;echo;done
# ./timer-weekly.target:
[Unit]
Description=Weekly Timer Target
StopWhenUnneeded=yes

# ./timer-daily.target:
[Unit]
Description=Daily Timer Target
StopWhenUnneeded=yes

# ./timer-hourly.target:
[Unit]
Description=Hourly Timer Target
StopWhenUnneeded=yes

# ./timer-daily.timer:
[Unit]
Description=Daily Timer

[Timer]
OnBootSec=10min
OnUnitActiveSec=1d
Unit=timer-daily.target
AccuracySec=12h

[Install]
WantedBy=basic.target

# ./timer-hourly.timer:
[Unit]
Description=Hourly Timer

[Timer]
OnBootSec=5min
OnUnitActiveSec=1h
Unit=timer-hourly.target
AccuracySec=30min

[Install]
WantedBy=basic.target

# ./timer-weekly.timer:
[Unit]
Description=Weekly Timer

[Timer]
OnBootSec=15min
OnUnitActiveSec=1w
Unit=timer-weekly.target
AccuracySec=12h

[Install]
WantedBy=basic.target


Then it's a matter of creating services which are "WantedBy timer-
weekly.target" or whatever is appropriate and they should execute after 
being installed. Maybe I'm trying to copy what Gentoo is doing for 
/etc/local.d with systemd (there's a generator in the gentoo-systemd-
integration ebuild [1] for files in that directoy). However, when going that 
route, cron should no longer be installed or at least be configured to not 
run these jobs on its own. But then, the above mentioned method of running 
user jobs would be needed - and that's not recommended (and I didn't get it 
to work either).


[1]: /usr/lib/systemd/system-generators/gentoo-local-generator

-- 
Replies to list only preferred.

