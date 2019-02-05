Return-Path: <SRS0=OwrN=QM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7743AC282CB
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 18:26:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54B72217F9
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 18:26:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbfBES0Z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Feb 2019 13:26:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:38358 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727397AbfBES0Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Feb 2019 13:26:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A3F5AB136;
        Tue,  5 Feb 2019 18:26:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 129D0DA7E3; Tue,  5 Feb 2019 19:25:45 +0100 (CET)
Date:   Tue, 5 Feb 2019 19:25:44 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: linux-next: Tree for Feb 5 (btrfs/zstd)
Message-ID: <20190205182543.GX2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
References: <20190205171228.41a9f771@canb.auug.org.au>
 <26ce21e5-0e3c-d847-c895-6cb166507441@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <26ce21e5-0e3c-d847-c895-6cb166507441@infradead.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 05, 2019 at 09:40:40AM -0800, Randy Dunlap wrote:
> On 2/4/19 10:12 PM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20190204:
> > 
> 
> on i386:
> 
> ../fs/btrfs/zstd.c: In function ‘zstd_reclaim_timer_fn’:
> ../fs/btrfs/zstd.c:27:35: warning: integer overflow in expression [-Woverflow]
>  #define ZSTD_BTRFS_RECLAIM_NS (45 * NSEC_PER_SEC)
>                                    ^
> ../fs/btrfs/zstd.c:96:33: note: in expansion of macro ‘ZSTD_BTRFS_RECLAIM_NS’
>    if (now < victim->last_used + ZSTD_BTRFS_RECLAIM_NS)

Thanks for the report. There's a v2 of the patchset that uses the
timer_after helper and this warning should be gone. The updated version
will appear in for-next soonish.
