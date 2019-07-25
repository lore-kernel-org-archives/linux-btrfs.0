Return-Path: <SRS0=fwWV=VW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 470E7C7618B
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Jul 2019 15:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 278F4229F3
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Jul 2019 15:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388736AbfGYPc4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Jul 2019 11:32:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:41084 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388082AbfGYPcz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jul 2019 11:32:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B2602AF6B
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2019 15:32:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C27F5DA7DE; Thu, 25 Jul 2019 17:33:31 +0200 (CEST)
Date:   Thu, 25 Jul 2019 17:33:31 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: Fix deadlock caused by missing memory barrier
Message-ID: <20190725153331.GS2868@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190725082729.14109-1-nborisov@suse.com>
 <20190725082729.14109-3-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725082729.14109-3-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jul 25, 2019 at 11:27:29AM +0300, Nikolay Borisov wrote:
> Commit 06297d8cefca ("btrfs: switch extent_buffer blocking_writers from atomic to int")
> changed the type of blocking_writers but forgot to adjust relevant code
> in btrfs_tree_unlock by converting the smp_mb__after_atomic to smp_mb.
> This opened up the possibility of a deadlock due to re-ordering of
> setting blocking_writers and checking/waking up the  waiter. This
> particular lockup is explained in a comment above waitqueue_active()
> function.
> 
> Fix it by converting the memory barrier to a full smp_mb, accounting
> for the fact that blocking_writers is a simple integer.
> 
> Fixes: 06297d8cefca ("btrfs: switch extent_buffer blocking_writers from atomic to int")
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> Tested-by: Johannes Thumshirn <jthumshirn@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
