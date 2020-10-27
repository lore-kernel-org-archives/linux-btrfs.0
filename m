Return-Path: <SRS0=hLwB=EC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38A25C4363A
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Oct 2020 00:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 113AA20759
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Oct 2020 00:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442410AbgJ0A0R (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 20:26:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:41386 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393718AbgJ0A0O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Oct 2020 20:26:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2F751AC53;
        Tue, 27 Oct 2020 00:26:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9326DDA6E2; Tue, 27 Oct 2020 01:24:39 +0100 (CET)
Date:   Tue, 27 Oct 2020 01:24:39 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 09/68] btrfs: extent_io: unexport
 extent_invalidatepage()
Message-ID: <20201027002439.GX6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20201021062554.68132-1-wqu@suse.com>
 <20201021062554.68132-10-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021062554.68132-10-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 21, 2020 at 02:24:55PM +0800, Qu Wenruo wrote:
> Function extent_invalidatepage() has a single caller,
> btree_invalidatepage().

It is so but the function is also part of the extent io tree API so it's
in the right file with other functions.
