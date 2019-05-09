Return-Path: <SRS0=cuF+=TJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C17C04AB1
	for <linux-btrfs@archiver.kernel.org>; Thu,  9 May 2019 09:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34E5621479
	for <linux-btrfs@archiver.kernel.org>; Thu,  9 May 2019 09:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbfEIJZD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 9 May 2019 05:25:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:52378 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725821AbfEIJZD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 May 2019 05:25:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 153A5BB97;
        Thu,  9 May 2019 09:25:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 87436DA8DC; Thu,  9 May 2019 11:26:00 +0200 (CEST)
Date:   Thu, 9 May 2019 11:26:00 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not abort transaction at btrfs_update_root()
 after failure to COW path
Message-ID: <20190509092600.GP20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190429120814.8638-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429120814.8638-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 29, 2019 at 01:08:14PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Currently when we fail to COW a path at btrfs_update_root() we end up
> always aborting the transaction. However all the current callers of
> btrfs_update_root() are able to deal with errors returned from it, many do
> end up aborting the transaction themselves (directly or not, such as the
> transaction commit path), other BUG_ON() or just gracefully cancel whatever
> they were doing.
> 
> When syncing the fsync log, we call btrfs_update_root() through
> tree-log.c:update_log_root(), and if it returns an -ENOSPC error, the log
> sync code does not abort the transaction, instead it gracefully handles
> the error and returns -EAGAIN to the fsync handler, so that it falls back
> to a transaction commit. Any other error different from -ENOSPC, makes the
> log sync code abort the transaction.
> 
> So remove the transaction abort from btrfs_update_log() when we fail to
> COW a path to update the root item, so that if an -ENOSPC failure happens
> we avoid aborting the current transaction and have a chance of the fsync
> succeeding after falling back to a transaction commit.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203413
> Fixes: 79787eaab46121 ("btrfs: replace many BUG_ONs with proper error handling")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
