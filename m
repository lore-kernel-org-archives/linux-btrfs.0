Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blaine.gmane.org ([80.91.229.8]:49570 "EHLO blaine.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbcHADsm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Jul 2016 23:48:42 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bU3yq-0008LL-Pa
	for linux-btrfs@vger.kernel.org; Mon, 01 Aug 2016 05:33:28 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: systemd KillUserProcesses=yes and btrfs scrub
Date: Mon, 1 Aug 2016 03:33:17 +0000 (UTC)
Message-ID: <pan$78252$34552641$3836f6b6$31bf3e7c@cox.net>
References: <CAJCQCtQ4CXjBzR6eo0zibDCb9_p0jAiS2q_fCRUkUNVWiM9i6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sat, 30 Jul 2016 14:02:17 -0600 as excerpted:

> Short version: When systemd-logind login.conf KillUserProcesses=yes, and
> the user does "sudo btrfs scrub start" in e.g. GNOME Terminal, and then
> logs out of the shell, the user space operation is killed, and btrfs
> scrub status reports that the scrub was aborted. [1]

What does btrfs scrub resume do?  Resume, or error?

If it resumes, I'd say RESOLVED/NOTABUG as both that systemd option and 
btrfs scrub appear to be working as intended.  If it doesn't, then 
there's definitely a btrfs bug, even if you argue it's only in the 
documentation, because the manpage (tho still 4.6.1, here) says it 
resumes an interrupted scrub but won't start a new one if the scrub 
finished successfully, and an abort is definitely an interruption, not a 
successful finish.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

