Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8764C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 17:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEEEF2070D
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 17:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732376AbfACRCO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 12:02:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:47626 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730870AbfACRCO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 12:02:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 89CD7AF6C;
        Thu,  3 Jan 2019 17:02:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A5F17DA781; Thu,  3 Jan 2019 18:01:43 +0100 (CET)
Date:   Thu, 3 Jan 2019 18:01:43 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: setup a nofs context for memory allocation at
 __btrfs_set_acl
Message-ID: <20190103170143.GK23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181213211656.14765-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181213211656.14765-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 13, 2018 at 09:16:56PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We are holding a transaction handle when setting an acl, therefore we can
> not allocate the xattr value buffer using GFP_KERNEL, as we could deadlock
> if reclaim is triggered by the allocation, therefore setup a nofs context.
> 
> Fixes: 39a27ec1004e8 ("btrfs: use GFP_KERNEL for xattr and acl allocations")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
