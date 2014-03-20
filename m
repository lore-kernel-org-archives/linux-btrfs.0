Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f178.google.com ([209.85.128.178]:59181 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759628AbaCTXgO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Mar 2014 19:36:14 -0400
Received: by mail-ve0-f178.google.com with SMTP id jw12so1750813veb.23
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Mar 2014 16:36:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131125214534.8160.40797@ret.masoncoding.com>
References: <20131125214534.8160.40797@ret.masoncoding.com>
Date: Thu, 20 Mar 2014 23:36:13 +0000
Message-ID: <CALOYprVH7pGuAR2OHvyGVfa9FKW-_5yMT-h=BAm_G8ejEOHboQ@mail.gmail.com>
Subject: Re: btrfs-progs tagged as v3.12
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25 November 2013 21:45, Chris Mason <chris.mason@fusionio.com> wrote:
> Hi everyone,
>
> I've tagged the current btrfs-progs repo as v3.12.  The new idea is that
> instead of making the poor distros pull from git, I'll be creating
> tagged releases at roughly the same pace as Linus cuts kernels.
>
> Given the volume of btrfs-progs patches, we should have enough new code
> and fixes to justify releases at least as often as the kernel.  Of
> course, if there are issues that need immediate attention, I'll tag a .y
> release (v3.12.1 for example).
>
> If the progs changes slow down, we might skip a version.  But tracking
> kernel version numbers makes it easier for me to line up bug reports,
> mostly because I already devote a fair number of brain cells to
> remembering how old each kernel is.
>
> Just let me know if there are any questions.
>
> -chris

Hi Chris,

I don't know if there wasn't enough commits to justify a 3.13 release
(I noticed your integration branch stalled 7 weeks ago, so I assume
this is the case), but can we expect a 3.14 release shortly after
Linus tags the mainline kernel as such?

If the integration branch stall was for another reason (e.g. testing
to make sure it was stable enough for primetime), could I suggest
pulling in David Sterba's current unstable integration branch, and
essentially freezing it for testing now, so that people/distros can
test it against the current/last couple of kernel -rcs, so that any
obvious bugs are ironed out before 3.14 is tagged proper. Distros
typically put packages like this through their own testing period
anyway, so a prolonged testing period shouldn't be required upstream.

Thanks for your continued hard work,


WorMzy Tykashi

(sorry if you receive this twice gmail went wrong)
