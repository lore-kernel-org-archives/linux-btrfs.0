Return-Path: <SRS0=yXFy=OU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9290AC5CFFE
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Dec 2018 16:28:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64E8F2081B
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Dec 2018 16:28:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 64E8F2081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbeLKQ2Z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 11 Dec 2018 11:28:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:44382 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726628AbeLKQ2Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Dec 2018 11:28:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 12B27AFAE
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Dec 2018 16:28:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 059F1DA835; Tue, 11 Dec 2018 17:28:01 +0100 (CET)
Date:   Tue, 11 Dec 2018 17:28:01 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: extent-tree: cleanup one-shot usage of @blocksize
 in do_walk_down
Message-ID: <20181211162801.GM23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181210070103.10073-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181210070103.10073-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 10, 2018 at 03:01:03PM +0800, Qu Wenruo wrote:
> @blocksize variable in do_walk_down() is only used once, really no need
> to declare it.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to misc-next, thanks.
