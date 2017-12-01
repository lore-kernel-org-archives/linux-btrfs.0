Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:45712 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdLASYJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Dec 2017 13:24:09 -0500
Subject: Re: btrfs-transacti hammering the system
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        Matt McKinnon <matt@techsquare.com>, linux-btrfs@vger.kernel.org
References: <bb2cfbcb-31dd-715c-114f-59d574a2012b@techsquare.com>
 <9703c200-28af-f26d-b3b2-6982fb289ac8@mendix.com>
 <1d11e03c-7d02-3f66-8b97-4c1b857566fa@techsquare.com>
 <b52265f9-2703-7f25-b1b9-6e84bc7db62e@mendix.com>
 <c9e5ef0a-e60b-b892-272c-1594d47f0657@techsquare.com>
 <5ecddad2-bb6a-2991-c8d0-be97a4541b0d@mendix.com>
 <17ead8e4-106e-f568-e996-ab472814a749@techsquare.com>
 <62d9e40d-3a73-303e-51d5-1b146230fa0d@applied-asynchrony.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <b7294c64-280e-7415-6ae9-7673a37f7370@mendix.com>
Date: Fri, 1 Dec 2017 19:24:07 +0100
MIME-Version: 1.0
In-Reply-To: <62d9e40d-3a73-303e-51d5-1b146230fa0d@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/01/2017 06:57 PM, Holger Hoffstätte wrote:
> On 12/01/17 18:34, Matt McKinnon wrote:
>> Thanks, I'll give space_cache=v2 a shot.
> 
> Yes, very much recommended.
> 
>> My mount options are: rw,relatime,space_cache,autodefrag,subvolid=5,subvol=/
> 
> Turn autodefrag off and use noatime instead of relatime.
> 
> Your filesystem also seems very full,

We don't know. btrfs fi df only displays allocated space. And that being
full is good, it means not too much free space fragments everywhere.

> that's bad with every filesystem but
> *especially* with btrfs because the allocator has to work really hard to find
> free space for COWing. Really consider deleting stuff or adding more space.

-- 
Hans van Kranenburg
