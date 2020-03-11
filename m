Return-Path: <SRS0=EJVa=44=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4014C10DCE
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DA1120663
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgCKA7x (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 20:59:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:54574 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727397AbgCKA7x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Mar 2020 20:59:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 23BF6B1A6;
        Wed, 11 Mar 2020 00:59:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2C176DA7A7; Wed, 11 Mar 2020 01:59:27 +0100 (CET)
Date:   Wed, 11 Mar 2020 01:59:27 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix log context list corruption after rename
 whiteout error
Message-ID: <20200311005927.GE12659@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20200310121353.11764-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310121353.11764-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 10, 2020 at 12:13:53PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> During a rename whiteout, if btrfs_whiteout_for_rename() returns an error
> we can end up returning from btrfs_rename() with the log context object
> still in the root's log context list - this happens if 'sync_log' was
> set to true before we called btrfs_whiteout_for_rename() and it is
> dangerous because we end up with a corrupt linked list (root->log_ctxs)
> as the log context object was allocated on the stack.
> 
> After btrfs_rename() returns, any task that is running btrfs_sync_log()
> concurrently can end up crashing because that linked list is traversed by
> btrfs_sync_log() (through btrfs_remove_all_log_ctxs()). That results in
> the same issue that commit e6c617102c7e4 ("Btrfs: fix log context list
> corruption after rename exchange operation") fixed.
> 
> Fixes: d4682ba03ef618 ("Btrfs: sync log after logging new name")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
