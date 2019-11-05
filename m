Return-Path: <SRS0=ssiY=Y5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B9E6C5DF60
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Nov 2019 17:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5789B20656
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Nov 2019 17:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389359AbfKERI2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Nov 2019 12:08:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:48664 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387776AbfKERI2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Nov 2019 12:08:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F236AB2D1;
        Tue,  5 Nov 2019 17:08:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E330CDA796; Tue,  5 Nov 2019 18:08:33 +0100 (CET)
Date:   Tue, 5 Nov 2019 18:08:33 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: remove unneeded check for btrfs_free_space_info
 in insert_into_bitmap()
Message-ID: <20191105170832.GN3001@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20191105135127.17357-1-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105135127.17357-1-jthumshirn@suse.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 05, 2019 at 02:51:27PM +0100, Johannes Thumshirn wrote:
> The only caller for insert_into_bitmap() is __btrfs_add_free_space() and
> it takes care that the btrfs_free_space_info pointer passed to
> insert_into_bitmap() is allocated.
> 
> Inside insert_into_bitmap() we're not freeing or NULLing this pointer
> anywhere, so checking if it is pre-allocated inside 'new_bitmap' label is
> pointless, so remove this check.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

Reviewed-by: David Sterba <dsterba@suse.com>
