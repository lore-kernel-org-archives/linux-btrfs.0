Return-Path: <SRS0=jqbo=UQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2862CC31E5B
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Jun 2019 14:27:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06C4E2084D
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Jun 2019 14:27:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbfFQO1B (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Jun 2019 10:27:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:50904 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725995AbfFQO1B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Jun 2019 10:27:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F0E3BAF41;
        Mon, 17 Jun 2019 14:26:59 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9FF02DA8D1; Mon, 17 Jun 2019 16:27:48 +0200 (CEST)
Date:   Mon, 17 Jun 2019 16:27:48 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH for 5.2] Btrfs: fix failure to persist compression
 property xattr deletion on fsync
Message-ID: <20190617142748.GF19057@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190612141411.25339-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612141411.25339-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jun 12, 2019 at 03:14:11PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> After the recent series of cleanups in the properties and xattrs modules
> that landed in the 5.2 merge window, we ended up with a regression where
> after deleting the compression xattr property through the setflags ioctl,
> we don't set the BTRFS_INODE_COPY_EVERYTHING flag in the inode anymore.
> As a consequence, if the inode was fsync'ed when it had the compression
> property set, after deleting the compression property through the setflags
> ioctl and fsync'ing again the inode, the log will still contain the
> compression xattr, because the inode did not had that bit set, which
> made the fsync not delete all xattrs from the log and copy all xattrs
> from the subvolume tree to the log tree.
> 
> This regression happens due to the fact that that series of cleanups
> made btrfs_set_prop() call the old function do_setxattr() (which is now
> named btrfs_setxattr()), and not the old version of btrfs_setxattr(),
> which is now called btrfs_setxattr_trans().
> 
> Fix this by setting the BTRFS_INODE_COPY_EVERYTHING bit in the current
> btrfs_setxattr() function and remove it from everywhere else, including
> its setup at btrfs_ioctl_setflags(). This is cleaner, avoids similar
> regressions in the future, and centralizes the setup of the bit. After
> all, the need to setup this bit should only be in the xattrs module,
> since it is an implementation of xattrs.
> 
> Fixes: 04e6863b19c722 ("btrfs: split btrfs_setxattr calls regarding transaction")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Queued for 5.2, thanks.
