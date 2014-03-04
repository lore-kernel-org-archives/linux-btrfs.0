Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:51241 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752579AbaCDR3r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Mar 2014 12:29:47 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:53236 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WKtA3-000G0X-8E
	for linux-btrfs@vger.kernel.org; Tue, 04 Mar 2014 10:29:47 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: ENOSPC errors during raid1 rebalance
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <loom.20140304T164456-762@post.gmane.org>
Date: Tue, 4 Mar 2014 10:29:48 -0700
Message-Id: <1B8ADD42-4E49-4A9A-9AF9-F403BF69D92F@colorremedies.com>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com> <20140303183911.GL13899@carfax.org.uk> <loom.20140304T164456-762@post.gmane.org>
To: Btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 4, 2014, at 8:55 AM, Michael Russo <mike@papersolve.com> wrote:

> Hugo Mills <hugo <at> carfax.org.uk> writes:
> 
>>   This is just a guess, but you might have some large (>1GB) 
> extents
>> in there that span across multiple chunks. I'd suggest running a 
> btrfs
>> defrag on any particularly big files and see if that helps the 
> situation.
>> 
> 
> Doing this is definitely helping, but I have to run the defrag multiple 
> times with different values for "-t". If I don't include -t the defrag 
> runs really quickly but doesn't seem to do anything.

Based on my reading of the man page, I think it's expected. You either need -s -l or -t.

>  Now I've gotten 
> it down to only 2 5GB segments that won't move.

Another way would be to just copy it (not reflink) and delete the original.


Chris Murphy

