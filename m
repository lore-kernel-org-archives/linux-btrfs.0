Return-Path: <SRS0=S96U=UT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BFFFC43613
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Jun 2019 15:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C3A42070B
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Jun 2019 15:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfFTPaG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 20 Jun 2019 11:30:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:40516 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726661AbfFTPaG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jun 2019 11:30:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9FDF5AEF7;
        Thu, 20 Jun 2019 15:30:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D401EDA846; Thu, 20 Jun 2019 17:30:51 +0200 (CEST)
Date:   Thu, 20 Jun 2019 17:30:51 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add missing inode version, ctime and mtime
 updates when punching hole
Message-ID: <20190620153051.GM8917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190619120550.9825-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619120550.9825-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jun 19, 2019 at 01:05:50PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If the range for which we are punching a hole covers only part of a page,
> we end up updating the inode item but we skip the update of the inode's
> iversion, mtime and ctime. Fix that by ensuring we update those properties
> of the inode.
> 
> A patch for fstests test case generic/059 that tests this as been sent
> along with this fix.
> 
> Fixes: 2aaa66558172b0 ("Btrfs: add hole punching")
> Fixes: e8c1c76e804b18 ("Btrfs: add missing inode update when punching hole")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
