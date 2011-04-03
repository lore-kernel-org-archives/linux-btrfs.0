From: Peter Stuge <peter@stuge.se>
Subject: Re: minor ID for btrfs-control
Date: Sun, 3 Apr 2011 14:28:08 +0200
Message-ID: <20110403122808.17595.qmail@stuge.se>
References: <20110402172936.GA24370@mother.jarsat.pl> <Bj8m7qCT1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Bj8m7qCT1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Helmut Hullen wrote:
> > If you do not use udev, you need to synchronise /dev/
> > node with /sys/class/misc/btrfs-control/dev manually on each boot.
> 
> Solved (something like reverse engineering).
> 
> I re-create the (permanent) entry /dev/btrfs-control using the
> actual contents of "/sys/class/misc/btrfs-control/dev", and btrfs
> is happy (and me too).

This is fine, and is just what udev does; it creates the correct
device node using kernel data.


//Peter
