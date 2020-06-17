Return-Path: <SRS0=y2QO=76=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47643C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Jun 2020 15:52:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A95720888
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Jun 2020 15:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgFQPwg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Jun 2020 11:52:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:50318 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgFQPwg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jun 2020 11:52:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 62C5DAE91;
        Wed, 17 Jun 2020 15:52:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A5D48DA728; Wed, 17 Jun 2020 17:52:25 +0200 (CEST)
Date:   Wed, 17 Jun 2020 17:52:25 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 0/5] btrfs: qgroup: detect and fix leaked data
 reserved space
Message-ID: <20200617155225.GM27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200616235955.21385-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616235955.21385-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jun 17, 2020 at 07:59:50AM +0800, Qu Wenruo wrote:
> v4:
> - Pure changelog update to co-operate with the dio iomap revert
>   Only the 1st and the 4th patches get updated.

Updated, thanks.
