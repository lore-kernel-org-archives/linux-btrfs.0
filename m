Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49311 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753078AbaCDTa0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Mar 2014 14:30:26 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:53738 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WKv2o-001MHs-58
	for linux-btrfs@vger.kernel.org; Tue, 04 Mar 2014 12:30:26 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: ENOSPC errors during raid1 rebalance
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <loom.20140304T194101-763@post.gmane.org>
Date: Tue, 4 Mar 2014 12:30:25 -0700
Message-Id: <539E0EA2-59A7-4948-9288-FE9670CF0EC6@colorremedies.com>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com> <20140303183911.GL13899@carfax.org.uk> <loom.20140304T164456-762@post.gmane.org> <1B8ADD42-4E49-4A9A-9AF9-F403BF69D92F@colorremedies.com> <loom.20140304T194101-763@post.gmane.org>
To: Btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 4, 2014, at 11:54 AM, Michael Russo <mike@papersolve.com> wrote:

> Chris Murphy <lists <at> colorremedies.com> writes:
>> Based on my reading of the man page, I think it's expected. 
>> You either need -s -l or -t.
> 
> Ok, although the man page uses [ ] instead of < > and something
> does happen if I don't add them. But if I use "-t 1" wouldn't that
> get everything?

Yeah you're right, you do get a default behavior but I think it's really permissive. I've thrown 30000 extent files at it, and it's still 30000 extents afterward.


> 
>> 
>>> Now I've gotten 
>>> it down to only 2 5GB segments that won't move.
>> 
>> Another way would be to just copy it (not reflink) and delete the original.
>> 
> 
> How can I find out what file is on the block group that 
> it's having a problem with?

I think that's btrfs-debug-tree -b ? But don't hold me to that. I haven't done enough debugging to find files from block numbers. Another that might be relevant is btrfs inspect-internal logical-resolve.

Chris Murphy

