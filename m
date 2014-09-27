Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:48176 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaI0KBX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Sep 2014 06:01:23 -0400
Received: by mail-ie0-f180.google.com with SMTP id ar1so13887345iec.25
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Sep 2014 03:01:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$2cf2e$b466e32e$8c5d4ef4$9a82294f@cox.net>
References: <8465933.4bvG1Xk5zJ@linuxpc>
	<pan$92371$cf7e2c62$a94a9382$e3e154b@cox.net>
	<CAOsFrTfQHZjUbBcMkx9e30x6fdi216PAMPRo+QoVmqAR0pZH1Q@mail.gmail.com>
	<pan$2cf2e$b466e32e$8c5d4ef4$9a82294f@cox.net>
Date: Sat, 27 Sep 2014 12:01:22 +0200
Message-ID: <CAOsFrTf6_RySdGH-zhPR6_9hEoa3G69ZJYKkYjbvs2vuSkGc9g@mail.gmail.com>
Subject: Re: Backup: Compare sent snapshots
From: G EO <1g2e3o4@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> What I had in mind was this (again, with the caveat that I'm not actually
> using send/receive myself, so I'd suggest testing or getting confirmation
> from someone that is, before depending on this):
> On the main filesystem, you did the first full send, we'll call it A.
> Then you did an incremental send with a new snapshot, B, using A as its
> parent, and later another, C, using B as its parent.
> On the backup, assuming you didn't delete anything and that the receives
> completed without error, you'd then have copies of all three, A, B, C.
> Now let's say you decide A is old and you no longer need it, so you
> delete it on both sides, leaving you with B and C.
> Now back on the main machine C is damaged.  But you still have B on both
> machines and C on the backup machine.
> What I was suggesting was that you could reverse the last send/receive,
> sending C from the backup with B as its parent (since B exists undamaged
> on both sides, with C undamaged on the backup but damaged or missing on
> the main machine), thereby restoring a valid copy of C on the main
> machine once again.
> Once you have a valid copy of C on the main machine again, you can now do
> normal incremental send/receive D, using C as its parent, just as you
> would have if C had never been damaged in the first place, because you
> restored a valid C reference on your main machine in ordered to be able
> to do so.


Assuming B (nor A) is nonexistent locally anymore and C damaged (or
nonexistent) locally there would be no way for determining the
differences (between C on the backup drive and the current active
subvolume on the root partition) anymore right? At least not with send
-p right?

> Of course that's with the caveat that you haven't done anything to
> reduplicate the data, breaking the sharing between snapshots.  The big
> factor there is defrag.  While snapshot-aware-defrag was introduced in I
> think kernel 3.9, that implementation turned out not to scale well AT
> ALL, and it was using 10s of GiB of RAM and taking days to defrag what
> should have been done in a few hours.  So they ended up disabling
> snapshot-aware-defrag again, until they can fix the scaling issues.  That
> means that when you defrag, you're defragging /just/ the snapshot you
> happened to point defrag at, and anything it moves in that defrag is
> effect duplicated, since other snapshots previously sharing that data
> aren't defragged along with it so they keep a reference to the old,
> undefragged version, thus doubling the required space for anything moved.


Is defrag disabled by default?
Are "space_cache" and "compress-force=lzo" known to cause trouble with
snapshots?

> Snapshot size?  That's not as well defined as you might think.  Do you
> mean the size of everything in that snapshot, including blocks shared
> with other snapshots, or do you mean just the size of what isn't shared


The full size of a snapshot, including what is shared with others is
easy to measure simply using "du", right?
For the relative size this should work with "qgroup show", right?
Although this also shows absolute values, but that do not comply with
du here.
qroup requires enabling quote though, right? Does it have an impact on
the values shown by qgroup whether quota is enabled since the
beginning or just recently?

Thanks for your awesome help Duncan!
