From: Chris Mason <chris.mason@oracle.com>
Subject: Re: New experimental btrfs branch ready for testing
Date: Tue, 9 Jun 2009 11:26:39 -0400
Message-ID: <20090609152639.GB9556@think>
References: <20090601210447.GC3890@think> <4A281A3C.6000006@austin.ibm.com> <20090605142008.GB6942@think> <4A294194.6050006@austin.ibm.com> <4A298DDB.6070002@austin.ibm.com> <20090606002021.GE3824@think> <4A2A9B95.5050604@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A2A9B95.5050604@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 06, 2009 at 11:38:45AM -0500, Steven Pratt wrote:
>
> No problem.  Raid results are uploading to  
> http://btrfs.boxacle.net/repository/raid/history/History.html  now.   
> There were massive improvements in the random write workloads,  
> especially with cow enabled!!  MailServer had moderate perf gains, but  
> dramatic decrease in CPU utilization, so this is very good as well.
>
> The only regression I see is on large file creates, CPU is up 200% or  
> more while performance is fairly flat.  btrfs_tree_lock now dominates  
> the profile.

I'm not able to reproduce the btrfs_tree_lock usage that you're seeing.
Could you please use the callgraph option to oprofile?

-chris

