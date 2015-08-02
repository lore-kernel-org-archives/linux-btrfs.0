Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:32911 "EHLO
	mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbbHBSbO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Aug 2015 14:31:14 -0400
Received: by vkgc186 with SMTP id c186so35862515vkg.0
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Aug 2015 11:31:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$2c3c8$edc30c0$3c253f51$8a661bd4@cox.net>
References: <55BD277F.2040201@friedels.name>
	<20150801203258.GA14352@carfax.org.uk>
	<CAJCQCtTY0bWrFmm_6An9QcPm7ek53vCrFHjZjehHf-UotXJ7+A@mail.gmail.com>
	<pan$7fbcf$6323c57d$e51a436f$80a59676@cox.net>
	<CAJCQCtQOa8_fcX_O9zop=mT0ABp=3XtJZ5N2SE2nrX7-0TvSpw@mail.gmail.com>
	<20150801223413.GC14352@carfax.org.uk>
	<pan$b8fa$cc3e43af$7e32a698$96ba80bb@cox.net>
	<CAJCQCtQqkUY=oRKFAx-0UaT-87STiDgD-vQ+gknkE5V2SzPb4A@mail.gmail.com>
	<pan$2c3c8$edc30c0$3c253f51$8a661bd4@cox.net>
Date: Sun, 2 Aug 2015 12:31:13 -0600
Message-ID: <CAJCQCtSrt5OcUtURko3PjOtvCZBJ6quTn=AdT5P=+Ek3HuNuCQ@mail.gmail.com>
Subject: Re: Data single *and* raid?
From: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 1, 2015 at 9:46 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> If it was setup with something earlier (not sure about 4.1.0, was it
> affected?

No.

> but 4.0.x and earlier should be fine for setup), however, once
> on a new kernel the usual ENOSPC workarounds can be given a try.  That
> would include a first balance start -dusage=0 -musage=0, and if that
> didn't free up at least a gig on a second device,

If I'm following this correctly, the reproduce steps would be to
create a single device Btrfs that's ~94% full, add two devices, then
convert to raid5. I think what's going on here is empty single profile
data chunks aren't being deallocated, and it's effectively a 2 device
raid5.

So actually, you're right, either -dusage=0 might fix it, or better,
newer kernel that automatically deallocated empty/converted single
profile data chunks. But right now it will take another balance in the
end because it looks like this is effectively a 2 device raid5, with
the 3rd drive full of single only chunks (which might be empty?).


-- 
Chris Murphy
