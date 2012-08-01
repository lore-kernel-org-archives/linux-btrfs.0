Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41138 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab2HABBF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Jul 2012 21:01:05 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.77 #2)
	id 1SwNJA-0001y4-6G
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2012 18:01:04 -0700
Date: Tue, 31 Jul 2012 18:01:04 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS crash on mount with 3.4.4
Message-ID: <20120801010104.GA7089@merlins.org>
References: <20120731180412.GA10520@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120731180412.GA10520@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 31, 2012 at 11:04:12AM -0700, Marc MERLIN wrote:
> My kernel crashed for some other reason, and now I can't mount my btrfs
> filesystem.
> I don't care about the data, it's backed up.
> 
> I'll compile a 3.5 kernel, but is there any info you'd like off that
> filesystem to see why btrfs is crashing on mount?

On the plus side, 3.5 mounted the filesystem:
[  183.069179] device label btrfs_pool1 devid 1 transid 20769 /dev/mapper/test
[  183.087805] btrfs: disk space caching is enabled
[  183.224784] btrfs: no dev_stats entry found for device /dev/mapper/test (devid 1) (OK on first mount after mkfs)
[  186.277795] Btrfs detected SSD devices, enabling SSD mode
[  188.477443] btrfs: unlinked 6 orphans
[  188.477451] btrfs: truncated 1 orphans
[  411.837015] btrfs: unlinked 13 orphans
[  414.373500] btrfs: unlinked 35 orphans

This seems to hint that I lost random files and that I don't know what they are.

I suppose I can go back to my latest hourly snapshot which is more likely to not have
truncated or missing files.

Is there anything else someone would want off that filesystem that will help 
the developers?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
