Return-Path: <SRS0=/JOF=4C=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2FBC2BA83
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Feb 2020 16:39:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A58524650
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Feb 2020 16:39:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389958AbgBNQjC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 14 Feb 2020 11:39:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:45750 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404422AbgBNQi7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Feb 2020 11:38:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4621BB011;
        Fri, 14 Feb 2020 16:38:58 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A5C95DA703; Fri, 14 Feb 2020 17:38:43 +0100 (CET)
Date:   Fri, 14 Feb 2020 17:38:42 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: relocation: Remove is_cowonly_root()
Message-ID: <20200214163842.GB2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200212074331.32800-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200212074331.32800-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 12, 2020 at 03:43:31PM +0800, Qu Wenruo wrote:
> This function is only used in read_fs_root(), which is just a wrapper of
> btrfs_get_fs_root().
> 
> For all the mentioned essential roots except log root tree,
> btrfs_get_fs_root() has its own quick path to grab them from fs_info
> directly, thus no need for key.offset modification.
> 
> For subvolume trees, btrfs_get_fs_root() with key.offset == -1 is
> completely fine.
> 
> For log trees and log root tree, it's impossible to hit them, as for
> relocation all backrefs are fetched from commit root, which never
> records log tree blocks.
> 
> Log tree blocks either get freed in regular transaction commit, or
> replayed at mount time. At runtime we should never hit an backref for
> log tree in extent tree.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to misc-next, thanks.
