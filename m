Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45399 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752111AbdD2EQu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Apr 2017 00:16:50 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d4JoH-0006bS-NT
        for linux-btrfs@vger.kernel.org; Sat, 29 Apr 2017 06:16:41 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs, journald logs, fragmentation, and fallocate
Date: Sat, 29 Apr 2017 04:16:36 +0000 (UTC)
Message-ID: <pan$53f85$ee564b6d$7f657417$325211f4@cox.net>
References: <CAJCQCtQk1p6rzUYaO19ei51YC+w1uj1qJ77OdLmL5JN3w1zNfw@mail.gmail.com>
        <5fd31e68-0199-8935-0873-78b4e7c6eb69@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli posted on Fri, 28 Apr 2017 19:05:21 +0200 as
excerpted:

> After some thinking I adopted a different strategies: I used journald as
> collector, then I forward all the log to rsyslogd, which used a "log
> append" format. Journald never write on the root filesystem, only in
> tmp.

Great minds think alike. =:^)

Only here it's syslog-ng that does the permanent writes.

I just couldn't see journald's crazy (for btrfs) write pattern going to 
permanent storage.

And AFAIK, journald has no pre-write filtering mechanism at all, only 
post-write display-time filtering, so even "log-spam" that I don't want/
need logged gets written to it, while if I see something spamming 
continuously (I run git kernels and kde, and do get such spammers 
occasionally) I setup a syslog-ng spam filter to kill it, so it never 
actually gets written to permanent storage at all.

But the tmpfs journals and btrfs traditional logs gives me the best of 
both worlds, per-boot journals with all the extra metadata, the last ten 
journal entries for it when I do systemctl status on a unit, etc, and a 
nice filtered and ordered multi-boot log that I can use traditional text-
based log-administration tools on.

The only part of it I'm not happy with is that journald apparently can't 
keep separate user and system journals when set to temporary only -- 
everything goes to the system journal.  Which eventually means that much 
of the stdout/stderr debugging spew that kde-based apps like to spew out 
ends up in the system journal and (would be in the) log.  But that's a 
journald "documented bug-feature", and I can and do syslog-ng filter it 
before it actually hits the written system log (or console log display).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

