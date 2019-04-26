Return-Path: <SRS0=BNt3=S4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA8E7C43219
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 14:28:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94450206C1
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 14:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfDZO21 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Apr 2019 10:28:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:56474 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbfDZO21 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Apr 2019 10:28:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8054BAF1C;
        Fri, 26 Apr 2019 14:28:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BC8B3DA847; Fri, 26 Apr 2019 16:29:29 +0200 (CEST)
Date:   Fri, 26 Apr 2019 16:29:28 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 2/2] btrfs: use the existing credit for our first prop
Message-ID: <20190426142927.GT20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20190207165426.15866-1-josef@toxicpanda.com>
 <20190207165426.15866-3-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207165426.15866-3-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 07, 2019 at 11:54:26AM -0500, Josef Bacik wrote:
> We're now reserving an extra items worth of space for property
> inheritance.  We only have one property at the moment so this covers us,
> but if we add more in the future this will allow us to not get bitten by
> the extra space reservation.  If we do add more properties in the future
> we should re-visit how we calculate the space reservation needs by the
> callers.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

There were xattr and property code cleanups, I've applied this patch on
top of that as the logic hasn't changed, only the context.
