Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E1A8C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 15:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 349BE20883
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 15:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbfAHPfO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 10:35:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:33976 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727928AbfAHPfO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 10:35:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F1B06ADA3;
        Tue,  8 Jan 2019 15:35:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5416DDA7E8; Tue,  8 Jan 2019 16:34:40 +0100 (CET)
Date:   Tue, 8 Jan 2019 16:34:39 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/3][V2] Delayed iput fixes
Message-ID: <20190108153438.GG23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20181203160652.25078-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203160652.25078-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 03, 2018 at 11:06:49AM -0500, Josef Bacik wrote:
> v1->v2:
> - only wakeup if the cleaner isn't currently doing work.
> - re-arranged some stuff for running delayed iputs during flushint.
> - removed the open code wakeup in the waitqueue patch.
> 
> -- Original message --
> 
> Here are some delayed iput fixes.  Delayed iputs can hold reservations for a
> while and there's no real good way to make sure they were gone for good, which
> means we could early enospc when in reality if we had just waited for the iput
> we would have had plenty of space.  So fix this up by making us wait for delayed
> iputs when deciding if we need to commit for enospc flushing, and then cleanup
> and rework how we run delayed iputs to make it more straightforward to wait on
> them and make sure we're all done using them.  Thanks,

I'd like to push this patchset to 5.0, can you please post the missing
rationale for 2/3? I'm not expecting any code changes so it's just the
text, I can update the patch, no need to resend the whole series.
Thanks.
