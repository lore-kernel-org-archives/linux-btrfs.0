Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50456 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754128AbdCJP4g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Mar 2017 10:56:36 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CF2E1AAC7
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Mar 2017 15:56:34 +0000 (UTC)
Subject: Re: [PATCH] qgroup: Retry after commit on getting EDQUOT
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
References: <20170219133059.20939-1-rgoldwyn@suse.de>
 <20170309165458.GI14605@twin.jikos.cz>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <e7664add-fc67-21e2-c720-8df9daf436de@suse.de>
Date: Fri, 10 Mar 2017 09:56:32 -0600
MIME-Version: 1.0
In-Reply-To: <20170309165458.GI14605@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/09/2017 10:54 AM, David Sterba wrote:
> On Sun, Feb 19, 2017 at 07:30:59AM -0600, Goldwyn Rodrigues wrote:
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>
>> We are facing the same problem with EDQUOT which was experienced with
>> ENOSPC. Not sure if we require a full ticketing system such as ENOSPC, but
>> here is a fix. Let me know if it is too big a hammer.
> 
> On first look it does seem too heavy. Do you have numbers what's the
> slowdown? If it's bearable we can stick with it and implement the
> ticketed approach.
> 

No, I don't have numbers because it is the case of when it reaches low
on space only.

When it meets the condition to return EDQUOUT, tt starts the commit in
order to get the data to disk, or more importantly the discards, and get
the true value to check. OTOH, a ticketing system will also do the same,
but it will restart the process when it is assured that there is enough
to continue.

The current ticketing system is designed for ENOSPC or the whole
filesystem tree.


-- 
Goldwyn
