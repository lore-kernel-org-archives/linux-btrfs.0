Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:60516 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab2ITLvS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 07:51:18 -0400
Date: Thu, 20 Sep 2012 13:51:12 +0200
From: David Sterba <dave@jikos.cz>
To: ching <lsching17@gmail.com>
Cc: Liu Bo <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: enquiry about autodefrag option
Message-ID: <20120920115111.GJ17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <50570652.4060200@gmail.com>
 <5059AC5E.1030003@gmail.com>
 <5059D2D3.3050303@oracle.com>
 <505A5715.9060309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <505A5715.9060309@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 20, 2012 at 07:36:53AM +0800, ching wrote:
> 
> >>> 2. AFAIK, "autodefrag" detects small random writes into files and
> >>> queues them up for an automatic defrag process, so the filesystem will
> >>> defragment itself while it's used.
> >>>
> >>>     If the system reboot/crash/remount-ro, will the autodefrag process
> >>> continue after resume?
> >>>
> > For reboot, autodefrag will be waited to finish during umounting btrfs.
> >
> > For crash and remount-ro, it won't resume since it is not that necessary and we're all
> > COWed so that the data is ok.
> >
> > And autodefrag will only take effect when taking the 'autodefrag' mount option.
> >
> > thanks,
> > liubo
> >
> >
> 
> Can the loophole be fixed by tuning the autodefrag algorithm? e.g.
> also queue up small extents detected during read operation for the
> autodefrag process.

Sounds interesting, though this would increase write load for a pure
read but may improve fragmentation situation and is obviously done only
on the first read. The write side of autodefrag could be extended to
defrag also small extents that would fit into some threshold, not only
newly written data.

> Is there any io niceness control for autodefrag process too? it will
> be nice if the idle class is used.

No. Autodefrag will mark file data dirty and they'll be written back to
the storage in the same way as any other write through the worker
threads.

> Actually, i try to write shell script to defrag entire FS monthy. but
> i soon find out it is hard to keep track of progress across reboot and
> avoid redefragging defragged file

The defrag process will skip already deframented files (in the meaning
of "defragmented" as it sees fit, implementation dependent currently,
not exactly that the file has 1 extent).

> For me, autodefrag is a killer feature. :)

Yeah, it improves the inherent problem of fragmentation for a COW based
filesystem.

david
