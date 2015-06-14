Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51218 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbbFND44 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Jun 2015 23:56:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z3z2T-0005EC-El
	for linux-btrfs@vger.kernel.org; Sun, 14 Jun 2015 05:56:53 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Jun 2015 05:56:53 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Jun 2015 05:56:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How do I make 'btrfs scrub' report errors via email?
Date: Sun, 14 Jun 2015 03:56:48 +0000 (UTC)
Message-ID: <pan$54887$39475d2b$524c205c$69d440ea@cox.net>
References: <CAL0=0H19M7JG4o4p55Li3tF4PeA-UXb8mURcSOdPLwxfL0c1DQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

crocket posted on Sat, 13 Jun 2015 22:48:35 +0900 as excerpted:

> I can check the result of 'btrfs scrub' later, but I don't want to take
> time to actually check it.
> Does anyone know how to make 'btrfs scrub' report errors via email?
> It seems google doesn't know.

You'd throw together a script to do it, or, if you're running it as a 
cronjob, cron normally already has the ability to mail output elsewhere.  
Similarly, systemd timer jobs normally start service units, which will 
normally log to journald and possibly from journald to a more 
conventional syslog daemon (I'm running syslog-ng here), and those logs 
can be mailed, often after being sorted.

Traditionally there was a sendmail executable (originally part of 
sendmail, but many alternatives supplied a call-compatible binary) as 
well, which could be called with an address to send to, along with the 
message body, and sometimes other parameters as well.  This standardized 
things, and was generally what various daemons that mailed logs used to 
send them.  A script could call it as easy as cron and other daemons did, 
so it was pretty easy to setup output/log mailings.

These days many people don't use a full mail system on the machine, 
instead using a mail client or webmail, and all these daemons that can be 
configured to send their output elsewhere very often aren't even setup 
for it.  But it's generally still possible, either using the traditional 
sendmail executable, or by scripting a call to whatever mail client you 
normally run, having it handle the message.

Meanwhile, it's likely someone here (not me) already has such a thing 
setup and can post the script.  Of course you'd have to adjust it to use 
your own mail client, if different.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

