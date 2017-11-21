Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46289 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751925AbdKUNto (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 08:49:44 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5FBC9AAC7
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Nov 2017 13:49:43 +0000 (UTC)
Date: Tue, 21 Nov 2017 14:47:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
Subject: Re: [PATCH] btrfs: extent-tree: Use round up to replace align macro
Message-ID: <20171121134748.GK3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171121055445.13972-1-wqu@suse.com>
 <78abe4d1-b83c-980a-4594-e1f25b52b81a@suse.com>
 <c864ff00-ec2a-603b-cc2c-b942d2373f7c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <c864ff00-ec2a-603b-cc2c-b942d2373f7c@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 21, 2017 at 04:06:54PM +0800, Qu Wenruo wrote:
> On 2017年11月21日 15:33, Nikolay Borisov wrote:
> > On 21.11.2017 07:54, Qu Wenruo wrote:
> >> @@ -2054,7 +2054,7 @@ static int btrfs_issue_discard(struct block_device *bdev, u64 start, u64 len,
> >>  {
> >>  	int j, ret = 0;
> >>  	u64 bytes_left, end;
> >> -	u64 aligned_start = ALIGN(start, 1 << 9);
> >> +	u64 aligned_start = round_up(start, 1 << 9);
> > 
> > nit: 1 << 9 == SZ_512 or essentially sector size however looking at the
> > defines there is SECTOR_SIZE defined in ide.h which we do not include.
> > Or just use 512 no need to obscure it behind a shift.
> 
> I also noticed that while I don't have any good idea which macro should
> be used.
> 
> That SECTOR_SIZE defined in ide.h doesn't sound good to me.

Heh, no we won't include ide.h just to get the macro definition.

> And all other filesystems are using their own definition, without some
> definition in fs/bio level.

That would be useful, as the sectorsize == 512 is part of the bio ABI.

I'd like to convert all the >> 9 shifts to *512 or /512, but this relies
on the compiler to convert namely the division to shifts where we use
u64.
