Return-Path: <SRS0=CVGX=6A=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24DDCC2BB85
	for <linux-btrfs@archiver.kernel.org>; Thu, 16 Apr 2020 12:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B37F208E4
	for <linux-btrfs@archiver.kernel.org>; Thu, 16 Apr 2020 12:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894377AbgDPM5A (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 16 Apr 2020 08:57:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:59760 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2894522AbgDPM45 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Apr 2020 08:56:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 034BFABD1;
        Thu, 16 Apr 2020 12:56:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5136EDA727; Thu, 16 Apr 2020 14:56:16 +0200 (CEST)
Date:   Thu, 16 Apr 2020 14:56:16 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Fix bad kernel header non-flat include case
Message-ID: <20200416125616.GL5920@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200408070412.40911-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408070412.40911-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 08, 2020 at 03:04:12PM +0800, Qu Wenruo wrote:
> If we're compiling using system header, we should include
> <btrfs/crc32c.h> other than "btrfs/crc32.h".
> 
> Fixes: 2efe160bc757 ("btrfs-progs: move name hashing functions to ctree.h and delete hash.h")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to devel, thanks.
