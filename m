Return-Path: <SRS0=r+Ws=4Q=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD019C3F2CD
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Feb 2020 16:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87B802467B
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Feb 2020 16:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgB1QUi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 11:20:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:41432 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgB1QUi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Feb 2020 11:20:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 04F85B331;
        Fri, 28 Feb 2020 16:20:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A2E3EDA79B; Fri, 28 Feb 2020 17:20:16 +0100 (CET)
Date:   Fri, 28 Feb 2020 17:20:16 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix crash during unmount due to race with delayed
 inode workers
Message-ID: <20200228162016.GP2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20200228130436.26128-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228130436.26128-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 28, 2020 at 01:04:36PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> During unmount we can have a job from the delayed inode items work queue
> still running, that can lead to at least two bad things_
> 
> 1) A crash, because the worker can try to create a transaction just
>    after the fs roots were freed;
> 
> 2) A transaction leak, because the worker can create a transaction
>    before the fs roots are freed and just after we committed the last
>    transaction and after we stopped the transaction kthread.
...
> +		 * This is a very rare case.

Added to misc-next, thanks. I'll tag it for stable but will not put to
5.6-rc queue given that it's very rare, unless requested.
