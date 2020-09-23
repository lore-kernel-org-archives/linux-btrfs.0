Return-Path: <SRS0=lTFz=DA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05EADC4727D
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Sep 2020 17:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B00702068E
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Sep 2020 17:26:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgIWR0t (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 13:26:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:41538 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726332AbgIWR0s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Sep 2020 13:26:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B9D90AAC7;
        Wed, 23 Sep 2020 17:27:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 39CACDA6E3; Wed, 23 Sep 2020 19:25:31 +0200 (CEST)
Date:   Wed, 23 Sep 2020 19:25:31 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     Eryu Guan <guan@eryu.me>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] btrfs/125: remove constantly failing test from auto group
Message-ID: <20200923172531.GS6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Eryu Guan <guan@eryu.me>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
References: <20200923164426.19534-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923164426.19534-1-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Sep 24, 2020 at 01:44:26AM +0900, Johannes Thumshirn wrote:
> The test-case btrfs/125 is often failing due to a design deficiency in
> btrfs' RAID5 code.
> 
> The details for this can be seen here:
> https://lore.kernel.org/linux-btrfs/CAL3q7H4oa70DUhOFE7kot62KjxcbvvZKxu62VfLpAcmgsinBFw@mail.gmail.com/
> 
> Remove the test from the auto group until we have a replacement for the
> current RAID5/6 code.
> 
> Cc: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: David Sterba <dsterba@suse.com>
