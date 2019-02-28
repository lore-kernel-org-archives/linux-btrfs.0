Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05699C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 18:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7A542070B
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 18:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731474AbfB1SYs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 13:24:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:35182 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726027AbfB1SYs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 13:24:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5AFD0AC3F
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2019 18:24:47 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 56E48DA944; Thu, 28 Feb 2019 19:26:04 +0100 (CET)
Date:   Thu, 28 Feb 2019 19:26:04 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: qgroup: Don't scan leaf if we're modifying reloc
 tree
Message-ID: <20190228182603.GQ31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181213054856.22340-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181213054856.22340-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 13, 2018 at 01:48:56PM +0800, Qu Wenruo wrote:
> Since reloc tree doesn't contribute to qgroup numbers, just skip them.
> 
> This should catch the final leakage of unnecessary data refs for qgroup.
> The 4G data 16 snapshots test should explain it pretty well:
> 
>              | delayed subtree | refactor delayed ref | this patch (*)
> ---------------------------------------------------------------------
> relocated    |           22653 |                22673 |         22744
> qgroup dirty |          122792 |                48360 |            70
> time         |          24.494 |               11.606 |         3.944
> 
> *: Needs to be applied upon delayed subtree scan and delayed ref
> refactor patchsets.
> 
> Finally, we're at the stage where qgroup + metadata balance cost no
> obvious overhead.

I don't see this patch in any of the development branches but given the
above I think it should be there. It's possible that I have missed an
update, sorry, please let me know the current status.

The dependencies have been merged for 5.1 so I could still queue it, and
the performance improvement is quite desired.
