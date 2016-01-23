Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:38501 "EHLO
	cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbcAWVlg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jan 2016 16:41:36 -0500
Date: Sat, 23 Jan 2016 16:41:28 -0500
From: Sean Greenslade <sean@seangreenslade.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: RAID1 disk upgrade method
Message-ID: <20160123214127.GA601@fox.wireless.rit.edu>
References: <20160122034538.GA25196@coach.student.rit.edu>
 <pan$ab5ec$b21ab56e$f67a3d97$7303502@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$ab5ec$b21ab56e$f67a3d97$7303502@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 22, 2016 at 10:54:58AM +0000, Duncan wrote:
> And since you do have the raid1 creation kernel info there too, I can 
> tell you that yes, a number of filesystem features are now default that 
> weren't, back on kernel 3.10, including I believe 16k node size (the 
> default back then was 4k, tho 16k was an available option, just not the 
> default).  I'm quite sure that was before skinny metadata by default, as 
> well.  Whether the newer features are worth the additional hassle of 
> doing the new mkfs.btrfs and copy, as opposed to the more straightforward 
> btrfs replace, is up to you, but yes, the defaults are slightly different 
> now, so you have that additional information to consider when choosing 
> your upgrade method. =:^)

Thanks Duncan, Austin, and Chris. I think my plan is going to be to do
btrfs replace on the disks, and try to enable skinny extents with
btrfstune. I'm not really concerned about the node size, as from what I
can tell it's just a slight performance bump.

Question about btrfstune: It seems to only operate on unmounted
partitions. If I want to enable skinny extents on my raid1, do I need to
run btrfstune on both drives, or just one? And I'm assuming it will just
apply to newly-allocated extents, so I should enable it before I start
the replace, correct?

--Sean
