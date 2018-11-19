Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27745C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 14:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6C0D20831
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 14:22:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6C0D20831
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbeKTAqE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 19:46:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:59088 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727564AbeKTAqE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 19:46:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3566DAFC8
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2018 14:22:17 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EB25ADAF89; Mon, 19 Nov 2018 15:21:59 +0100 (CET)
Date:   Mon, 19 Nov 2018 15:21:59 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] btrfs: remove unused function
 btrfs_sysfs_feature_update()
Message-ID: <20181119142159.GD24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20181119093817.9291-1-jthumshirn@suse.de>
 <20181119093817.9291-4-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119093817.9291-4-jthumshirn@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 19, 2018 at 10:38:15AM +0100, Johannes Thumshirn wrote:
> btrfs_sysfs_feature_update() was introduced with commit 444e75169872 (btrfs:
> sysfs: introduce helper for syncing bits with sysfs files) to provide a helper
> which was used in 14e46e04958d (btrfs: synchronize incompat feature bits with
> sysfs files).
> 
> But commit e410e34fad91 (Revert "btrfs: synchronize incompat feature bits with
> sysfs files") reverted 14e46e04958d so btrfs_sysfs_feature_update() ended up
> as an unused function.

    This ends up doing sysfs operations from deep in balance (where we
    should be GFP_NOFS) and under heavy balance load, we're making races
    against sysfs internals.

    Revert it for now while we figure things out.

With the memalloc_nofs_save/memalloc_nofs_restore we can get address the
GFP_NOFS problem, but I don't remember what was the other part about sysfs
internals.

The sysfs bits for features should be match the internal state so this
is a (low priority) bug, I'd prefer fixing it instead of removing the
code.
