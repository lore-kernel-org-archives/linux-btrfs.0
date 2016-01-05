Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:34575 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbcAEVrx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jan 2016 16:47:53 -0500
Received: by mail-io0-f170.google.com with SMTP id 1so153647770ion.1
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jan 2016 13:47:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$4b55a$cfffcc6c$c8faaa76$1740646a@cox.net>
References: <CAJCQCtS59TFek+g9x_aoqGzepySMrRn6DcOQkuwi=VQYR9M4tw@mail.gmail.com>
	<pan$671e2$87d221b4$c1b40d79$6f794584@cox.net>
	<CAJCQCtSCvzoOdqFx9dB9sbT-dR0XsQVzWwVcK3zBnwC17+ZV_Q@mail.gmail.com>
	<pan$4b55a$cfffcc6c$c8faaa76$1740646a@cox.net>
Date: Tue, 5 Jan 2016 14:47:52 -0700
Message-ID: <CAJCQCtRkDrUhiCsgO5Wm=1OhpbtxaR58SLLg5JxZvYQE_nSTUQ@mail.gmail.com>
Subject: Re: evidence of persistent state, despite device disconnects
From: Chris Murphy <lists@colorremedies.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 5, 2016 at 7:50 AM, Duncan <1i5t5.duncan@cox.net> wrote:

>
> If however you mounted it degraded,rw at some point, then I'd say the bug
> is in wetware, as in that case, based on my understanding, it's working
> as intended.  I was inclined to believe that was what happened based on
> the obviously partial sequence in the earlier post, but if you say you
> didn't... then it's all down to duplication and finding why it's suddenly
> reverting to single mode on non-degraded mounts, which indeed /is/ a bug.

Clearly I will have to retest.

But even as rw,degraded, it doesn't matter, that'd still be a huge
bug. There's no possible way you'll convince me this is a user
misunderstanding. No where is this documented.

I made the fs using mfks.btrfs -draid1 -mraid1. There is no way the
fs, under any circumstance, legitimately creates and uses any other
profile for any chunk type, ever. Let alone silently.

-- 
Chris Murphy
