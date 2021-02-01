Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A4BC433E0
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Feb 2021 17:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48A7E64E92
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Feb 2021 17:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhBARpV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:45:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:45698 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231287AbhBARpK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Feb 2021 12:45:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3D1F9AC3A;
        Mon,  1 Feb 2021 17:44:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7D3F8DA6FC; Mon,  1 Feb 2021 18:42:38 +0100 (CET)
Date:   Mon, 1 Feb 2021 18:42:38 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     David Sterba <dsterba@suse.com>,
        Naohiro Aota <Naohiro.Aota@wdc.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Julia Lawall <julia.lawall@inria.fr>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH for-next 0/2] Fix compilation and checker errors in zoned
 series
Message-ID: <20210201174238.GU1993@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Naohiro Aota <Naohiro.Aota@wdc.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Julia Lawall <julia.lawall@inria.fr>, linux-btrfs@vger.kernel.org
References: <cover.1612005682.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1612005682.git.johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Jan 30, 2021 at 08:26:42PM +0900, Johannes Thumshirn wrote:
> Hi David,
> 
> The Kbuild Robot and Julia reported two errors in the zoned series which have
> slipped thorugh.
> 
> Here are the fixes.
> 
> Johannes Thumshirn (2):
>   btrfs: fix compilation error for !CONFIG_BLK_DEV_ZONED
>   btrfs: fix double free in btrfs_get_dev_zone_info

Folded, thanks.
