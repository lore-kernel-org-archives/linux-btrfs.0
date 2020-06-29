Return-Path: <SRS0=dUu7=AK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1610C433E1
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Jun 2020 21:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB623214F1
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Jun 2020 21:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729105AbgF2VXZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:23:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:44656 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729589AbgF2SvY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jun 2020 14:51:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E2271AC6E;
        Mon, 29 Jun 2020 15:40:29 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 44329DA703; Mon, 29 Jun 2020 17:40:15 +0200 (CEST)
Date:   Mon, 29 Jun 2020 17:40:15 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v7 0/3] btrfs: allow btrfs_truncate_block() to fallback
 to nocow for data space reservation
Message-ID: <20200629154015.GK27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200628113931.26576-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200628113931.26576-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Jun 28, 2020 at 07:39:28PM +0800, Qu Wenruo wrote:
> v7:
> - Fix a "BTRF_I()" typo
>   Reported-by: kernel test robot <lkp@intel.com>

Please don't resend the whole patchset only a few hours since the last
one. If it's just a trivial fix, you can reply to the patch where it
happens with the fix. Or compile before you hit send.
