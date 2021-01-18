Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA77C433DB
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Jan 2021 23:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8452222EBF
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Jan 2021 23:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403895AbhARXEV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 18:04:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:44312 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403847AbhARXEU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jan 2021 18:04:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 78754AA6F;
        Mon, 18 Jan 2021 23:03:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 29398DA7CF; Tue, 19 Jan 2021 00:01:43 +0100 (CET)
Date:   Tue, 19 Jan 2021 00:01:43 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v4 03/18] btrfs: introduce the skeleton of btrfs_subpage
 structure
Message-ID: <20210118230143.GM6430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
References: <20210116071533.105780-1-wqu@suse.com>
 <20210116071533.105780-4-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116071533.105780-4-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Jan 16, 2021 at 03:15:18PM +0800, Qu Wenruo wrote:
> For btrfs subpage support, we need a structure to record extra info for
> the status of each sectors of a page.
> 
> This patch will introduce the skeleton structure for future btrfs
> subpage support.
> All subpage related code would go to subpage.[ch] to avoid populating
> the existing code base.

Ok, and after reading more of the patchset it makes even more sense,
handling all the special cases is suitable for a separate file.
