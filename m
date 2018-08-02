Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:44943 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbeHBSP1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2018 14:15:27 -0400
Received: by mail-qt0-f173.google.com with SMTP id b15-v6so2913595qtp.11
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Aug 2018 09:23:35 -0700 (PDT)
Date: Thu, 2 Aug 2018 12:23:32 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, lkp@01.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [LKP] [lkp-robot] [mm] 9092c71bb7: blogbench.write_score -12.3%
 regression
Message-ID: <20180802162330.bs3irlc5hqq75ukp@destiny>
References: <20180408015739.GN3845@yexl-desktop>
 <876036apgx.fsf@yhuang-dev.intel.com>
 <878t7t3k3s.fsf@yhuang-dev.intel.com>
 <87h8m6m9ld.fsf@yhuang-dev.intel.com>
 <878t7ai08v.fsf@yhuang-dev.intel.com>
 <B33D77FE-E654-4BB3-A7F3-CEBCE93C6589@fb.com>
 <87zhyvew74.fsf@yhuang-dev.intel.com>
 <87tvod8g8k.fsf@yhuang-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87tvod8g8k.fsf@yhuang-dev.intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 02, 2018 at 01:55:23PM +0800, Huang, Ying wrote:
> "Huang, Ying" <ying.huang@intel.com> writes:
> 
> > Hi, Chris,
> >
> > Chris Mason <clm@fb.com> writes:
> >
> >> On 19 Jun 2018, at 23:51, Huang, Ying wrote:
> >>>>> "Huang, Ying" <ying.huang@intel.com> writes:
> >>>>>
> >>>>>> Hi, Josef,
> >>>>>>
> >>>>>> Do you have time to take a look at the regression?
> >>>>>>
> >>>>>> kernel test robot <xiaolong.ye@intel.com> writes:
> >>>>>>
> >>>>>>> Greeting,
> >>>>>>>
> >>>>>>> FYI, we noticed a -12.3% regression of blogbench.write_score and
> >>>>>>> a +9.6% improvement
> >>>>>>> of blogbench.read_score due to commit:
> >>>>>>>
> >>>>>>>
> >>>>>>> commit: 9092c71bb724dba2ecba849eae69e5c9d39bd3d2 ("mm: use
> >>>>>>> sc->priority for slab shrink targets")
> >>>>>>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git
> >>>>>>> master
> >>>>>>>
> >>>>>>> in testcase: blogbench
> >>>>>>> on test machine: 16 threads Intel(R) Xeon(R) CPU D-1541 @
> >>>>>>> 2.10GHz with 8G memory
> >>>>>>> with following parameters:
> >>>>>>>
> >>>>>>> 	disk: 1SSD
> >>>>>>> 	fs: btrfs
> >>>>>>> 	cpufreq_governor: performance
> >>>>>>>
> >>>>>>> test-description: Blogbench is a portable filesystem benchmark
> >>>>>>> that tries to reproduce the load of a real-world busy file
> >>>>>>> server.
> >>>>>>> test-url:
> >>
> >> I'm surprised, this patch is a big win in production here at FB.  I'll
> >> have to reproduce these results to better understand what is going on.
> >> My first guess is that since we have fewer inodes in slab, we're
> >> reading more inodes from disk in order to do the writes.
> >>
> >> But that should also make our read scores lower.
> >
> > Any update on this?
> 
> Ping.
> 

I can't reproduce this, and what's more it appears that blogbench doesn't use
much memory at all.  I have the slab shrinking tracepoints on and we never go
into this code at all, so I'm pretty sure these results are bogus.  How are you
running blogbench?  I'm doing blogbench -d /whatever, if I need to be doing
something else let me know.  But from what I can tell this thing uses less than
100m of memory, and on an 8gig of ram box we're never going to trip over this
code.  Thanks,

Josef
