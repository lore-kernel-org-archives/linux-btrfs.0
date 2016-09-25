Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:35784 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034030AbcIYNzn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Sep 2016 09:55:43 -0400
Received: by mail-qt0-f179.google.com with SMTP id 93so71013295qtg.2
        for <linux-btrfs@vger.kernel.org>; Sun, 25 Sep 2016 06:55:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$afe1d$3cd285bd$f0b68da9$67150f63@cox.net>
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
 <pan$afe1d$3cd285bd$f0b68da9$67150f63@cox.net>
From: Rich Freeman <r-btrfs@gw.thefreemanclan.net>
Date: Sun, 25 Sep 2016 09:55:42 -0400
Message-ID: <CAGfcS_n+pMq0thNEM9b2ZA78xEpXTFJXjwTHRyvquLS8dR_yng@mail.gmail.com>
Subject: Re: unable to handle kernel paging request - btrfs
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 23, 2016 at 12:58 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>
> Btrfs raid1 you say, and you have existing compressed files it's trying
> to read in the backtrace?
>
> Sounds like the issues I see sometimes and have posted about where after
> a crash that resulted in one device of my raid1 pair getting behind the
> other, the kernel will crash if it sees too many csum-errors, even tho
> it's /supposed/ to check the other copy and read from it if valid (which
> it is as a btrfs scrub resolves the issue).
>
> When booted to rescue/single-user mode, can you run a scrub?

After a few reboots trying to capture the initial panic message (even
when I set panic_on_oops=1 I was getting multiple ones with only the
tainted one staying on screen), the system managed to stay up.  I
completed a scrub and it found no errors.  I also haven't had any
issues with it but haven't attempted another reboot.  I figured the
safest course was to just leave it on for a good week so that whatever
was in the log/etc that was giving it trouble works its way out.  I'm
also doing a balance which may or may not help (and which is useful
anyway since I increased the size of the drive I replaced).

I'm still pretty skeptical of a hardware problem, but once I think the
system is able to be safely rebooted I'll go ahead and run a longer
memory test/etc.  This really doesn't seem like a memory problem, and
I don't see a corrupted binary as an issue since everything running in
kernel space is versioned and the problem happens with multiple kernel
versions (and the older ones haven't been touched on-disk in ages).  A
problem in glibc/etc shouldn't cause a kernel oops absent a bug.  But,
if there is a hardware problem I obviously want to know about it, and
I've had a few RAM failures over the years...

--
Rich
