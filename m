Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:60631 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab2GTSi7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jul 2012 14:38:59 -0400
Date: Fri, 20 Jul 2012 14:38:55 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Josef Bacik <jbacik@fusionio.com>
CC: Zach Brown <zab@zabbo.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: detect if the disk we are formatting is a
 ssd
Message-ID: <20120720183855.GL18878@shiny.int.fusionio.com>
References: <1342797098-6493-1-git-send-email-jbacik@fusionio.com>
 <20120720181859.GE3889@lenny.home.zabbo.net>
 <20120720182056.GE2118@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120720182056.GE2118@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 20, 2012 at 12:20:56PM -0600, Josef Bacik wrote:
> On Fri, Jul 20, 2012 at 12:18:59PM -0600, Zach Brown wrote:
> > > +static int is_ssd(const char *file)
> > > +{
> > > +	char *dev = strrchr(file, '/');
> > 
> >  [ ... ]
> > 
> > > +	snprintf(path, PATH_MAX, "/sys/block/%s/queue/rotational", dev);
> > > +	fd = open(path, O_RDONLY);
> > 
> > Hmm, this doesn't seem right.  The last path component can have nothing
> > to do with the underlying device name.  And /sys/block doesn't have
> > entries for partition devices.
> > 
> > After some poking around (and hints from Eric), it looks like the thing
> > to do is stat the file to find that it's a block device and then use
> > blkid_devno_to_wholedisk().  That parses the link from
> > /sys/dev/block/$maj:$min to find the containing device.
> > 
> > Then it'll work for partitions and nutty udev vanity symlinks.
> > 
> 
> Partitions are for losers.

Winners make a separate /boot, even when using syslinux to boot directly
off btrfs (syslinux is awesome everyone, switch now).

-chris

