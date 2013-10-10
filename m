Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:59621 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755772Ab3JJTLT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Oct 2013 15:11:19 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Will "btrfs scrub" clear corrupt filesystem trees?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <l36ri7$uvg$1@ger.gmane.org>
Date: Thu, 10 Oct 2013 13:11:08 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <814324C4-9C00-4F6F-B63B-88F20177F946@colorremedies.com>
References: <l36ri7$uvg$1@ger.gmane.org>
To: Martin <m_btrfs@ml1.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 10, 2013, at 12:27 PM, Martin <m_btrfs@ml1.co.uk> wrote:

> I have 1.5TB of data on a single disk formatted with defaults. There
> appears to be only two directory trees of a few MBytes that have
> suffered corruption (due to in the past too high a sata speed causing
> corruption).
> 
> The filesystem mounts fine. But how to clear out the corrupt trees?

If you've already gone through Hugo's list, I think it's a matter of waiting for further development for fixing such problems.

> 
> 
> Would a:
> 
> btrfs scrub start
> 
> clear out the corrupt trees?

I don't think so.


> 
> Must I wait for the btrfsck to complete if it is recreating an extents
> tree?…


Yes because scrub is online/mounted, and btrfsck is offline/unmounted.

Chris Murphy

