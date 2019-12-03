Return-Path: <SRS0=ifAh=ZZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 885E0C432C0
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Dec 2019 17:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 640D02084B
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Dec 2019 17:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbfLCRmw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 12:42:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:57222 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726224AbfLCRmw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Dec 2019 12:42:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C0D5CB21CA;
        Tue,  3 Dec 2019 17:42:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1CC4BDA7D9; Tue,  3 Dec 2019 18:42:44 +0100 (CET)
Date:   Tue, 3 Dec 2019 18:42:43 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] Cleanups from pinned rework try
Message-ID: <20191203174243.GS2734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20191202094015.19444-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202094015.19444-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 02, 2019 at 11:40:12AM +0200, Nikolay Borisov wrote:
> Here are 3 minor cleanups resulting from dwelling in pinned extents rework.
> Those cleanup WARN_ONs and make it clear when btrfs_pin_reserved_extent is
> called with active transaction. No functional changes in any of them.
> 
> Nikolay Borisov (3):
>   btrfs: Remove WARN_ON in walk_log_tree
>   btrfs: Remove redundant WARN_ON in walk_down_log_tree
>   btrfs: Ensure btrfs_pin_reserved_extent is always called with valid
>     transaction

Added to misc-next, thanks.
