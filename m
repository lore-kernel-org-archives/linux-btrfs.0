Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE45C64EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 16:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6097A213A2
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 16:10:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6097A213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbeJIX2d (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 19:28:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:52686 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726479AbeJIX2d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Oct 2018 19:28:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 84269ADE3;
        Tue,  9 Oct 2018 16:10:53 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A3D7CDAD2B; Tue,  9 Oct 2018 18:10:50 +0200 (CEST)
Date:   Tue, 9 Oct 2018 18:10:50 +0200
From:   David Sterba <dsterba@suse.cz>
To:     dsterba@suse.cz, fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix warning when replaying log after fsync of a
 tmpfile
Message-ID: <20181009161049.GK29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181008101255.17110-1-fdmanana@kernel.org>
 <20181009160156.GJ29418@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181009160156.GJ29418@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 09, 2018 at 06:01:56PM +0200, David Sterba wrote:
> > Reported-by: Martin Steigerwald <martin@lichtvoll.de>
> > Link: https://lore.kernel.org/linux-btrfs/3666619.NTnn27ZJZE@merkaba/
> > Fixes: 471d557afed1 ("Btrfs: fix loss of prealloc extents past i_size after fsync log replay")
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> 
> Thanks, the tmpfile logging logic makes sense to me. Patch added to
> misc-next and queued for 4.20 and I've added stable tag for 4.9+.

Err, no sorry, it's 4.18+ as there's the Fixes: reference.
