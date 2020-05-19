Return-Path: <SRS0=EU31=7B=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE11C433DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 May 2020 20:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4F46207E8
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 May 2020 20:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgESULW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 May 2020 16:11:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:55600 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726348AbgESULV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 May 2020 16:11:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5B657AF83;
        Tue, 19 May 2020 20:11:23 +0000 (UTC)
Date:   Tue, 19 May 2020 15:11:16 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/9] btrfs: Switch to iomap_dio_rw() for dio
Message-ID: <20200519201116.6qyoaxc7g2krxzzx@fiona>
References: <20200327161348.to4upflzczkbbpfo@fiona>
 <20200507061430.GA8939@infradead.org>
 <20200507113741.GJ18421@twin.jikos.cz>
 <20200507121037.GA25363@infradead.org>
 <20200508031405.br4dcibcyuoluxum@fiona>
 <20200509135914.GA4962@infradead.org>
 <20200510040601.bub3du7g5kepeakw@fiona>
 <20200512145807.GA23409@infradead.org>
 <20200512171927.tk46sbriqvhasvsq@fiona>
 <20200515141305.GA27936@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515141305.GA27936@infradead.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

On  7:13 15/05, Christoph Hellwig wrote:
> 
> FYI, generic/475 always fail on me for btrfs, due to the warnings on
> transaction abort.
> 
> Anyway, I have come up with a version that seems to mostly work.
> 
> The main change is that btrfs_sync_file stashes away the journal handle.
> I also had to merge parts of the ->iomap_end patch into the main iomap
> one.  I also did some cleanups to my iomap changes while looking over it.
> Let me know what you thing, the tree is here:
> 
>     git://git.infradead.org/users/hch/misc.git btrfs-dio
> 
> Gitweb:
> 
>     http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/btrfs-dio

I finally managed to fix the reservation issue and the final tree based
on Dave's for-next is at:
https://github.com/goldwynr/linux/tree/dio-merge

I will test it thoroughly and send another patchset.
I will still need that iomap->private!

-- 
Goldwyn
