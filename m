From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC PATCH 0/5] Btrfs: Add hot data tracking functionality
Date: Wed, 28 Jul 2010 14:22:49 -0700
Message-ID: <1280352169.7694.2.camel@mingming-laptop>
References: <1280268023-18408-1-git-send-email-bchociej@gmail.com>
	 <20100727222916.GM18595@tracyreed.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: bchociej@gmail.com, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	bcchocie@us.ibm.com, mrlupfer@us.ibm.com, crscott@vnet.ibm.com,
	linux-kernel@vger.kernel.org
To: Tracy Reed <treed@ultraviolet.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100727222916.GM18595@tracyreed.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2010-07-27 at 15:29 -0700, Tracy Reed wrote: 
> On Tue, Jul 27, 2010 at 05:00:18PM -0500, bchociej@gmail.com spake thusly:
> > The long-term goal of these patches, as discussed in the Motivation
> > section at the end of this message, is to enable Btrfs to perform
> > automagic relocation of hot data to fast media like SSD. This goal has
> > been motivated by the Project Ideas page on the Btrfs wiki.
> 
> With disks being so highly virtualized away these days is there any
> way for btrfs to know which are the fast outer-tracks vs the slower
> inner-tracks of a physical disk? If so not only could this benefit SSD
> owners but it could also benefit the many more spinning platters out
> there. If not (which wouldn't be surprising) then disregard. Even just
> having that sort of functionality for SSD would be excellent. If I
> understand correctly not only would this work for SSD but if I have a
> SAN full of many large 7200rpm disks and a few 15k SAS disks I could
> effectively utilize that disk by allowing btrfs to place hot data on
> the 15k SAS. I understand Compellent does this as well.
> 

This certainly possible. The disk to store hot data does not has to
limit to SSDs, thought current implementation detecting "fast" device by
checking the SSD rotation flag. This could be easily extended if btrfs
is able to detect the relatively fast devices.

