Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3835AC433DB
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Jan 2021 16:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C26422583
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Jan 2021 16:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbhAYQOd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 11:14:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:58262 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729077AbhAYQOV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Jan 2021 11:14:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6E9B7AD18;
        Mon, 25 Jan 2021 15:54:40 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 10EE7DA7D2; Mon, 25 Jan 2021 16:52:54 +0100 (CET)
Date:   Mon, 25 Jan 2021 16:52:53 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: Remove unused variable
Message-ID: <20210125155253.GK1993@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210124160321.744187-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210124160321.744187-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Jan 24, 2021 at 06:03:21PM +0200, Nikolay Borisov wrote:
> This fixes fs/btrfs/zoned.c:491:6: warning: variable ‘zone_size’ set but not used [-Wunused-but-set-variable]
>   491 |  u64 zone_size;
> 
> Which got introduced in 12659251ca5d ("btrfs: implement log-structured superblock for ZONED mode")
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

With updated subject and changelog added to misc-next, thanks.
