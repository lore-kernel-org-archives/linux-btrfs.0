Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-01.prod.phx3.secureserver.net ([184.168.200.138]:59146
        "EHLO p3nlsmtpcp01-01.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751620AbdB0LEh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Feb 2017 06:04:37 -0500
Date: Mon, 27 Feb 2017 16:31:38 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: List of corruption cases for scrub
Message-ID: <20170227110138.GA2667@giis.co.in>
References: <20170224023225.GA4006@giis.co.in>
 <e1ce9d74-57e8-8078-11fb-d2e4613428ea@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e1ce9d74-57e8-8078-11fb-d2e4613428ea@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 27, 2017 at 11:40:31AM +0800, Qu Wenruo wrote:
> 
> 
> At 02/24/2017 10:32 AM, Lakshmipathi.G wrote:
> >Hi.
> >
> >I tried to a create list of corruption test scenarios for scrubbing process with RAID5.
> >Here's the list: https://btrfs.wiki.kernel.org/index.php/Scrub_corruption_cases
> >
> >If similar list already exists in btrfs wiki, let me know, I'll move this data
> >to there. Feel free to add/update/delete entries or suggest new corrupt ideas!
> 
> What about adding testing result for latest kernel release?
> 
> Thanks,
> Qu

True, Ideally, the wiki should have list-corruption cases along with result for
each latest kernel version.

Planning to add more cases, gradually. For example, I think inode object
with RAID5 can be replicated across drives. If thats correct, can scrub 
fix those corruption too? cases like this may be more important than other
to-do items like raid5 with features like snapshot/quota etc

I think it should be possible to add test-results for few cases but list has
repeated-cases with different sizes,drives etc for these cases we need some
kind of automated scripts.

Hope to extend the cases first and then start updating results with manual or 
automated tests.

Cheers.
Lakshmipathi.G
