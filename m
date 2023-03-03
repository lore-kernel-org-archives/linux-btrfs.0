Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B498C64EC4
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 Mar 2023 14:15:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjCCOPt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 3 Mar 2023 09:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjCCOPr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Mar 2023 09:15:47 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECEF3CE3A
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Mar 2023 06:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=95X8pBm6LfRnKGcz2urVLGRf6ZCwtHhFQ3XV1GetDm4=; b=U5x13JBY8sqZMIyFkrZBiwr4fz
        QJzJfOD6RcHfN1OxZpFRGVp/iQV5Ox5SXybaAL15SFbjpAmbjxc8ejc9TTJYTT5/M8I4H/MT4j3Fo
        OxJRP9uVKNDecR/GE/nfgpWkvoTxcJqsp/YU3RAW6WsD1pJccQAjff5QjCVvxewvGsplIf9huIEkn
        QY/Pf9EZWZx2wav+dFmWCakOGzOFztdaBMZViApjAafnFel87WBLBVILlk5bgQJ+IDnVSWIGPzpS5
        TofDrheUSNEdkbY3Twl0YfenPaaBiYVZzK3N/i6Ak5NOMa816VkUv+forKAVXWtNzqq6QyMEqrn0g
        1SM/z4OQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pY6Bt-006aEN-DN; Fri, 03 Mar 2023 14:15:21 +0000
Date:   Fri, 3 Mar 2023 06:15:21 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v7 04/13] btrfs: add support for inserting raid stripe
 extents
Message-ID: <ZAIA+a6G8kd2I8Pp@infradead.org>
References: <cover.1677750131.git.johannes.thumshirn@wdc.com>
 <94293952cdc120b46edf82672af874b0877e1e83.1677750131.git.johannes.thumshirn@wdc.com>
 <3e2d5ede-fb00-3aa8-e55e-d088b8df9e60@gmx.com>
 <b5bfe1a9-51dc-2a94-5ebd-4673b896d5ea@wdc.com>
 <ZACrzUh82/9HPDV2@infradead.org>
 <cb26ea54-a0b8-2102-6899-521ca8028b9c@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb26ea54-a0b8-2102-6899-521ca8028b9c@gmx.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 03, 2023 at 08:13:23AM +0800, Qu Wenruo wrote:
> > I have a series in my queue the limits every btrfs_bio (and thus bioc)
> > to a single ordered_extent.  The bio spanning ordered_extents is a very
> > strange corner case that rarely happens but causes a lot of problems.
> 
> Really?
> 
> A not-so-large write (e.g. 4MiB) for RAID0 (64K stripe len) can easily lead
> to that situation.
> 
> If we really split ordered extents to that stripe len, it can cause a lot of
> small file extents thus bloat the size of subvolume trees.

I might have been a little more clear in my wording.

This is talking about the btrfs_bio submitted by the upper layers using
btrfs_submit_bio, not the ones split out by it at the extent boundaries.
