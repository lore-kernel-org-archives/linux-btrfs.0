Return-Path: <SRS0=RqtL=C7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F36BC2D0E2
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Sep 2020 13:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31B962396D
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Sep 2020 13:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgIVNSz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 09:18:55 -0400
Received: from verein.lst.de ([213.95.11.211]:44557 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgIVNSy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Sep 2020 09:18:54 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8FD4E67373; Tue, 22 Sep 2020 15:18:51 +0200 (CEST)
Date:   Tue, 22 Sep 2020 15:18:51 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        david@fromorbit.com, hch@lst.de, johannes.thumshirn@wdc.com,
        dsterba@suse.com, darrick.wong@oracle.com, josef@toxicpanda.com,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <jth@kernel.org>
Subject: Re: [PATCH 02/15] btrfs: remove BTRFS_INODE_READDIO_NEED_LOCK
Message-ID: <20200922131851.GA20432@lst.de>
References: <20200921144353.31319-1-rgoldwyn@suse.de> <20200921144353.31319-3-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921144353.31319-3-rgoldwyn@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Sep 21, 2020 at 09:43:40AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Since we now perform direct reads using i_rwsem, we can remove this
> inode flag used to co-ordinate unlocked reads.
> 
> The truncate call takes i_rwsem. This means it is correctly synchronized
> with concurrent direct reads.
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> Reviewed-by: Johannes Thumshirn <jth@kernel.org>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
