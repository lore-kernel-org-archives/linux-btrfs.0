From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: A lot of writing to FS only read (Was: Memory leak?)
Date: Sat, 9 Jul 2011 08:42:52 +0100
Message-ID: <20110709074252.GB4294@yahoo.fr>
References: <20110703190913.GA4474@yahoo.fr>
 <CAE5mzvhZc4afuBTT0GrDvPXKaSwYeyPdyiQaYPjCTmvzBahr7g@mail.gmail.com>
 <20110706081111.GA6931@yahoo.fr>
 <20110708124429.GB4284@yahoo.fr>
 <1310137241-sup-8158@shiny>
 <20110708154123.GA17886@yahoo.fr>
 <1310141349-sup-9515@shiny>
 <20110708200412.GG4284@yahoo.fr>
 <1310155908-sup-9183@shiny>
 <20110709070955.GA4294@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cwillu <cwillu@cwillu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110709070955.GA4294@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-09 08:09:55 +0100, Stephane Chazelas:
> 2011-07-08 16:12:28 -0400, Chris Mason:
> [...]
> > > I'm running a "dstat -df" at the same time and I'm seeing
> > > substantive amount of disk writes on the disks that hold the
> > > source FS (and I'm rsyncing from read-only snapshot subvolumes
> > > in case you're thinking of atimes) almost more than onto the
> > > drive holding the target FS!?
[...]

One thing I didn't mention is that before doing the rsync, I
deleted a few snapshot volumes (those were read-only snapshots
of read-only snapshots) and recreated them and that's the ones
I'm rsyncing from (basically, I prepare an area to be rsynced
made of the latests snapshots of a few subvolumes).

-- 
Stephane
