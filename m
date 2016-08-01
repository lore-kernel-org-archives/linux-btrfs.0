Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35011 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbcHAPwg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Aug 2016 11:52:36 -0400
Received: by mail-oi0-f51.google.com with SMTP id l72so198300372oig.2
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Aug 2016 08:52:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ac28e105-f228-de18-08c2-e504e304052d@gmail.com>
References: <CAJCQCtQ4CXjBzR6eo0zibDCb9_p0jAiS2q_fCRUkUNVWiM9i6g@mail.gmail.com>
 <CAJCQCtQ8yPQf8O2LA92-Gd95GGXQiDp-ZomKZgP4bNv-MmKHYw@mail.gmail.com> <ac28e105-f228-de18-08c2-e504e304052d@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 1 Aug 2016 09:46:58 -0600
Message-ID: <CAJCQCtQahbHJhcyKrdRGLNuzbd7MUL11nGBpiQ2U40nAn1ve2w@mail.gmail.com>
Subject: Re: systemd KillUserProcesses=yes and btrfs scrub
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK I've created a new volume that's sufficiently large I can tell if
the kernel workers doing the scrub are also being killed off. First, I
do a scrub without logging out to get a time for an uninterrupted
scrub. And then initiate a scrub which I start timing, but then logout
of the DE and watch for the kernel workers to stop.

- The kernel workers are killed off within ~5 seconds of an
uninterrupted scrub. Conclusion is the scrub is still happening by the
kernel.
- The btrfs process for the scrub isn't killed either, it's just
status Z for the entire length of the scrub.
- While this scrubbing is happening, issuing a 'btrfs scrub status'
gets me consistently stale information. It's the same information from
the moment the DE was logged out.

[root@localhost ~]# btrfs scrub status /mnt/x
scrub status for 9f9e5e1f-8d5a-44a0-8f69-8a393fb7ff3c
    scrub started at Mon Aug  1 09:29:59 2016, running for 00:00:15
    total bytes scrubbed: 3.06GiB with 0 errors

Even a minute later this information is the same.

Once the zombie btrfs process dies off, and the kernel workers stop
working, I get this bogus status information:

[root@localhost ~]# btrfs scrub status /mnt/x
scrub status for 9f9e5e1f-8d5a-44a0-8f69-8a393fb7ff3c
    scrub started at Mon Aug  1 09:29:59 2016, interrupted after
00:00:15, not running
    total bytes scrubbed: 3.06GiB with 0 errors


Only the user process was interrupted. Not the scrub. Looks like only
the user process is writing out the statistics and status, so once it
goes zombie, there's no accounting, rather than accounting being done
independently via sysfs.

Can I resume this scrub? Yes. But that's also bogus because there
really isn't anything to resume. All that work was done already, it
just hasn't been accounted for.

So whether you want to call this a bug, or deeply suboptimal behavior,
I think that's splitting hairs. Neither mdadm nor LVM scrubs are
affected by this logout behavior and systemd killing off user
processes. I always get reliable scrub status information from either
'echo check md/sync_action' or 'lvchange --syncaction check' before
and after logging out of the DE from which the command was issued.

And it's even inconsistent with btrfs replace where it continues to
give me correct status information from a tty shell even though the
replace command was issued in a DE, subsequently logged out of. So
'btrfs scrub' is inconsistent no matter how you look at it. It's a
bug.


-- 
Chris Murphy
