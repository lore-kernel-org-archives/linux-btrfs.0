Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:35603 "EHLO
	zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbcERNhY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 May 2016 09:37:24 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
	by zaphod.cobb.me.uk (Postfix) with ESMTP id 657709B8E1
	for <linux-btrfs@vger.kernel.org>; Wed, 18 May 2016 14:29:44 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
	by black.home.cobb.me.uk (Postfix) with ESMTPS id 428EA5FB88
	for <linux-btrfs@vger.kernel.org>; Wed, 18 May 2016 14:29:44 +0100 (BST)
To: linux-btrfs@vger.kernel.org
From: Graham Cobb <g.btrfs@cobb.uk.net>
Subject: Reducing impact of periodic btrfs balance
Message-ID: <573C6E47.2080109@cobb.uk.net>
Date: Wed, 18 May 2016 14:29:43 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a 6TB btrfs filesystem I created last year (about 60% used).  It
is my main data disk for my home server so it gets a lot of usage
(particularly mail). I do frequent snapshots (using btrbk) so I have a
lot of snapshots (about 1500 now, although it was about double that
until I cut back the retention times recently).

A while ago I had a "no space" problem (despite fi df, fi show and fi
usage all agreeing I had over 1TB free).  But this email isn't about that.

As part of fixing that problem, I tried to do a "balance -dusage=20" on
the disk.  I was expecting it to have system impact, but it was a major
disaster.  The balance didn't just run for a long time, it locked out
all activity on the disk for hours.  A simple "touch" command to create
one file took over an hour.

More seriously, because of that, mail was being lost: all mail delivery
timed out and the timeout error was interpreted as a fatal delivery
error causing mail to be discarded, mailing lists to cancel
subscriptions, etc. The balance never completed, of course.  I
eventually got it cancelled.

I have since managed to complete the "balance -dusage=20" by running it
repeatedly with "limit=N" (for small N).  I wrote a script to automate
that process, and rerun it every week.  If anyone is interested, the
script is on GitHub: https://github.com/GrahamCobb/btrfs-balance-slowly

Out of that experience, I have a couple of thoughts about how to
possibly make balance more friendly.

1) It looks like the balance process seems to (effectively) lock all
file (extent?) creation for long periods of time.  Would it be possible
for balance to make more effort to yield locks to allow other
processes/threads to get in to continue to create/write files while it
is running?

2) btrfs scrub has options to set ionice options.  Could balance have
something similar?  Or would reducing the IO priority make things worse
because locks would be held for longer?

3) My btrfs-balance-slowly script would work better if there was a
time-based limit filter for balance, not just the current count-based
filter.  I would like to be able to say, for example, run balance for no
more than 10 minutes (completing the operation in progress, of course)
then return.

4) My btrfs-balance-slowly script would be more reliable if there was a
way to get an indication of whether there was more work to be done,
instead of parsing the output for the number of relocations.

Any thoughts about these?  Or other things I could be doing to reduce
the impact on my services?

Graham
