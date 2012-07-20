Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:48344 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab2GTSU7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jul 2012 14:20:59 -0400
Date: Fri, 20 Jul 2012 14:20:56 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Zach Brown <zab@zabbo.net>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: detect if the disk we are formatting is a
 ssd
Message-ID: <20120720182056.GE2118@localhost.localdomain>
References: <1342797098-6493-1-git-send-email-jbacik@fusionio.com>
 <20120720181859.GE3889@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120720181859.GE3889@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 20, 2012 at 12:18:59PM -0600, Zach Brown wrote:
> > +static int is_ssd(const char *file)
> > +{
> > +	char *dev = strrchr(file, '/');
> 
>  [ ... ]
> 
> > +	snprintf(path, PATH_MAX, "/sys/block/%s/queue/rotational", dev);
> > +	fd = open(path, O_RDONLY);
> 
> Hmm, this doesn't seem right.  The last path component can have nothing
> to do with the underlying device name.  And /sys/block doesn't have
> entries for partition devices.
> 
> After some poking around (and hints from Eric), it looks like the thing
> to do is stat the file to find that it's a block device and then use
> blkid_devno_to_wholedisk().  That parses the link from
> /sys/dev/block/$maj:$min to find the containing device.
> 
> Then it'll work for partitions and nutty udev vanity symlinks.
> 

Partitions are for losers.

Josef
