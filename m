Return-Path: <SRS0=vkwB=B5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6607C433E1
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Aug 2020 16:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AAD220882
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Aug 2020 16:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgHSQXw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Aug 2020 12:23:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:39710 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbgHSQXo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Aug 2020 12:23:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B344CAE0C;
        Wed, 19 Aug 2020 16:24:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CEC4DDA703; Wed, 19 Aug 2020 18:22:36 +0200 (CEST)
Date:   Wed, 19 Aug 2020 18:22:36 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: check the right variable in
 btrfs_del_dir_entries_in_log
Message-ID: <20200819162236.GS2026@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20200810213116.795789-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810213116.795789-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Aug 10, 2020 at 05:31:16PM -0400, Josef Bacik wrote:
> With my new locking code dbench is so much faster that I tripped over a
> transaction abort from ENOSPC.  This turned out to be because
> btrfs_del_dir_entries_in_log was checking for ret == -ENOSPC, but this
> function sets err on error, and returns err.  So instead of properly
> marking the inode as needing a full commit, we were returning -ENOSPC
> and aborting in __btrfs_unlink_inode.  Fix this by checking the proper
> variable so that we return the correct thing in the case of ENOSPC.
> 
> Fixes: 4a500fd178c8 ("Btrfs: Metadata ENOSPC handling for tree log")
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Added to misc-next, with updated changelog and comment explaining the
ENOENT.
