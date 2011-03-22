From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH RFC] btrfs: Simplify locking
Date: Tue, 22 Mar 2011 19:13:09 -0400
Message-ID: <1300835390-sup-7485@think>
References: <20110320174433.GA12003@htj.dyndns.org> <1300665355-sup-1698@think> <20110321082942.GD12003@htj.dyndns.org> <20110321165955.GG12003@htj.dyndns.org> <1300728113-sup-8564@think> <20110321181124.GK12003@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110321181124.GK12003@htj.dyndns.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Tejun Heo's message of 2011-03-21 14:11:24 -0400:
> Hello,
> 
> On Mon, Mar 21, 2011 at 01:24:37PM -0400, Chris Mason wrote:
> > Very interesting.  Ok, I'll definitely rerun my benchmarks as well.  I
> > used dbench extensively during the initial tuning, but you're forcing
> > the memory low in order to force IO.
> > 
> > This case doesn't really hammer on the locks, it hammers on the
> > transition from spinning to blocking.  We want also want to compare
> > dbench entirely in ram, which will hammer on the spinning portion.
> 
> Here's re-run of DFL and SIMPLE with the memory restriction lifted.
> Memory is 4GiB and disk remains mostly idle with all CPUs running
> full.
> 
>        USER   SYSTEM   SIRQ    CXTSW  THROUGHPUT
> DFL    59898  504517    377  6814245     782.295
> SIMPLE 61090  493441    457  1631688     827.751
>     
> So, about the same picture.

Ok, this impact of this is really interesting.  If we have very short
waits where there is no IO at all, this patch tends to lose.  I ran with
dbench 10 and got about 20% slower tput.

But, if we do any IO at all it wins by at least that much or more.  I
think we should take this patch and just work on getting rid of the
scheduling with the mutex held where possible.

Tejun, could you please send the mutex_tryspin stuff in?  If we can get
a sob for that I can send the whole thing.

-chris
