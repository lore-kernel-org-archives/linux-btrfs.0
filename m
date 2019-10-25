Return-Path: <SRS0=FriU=YS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 263C5CA9EA0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Oct 2019 16:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0347F21872
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Oct 2019 16:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505713AbfJYQlX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:41:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:44458 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391060AbfJYQlW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Oct 2019 12:41:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 69043B319;
        Fri, 25 Oct 2019 16:41:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DF63FDA785; Fri, 25 Oct 2019 18:41:32 +0200 (CEST)
Date:   Fri, 25 Oct 2019 18:41:32 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs: remove cached space_info in btrfs_statfs()
Message-ID: <20191025164132.GQ3001@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20191024154455.19370-1-jthumshirn@suse.de>
 <20191024154455.19370-2-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024154455.19370-2-jthumshirn@suse.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 24, 2019 at 05:44:54PM +0200, Johannes Thumshirn wrote:
> In btrfs_statfs() we cache fs_info::space_info in a local variable only
> to use it once in a list_for_each_rcu() statement.
> 
> Not only is the local variable unnecessary it even makes the code harder
> to follow as it's not clear which list it is iterating.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

Added to misc-next as it's not related to the statfs change itself.
