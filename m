Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:38462 "EHLO
	mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbcHAQId (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Aug 2016 12:08:33 -0400
Received: by mail-it0-f49.google.com with SMTP id j124so177080940ith.1
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Aug 2016 09:08:33 -0700 (PDT)
Subject: Re: systemd KillUserProcesses=yes and btrfs scrub
To: Chris Murphy <lists@colorremedies.com>
References: <CAJCQCtQ4CXjBzR6eo0zibDCb9_p0jAiS2q_fCRUkUNVWiM9i6g@mail.gmail.com>
 <CAJCQCtQ8yPQf8O2LA92-Gd95GGXQiDp-ZomKZgP4bNv-MmKHYw@mail.gmail.com>
 <ac28e105-f228-de18-08c2-e504e304052d@gmail.com>
 <CAJCQCtQahbHJhcyKrdRGLNuzbd7MUL11nGBpiQ2U40nAn1ve2w@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <a582564a-e991-dd35-721f-31c807a24929@gmail.com>
Date: Mon, 1 Aug 2016 12:08:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQahbHJhcyKrdRGLNuzbd7MUL11nGBpiQ2U40nAn1ve2w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-01 11:46, Chris Murphy wrote:
> OK I've created a new volume that's sufficiently large I can tell if
> the kernel workers doing the scrub are also being killed off. First, I
> do a scrub without logging out to get a time for an uninterrupted
> scrub. And then initiate a scrub which I start timing, but then logout
> of the DE and watch for the kernel workers to stop.
>
> - The kernel workers are killed off within ~5 seconds of an
> uninterrupted scrub. Conclusion is the scrub is still happening by the
> kernel.
This makes sense, systemd is killing based on session ID, and the kernel 
workers have an sid of 0 (I think, it should be whatever the sid of 
kthreadd (PID 2) has).
> - The btrfs process for the scrub isn't killed either, it's just
> status Z for the entire length of the scrub.
Z means the process is dead, but nothing has called wait() or similar to 
get status info from it, so it was killed, it's just that nothing took 
the body to the morgue yet.
> - While this scrubbing is happening, issuing a 'btrfs scrub status'
> gets me consistently stale information. It's the same information from
> the moment the DE was logged out.
This makes sense, because the userspace component updates this info (and 
that's _all_ it does).
>
> [root@localhost ~]# btrfs scrub status /mnt/x
> scrub status for 9f9e5e1f-8d5a-44a0-8f69-8a393fb7ff3c
>     scrub started at Mon Aug  1 09:29:59 2016, running for 00:00:15
>     total bytes scrubbed: 3.06GiB with 0 errors
>
> Even a minute later this information is the same.
>
> Once the zombie btrfs process dies off, and the kernel workers stop
> working, I get this bogus status information:
>
> [root@localhost ~]# btrfs scrub status /mnt/x
> scrub status for 9f9e5e1f-8d5a-44a0-8f69-8a393fb7ff3c
>     scrub started at Mon Aug  1 09:29:59 2016, interrupted after
> 00:00:15, not running
>     total bytes scrubbed: 3.06GiB with 0 errors
>
>
> Only the user process was interrupted. Not the scrub. Looks like only
> the user process is writing out the statistics and status, so once it
> goes zombie, there's no accounting, rather than accounting being done
> independently via sysfs.
>
> Can I resume this scrub? Yes. But that's also bogus because there
> really isn't anything to resume. All that work was done already, it
> just hasn't been accounted for.
>
> So whether you want to call this a bug, or deeply suboptimal behavior,
> I think that's splitting hairs. Neither mdadm nor LVM scrubs are
> affected by this logout behavior and systemd killing off user
> processes. I always get reliable scrub status information from either
> 'echo check md/sync_action' or 'lvchange --syncaction check' before
> and after logging out of the DE from which the command was issued.
MD and DM RAID handle this by starting kernel threads to do the scrub. 
They then store the info about the scrub in the array itself, so you can 
query it externally.  If you watch, neither of those commands runs 
longer than it takes to start the operation, so there's nothing for 
systemd to kill.
>
> And it's even inconsistent with btrfs replace where it continues to
> give me correct status information from a tty shell even though the
> replace command was issued in a DE, subsequently logged out of. So
> 'btrfs scrub' is inconsistent no matter how you look at it. It's a
> bug.
>
Replace was implemented the way scrub should have been.  It's done 
entirely in the kernel, and the userspace tools just start, stop and 
check status.  We should just get rid of the whole scrub state file crap 
and have a way to query the last scrub status directly from the FS. 
That would fix this particular issue, and make scrub more consistent 
with everything else (and solve the stale scrub status bug too).
