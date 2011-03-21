From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC] btrfs: Simplify locking
Date: Mon, 21 Mar 2011 09:29:42 +0100
Message-ID: <20110321082942.GD12003@htj.dyndns.org>
References: <20110320174433.GA12003@htj.dyndns.org>
 <1300665355-sup-1698@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1300665355-sup-1698@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Chris.

On Sun, Mar 20, 2011 at 08:10:51PM -0400, Chris Mason wrote:
> I went through a number of benchmarks with the explicit
> blocking/spinning code and back then it was still significantly faster
> than the adaptive spin.  But, it is definitely worth doing these again,
> how many dbench procs did you use?

It was dbench 50.

> The biggest benefit to explicit spinning is that mutex_lock starts with
> might_sleep(), so we skip the cond_resched().  Do you have voluntary
> preempt on?

Ah, right, I of course forgot to actually attach the .config.  I had
CONFIG_PREEMPT, not CONFIG_PREEMPT_VOLUNTARY.  I'll re-run with
VOLUNTARY and see how its behavior changes.

Thanks.

-- 
tejun
