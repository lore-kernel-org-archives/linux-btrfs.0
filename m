Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:33677 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852Ab3ACPGK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Jan 2013 10:06:10 -0500
Date: Thu, 3 Jan 2013 10:06:06 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Richard Cooper <richard@richardcooper.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfsck: extent-tree.c:2549: btrfs_reserve_extent: Assertion
 `!(ret)' failed.
Message-ID: <20130103150606.GC2389@localhost.localdomain>
References: <0400867D-6E5E-4D0F-8A06-B5AD3E58DEE6@richardcooper.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <0400867D-6E5E-4D0F-8A06-B5AD3E58DEE6@richardcooper.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 03, 2013 at 05:26:38AM -0700, Richard Cooper wrote:
> Hi All,
> 
> I'm trying to repair a broken fs using btrfsck and am hitting a failed assertion. I'd appreciate any suggestions for what to do next. Is there any thing I can do to help fix this bug? Any other information from my FS which would help? If the FS could be salvaged that would be a bonus, but I'm more interested in providing a useful bug report before wiping the disk.
> 

Well good news is that its the allocator failing to find space for a new block,
and the allocator in btrfs-progs is under-tested, so it's likely just an
internal bug and something we can fix.  Can you do btrfs fi show /dev/md4 (not
mounted) and post that so we can be sure there's actually enough space.  And
I'll look at the allocator code in the meantime and see if theres something
obvious wrong.  Thanks,

Josef
