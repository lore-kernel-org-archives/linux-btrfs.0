Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE042C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 15:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 802C32184D
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 15:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbfC2PSd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Mar 2019 11:18:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:52682 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728869AbfC2PSc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Mar 2019 11:18:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 58A2DAEFF
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2019 15:18:31 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 21F88DA882; Fri, 29 Mar 2019 16:19:43 +0100 (CET)
Date:   Fri, 29 Mar 2019 16:19:43 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: inode: Check if we get a valid inode before
 checking its mode.
Message-ID: <20190329151942.GU29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190329071259.6447-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190329071259.6447-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 29, 2019 at 03:12:59PM +0800, Qu Wenruo wrote:
> We should check the inode validation before checking the imode.
> 
> As btrfs_iget() could return ERR_PTR(), unlike previous path, we need to
> verify the inode before checking the imode.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> To David:
> 
> Please fold this into 9944a5b5d26e ("btrfs: inode: Verify inode mode to avoid NULL pointer dereference") 
> of misc-next branch.

Folded and branch pushed, thanks.
