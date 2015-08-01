Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:35910 "EHLO
	mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbbHAW00 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Aug 2015 18:26:26 -0400
Received: by vkci6 with SMTP id i6so32283060vkc.3
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Aug 2015 15:26:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$7fbcf$6323c57d$e51a436f$80a59676@cox.net>
References: <55BD277F.2040201@friedels.name>
	<20150801203258.GA14352@carfax.org.uk>
	<CAJCQCtTY0bWrFmm_6An9QcPm7ek53vCrFHjZjehHf-UotXJ7+A@mail.gmail.com>
	<pan$7fbcf$6323c57d$e51a436f$80a59676@cox.net>
Date: Sat, 1 Aug 2015 16:26:25 -0600
Message-ID: <CAJCQCtQOa8_fcX_O9zop=mT0ABp=3XtJZ5N2SE2nrX7-0TvSpw@mail.gmail.com>
Subject: Re: Data single *and* raid?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 1, 2015 at 3:45 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Does fi usage deal with raid5 yet?

Now that you mention it, I think it doesn't. But if it did, it would
show this problem better than df I think.

> But, somewhere along the line he got 6 GiB of raid1 metadata.  Either he
> added/rewrote a *BUNCH* of files after adding at least one device before
> the conversion that he didn't tell us about, or the conversion screwed
> up, because that's a lot of raid1 metadata coming out of nowhere!

Yeah it's a little confusing, that's why I asked about the kernel version.
>
>
> But I'm *strongly* suspecting a pre-full-raid56-support kernel, because
> btrfs-progs is certainly reasonably new (v4.1.1, as of yesterday 4.1.2 is
> the newest as I mention above), but the fi df doesn't report global
> reserve.  The only way I know of that it wouldn't report that with a new
> userspace is if the kernelspace is too old.

Yes and that also puts it in the realm of kernels that weren't
releasing/deallocating empty chunks; although I don't know if that's a
factor, if dconvert forcibly deals with this..


> Finally, that's btrfs-progs 4.1.1, the one that's blacklisted due to a
> buggy mkfs.btrfs.  If he created the filesystem with that mkfs.btrfs...
> maybe that explains the funky results, as well.

Good catch. That really ought to be filed as a bug with that distro to
flat out remove 4.1.1 from the repos.



-- 
Chris Murphy
