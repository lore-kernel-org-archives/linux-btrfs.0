From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH 4/4] btrfs: Moved repair code from inode.c to extent_io.c
Date: Sun, 24 Jul 2011 09:24:08 -0700
Message-ID: <m21uxftzo7.fsf@firstfloor.org>
References: <cover.1311344751.git.list.btrfs@jan-o-sch.net>
	<31a5f07325d66bd6691673eafee2c242afd8b833.1311344751.git.list.btrfs@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <31a5f07325d66bd6691673eafee2c242afd8b833.1311344751.git.list.btrfs@jan-o-sch.net>
	(Jan Schmidt's message of "Fri, 22 Jul 2011 16:58:08 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

Jan Schmidt <list.btrfs@jan-o-sch.net> writes:
>
> Repair works that way: Whenever a read error occurs and we have more
> mirrors to try, note the failed mirror, and retry another. If we find a
> good one, check if we did note a failure earlier and if so, do not allow
> the read to complete until after the bad sector was written with the good
> data we just fetched. As we have the extent locked while reading, no one
> can change the data in between.

This has the potential for error loops: when the write fails too
you get another error in the log and can flood the log etc. 
I assume this could get really noisy if that disk completely
went away.

Perhaps it needs a threshold to see if there aren't too many errors
on the mirror and then stop retrying at some point.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
