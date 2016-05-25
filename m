Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fallback8.mail.ru ([94.100.181.110]:42297 "EHLO
	fallback8.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbcEYNrR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 09:47:17 -0400
Received: from smtp53.i.mail.ru (smtp53.i.mail.ru [94.100.177.113])
	by fallback8.mail.ru (mPOP.Fallback_MX) with ESMTP id 280569E0FD49
	for <linux-btrfs@vger.kernel.org>; Wed, 25 May 2016 16:06:41 +0300 (MSK)
Received: from 77-173-215-182.ip.telfort.nl ([77.173.215.182]:56028 helo=centurion)
	by smtp53.i.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
	id 1b5YWE-0001QS-A5
	for linux-btrfs@vger.kernel.org; Wed, 25 May 2016 16:06:38 +0300
Received: from www.centurion.link (localhost [IPv6:::1])
	by centurion (Postfix) with ESMTP id A2B711157CE
	for <linux-btrfs@vger.kernel.org>; Wed, 25 May 2016 15:06:36 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 25 May 2016 15:06:36 +0200
From: Dmitry Katsubo <dma_k@mail.ru>
To: linux-btrfs@vger.kernel.org
Subject: Re: Copy on write of unmodified data
In-Reply-To: <20160525092958.GH16712@carfax.org.uk>
References: <ae68a6ae-8184-88b8-05e5-8bb369d906b5@zytor.com>
 <20160525092958.GH16712@carfax.org.uk>
Message-ID: <e3232b252e42ca215888356ae8e78904@www.centurion.link>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-25 11:29, Hugo Mills wrote:
> On Wed, May 25, 2016 at 01:58:15AM -0700, H. Peter Anvin wrote:
>> Hi,
>> 
>> I'm looking at using a btrfs with snapshots to implement a 
>> generational
>> backup capacity.  However, doing it the naïve way would have the side
>> effect that for a file that has been partially modified, after
>> snapshotting the file would be written with *mostly* the same data.  
>> How
>> does btrfs' COW algorithm deal with that?  If necessary I might want 
>> to
>> write some smarter user space utilities for this.
> 
> Sounds like it might be a job for one of the dedup tools
> (deupremove, bedup), or, if you're writing your own, the safe
> deduplication ioctl which underlies those tools.
> 
> Hugo.

Perhaps it really makes sense to delegate de-duplication to 3-rd party
software like BackupPC [1]. I am not sure if btrfs can manage it more
effectively, as in order to find duplicates it would need to scan / 
analyse
all blocks, so at least it would take longer.

[1] https://sourceforge.net/projects/backuppc/

-- 
With best regards,
Dmitry
