Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:30489 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757760Ab2JaAfE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 20:35:04 -0400
Message-ID: <5090721E.2090806@oracle.com>
Date: Wed, 31 Oct 2012 08:34:38 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: David Sterba <dave@jikos.cz>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs: make snapshot-aware defrag as a mount option
References: <1351333721-3220-1-git-send-email-bo.li.liu@oracle.com> <1351333721-3220-2-git-send-email-bo.li.liu@oracle.com> <20121030233146.GB3102@twin.jikos.cz>
In-Reply-To: <20121030233146.GB3102@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/31/2012 07:31 AM, David Sterba wrote:
> On Sat, Oct 27, 2012 at 06:28:41PM +0800, Liu Bo wrote:
>> This feature works on our crucial write endio path, so if we've got
>> lots of fragments to process, it will be kind of a disaster to the
>> performance, so I make such a change.
>>
>> One can benifit from it while mounting with '-o snap_aware_defrag'.
> 
> I vote for a more fine grained control over this feature, ie.  via
> 'btrfs fi defrag', off by default (current behaviour). The defrag ioctl
> is the only place that actually calls set_extent_defrag, so this will
> not affect normal operation and is fully in hands of the user who runs
> defrag.
> 

Besides 'btrfs fi defrag', mounting with autodefrag may also do the same thing.

But controlling by 'btrfs fi defrag' can actually be a good idea.

thanks,
liubo

> Do you have a usecase for setting it through the mount option?
> 
> thanks,
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

