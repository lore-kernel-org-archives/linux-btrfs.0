Return-Path: <SRS0=zwl1=CC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA91C433E5
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Aug 2020 16:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A525E20578
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Aug 2020 16:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbgHXQyy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 12:54:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:35418 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728576AbgHXQyh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Aug 2020 12:54:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 36D91AD6B;
        Mon, 24 Aug 2020 16:55:06 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 535B9DA730; Mon, 24 Aug 2020 18:53:28 +0200 (CEST)
Date:   Mon, 24 Aug 2020 18:53:28 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Document some invariants of seed code
Message-ID: <20200824165328.GO2026@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200812140436.11749-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812140436.11749-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Aug 12, 2020 at 05:04:36PM +0300, Nikolay Borisov wrote:
> Without good understanding of how seed devices works it's hard to grok
> some of what the code in open_seed_devices or btrfs_prepare_sprout does.
> 
> Add comments hopefully reducing some of the cognitive load.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

I'll add this patch to the seed list api patchset.
