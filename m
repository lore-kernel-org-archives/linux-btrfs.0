Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([80.100.93.5]:50298 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbbFQK6h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 06:58:37 -0400
Date: Wed, 17 Jun 2015 12:58:35 +0200
From: Sander <sander@humilis.net>
To: Hugo Mills <hugo@carfax.org.uk>, Marc MERLIN <marc@merlins.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS: read error corrected: ino 1 off 226840576 (dev
 /dev/mapper/dshelf1 sector 459432)
Message-ID: <20150617105835.GA28982@panda>
Reply-To: sander@humilis.net
References: <20150617071654.GI16468@merlins.org>
 <20150617101121.GQ9850@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150617101121.GQ9850@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills wrote (ao):
> On Wed, Jun 17, 2015 at 12:16:54AM -0700, Marc MERLIN wrote:
> > I had a few power offs due to a faulty power supply, and my mdadm raid5
> > got into fail mode after 2 drives got kicked out since their sequence
> > numbers didn't match due to the abrupt power offs.

> > gargamel:~# btrfs fi df /mnt/btrfs_pool1
> > Data, single: total=8.29TiB, used=8.28TiB
> > System, DUP: total=8.00MiB, used=920.00KiB
> > System, single: total=4.00MiB, used=0.00B
> > Metadata, DUP: total=14.00GiB, used=10.58GiB
> > Metadata, single: total=8.00MiB, used=0.00B
> > GlobalReserve, single: total=512.00MiB, used=0.00B

> > I'll do a scrub later, for now I have to wait 20 hours for the raid
> > rebuild first.
> 
>    You'll probably find that the rebuild is equivalent to a scrub anyway.

He has mdadm raid, which is rebuilding. This is obviously not equivalent
to a btrfs scrub.

	Sander
