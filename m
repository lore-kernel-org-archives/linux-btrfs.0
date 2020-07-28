Return-Path: <SRS0=QcMt=BH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE376C433E8
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Jul 2020 13:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DA3D206D4
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Jul 2020 13:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729978AbgG1NOp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 28 Jul 2020 09:14:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:54598 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729433AbgG1NOo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Jul 2020 09:14:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0A76DB1A7;
        Tue, 28 Jul 2020 13:14:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 22221DA701; Tue, 28 Jul 2020 15:14:14 +0200 (CEST)
Date:   Tue, 28 Jul 2020 15:14:13 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Hans van Kranenburg <hans@knorrie.org>
Subject: Re: [PATCH] btrfs: trace: output proper root owner for
 trace_find_free_extent()
Message-ID: <20200728131413.GT3703@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Hans van Kranenburg <hans@knorrie.org>
References: <20200728014249.35532-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728014249.35532-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jul 28, 2020 at 09:42:49AM +0800, Qu Wenruo wrote:
> The current trace event always output result like this:
> 
>  find_free_extent: root=2(EXTENT_TREE) len=16384 empty_size=0 flags=4(METADATA)
>  find_free_extent: root=2(EXTENT_TREE) len=16384 empty_size=0 flags=4(METADATA)
>  find_free_extent: root=2(EXTENT_TREE) len=8192 empty_size=0 flags=1(DATA)
>  find_free_extent: root=2(EXTENT_TREE) len=8192 empty_size=0 flags=1(DATA)
>  find_free_extent: root=2(EXTENT_TREE) len=4096 empty_size=0 flags=1(DATA)
>  find_free_extent: root=2(EXTENT_TREE) len=4096 empty_size=0 flags=1(DATA)
> 
> It's driving me crazy, as it's saying we're allocating data extent for
> EXTENT tree, which is not even possible.
> 
> It's because we always use EXTENT tree as the owner for
> trace_find_free_extent() without using the @root from
> btrfs_reserve_extent().
> 
> This patch will change the parameter to use proper @root for
> trace_find_free_extent() to make life a little easier.
> 
> Now it looks much better:
>  find_free_extent: root=5(FS_TREE) len=16384 empty_size=0 flags=36(METADATA|DUP)
>  find_free_extent: root=5(FS_TREE) len=8192 empty_size=0 flags=1(DATA)
>  find_free_extent: root=5(FS_TREE) len=16384 empty_size=0 flags=1(DATA)
>  find_free_extent: root=5(FS_TREE) len=4096 empty_size=0 flags=1(DATA)
>  find_free_extent: root=5(FS_TREE) len=8192 empty_size=0 flags=1(DATA)
>  find_free_extent: root=5(FS_TREE) len=16384 empty_size=0 flags=36(METADATA|DUP)
>  find_free_extent: root=7(CSUM_TREE) len=16384 empty_size=0 flags=36(METADATA|DUP)
>  find_free_extent: root=2(EXTENT_TREE) len=16384 empty_size=0 flags=36(METADATA|DUP)
>  find_free_extent: root=1(ROOT_TREE) len=16384 empty_size=0 flags=36(METADATA|DUP)
> 
> Reported-by: Hans van Kranenburg <hans@knorrie.org>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Thanks, added to misc-next, with some changelog adjustments.
