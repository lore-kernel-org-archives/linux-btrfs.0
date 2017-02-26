Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-04.prod.phx3.secureserver.net ([184.168.200.145]:36614
        "EHLO p3nlsmtpcp01-04.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751415AbdBZNbu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Feb 2017 08:31:50 -0500
Date: Sun, 26 Feb 2017 18:51:28 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org
Subject: Re: List of corruption cases for scrub
Message-ID: <20170226132128.GA2690@giis.co.in>
References: <20170224023225.GA4006@giis.co.in>
 <9a5fb7b9-76b3-9848-9c29-8d4aac3fdb7b@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9a5fb7b9-76b3-9848-9c29-8d4aac3fdb7b@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 24, 2017 at 06:39:20PM +0100, Goffredo Baroncelli wrote:
> Hi,
> On 2017-02-24 03:32, Lakshmipathi.G wrote:
> > Hi.
> > 
> > I tried to a create list of corruption test scenarios for scrubbing process with RAID5.
> > Here's the list: https://btrfs.wiki.kernel.org/index.php/Scrub_corruption_cases
> > 
> > If similar list already exists in btrfs wiki, let me know, I'll move this data
> > to there. Feel free to add/update/delete entries or suggest new corrupt ideas!
> 
> Thanks for doing that. About the test "Device-corruption", I suppose that you want to test a scenario where one disk fails. If so you do not have to always corrupt "D0" block, but the first block of the file which is stored in the failing disk (which could be different from the D0).
> 
Yes, that's right. Updated (Device-corruption) the list now.

> Another scenario which should be tested, is the reshaping of the raid: add a drive (or remove a drive) then re-balance the system (with or without some corruption). IIRC this use the same scrub code.
> 
Added this as 'Rebalance-corruption' on the wiki. thanks!

Cheers.
Lakshmipathi.G
