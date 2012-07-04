Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:34697 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab2GDNnE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jul 2012 09:43:04 -0400
Date: Wed, 4 Jul 2012 15:42:58 +0200
From: David Sterba <dave@jikos.cz>
To: "Fajar A. Nugraha" <list@fajar.net>
Cc: Hugo Mills <hugo@carfax.org.uk>,
        =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS fsck apparent errors
Message-ID: <20120704134258.GL5326@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <4FF30B55.6060205@petaramesh.org>
 <20120703152208.GA28701@carfax.org.uk>
 <CAG1y0scaAqck=LYJdfhQa02BsrnBM7=24RFG5j00pb0QSdn1LA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAG1y0scaAqck=LYJdfhQa02BsrnBM7=24RFG5j00pb0QSdn1LA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 04, 2012 at 07:40:05AM +0700, Fajar A. Nugraha wrote:
> Are there any known btrfs regression in 3.4? I'm using 3.4.0-3-generic
> from a ppa, but a normal mount - umount cycle seems MUCH longer
> compared to how it was on 3.2, and iostat shows the disk is
> read-IOPS-bound

Is it just mount/umount without any other activity? Is the fs
fragmented (or aged), almost full, has lots of files?

> 
> # time mount LABEL=WD-root
> 
> real	0m10.400s
> user	0m0.000s
> sys	0m0.060s
> 
> # time umount /media/WD-root/
> 
> real	0m22.419s
> user	0m0.000s
> sys	0m0.064s
> 
> # /proc/10142/stack  <--- the PID of umount process

The process(es) actually doing the work are the btrfs workers, usual
sucspects are btrfs-cache (free space cache) or btrfs-ino (inode cache)
that are writing the cache states back to disk.
I'm using iotop to observe such things.


david
