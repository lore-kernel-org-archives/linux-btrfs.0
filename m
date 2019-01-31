Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B07C169C4
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 15:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E397C20869
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 15:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731630AbfAaPYB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Jan 2019 10:24:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:45004 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728066AbfAaPYA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Jan 2019 10:24:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 684FCAD6B
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2019 15:23:59 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3E5D3DA7D6; Thu, 31 Jan 2019 16:23:25 +0100 (CET)
Date:   Thu, 31 Jan 2019 16:23:25 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org, jeffm@suse.com
Subject: Re: [PATCH 03/15] btrfs: Remove  EXTENT_FIRST_DELALLOC bit
Message-ID: <20190131152325.GI2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, jeffm@suse.com
References: <20190130145102.4708-1-nborisov@suse.com>
 <20190130145102.4708-4-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190130145102.4708-4-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 30, 2019 at 04:50:50PM +0200, Nikolay Borisov wrote:
> With the refactoring introduced in 8b62f87bad9c ("Btrfs: reworki
> outstanding_extents") this flag became unused. Remove it and renumber
> the following flags accordingly. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
