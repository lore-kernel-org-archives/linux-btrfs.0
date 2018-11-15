Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18097C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 16:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D207621582
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 16:39:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D207621582
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388489AbeKPCrw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 21:47:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:35988 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387839AbeKPCrw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 21:47:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3EE6FAF09;
        Thu, 15 Nov 2018 16:39:17 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 55E69DAC83; Thu, 15 Nov 2018 17:38:59 +0100 (CET)
Date:   Thu, 15 Nov 2018 17:38:59 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org, robbieko@synology.com,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] Btrfs: send, fix infinite loop due to directory rename
 dependencies
Message-ID: <20181115163858.GW24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org, robbieko@synology.com,
        Filipe Manana <fdmanana@suse.com>
References: <20181114183237.19884-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181114183237.19884-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 14, 2018 at 06:32:37PM +0000, fdmanana@kernel.org wrote:
> From: Robbie Ko <robbieko@synology.com>
> 
> When doing an incremental send, due to the need of delaying directory move
> (rename) operations we can end up in infinite loop at
> apply_children_dir_moves().
> 
> An example scenario that triggers this problem is described below, where
> directory names correspond to the numbers of their respective inodes.
> 
> Parent snapshot:
> 
>  .
>  |--- 261/
>        |--- 271/
>              |--- 266/
>                    |--- 259/
>                    |--- 260/
>                    |     |--- 267
>                    |
>                    |--- 264/
>                    |     |--- 258/
>                    |           |--- 257/
>                    |
>                    |--- 265/
>                    |--- 268/
>                    |--- 269/
>                    |     |--- 262/
>                    |
>                    |--- 270/
>                    |--- 272/
>                    |     |--- 263/
>                    |     |--- 275/
>                    |
>                    |--- 274/
>                          |--- 273/
> 
> Send snapshot:
> 
>  .
>  |-- 275/
>       |-- 274/
>            |-- 273/
>                 |-- 262/
>                      |-- 269/
>                           |-- 258/
>                                |-- 271/
>                                     |-- 268/
>                                          |-- 267/
>                                               |-- 270/
>                                                    |-- 259/
>                                                    |    |-- 265/
>                                                    |
>                                                    |-- 272/
>                                                         |-- 257/
>                                                              |-- 260/
>                                                              |-- 264/
>                                                                   |-- 263/
>                                                                        |-- 261/
>                                                                             |-- 266/
> 
> When processing inode 257 we delay its move (rename) operation because its
> new parent in the send snapshot, inode 272, was not yet processed. Then
> when processing inode 272, we delay the move operation for that inode
> because inode 274 is its ancestor in the send snapshot. Finally we delay
> the move operation for inode 274 when processing it because inode 275 is
> its new parent in the send snapshot and was not yet moved.
> 
> When finishing processing inode 275, we start to do the move operations
> that were previously delayed (at apply_children_dir_moves()), resulting in
> the following iterations:
> 
> 1) We issue the move operation for inode 274;
> 
> 2) Because inode 262 depended on the move operation of inode 274 (it was
>    delayed because 274 is its ancestor in the send snapshot), we issue the
>    move operation for inode 262;
> 
> 3) We issue the move operation for inode 272, because it was delayed by
>    inode 274 too (ancestor of 272 in the send snapshot);
> 
> 4) We issue the move operation for inode 269 (it was delayed by 262);
> 
> 5) We issue the move operation for inode 257 (it was delayed by 272);
> 
> 6) We issue the move operation for inode 260 (it was delayed by 272);
> 
> 7) We issue the move operation for inode 258 (it was delayed by 269);
> 
> 8) We issue the move operation for inode 264 (it was delayed by 257);
> 
> 9) We issue the move operation for inode 271 (it was delayed by 258);
> 
> 10) We issue the move operation for inode 263 (it was delayed by 264);
> 
> 11) We issue the move operation for inode 268 (it was delayed by 271);
> 
> 12) We verify if we can issue the move operation for inode 270 (it was
>     delayed by 271). We detect a path loop in the current state, because
>     inode 267 needs to be moved first before we can issue the move
>     operation for inode 270. So we delay again the move operation for
>     inode 270, this time we will attempt to do it after inode 267 is
>     moved;
> 
> 13) We issue the move operation for inode 261 (it was delayed by 263);
> 
> 14) We verify if we can issue the move operation for inode 266 (it was
>     delayed by 263). We detect a path loop in the current state, because
>     inode 270 needs to be moved first before we can issue the move
>     operation for inode 266. So we delay again the move operation for
>     inode 266, this time we will attempt to do it after inode 270 is
>     moved (its move operation was delayed in step 12);
> 
> 15) We issue the move operation for inode 267 (it was delayed by 268);
> 
> 16) We verify if we can issue the move operation for inode 266 (it was
>     delayed by 270). We detect a path loop in the current state, because
>     inode 270 needs to be moved first before we can issue the move
>     operation for inode 266. So we delay again the move operation for
>     inode 266, this time we will attempt to do it after inode 270 is
>     moved (its move operation was delayed in step 12). So here we added
>     again the same delayed move operation that we added in step 14;
> 
> 17) We attempt again to see if we can issue the move operation for inode
>     266, and as in step 16, we realize we can not due to a path loop in
>     the current state due to a dependency on inode 270. Again we delay
>     inode's 266 rename to happen after inode's 270 move operation, adding
>     the same dependency to the empty stack that we did in steps 14 and 16.
>     The next iteration will pick the same move dependency on the stack
>     (the only entry) and realize again there is still a path loop and then
>     again the same dependency to the stack, over and over, resulting in
>     an infinite loop.
> 
> So fix this by preventing adding the same move dependency entries to the
> stack by removing each pending move record from the red black tree of
> pending moves. This way the next call to get_pending_dir_moves() will
> not return anything for the current parent inode.
> 
> A test case for fstests, with this reproducer, follows soon.
> 
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> [Wrote changelog with example and more clear explanation]

Thanks for that. Patch added to misc-next.

> Signed-off-by: Filipe Manana <fdmanana@suse.com>
