Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:32123 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933010Ab2KAPt1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 11:49:27 -0400
Message-ID: <509299F9.6010307@oracle.com>
Date: Thu, 01 Nov 2012 23:49:13 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Btrfs: make snapshot-aware defrag as a mount option
References: <1351333721-3220-1-git-send-email-bo.li.liu@oracle.com> <1351333721-3220-2-git-send-email-bo.li.liu@oracle.com> <20121101144323.GB8307@shiny>
In-Reply-To: <20121101144323.GB8307@shiny>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/01/2012 10:43 PM, Chris Mason wrote:
> On Sat, Oct 27, 2012 at 04:28:41AM -0600, Liu Bo wrote:
>> This feature works on our crucial write endio path, so if we've got
>> lots of fragments to process, it will be kind of a disaster to the
>> performance, so I make such a change.
>>
>> One can benifit from it while mounting with '-o snap_aware_defrag'.
> 
> I think we should always prefer to maintain snapshot cloning as much as
> possible, and have a specific option to defrag that makes it break the
> clone in favor of removing fragmentation.
> 

Oh yeah, so I was considering the existing btrfs partitions who have already
broke the cloning relationship.

> So, please keep the snapshot aware defrag the default ;)
> 

All right, that'd be nice, just drop this patch.

thanks,
liubo

> Thanks for taking these patches up again!
> 
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

