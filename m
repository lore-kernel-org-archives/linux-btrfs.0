From: Sander <sander@humilis.net>
Subject: Re: BTRFS && SSD
Date: Thu, 30 Sep 2010 15:45:06 +0200
Message-ID: <20100930134506.GA11295@attic.humilis.net>
References: <AANLkTik9qiqtePxAhaJTyM7Q-g1nTgw9krTZFf_DaYxn@mail.gmail.com>
 <20100929170855.GA4635@lelouch.nomadic.ncsu.edu>
 <AANLkTind3szR8RjBLPbKb2yMH-s8q2ti+28N38z1BeTj@mail.gmail.com>
 <20100929195929.GA5588@lelouch.nomadic.ncsu.edu>
 <AANLkTinzhHOv4L0cPR+tiw=3b7koHGe7svX223FNSxxS@mail.gmail.com>
 <20100930071530.GA964@attic.humilis.net>
 <AANLkTinmBmtrv7MC=1XdN97sOFXeLvx2z=Yr+JrCzoj=@mail.gmail.com>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sander@humilis.net, linux-btrfs@vger.kernel.org, yhxu@wayne.edu,
	chris.mason@oracle.com, wingedtachikoma@gmail.com
To: Yuehai Xu <yuehaixu@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinmBmtrv7MC=1XdN97sOFXeLvx2z=Yr+JrCzoj=@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Yuehai Xu wrote (ao):
> On Thu, Sep 30, 2010 at 3:15 AM, Sander <sander@humilis.net> wrote:
> > Yuehai Xu wrote (ao):
> >> So, is it a bottleneck in the case of SSD since the cost for over
> >> write is very high? For every write, I think the superblocks should be
> >> overwritten, it might be much more frequent than other common blocks
> >> in SSD, even though SSD will do wear leveling inside by its FTL.
> >
> > The FTL will make sure the write cycles are evenly divided among the
> > physical blocks, regardless of how often you overwrite a single spot on
> > the fs.
> >
> >> What I current know is that for Intel x25-V SSD, the write throughput
> >> of BTRFS is almost 80% less than the one of EXT3 in the case of
> >> PostMark. This really confuses me.
> >
> > Can you show the script you use to test this, provide some info
> > regarding your setup, and show the numbers you see?
> 
> My test case for PostMark is:
> set file size 9216 15360 (file size from 9216 bytes to 15360 bytes)
> set number 50000(file number is 50000)
> 
> write throughput(MB/s) for different file systems in Intel SSD X25-V:
> EXT3: 28.09
> NILFS2: 10
> BTRFS: 17.35
> EXT4: 31.04
> XFS: 11.56
> REISERFS: 28.09
> EXT2: 15.94

And your testscript? You'll have to provide information on how you
create the filesystems (partitioning, etc), how you mount (options),
what versions of kernel, tools, etc, if you reboot between runs, how
many runs (also per fs), did you burn in the ssd before, modules loaded,
type and amount of hardware (controller, cpu, memory) etc, etc, etc.

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
