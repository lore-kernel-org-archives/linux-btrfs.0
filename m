Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC49C65BAF
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 18:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C05820811
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 18:52:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C05820811
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbeLLSwF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 13:52:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:46062 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727897AbeLLSwE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 13:52:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 99D45AC9C;
        Wed, 12 Dec 2018 18:52:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 734A2DA7E5; Wed, 12 Dec 2018 19:51:40 +0100 (CET)
Date:   Wed, 12 Dec 2018 19:51:39 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: use generic_remap_file_range_prep() for
 cloning and deduplication
Message-ID: <20181212185139.GA23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181207132453.5455-1-fdmanana@kernel.org>
 <20181207152538.19269-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181207152538.19269-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Dec 07, 2018 at 03:25:38PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Since cloning and deduplication are no longer Btrfs specific operations, we
> now have generic code to handle parameter validation, compare file ranges
> used for deduplication, clear capabilities when cloning, etc. This change
> makes Btrfs use it, eliminating a lot of code in Btrfs and also fixing a
> few bugs, such as:
> 
> 1) When cloning, the destination file's capabilities were not dropped
>    (the fstest generic/513 tests this);
> 
> 2) We were not checking if the destination file is immutable;
> 
> 3) Not checking if either the source or destination files are swap
>    files (swap file support is coming soon for Btrfs);
> 
> 4) System limits were not checked (resource limits and O_LARGEFILE).
> 
> Note that the generic helper generic_remap_file_range_prep() does start
> and waits for writeback by calling filemap_write_and_wait_range(), however
> that is not enough for Btrfs for two reasons:
> 
> 1) With compression, we need to start writeback twice in order to get the
>    pages marked for writeback and ordered extents created;
> 
> 2) filemap_write_and_wait_range() (and all its other variants) only waits
>    for the IO to complete, but we need to wait for the ordered extents to
>    finish, so that when we do the actual reflinking operations the file
>    extent items are in the fs tree. This is also important due to the fact
>    that the generic helper, for the deduplication case, compares the
>    contents of the pages in the requested range, which might require
>    reading extents from disk in the very unlikely case that pages get
>    invalidated after writeback finishes (so the file extent items must be
>    up to date in the fs tree).
> 
> Since these reasons are specific to Btrfs we have to do it in the Btrfs
> code before calling generic_remap_file_range_prep(). This also results in
> a more simple way of dealing with existing delalloc in the source/target
> ranges, specially for the deduplication case where we used to lock all the
> pages first and then if we found any dealloc for the range, or ordered
> extent, we would unlock the pages trigger writeback and wait for ordered
> extents to complete, then lock all the pages again and check if
> deduplication can be done. So now we get a simpler approach: lock the
> inodes, then trigger writeback and then wait for ordered extents to
> complete.
> 
> So make btrfs use generic_remap_file_range_prep() (XFS and OCFS2 use it)
> to eliminate duplicated code, fix a few bugs and benefit from future bug
> fixes done there - for example the recent clone and dedupe bugs involving
> reflinking a partial EOF block got a counterpart fix in the generic helpe,
> since it affected all filesystems supporting these operations, so we no
> longer need special checks in Btrfs for them.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
> 
> V2: Removed check that verifies if either of the inodes is a directory,
>     as it is done by generic_remap_file_range_prep(). Oddly in btrfs was being
>     done only for cloning but not for dedupe.

A big patch, but I see how the logic is simplified and redundant code
thrown out. I'm concerned about size here because of potential backports
to older kernels, where a minimal fix separated from actual code removal
would cause fewer conflicts.

Reviewed-by: David Sterba <dsterba@suse.com>
