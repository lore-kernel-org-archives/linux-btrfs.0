Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail6.webfaction.com ([74.55.86.74]:49374 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab3ACQnd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2013 11:43:33 -0500
Subject: Re: btrfsck: extent-tree.c:2549: btrfs_reserve_extent: Assertion `!(ret)' failed.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Richard Cooper <richard@richardcooper.net>
In-Reply-To: <20130103150606.GC2389@localhost.localdomain>
Date: Thu, 3 Jan 2013 16:43:30 +0000
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <042190A6-9365-4ACB-AB89-B277F687E09D@richardcooper.net>
References: <0400867D-6E5E-4D0F-8A06-B5AD3E58DEE6@richardcooper.net> <20130103150606.GC2389@localhost.localdomain>
To: Josef Bacik <jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 3 Jan 2013, at 15:06, Josef Bacik wrote:

> On Thu, Jan 03, 2013 at 05:26:38AM -0700, Richard Cooper wrote:
>> Hi All,
>> 
>> I'm trying to repair a broken fs using btrfsck and am hitting a failed assertion. I'd appreciate any suggestions for what to do next. Is there anything I can do to help fix this bug? Any other information from my FS which would help? If the FS could be salvaged that would be a bonus, but I'm more interested in providing a useful bug report before wiping the disk.
>> 
> 
> Well good news is that its the allocator failing to find space for a new block,
> and the allocator in btrfs-progs is under-tested, so it's likely just an
> internal bug and something we can fix.  Can you do btrfs fi show /dev/md4 (not
> mounted) and post that so we can be sure there's actually enough space. 

# ./btrfs fi show /dev/md4 
Label: none  uuid: 5be10dea-64c1-474e-b640-987b25af3c27
	Total devices 1 FS bytes used 606.79GB
	devid    1 size 16.36TB used 627.04GB path /dev/md4

Thanks for looking at this.


