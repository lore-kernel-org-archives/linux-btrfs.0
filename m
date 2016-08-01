Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:34427 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbcHAQTD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Aug 2016 12:19:03 -0400
Received: by mail-oi0-f44.google.com with SMTP id l65so199127025oib.1
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Aug 2016 09:19:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a582564a-e991-dd35-721f-31c807a24929@gmail.com>
References: <CAJCQCtQ4CXjBzR6eo0zibDCb9_p0jAiS2q_fCRUkUNVWiM9i6g@mail.gmail.com>
 <CAJCQCtQ8yPQf8O2LA92-Gd95GGXQiDp-ZomKZgP4bNv-MmKHYw@mail.gmail.com>
 <ac28e105-f228-de18-08c2-e504e304052d@gmail.com> <CAJCQCtQahbHJhcyKrdRGLNuzbd7MUL11nGBpiQ2U40nAn1ve2w@mail.gmail.com>
 <a582564a-e991-dd35-721f-31c807a24929@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 1 Aug 2016 10:19:01 -0600
Message-ID: <CAJCQCtRgmfWVf9YB2=fVLDSRhm4-t7W+YHBabBaBsBZeSiDU1Q@mail.gmail.com>
Subject: Re: systemd KillUserProcesses=yes and btrfs scrub
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 1, 2016 at 10:08 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

>
> MD and DM RAID handle this by starting kernel threads to do the scrub. They
> then store the info about the scrub in the array itself, so you can query it
> externally.  If you watch, neither of those commands runs longer than it
> takes to start the operation, so there's nothing for systemd to kill.

pvmove continues to run and report progress so it can be killed off,
but it only polls for statistics, it's not actually recording them. So
even though it gets killed, subsequent pvmove command shows correct
statistics.

So that makes me wonder how btrfs device add and remove will behave,
if issued in a DE which is then logged out of. Those commands do not
return to prompt until they complete.


> Replace was implemented the way scrub should have been.  It's done entirely
> in the kernel, and the userspace tools just start, stop and check status.
> We should just get rid of the whole scrub state file crap and have a way to
> query the last scrub status directly from the FS. That would fix this
> particular issue, and make scrub more consistent with everything else (and
> solve the stale scrub status bug too).

OK, I'll update the bug report.

-- 
Chris Murphy
