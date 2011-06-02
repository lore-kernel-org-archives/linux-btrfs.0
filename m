From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [BUG 3.0-rc1] oops during file removal, severe lock contention
Date: Thu, 02 Jun 2011 12:46:24 -0700
Message-ID: <m2aae0t3sf.fsf@firstfloor.org>
References: <20110602011139.GP561@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110602011139.GP561@dastard> (Dave Chinner's message of "Thu, 2
	Jun 2011 11:11:39 +1000")
List-ID: <linux-btrfs.vger.kernel.org>

Dave Chinner <david@fromorbit.com> writes:
>
> Also, there is massive lock contention while running these workloads.
> perf top shows this for the create after about 5m inodes have been
> created:

We saw pretty much the same thing in some simple tests on large systems
(extent io tree locking and higher level b*tree locks are a problem)
It is being looked at I believe.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
