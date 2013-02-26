Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759602Ab3BZT3H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 14:29:07 -0500
Date: Tue, 26 Feb 2013 11:28:55 -0800
From: Zach Brown <zab@redhat.com>
To: Marc MERLIN <marc@merlins.org>
Cc: Josef Bacik <jbacik@fusionio.com>, Liu Bo <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:3753! These btrfs crashes at
 mount time on log replay are really a problem
Message-ID: <20130226192855.GL1658@lenny.home.zabbo.net>
References: <20130226065102.GC11218@merlins.org>
 <20130226142300.GE19641@localhost.localdomain>
 <20130226162029.GB22367@merlins.org>
 <20130226182442.GI1658@lenny.home.zabbo.net>
 <20130226190917.GF22367@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130226190917.GF22367@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > The equivalent consistent update mechanism in btrfs is cow tree updates.
> > The superblock that references new tree blocks written to free space is
> > itself only written once all those blocks are stable on disk.  If the
> > tree block writes are interrupted then the superblock isn't updated and
> > btrfs won't see the partially written blocks.  No worries.
> 
> Ok. So basically what I seem to be hitting, are seemingly complete tree
> blocks in the log, that aren't complete or consistent afterall, triggering 
> BUG() in the end.

That's my understanding, yes.  I think Josef is digging in.

> I understand that this might not want to be a default, but it should be
> something that could be done from the kernel command line, and allow the
> mount to continue and the boot to succeed (including the kernel debug log to
> make it to local disk, where it can then be Emailed since serial console or
> netconsole is not something you can do easily)
> 
> Does that sound reasonable?

To me?  Absolutely.  Having to recover with btrfs-zero-log is annoying.
I'd be surprised if anyone didn't agree that the current process should
be improved.

- z
