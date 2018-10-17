Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67EA7ECDE32
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 15:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2773D2150F
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 15:03:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2773D2150F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbeJQW7o (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 18:59:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:59510 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727047AbeJQW7o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 18:59:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BA374AF3C
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Oct 2018 15:03:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E7F99DAD55; Wed, 17 Oct 2018 17:03:30 +0200 (CEST)
Date:   Wed, 17 Oct 2018 17:03:29 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 0/4] btrfs: Refactor find_free_extent()
Message-ID: <20181017150329.GG29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181017065606.8707-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181017065606.8707-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 17, 2018 at 02:56:02PM +0800, Qu Wenruo wrote:
> Can be fetched from github:
> https://github.com/adam900710/linux/tree/refactor_find_free_extent
> 
> Which is based on v4.19-rc1.
> 
> extent-tree.c::find_free_extent() could be one of the most
> ill-structured functions, it has at least 6 non-exit tags and jumps
> between them.
> 
> Refactor it into 4 parts:
> 
> 1) find_free_extent()
>    The main entrance, does the main work of block group iteration and
>    block group selection.
>    Now this function doesn't care nor handles free extent search by
>    itself.
> 
> 2) find_free_extent_clustered()
>    Do clustered free extent search.
>    May try to build/re-fill cluster.
> 
> 3) find_free_extent_unclustered()
>    Do unclustered free extent search.
>    May try to fill free space cache.
> 
> 4) find_free_extent_update_loop()
>    Do the loop based black magic.
>    May allocate new chunk.
> 
> With this patch, at least we should make find_free_extent() a little
> easier to read, and provides the basis for later work on this function.
> 
> Current refactor is trying not to touch the original functionality, thus
> the helper structure find_free_extent_ctl still contains a lot of
> unrelated members.
> But it should not change how find_free_extent() works at all.

Thanks, patches added to for-next. It looks much better than before,
more cleanups welcome.
