Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:57491 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757832Ab3BSBR0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Feb 2013 20:17:26 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 696067C0424
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2013 18:17:26 -0700 (MST)
Date: Mon, 18 Feb 2013 20:17:23 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Tony Plack <tony@plack.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: RAID5/6 Implementation - Understanding first
Message-ID: <20130219011723.GE13803@shiny.masoncoding.com>
References: <FB38335C-3CF7-4D82-B7E2-79264D54F0C8@plack.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <FB38335C-3CF7-4D82-B7E2-79264D54F0C8@plack.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 18, 2013 at 04:20:58PM -0700, Tony Plack wrote:
> Chris and team, hats off on the RAID5/6 being at least experimental.
> I have been following your work for a year now, and waiting for these
> days.
> 
> I am trying to get my head rapped around the architecture for BTRFS
> before I jump in and start recommending code changes to the branch.
> 
> What I am trying to understand is the comments in the GIT commit which
> state:
> 
> 	Read/modify/write is done after the higher levels of the filesystem have
> 	prepared a given bio.  This means the higher layers are not responsible
> 	for building full stripes, and they don't need to query for the topology
> 	of the extents that may get allocated during delayed allocation runs.
> 	It also means different files can easily share the same stripe.
> 
> As I understand it, what we are doing is trying to hide the underlying
> extents architecture to gain some advantages in the higher level code.
> I have been digging in the code, and believe I know the answer to this
> question.  So by "higher levels" does this mean that RMW, snapshots,
> checksums and duplicate detection are all unaware of RAID
> architecture?

Yes, although the allocator is aware of the raid code, and the raid code
is aware that the higher levels are doing copy-on-write.  They also
share the same transaction subsystem, at least until my parity logging
code is complete.

Longer term the two will cooperate more.  For example, when we trigger
read/modify/write in RAID because a sub-stripe write was made to a large
file, we might as well use adjacent blocks from that file to fill the
new stripe.  This will reduce a lot of complexity in terms of small
extent overhead in the rest of the code.

-chris
