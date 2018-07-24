Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:59292 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S2388470AbeGXU4h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jul 2018 16:56:37 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fi3GI-0000is-6Q
        for linux-btrfs@vger.kernel.org; Tue, 24 Jul 2018 21:46:22 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: File permissions lost during send/receive?
Date: Tue, 24 Jul 2018 19:46:14 +0000 (UTC)
Message-ID: <pan$d56e4$375bb872$1bdbd77f$1569f8ce@cox.net>
References: <8202618.Xtt70Sb46P@thetick>
        <47372f67-70fd-8b11-0573-39d1137356e3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Andrei Borzenkov posted on Tue, 24 Jul 2018 20:53:15 +0300 as excerpted:

> 24.07.2018 15:16, Marc Joliet пишет:
>> Hi list,
>> 
>> (Preemptive note: this was with btrfs-progs 4.15.1, I have since
>> upgraded to 4.17.  My kernel version is 4.14.52-gentoo.)
>> 
>> I recently had to restore the root FS of my desktop from backup (extent
>> tree corruption; not sure how, possibly a loose SATA cable?). 
>> Everything was fine,
>> even if restoring was slower than expected.  However, I encountered two
>> files with permission problems, namely:
>> 
>> - /bin/ping, which caused running ping as a normal user to fail due to
>> missing permissions, and
>> 
>> - /sbin/unix_chkpwd (part of PAM), which prevented me from unlocking
>> the KDE Plasma lock screen; I needed to log into a TTY and run
>> "loginctl unlock- session".
>> 
>> Both were easily fixed by reinstalling the affected packages (iputils
>> and pam), but I wonder why this happened after restoring from backup.
>> 
>> I originally thought it was related to the SUID bit not being set,
>> because of the explanation in the ping(8) man page (section
>> "SECURITY"), but cannot find evidence of that -- that is, after
>> reinstallation, "ls -lh" does not show the sticky bit being set, or any
>> other special permission bits, for that matter:
>> 
>> % ls -lh /bin/ping /sbin/unix_chkpwd
>> -rwx--x--x 1 root root 60K 22. Jul 14:47 /bin/ping*
>> -rwx--x--x 1 root root 31K 23. Jul 00:21 /sbin/unix_chkpwd*
>> 
>> (Note: no ACLs are set, either.)
>> 
>> 
> What "getcap /bin/ping" says? You may need to install package providing
> getcap (libcap-progs here on openSUSE).

sys-libs/libcap on gentoo.  Here's what I get:

$ getcap /bin/ping
/bin/ping = cap_net_raw+ep

(getcap on unix_chkpwd returns nothing, but while I use kde/plasma I 
don't normally use the lockscreen at all, so for all I know that's broken 
here too.)

As hinted, it's almost certainly a problem with filecaps.  While I'll 
freely admit to not fully understanding how file-caps work, and my use-
case doesn't use send/receive, I do recall filecaps are what ping uses 
these days instead of SUID/SGID (on gentoo it'd be iputils' filecaps and 
possibly caps USE flags controlling this for ping), and also that btrfs 
send/receive did have a recent bugfix related to the extended-attributes 
normally used to record filecaps, so the symptoms match the bug and 
that's probably what you were seeing.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

