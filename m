Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03316C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 16:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D377F20815
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 16:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732462AbfACQ7e (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 11:59:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:47380 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731413AbfACQ7d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 11:59:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B3F85AF57;
        Thu,  3 Jan 2019 16:59:31 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D984DDA781; Thu,  3 Jan 2019 17:59:02 +0100 (CET)
Date:   Thu, 3 Jan 2019 17:59:02 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: setup a nofs context for memory allocation at
 btrfs_create_tree()
Message-ID: <20190103165902.GJ23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181213211645.14713-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181213211645.14713-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 13, 2018 at 09:16:45PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We are holding a transaction handle when creating a tree, therefore we can
> not allocate the root using GFP_KERNEL, as we could deadlock if reclaim is
> triggered by the allocation, therefore setup a nofs context.
> 
> Fixes: 74e4d82757f74 ("btrfs: let callers of btrfs_alloc_root pass gfp flags")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.

Regarding this class of bugs, I'm not sure if I mentioned it or not, the
long-term fix is to set NOFS in transaction start and restore at
end/commit. I have a wip patch but not near completion so until then
the individual callsites need to be handled.
