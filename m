Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-out15.tpgi.com.au ([220.244.226.125]:59441 "EHLO
	mail15.tpgi.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757390AbbEFEAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 May 2015 00:00:03 -0400
From: Paul Jones <paul@pauljones.id.au>
To: sam tygier <samtygier@yahoo.co.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH] btrfs-progs: check metadata redundancy
Date: Wed, 6 May 2015 03:40:12 +0000
Message-ID: <B7F2379062E32745A8651FBDB20F645954A286B3@Server.waterlogic.com.au>
References: <mi2sgj$urs$1@ger.gmane.org>
 <20150505145432.GG5099@twin.jikos.cz> <mibc2f$a9$1@ger.gmane.org>
In-Reply-To: <mibc2f$a9$1@ger.gmane.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of sam tygier
> Sent: Wednesday, 6 May 2015 7:18 AM
> To: linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH] btrfs-progs: check metadata redundancy
> 
> On 05/05/15 15:54, David Sterba wrote:
> > On Sat, May 02, 2015 at 05:03:31PM +0100, sam tygier wrote:
> >> Currently BTRFS allows you to make bad choices of data and metadata
> >> levels. For example -d raid1 -m raid0 means you can only use half
> >> your total disk space, but will loose everything if 1 disk fails.
> >> This patch prevents you creating the situation another will be need
> >> to prevent rebalancing in to it.
> >>
> >> When making a filesystem check that metadata mode is at least as
> >> redundant as the data mode. For example don't allow:
> >> 	-d raid1 -m raid0
> >
> > This is enforcing some policty that makes sense for some usecases, but
> > I think that the tool should be flexible enough to create any kind of
> > raid profiles. It's up to the user. I'm willing to add a warning that
> > the profiles seem fishy, but failing mkfs without any way to override
> > that is IMHO not a good thing.
> 
> There already seems to be policy in test_num_disk_vs_raid() disallowing
> DUP for multiple devices. Is there really a useful case better protected data
> than metadata?

I would appreciate being able to use the DUP profile for data on a single disk - at the moment I just resort to partitioning the disk in two and creating a raid1.
Usecase is portable disk backups - I take a master backup at site A with slow internet, and upload it to backup server from site B. Then I use rsync and snapshots. I start over every 2 months as one of the backups is an incremental backup of a few windows system images.

Paul.
