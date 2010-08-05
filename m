From: Chris Mason <chris.mason@oracle.com>
Subject: Re: volume broken? btrfsck fails
Date: Wed, 4 Aug 2010 21:30:05 -0400
Message-ID: <20100805013005.GC29506@think>
References: <569BCC7F-1920-4AC4-8069-369419029373@gmail.com>
 <20100707001622.GH15984@think>
 <20100804204840.1652f4cd@gimpel.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Thomas Kuther <gimpel@sonnenkinder.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100804204840.1652f4cd@gimpel.ath.cx>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 04, 2010 at 08:48:40PM +0200, Thomas Kuther wrote:
> On Di, 06.07.10 20:16 Chris Mason <chris.mason@oracle.com> wrote:
> 
> > On Sat, Jun 26, 2010 at 03:15:04PM -0700, Yee-Ting Li wrote:
> > > Hi,
> > > 
> > > i think my btrfs volume is hosed.... it mounts okay, but iostat
> > > shows /dev/sdg on 100% load. dmesg shows lots of 'parent transid
> > > verify failed on x wanted y found z'. then after a while i can't
> > > read from it (access to the filesystem freezes).
> > > 
> > > the machine had crashed (prob from some other process), and upon
> > > reboot i've been experience this problem since.
> > > 
> > > can anyone provide any guidance in how to proceed?
> > 
> > These are definitely corruptions, and they probably came from the
> > crash. Can you tell me more about the crash? (Power failure, what is
> > the storage underneath etc, what are the write cache settings).  We
> > don't expect these kinds corruptions to happen.
> > 
> > Yan Zheng is making a lot of progress on btrfsck, but I don't think
> > you'll want to be one of the first testers there.  I can definitely
> > help copy things off if you're having trouble accessing the FS.
> > 
> > -chris
> 
> Hello Chris,
> 
> sorry if I'm hijacking this thread. I got a similar problem, probably
> caused by a system crash due to faulty/badly timed memory dimms. The
> system suddenly hardlocked during write activity.
> 
> - kernel is 2.6.35
> - btrfs on top of a md raid5, which looks healthy. Desktop SATA disks.
> 
> # cat /proc/mdstat|grep -A1 md0
> md0 : active raid5 sdb1[0] sdd1[1] sdc1[2]
>       2930271872 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
> 
> # btrfsck
> usage: btrfsck dev
> Btrfs v0.19-16-g075587c-dirty
> 
> # btrfsck /dev/md0
> parent transid verify failed on 2419218964480 wanted 127839 found 127260
> parent transid verify failed on 2419218964480 wanted 127839 found 127260
> parent transid verify failed on 2419218915328 wanted 127839 found 127260
> parent transid verify failed on 2419218915328 wanted 127839 found 127260
> parent transid verify failed on 2419214266368 wanted 127839 found 127837
> parent transid verify failed on 2419214266368 wanted 127839 found 127837
> parent transid verify failed on 2419214266368 wanted 127839 found 127837
> Segmentation fault
> 
> Mount endlessly loops, like explained in this thread.
> 
> If there is a way, I would really like some aid copying the data off.
> The backup is quite out of date, shame on me.

No problem, I'll get a test patch out in the morning.

-chris

