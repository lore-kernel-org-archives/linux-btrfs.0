From: Peter Stuge <peter@stuge.se>
Subject: Re: minor ID for btrfs-control
Date: Sun, 3 Apr 2011 16:00:23 +0200
Message-ID: <20110403140023.25981.qmail@stuge.se>
References: <20110403122808.17595.qmail@stuge.se> <Bj8mcR0T1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Bj8mcR0T1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Helmut Hullen wrote:
> >> Solved (something like reverse engineering).
> >>
> >> I re-create the (permanent) entry /dev/btrfs-control using the
> >> actual contents of "/sys/class/misc/btrfs-control/dev", and btrfs
> >> is happy (and me too).
> 
> > This is fine, and is just what udev does; it creates the correct
> > device node using kernel data.
> 
> Maybe. But if I want a cup of milk I don't buy a complete cow ...

My point was that it's not so much reverse engineering, it's exactly
how udev works, and that also makes it a really reliable solution.


//Peter
