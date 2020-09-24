Return-Path: <SRS0=iRg2=DB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20AC2C4727D
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Sep 2020 14:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4E4D212CC
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Sep 2020 14:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgIXOMj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 10:12:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:59408 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727982AbgIXOMi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Sep 2020 10:12:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 289E1AC4C;
        Thu, 24 Sep 2020 14:12:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BCF61DA6E3; Thu, 24 Sep 2020 16:11:20 +0200 (CEST)
Date:   Thu, 24 Sep 2020 16:11:20 +0200
From:   David Sterba <dsterba@suse.cz>
To:     linux-btrfs@vger.kernel.org
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix potential null pointer deref
Message-ID: <20200924141120.GX6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-kernel@vger.kernel.org
References: <20200921191243.27833-1-a.dewar@sussex.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921191243.27833-1-a.dewar@sussex.ac.uk>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Sep 21, 2020 at 08:12:44PM +0100, Alex Dewar wrote:
> In btrfs_destroy_inode(), the variable root may be NULL, but the check
> for this takes place after its value has already been dereferenced to
> access its fs_info member. Move the dereference operation to later in
> the function.
> 
> Fixes: a6dbd429d8dd ("Btrfs: fix panic when trying to destroy a newly allocated")
> Addresses-Coverity: CID 1497103: Null pointer dereferences (REVERSE_INULL)
> Signed-off-by: Alex Dewar <a.dewar@sussex.ac.uk>

For some reason my replies did not get to linux-btrfs@, so for the
record the changes has been folded to the patch "btrfs: clean BTRFS_I
usage in btrfs_destroy_inode".
