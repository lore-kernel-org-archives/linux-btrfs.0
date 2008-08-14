From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: btrfs day 1
Date: Thu, 14 Aug 2008 11:27:13 -0700
Message-ID: <20080814112713.7380ee98@extreme>
References: <20080814001120.4f1fea7a@speedy>
	<1218709514.15342.370.camel@think.oraclecorp.com>
	<20080814091937.470f42ed@speedy>
	<1218734760.15342.381.camel@think.oraclecorp.com>
	<20080814110612.1f411564@extreme>
	<1218738082.15342.388.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Stephen Hemminger <stephen.hemminger@vyatta.com>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218738082.15342.388.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 14 Aug 2008 14:21:22 -0400
Chris Mason <chris.mason@oracle.com> wrote:

> On Thu, 2008-08-14 at 11:06 -0700, Stephen Hemminger wrote:
> 
> > > So, the question is why the kernel compile workload works for me.  What
> > > kind of hardware are you running (ram, cpu, disks?)
> > 
> > Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz
> > Memory 2G
> > Disk 80G (partition was 20G)
> > 
> 
> It seems you have the secret to corrupting things.  I'll try to
> reproduce with smaller partitions and less ram here.
> 
> -chris
> 
> 

Actually, the partition that got corrupted was 60G
