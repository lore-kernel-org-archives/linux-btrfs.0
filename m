Return-Path: <SRS0=oUBw=X3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D59C35280
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Oct 2019 13:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9066E21A4A
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Oct 2019 13:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbfJBNKT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Oct 2019 09:10:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:57838 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726297AbfJBNKT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Oct 2019 09:10:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 31EF4B03C;
        Wed,  2 Oct 2019 13:10:18 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 780AFDA88C; Wed,  2 Oct 2019 15:10:35 +0200 (CEST)
Date:   Wed, 2 Oct 2019 15:10:35 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: transaction: Cleanup unused
 TRANS_STATE_BLOCKED
Message-ID: <20191002131035.GN2751@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190822072500.22730-1-wqu@suse.com>
 <20190822072500.22730-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822072500.22730-2-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Aug 22, 2019 at 03:25:00PM +0800, Qu Wenruo wrote:
> The state is introduced in commit 4a9d8bdee368 ("Btrfs: make the state
> of the transaction more readable"), then in commit 302167c50b32
> ("btrfs: don't end the transaction for delayed refs in throttle") the
> state is completely removed.
> 
> So we can just clean up the state since it's only compared but never
> set.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
