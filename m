Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48890 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab3BUGx7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 01:53:59 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1U8Q2s-0003xG-Kn
	for linux-btrfs@vger.kernel.org; Thu, 21 Feb 2013 07:54:18 +0100
Received: from rain.gmane.org ([80.91.229.7])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 07:54:18 +0100
Received: from eternaleye by rain.gmane.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 07:54:18 +0100
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: Hybrid Storage proposal
Date: Wed, 20 Feb 2013 22:53:44 -0800
Message-ID: <kg4g9l$4p8$1@ger.gmane.org>
References: <20130220164605.GA13504@uflip.org> <CA+WRLO8ESSq6NrHOvUTQ3Sm+4RyBmSoU+PZ1wnqxwQBgG04=Tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gareth Pye wrote:

> On Thu, Feb 21, 2013 at 3:46 AM, Matias Bjorling <mabj@itu.dk> wrote:
>> Recent development in Linux SSD caches, uses a block IO approach to solve
>> caching. The approach assumes that data is stable on disk and evicts data
>> based on LRU, temparature, etc. This is great for read only IO patterns
>> and in-place writes. However, btrfs uses a copy on write approach, that
>> reduces the benefits of block IO caching. The block caches are unable to
>> track updates (require extensive hints forth and back between the cache
>> layer). Additionally, data and metadata is the same to the block layer.
> 
> 
> Another great reason for this to be implemented in btrfs is that
> knowledge of redundancy can be applied. Chunks that are mirrored
> should be unlikely to need both copies on SSD devices unless they are
> very highly used (probably true for some of the meta data but not for
> data).

On the other hand, there's the option of doing something that bcache has had 
on its roadmap for a while (but I'm not sure was ever implemented) by 
striping clean data and mirroring dirty data across the SSDs. The intent for 
bcache was to maximize both redundancy (for dirty data, which can't be 
regenerated) and space (for clean data, where if you lose some you can just 
shrug and say "oh well") in the case of one SSD failing.

> Conversely there is little benefit to putting one stripe of a
> raid0/5/6 into the SSD device without the rest of that data reaching
> the same level.
> 
> Not that additional reasons to do this work in btrfs were needed it
> does need to be thought about how this implementation interacts with
> those features.
> 

Agreed.

