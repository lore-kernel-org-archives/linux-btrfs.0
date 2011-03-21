From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC] btrfs: Simplify locking
Date: Mon, 21 Mar 2011 19:11:24 +0100
Message-ID: <20110321181124.GK12003@htj.dyndns.org>
References: <20110320174433.GA12003@htj.dyndns.org>
 <1300665355-sup-1698@think>
 <20110321082942.GD12003@htj.dyndns.org>
 <20110321165955.GG12003@htj.dyndns.org>
 <1300728113-sup-8564@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1300728113-sup-8564@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

On Mon, Mar 21, 2011 at 01:24:37PM -0400, Chris Mason wrote:
> Very interesting.  Ok, I'll definitely rerun my benchmarks as well.  I
> used dbench extensively during the initial tuning, but you're forcing
> the memory low in order to force IO.
> 
> This case doesn't really hammer on the locks, it hammers on the
> transition from spinning to blocking.  We want also want to compare
> dbench entirely in ram, which will hammer on the spinning portion.

Here's re-run of DFL and SIMPLE with the memory restriction lifted.
Memory is 4GiB and disk remains mostly idle with all CPUs running
full.

       USER   SYSTEM   SIRQ    CXTSW  THROUGHPUT
DFL    59898  504517    377  6814245     782.295
SIMPLE 61090  493441    457  1631688     827.751
    
So, about the same picture.

Thanks.

-- 
tejun
