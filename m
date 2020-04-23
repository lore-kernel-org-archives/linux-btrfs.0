Return-Path: <SRS0=Tw2U=6H=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73E92C55189
	for <linux-btrfs@archiver.kernel.org>; Thu, 23 Apr 2020 00:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F0762076C
	for <linux-btrfs@archiver.kernel.org>; Thu, 23 Apr 2020 00:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgDWAnA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 20:43:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:53192 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbgDWAnA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Apr 2020 20:43:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D67DCAB89;
        Thu, 23 Apr 2020 00:42:58 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id AE485DA704; Thu, 23 Apr 2020 02:42:16 +0200 (CEST)
Date:   Thu, 23 Apr 2020 02:42:16 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove useless check for copy_items() return value
Message-ID: <20200423004216.GX18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20200421102531.14736-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421102531.14736-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 21, 2020 at 11:25:31AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> At btrfs_log_prealloc_extents() we are checking if copy_items() returns a
> value greater than 0. That used to happen in the past to signal the caller
> that the path given to it was released and reused for other searches, but
> as of commit 0e56315ca147b3 ("Btrfs: fix missing hole after hole punching
> and fsync when using NO_HOLES"), the copy_items() function does not have
> that behaviour anymore and always returns 0 or a negative value. So just
> remove that check at btrfs_log_prealloc_extents(), which the previously
> mentioned commit forgot to remove.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
