From: Simon Kirby <sim@hostway.ca>
Subject: Re: Slow snapshot deletion
Date: Fri, 12 Aug 2011 11:26:11 -0700
Message-ID: <20110812182611.GB11997@hostway.ca>
References: <20110728200444.GA30801@untroubled.org> <1311884805-sup-7662@shiny> <1311886250-sup-5126@shiny> <20110804163536.GA25185@untroubled.org> <20110811150456.GA558@untroubled.org> <20110812004036.GA3960@hostway.ca> <20110812182144.GA10102@untroubled.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110812182144.GA10102@untroubled.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 12, 2011 at 12:21:44PM -0600, Bruce Guenter wrote:

> On Thu, Aug 11, 2011 at 05:40:36PM -0700, Simon Kirby wrote:
> > By chance, does "vmstat 1" or top show a high system cpu% while this is
> > happening,
> 
> Absolutely, usually around 80-90%

...which is perhaps why you had difficult obtaining traces with sysrq-w,
since most of the time there were no D-state processes. Instead, sysrq-l
give a backtrace of each running CPU.

> > and if so, does cat /proc/<pid>/stack of the PIDs in R state
> > sometimes show things under btrfs_run_delayed_refs like
> > setup_cluster_no_bitmap() and rb_next()?
> 
> No, I am not seeing what you describe.  The stack traces are usually
> showing what I originally quoted.  I don't know if I've seen
> setup_cluster_no_bitmap or rb_* at all.

Ok, oh well. :)

Simon-
