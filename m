Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:53255 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751487AbdKEOCS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Nov 2017 09:02:18 -0500
Received: by mail-oi0-f44.google.com with SMTP id h6so5217901oia.10
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Nov 2017 06:02:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$94157$844c1b67$c8d5af52$b34db269@cox.net>
References: <CAJCQCtSf1mX0kWCRjfSTwZKwZC6mMN7Vdio0LJdCCY96ifte4g@mail.gmail.com>
 <pan$94157$844c1b67$c8d5af52$b34db269@cox.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 5 Nov 2017 07:02:16 -0700
Message-ID: <CAJCQCtQdz0zEesU0SuHCs5-bhqohqT7zEnh7krY-aiVgHGfSKw@mail.gmail.com>
Subject: Re: Fixed subject: updatedb does not index separately mounted btrfs subvolumes
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 5, 2017 at 1:47 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Chris Murphy posted on Fri, 03 Nov 2017 18:15:53 -0600 as excerpted:
>
>> Ancient bug, still seems to be a bug.
>> https://bugzilla.redhat.com/show_bug.cgi?id=906591
>>
>> The issue is that updatedb by default will not index bind mounts, but by
>> default on Fedora and probably other distros, put /home on a subvolume
>> and then mount that subvolume which is in effect a bind mount.
>
> <gripe-mode: inaccurate subject lines>
>
> So the issue isn't /home being btrfs (as you said in the subject), but
> rather, it's /home being an explicitly mounted subvolume, since btrfs
> uses bind-mounts internally for subvolume mounts.
>
> Makes a difference for folks like me who have /home on a fully separate
> btrfs.  You had me wondering for a moment, tho as it happens I don't use
> updatedb either, but I was still wondering what weird bug and how it
> might otherwise affect me.  An accurate subject line would have helped...


It is accurate, it's an exactly copied title from the bug report. That
the bug report's title is confusing is sorta beside the point, I
certainly can't do anything about that.

-- 
Chris Murphy
