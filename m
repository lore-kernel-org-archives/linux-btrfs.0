Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52400C282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 16:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24051217D9
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 16:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730753AbfBLQEh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 11:04:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:59252 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729355AbfBLQEg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 11:04:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CEDC7ADED;
        Tue, 12 Feb 2019 16:04:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 991FEDA84E; Tue, 12 Feb 2019 17:03:53 +0100 (CET)
Date:   Tue, 12 Feb 2019 17:03:52 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: don't end the transaction for delayed refs in
 throttle
Message-ID: <20190212160351.GD2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20190124143143.8838-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124143143.8838-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 24, 2019 at 09:31:43AM -0500, Josef Bacik wrote:
> Previously callers to btrfs_end_transaction_throttle() would commit the
> transaction if there wasn't enough delayed refs space.  This happens in
> relocation, and if the fs is relatively empty we'll run out of delayed
> refs space basically immediately, so we'll just be stuck in this loop of
> committing the transaction over and over again.
> 
> This code existed because we didn't have a good feedback mechanism for
> running delayed refs, but with the delayed refs rsv we do now.  Delete
> this throttling code and let the btrfs_start_transaction() in relocation
> deal with putting pressure on the delayed refs infrastructure.  With
> this patch we no longer take 5 minutes to balance a metadata only fs.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

For the record, this has been merged to 5.0-rc5
