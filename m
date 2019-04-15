Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D208C10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 14:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4810A2075B
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 14:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfDOOd5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 10:33:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:56932 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725789AbfDOOd5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 10:33:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 74915AC94;
        Mon, 15 Apr 2019 14:33:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0D203DA9C7; Mon, 15 Apr 2019 16:35:02 +0200 (CEST)
Date:   Mon, 15 Apr 2019 16:35:00 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: allocate ulists in btrfs_check_shared() using
 GFP_KERNEL
Message-ID: <20190415143500.GI3476@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190415082910.2073-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190415082910.2073-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 15, 2019 at 09:29:10AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> As of commit bb739cf08e8f32 ("btrfs: btrfs_check_shared should manage its
> own transaction") btrfs_check_shared() manages its own transaction, it
> no longer receives a transaction handle as parameter. Since it is used
> only in the fiemap path, the ulists it needs to use are allocated before
> it grabs a transaction handle and we are not holding any locks that could
> cause a deadlock in case reclaim happens during a memory allocation, we
> can use the GFP_KERNEL flag to allocate the ulists instead of GFP_NOFS.
> So do that switch.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
