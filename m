Return-Path: <SRS0=YGKe=NF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D05C46475
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 12:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 877212082D
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 12:08:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 877212082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbeJYUkn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Oct 2018 16:40:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:48614 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727208AbeJYUkn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Oct 2018 16:40:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D3D3EAF11
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2018 12:08:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 22A0ADABAA; Thu, 25 Oct 2018 14:08:04 +0200 (CEST)
Date:   Thu, 25 Oct 2018 14:08:03 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: image: Warn about log tree generation
 mismatch when restore
Message-ID: <20181025120803.GC16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181004060213.13022-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181004060213.13022-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 04, 2018 at 02:02:13PM +0800, Qu Wenruo wrote:
> At restore time, btrfs-image will try to fixup dev extents, this will
> trigger a transaction.
> 
> It's normally OK to start a new transaction, but for image with log
> tree, a new transaction will bump up generation, and log tree generation
> will not match with super block generation + 1.
> 
> There is no good way to solve it yet. Just output a warning for now.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
