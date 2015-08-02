Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:33251 "EHLO
	mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbbHBBOO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Aug 2015 21:14:14 -0400
Received: by vkgc186 with SMTP id c186so32298792vkg.0
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Aug 2015 18:14:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$b8fa$cc3e43af$7e32a698$96ba80bb@cox.net>
References: <55BD277F.2040201@friedels.name>
	<20150801203258.GA14352@carfax.org.uk>
	<CAJCQCtTY0bWrFmm_6An9QcPm7ek53vCrFHjZjehHf-UotXJ7+A@mail.gmail.com>
	<pan$7fbcf$6323c57d$e51a436f$80a59676@cox.net>
	<CAJCQCtQOa8_fcX_O9zop=mT0ABp=3XtJZ5N2SE2nrX7-0TvSpw@mail.gmail.com>
	<20150801223413.GC14352@carfax.org.uk>
	<pan$b8fa$cc3e43af$7e32a698$96ba80bb@cox.net>
Date: Sat, 1 Aug 2015 19:14:13 -0600
Message-ID: <CAJCQCtQqkUY=oRKFAx-0UaT-87STiDgD-vQ+gknkE5V2SzPb4A@mail.gmail.com>
Subject: Re: Data single *and* raid?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 1, 2015 at 6:27 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> 1) If this fs was created with btrfs-progs v4.1.1, get what you need to
> retrieve off of it immediately, then blow it away and start over, as the
> thing isn't stable and all data is at risk.

Agreed. But I'd go so far as to say at this point it looks like it's
wedged itself into a kind of self-induced faux-ENOSPC state because
there isn't room to allocate more raid5 chunks. So, I think it's stuck
in any case.

It'd be great to reproduce this with a current kernel and see if it's
still happening.


-- 
Chris Murphy
