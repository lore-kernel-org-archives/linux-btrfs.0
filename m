Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:45281 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753913AbaCCSsM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Mar 2014 13:48:12 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:61913 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WKXuL-002qQf-RD
	for linux-btrfs@vger.kernel.org; Mon, 03 Mar 2014 11:48:09 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: ENOSPC errors during raid1 rebalance
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <loom.20140303T191959-983@post.gmane.org>
Date: Mon, 3 Mar 2014 11:48:09 -0700
Message-Id: <D35E6741-2350-4910-B785-5584F730EDA9@colorremedies.com>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com> <pan$b5b02$85505b$f53ee629$e32b9776@cox.net> <loom.20140303T191959-983@post.gmane.org>
To: Btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 3, 2014, at 11:24 AM, Michael Russo <mike@papersolve.com> wrote:

> Duncan <1i5t5.duncan <at> cox.net> writes:
>> 
>> That allows rollback if desired, but does tie up some some space with the 
>> automatically created btrfs "snapshot" that contains the ext3/4 metadata 
>> and untouched data.  
> 
> Nope, I definitely deleted the snapshots, running btrfs sub list 
> gives me nothing back:
> 
> root@ossy:/usr/src/btrfs-progs# /usr/src/btrfs-progs/btrfs sub list /mymedia
> root@ossy:/usr/src/btrfs-progs# 
> 
> Thanks for the detailed reply though. While doing this operation I 
> wanted to not have any snapshots so that I needed the minimum 
> amount of space to do the rebalance.  
> 
> But this all does seem strange right? Why the heck would it refuse
> to move these 70GB and think there are 0 blocks of free space? 

It might be worth adding enospc_debug as a mount option and then retrying the balance -dconvert=raid1,soft which should only try to balance unconverted data chunks. The metadata all looks converted to raid1. The debug output probably only means something to a developer but maybe it'll be enlightening.

Slightly off-topic to your question is whether btrfs-convert is expected to be a recommended method of migrating from ext3/4 or if it's more proof of concept that ought to work? The current version uses the ext block size for btrfs leaf size, rather than the 16KB default leaf size by mkfs.btfs. David Sterba was working on this at one point. Also I don't think btrfs-convert yet enables extref, although it can be enabled with btrfs-tune after conversion. In any case, the conversion isn't quite the same thing as you get with a new file system.



Chris Murphy

