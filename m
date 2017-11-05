Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:43622 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751543AbdKEHr2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Nov 2017 02:47:28 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eBFeG-0004rX-Lg
        for linux-btrfs@vger.kernel.org; Sun, 05 Nov 2017 08:47:16 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Fixed subject: updatedb does not index separately mounted btrfs
 subvolumes
Date: Sun, 5 Nov 2017 07:47:07 +0000 (UTC)
Message-ID: <pan$94157$844c1b67$c8d5af52$b34db269@cox.net>
References: <CAJCQCtSf1mX0kWCRjfSTwZKwZC6mMN7Vdio0LJdCCY96ifte4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Fri, 03 Nov 2017 18:15:53 -0600 as excerpted:

> Ancient bug, still seems to be a bug.
> https://bugzilla.redhat.com/show_bug.cgi?id=906591
> 
> The issue is that updatedb by default will not index bind mounts, but by
> default on Fedora and probably other distros, put /home on a subvolume
> and then mount that subvolume which is in effect a bind mount.

<gripe-mode: inaccurate subject lines>

So the issue isn't /home being btrfs (as you said in the subject), but 
rather, it's /home being an explicitly mounted subvolume, since btrfs 
uses bind-mounts internally for subvolume mounts.

Makes a difference for folks like me who have /home on a fully separate 
btrfs.  You had me wondering for a moment, tho as it happens I don't use 
updatedb either, but I was still wondering what weird bug and how it 
might otherwise affect me.  An accurate subject line would have helped...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

