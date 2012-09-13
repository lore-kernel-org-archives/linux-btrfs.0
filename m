Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:38264 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124Ab2IMNAP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Sep 2012 09:00:15 -0400
Date: Thu, 13 Sep 2012 09:00:11 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: ching lu <lsching17@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: ssd alignment and btrfs sector size
Message-ID: <20120913130011.GE12994@localhost.localdomain>
References: <CACHiF8Bg+od7tyq_5QeXAN1uo+Gs+D_Mnof00RPJZRoP2RC6ZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CACHiF8Bg+od7tyq_5QeXAN1uo+Gs+D_Mnof00RPJZRoP2RC6ZA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 13, 2012 at 12:02:04AM -0600, ching lu wrote:
> I am trying to test btrfs on my ssd, i am studying about btrfs and alignment.
> 
> I have read this old mail:
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg16177.html
> 
> According to the thread, 3 parameters should be tuned
> 
> 1. leafsize
> 2. nodesize
> 3. sectorsize
> 
> The first two parameters are easy to understand, but how does
> "sectorsize" affect the alignment?
> 
> If the erase block size of my SSD is 16k, and i set
> leafsize=nodesize=16k, leave the sectorsize=4k (default), will it
> causes misalignment?

So frist leafsize/nodesize will always be the same, so if you set one to 16k
mkfs will autmatically set the other to 16k, it's just way back when we had
grand plans of having different sizes for both.

Secondly your erase block size is 16k?  What kind of drive are you using?  But
yeah 4k sectorsize will result in misaligned writes to the data area, but your
metadata will be aligned.  Hopefully the raid5/6 code will be out soon and we'll
be able to do > page size sectorsize and you'll be able to set
leafsize==sectorsize.  Btw most normal SSDs have waaaay larger erase blocks, on
the order of several MB, so it's not the worst thing to write to the middle of
erase blocks, everybody does it anyway.  Thanks,

Josef
