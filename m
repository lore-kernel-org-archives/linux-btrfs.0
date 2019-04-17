Return-Path: <SRS0=+3PB=ST=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 144AAC282DA
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 13:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3B51204EC
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 13:39:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731959AbfDQNjP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Apr 2019 09:39:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:35182 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729356AbfDQNjO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Apr 2019 09:39:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C23ABB176;
        Wed, 17 Apr 2019 13:39:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 77F08DA871; Wed, 17 Apr 2019 15:40:21 +0200 (CEST)
Date:   Wed, 17 Apr 2019 15:40:21 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove no longer used function to run delayed
 refs asynchronously
Message-ID: <20190417134021.GG20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190417092847.17299-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417092847.17299-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 17, 2019 at 10:28:47AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> It used to be called from only two places (truncate path and releasing a
> transaction handle), but commits 28bad2125767c5 ("btrfs: fix truncate
> throttling") and db2462a6ad3dc4 ("btrfs: don't run delayed refs in the end
> transaction logic") removed their calls to this function, so it's not used
> anymore. Just remove it and all its helpers.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
