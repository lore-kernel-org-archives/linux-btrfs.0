From: Sander <sander@humilis.net>
Subject: Re: BTRFS && SSD
Date: Thu, 30 Sep 2010 09:15:30 +0200
Message-ID: <20100930071530.GA964@attic.humilis.net>
References: <AANLkTik9qiqtePxAhaJTyM7Q-g1nTgw9krTZFf_DaYxn@mail.gmail.com>
 <20100929170855.GA4635@lelouch.nomadic.ncsu.edu>
 <AANLkTind3szR8RjBLPbKb2yMH-s8q2ti+28N38z1BeTj@mail.gmail.com>
 <20100929195929.GA5588@lelouch.nomadic.ncsu.edu>
 <AANLkTinzhHOv4L0cPR+tiw=3b7koHGe7svX223FNSxxS@mail.gmail.com>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, yhxu@wayne.edu,
	chris.mason@oracle.com, wingedtachikoma@gmail.com
To: Yuehai Xu <yuehaixu@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinzhHOv4L0cPR+tiw=3b7koHGe7svX223FNSxxS@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Yuehai Xu wrote (ao):
> So, is it a bottleneck in the case of SSD since the cost for over
> write is very high? For every write, I think the superblocks should be
> overwritten, it might be much more frequent than other common blocks
> in SSD, even though SSD will do wear leveling inside by its FTL.

The FTL will make sure the write cycles are evenly divided among the
physical blocks, regardless of how often you overwrite a single spot on
the fs.

> What I current know is that for Intel x25-V SSD, the write throughput
> of BTRFS is almost 80% less than the one of EXT3 in the case of
> PostMark. This really confuses me.

Can you show the script you use to test this, provide some info
regarding your setup, and show the numbers you see?

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
