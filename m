Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:39494 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab2G0MFc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jul 2012 08:05:32 -0400
Date: Fri, 27 Jul 2012 08:05:29 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: David Sterba <dave@jikos.cz>
CC: "cbay@alwaysdata.com" <cbay@alwaysdata.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <JBacik@fusionio.com>
Subject: Re: mkfs devices ordering relevant with devices of different sizes?
Message-ID: <20120727120529.GA13442@localhost.localdomain>
References: <juos5r$2tp$1@dough.gmane.org>
 <20120726210959.GK17430@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120726210959.GK17430@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 26, 2012 at 03:09:59PM -0600, David Sterba wrote:
> On Wed, Jul 25, 2012 at 03:26:20PM +0200, Cyril B.  wrote:
> > When creating a filesystem with devices of different sizes, the resulting 
> > filesystem total size depends on the device order specified to mkfs. When 
> > the smaller device is specified first, the second (larger) device is seen as 
> > the same size as the first. This doesn't occur when the order is reversed.
> > 
> > It's confusing. Is this expected? I'm using the latest btrfs-progs and Linux 
> > 3.5.
> 
> Confusing it is, caused by this commit
> 
> Author:     Josef Bacik <josef@redhat.com>
> AuthorDate: Wed Mar 28 14:20:52 2012 -0400
> Commit:     Chris Mason <chris.mason@fusionio.com>
> CommitDate: Tue Jul 3 16:27:46 2012 -0400
> 
>     btrfs-progs: enforce block count on all devices in mkfs
> 
>     I had a test that creates a 7gig raid1 device but it was ending up wonky
>     because the second device that gets added is the full size of the disk
>     instead of the limited size.  So enforce the limited size on all disks
>     passed in at mkfs time, otherwise our threshold calculations end up wonky
>     when doing chunk allocations.  Thanks,

Ooops, that's definitely not what I intended, I will fix that up right away,
sorry about that.  Thanks,

Josef
