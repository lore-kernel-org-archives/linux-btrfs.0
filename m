Return-Path: <SRS0=fY4Z=NX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD68C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 18:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C41F22504
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 18:58:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C41F22504
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730314AbeKMExD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Nov 2018 23:53:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:52840 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727530AbeKMExD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Nov 2018 23:53:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A5874AEE1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2018 18:58:31 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7963CDAFAE; Mon, 12 Nov 2018 19:58:16 +0100 (CET)
Date:   Mon, 12 Nov 2018 19:58:16 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] Cleanups following optional extent_io_ops callbacks
 removal
Message-ID: <20181112185816.GO24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181108081808.16920-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181108081808.16920-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 08, 2018 at 10:18:05AM +0200, Nikolay Borisov wrote:
> Here are 3 minor patches that further clean up writepage_delalloc. The first
> one moves the extent locked check in the caller of writepage_delalloc since
> this seems more natural. This paves the way for the second patch which removes
> epd as an argument to writepage_delalloc. The final patch was suggested by 
> Josef and removes an extent_state argument which has never been used. 
> 
> Nikolay Borisov (3):
>   btrfs: Move epd::extent_locked check to writepage_delalloc's caller
>   btrfs: Remove extent_page_data argument from writepage_delalloc
>   btrfs: Remove unused extent_state argument from
>     btrfs_writepage_endio_finish_ordered

Added to misc-next, thanks.
