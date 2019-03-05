Return-Path: <SRS0=ObWa=RI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F5E3C43381
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 13:53:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C55820684
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 13:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbfCENxy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Mar 2019 08:53:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:53340 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727424AbfCENxx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Mar 2019 08:53:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CD146AC44
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Mar 2019 13:53:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C20AFDA8A5; Tue,  5 Mar 2019 14:55:08 +0100 (CET)
Date:   Tue, 5 Mar 2019 14:55:08 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v1.1] btrfs-progs: Do metadata prealloc as long as we're
 not modifying extent tree
Message-ID: <20190305135508.GA31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180914074944.19526-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180914074944.19526-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Sep 14, 2018 at 03:49:44PM +0800, Qu Wenruo wrote:
> In github issues, one user reports unexpected ENOSPC error if enabling
> datasum.
> After some investigation, it looks like that during ext2_saved/image
> creation, we could create large file extent whose size can be 128M (max
> data extent size).
> 
> In that case, its csum will be at least 128K. Under certain case we need
> to allocate extra metadata chunks to fulfill such space requirement.
> 
> However we only do metadata prealloc if we're reserving extents for fs
> trees.
> (we use btrfs_root::ref_cows to determine whether we should do metadata
> prealloc, and that member is only set for fs trees).
> 
> There is no explaination on why we only do metadata prealloc for file
> trees, but at least from my investigation, it could be related to avoid
> nested extent tree modication.
> 
> At least extent reservation for csum tree shouldn't be a problem with
> metadata block group preallocation.
> 
> So change the metadata block group preallocation check from
> "root->ref_cow" to "root->root_key.objectid !=
> BTRFS_EXTENT_TREE_OBJECTID", and add some comment for it.

This looks a bit fragile to me but I don't have a better suggestion for
a fix. Added to devel, thanks.
