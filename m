Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:35203 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751444AbdG0OPE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 10:15:04 -0400
Received: by mail-lf0-f42.google.com with SMTP id t128so50764956lff.2
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jul 2017 07:15:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170726160717.GA32451@localhost.localdomain>
References: <CANznX5FxavW+0_YdA4hir9_A3KrobRLyV9+CNadigDT3uNUkXw@mail.gmail.com>
 <20170726160717.GA32451@localhost.localdomain>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Thu, 27 Jul 2017 16:14:47 +0200
Message-ID: <CANznX5Hx57JbwS75usDHwWBHbmiLj7dVHrfgZ5Swn=8zX=2iHw@mail.gmail.com>
Subject: Re: write corruption due to bio cloning on raid5/6
To: bo.li.liu@oracle.com
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> It should only affect the dio-written files, the mentioned bug makes
> btrfs write garbage into those files, so checksum fails when reading
> files, nothing else from this bug.

Thanks for confirming that.  I thought so but I removed the affected
temporary files even before I knew they were corrupt, yet I had
trouble with the follow-up scrub, so I got confused about the scope of
the issue.
However, I am not sure if some other software which regularly runs in
the background might use DIO (I don't think so but can't say for
sure).

> A hang could normally be caught by sysrq-w, could you please try it
> and see if there is a difference in kernel log?

It's not a total system hang. The filesystem in question effectively
becomes read-only (I forgot to check if it actually turns RO or writes
just silently hang) and scrub hangs (it doesn't seem to do any disk
I/O and can't be cancelled gracefully). A graceful reboot or shutdown
silently fails.

In the mean time, I switched to Linux 4.12.3, updated the firmware on
the HDDs and ran an extended SMART self-test (which found no errors),
used cp to copy everything (not for backup but as a form of "crude
scrub" [see *], which yielded zero errors) and now finally started a
scrub (in foreground and read-only mode this time).

* This is off-topic but raid5 scrub is painful. The disks run at
constant ~100% utilization while performing at ~1/5 of their
sequential read speeds. And despite explicitly asking idle IO priority
when launching scrub, the filesystem becomes unbearably slow (while
scrub takes a days or so to finish ... or get to the point where it
hung the last time around, close to the end).

I find it a little strange that BFQ and the on-board disk caching with
NCQ + FUA (look-ahead read caching and write cache reordering enabled
with 128Mb on-board caches) can't mitigate the issue a little better
(whatever scrub is doing "wrong" from a performance perspective).

If scrub hangs again, I will try to extract something useful from the logs.
