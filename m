Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from loup.kjorling.se ([87.237.208.114]:47997 "EHLO loup.kjorling.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab2KFNra (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 08:47:30 -0500
Date: Tue, 6 Nov 2012 13:47:02 +0000
From: Michael =?utf-8?B?S2rDtnJsaW5n?= <michael@kjorling.se>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: How does btrfs handle sudden shutdowns?
Message-ID: <20121106134702.GA3900@yeono.kjorling.se>
References: <20121106123308.GA2676@yeono.kjorling.se>
 <20121106124802.GA29581@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20121106124802.GA29581@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6 Nov 2012 12:48 +0000, from hugo@carfax.org.uk (Hugo Mills):
>    There are also some caveats: while the FS should always be
> consistent, the latest transaction write may not have been completed,
> so you could potentially lose up to 30 seconds of writes to the FS
> from immediately before the crash.

I'd rather lose the most recent 30 seconds of writes but have a
consistent file system with as-consistent-as-can-be-expected data,
than end up with a corrupted file system.

On that note; can this value be tuned currently, is it hardcoded, or
is it stored in metadata somewhere but the tooling to tune it is not
yet available?


>    If the FS does corrupt over a power failure, and the hardware can
> be demonstrated to be good, then we have a bug that needs to be
> tracked down. (There have been a number of these over the development
> of the FS so far, but they do get fixed).

Is there a simple way to tell ahead of time whether the hardware meets
the assumptions made by the file system with regards to write barriers
etc.?


>    I guess the question for you is: are you after the _expected_
> behaviour of the FS (should always be consistent on good hardware, but
> you may lose up to 30 seconds of writes), or are you after mitigation
> strategies in the face of FS bugs (keep off-site backups and be
> prepared to use them)?

I already have full, daily on-site backups on an external drive that
is logically unmounted except for when backups are running, as well as
partial off-site backups to cloud storage - and of course, taking
advantage of btrfs's snapshotting support there is no real reason why
I couldn't increase the backup frequency while retaining data
consistency. Losing half a minute of writes is fairly inconsequential
for personal use as long as the file system remains consistent, and in
the face of disastrous corruption it is at least possible to do a full
restore to bare metal from rescue media and backup without losing too
much. Not trivial time-wise (that's currently 1.4 TB over USB 2.0),
but possible.

-- 
Michael Kjörling • http://michael.kjorling.se • michael@kjorling.se
                “People who think they know everything really annoy
                those of us who know we don’t.” (Bjarne Stroustrup)
