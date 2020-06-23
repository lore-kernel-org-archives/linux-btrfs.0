Return-Path: <SRS0=qk6s=AE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91AF8C433E0
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Jun 2020 15:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7957C2076E
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Jun 2020 15:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732962AbgFWPpy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 11:45:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:51900 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732952AbgFWPpy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jun 2020 11:45:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C5F06AE53;
        Tue, 23 Jun 2020 15:45:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1F66FDA79B; Tue, 23 Jun 2020 17:45:41 +0200 (CEST)
Date:   Tue, 23 Jun 2020 17:45:41 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jth@kernel.org>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 0/4] btrfs-progs: get rid of btrfs_raid_profile_table
Message-ID: <20200623154540.GL27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jth@kernel.org>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20200623141019.23991-1-jth@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623141019.23991-1-jth@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jun 23, 2020 at 04:10:15PM +0200, Johannes Thumshirn wrote:
> From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> 
> As promised here's the removal of btrfs_raid_profile_table which helped as a
> intermediate step to refactor the raid specific settings in block group
> creation in progs.
> 
> As Qu remindet me of the outstanding debts this morning, I decided to go ahead
> and pay my debt today.
> 
> It will not be the last refactoring round in this area though, as the
> btrfs-progs side and the kernel side still diverge a lot.

Thanks, all look good. This level of granularity makes review easy and
as said before, the intermediate patches are ok esp when the code
diverged.
