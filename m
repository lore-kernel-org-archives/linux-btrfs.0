Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail0200.smtp25.com ([174.37.170.200]:36488 "EHLO
	mail0200.smtp25.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbbLZH3P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Dec 2015 02:29:15 -0500
From: covici@ccs.covici.com
To: Chris Murphy <lists@colorremedies.com>
cc: Henk Slager <eye1tm@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs problems on new file system
In-reply-to: <CAJCQCtTQ-73RbohA9wdrttj_uSnF5f8x1Opa0a6O2ZF-5NVqhQ@mail.gmail.com>
References: <16107.1451037790@ccs.covici.com> <CAPmG0jbOu6BmKfbaoJ6pzprWzbch3tf7=zbBS8AcDz4MQVEJZA@mail.gmail.com> <18552.1451078098@ccs.covici.com> <CAJCQCtTQ-73RbohA9wdrttj_uSnF5f8x1Opa0a6O2ZF-5NVqhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Sat, 26 Dec 2015 02:29:11 -0500
Message-ID: <5117.1451114951@ccs.covici.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists@colorremedies.com> wrote:

> If you can post the entire dmesg somewhere that'd be useful. MUAs tend
> to wrap that text and make it unreadable on list. I think the problems
> with your volume happened before the messages, but it's hard to say.
> Also, a generation of nearly 5000 is not that new?

The file system was only a few days old.  It was on an lvm volume group
which consisted of two ssd drives, so I am not sure what you are saying
about lvm cache -- how could I do anything different?


> 
> On another thread someone said you probably need to specify the device
> to mount when using Btrfs and lvmcache? And the device to specify is
> the combined HDD+SSD logical device, for lvmcache that's the "cache
> LV", which is the OriginLV + CachePoolLV. If Btrfs decides to mount
> the origin, it can result in corruption.

See above.


-- 
Your life is like a penny.  You're going to lose it.  The question is:
How do
you spend it?

         John Covici
         covici@ccs.covici.com
