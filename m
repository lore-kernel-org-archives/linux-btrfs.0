Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:36598 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbbIQCHl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 22:07:41 -0400
Received: by igcrk20 with SMTP id rk20so46784809igc.1
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 19:07:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABL_Pd8nOj7B1_64Us+goP=corZkCtw_WJW8eMQpiP6iQpw=HA@mail.gmail.com>
References: <20150916144355.GA1285@invalid>
	<55F988A6.8070109@gmail.com>
	<CABL_Pd8nOj7B1_64Us+goP=corZkCtw_WJW8eMQpiP6iQpw=HA@mail.gmail.com>
Date: Wed, 16 Sep 2015 22:07:40 -0400
Message-ID: <CAGfcS_kuiUZCtydn51WXYP8OcwTpM0xzEZdErcCoaka+NxDnOg@mail.gmail.com>
Subject: Re: FYIO: A rant about btrfs
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Martin Tippmann <martin.tippmann@gmail.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 16, 2015 at 12:45 PM, Martin Tippmann
<martin.tippmann@gmail.com> wrote:
> From reading the list I understand that btrfs is still very much work
> in progress and performance is not a top priority at this stage but I
> don't see why it shouldn't perform at least equally good as ZFS/F2FS
> on the same workloads. Is looking at performance problems on the
> development roadmap?

My sense is that sufferings in comparison to ZFS just represent a lack
of maturity - there just hasn't been as much focus on performance.
I'm not aware of any fundamental design issues which are likely to
make btrfs perform worse than ZFS in the long-term.

F2FS is a fundamentally different beast.  It is a log-based filesystem
as far as I'm aware, and on flash that gives it some substantial
advantages, but it doesn't support snapshotting/etc as far as I'm
aware.  I'm sure that in the long term some operations are just going
to be faster on F2FS no matter what just due to its design, and other
operations will always be slower on F2FS.

To draw an analogy, imagine you have a 1TB ext4 filesystem and a 1TB
btrfs filesystem.  On each you create a 900GB file, and then proceed
to make millions of internal writes all over it.  The ext4 filesystem
is just going to completely outperform btrfs at this job, and I
suspect it would outperform zfs as well.  For such a use case you
don't really even need a filesystem - you might as well just be
reading/writing random blocks right off the disk, and ext4 is pretty
close to that in behavior when it comes to internal file
modifications.  The COW filesystems are going to be fragmenting the
living daylights out of the file and its metadata.  Of course, if you
pulled the plug in the middle of one of those operations the COW
filesystems are more likely to end up in a sane state if you care
about the order of file modifications, and if you're doing this on
RAID both zfs and btrfs will be immune to any write hole issues.
Also, if you go making reflink copies of large files on a btrfs
filesystem it will perform MUCH better than doing the equivalent on
ext4 (which requires copying all the data, at a cost of both time and
space).

In the end you have to look at your application, and not just
performance stats.  There are tradeoffs.  Personally, I've had enough
hard drive failures that btrfs is worth it to me just for the
assurance that when something goes wrong the filesystem knows what is
good and what isn't.  As drives get bigger this becomes more and more
important.

--
Rich
