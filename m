Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F2D9C25B0C
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Aug 2022 13:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243328AbiHHNlp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Aug 2022 09:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243180AbiHHNlo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Aug 2022 09:41:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F751121;
        Mon,  8 Aug 2022 06:41:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 79EF8CE10CA;
        Mon,  8 Aug 2022 13:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D46C433D6;
        Mon,  8 Aug 2022 13:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659966099;
        bh=afAXm71B7EnFDpaND4Kf4mrRKOIwNi0hQ6BBCKGbyNA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=upzHflR3x1ZeIPJd7AdNyeWL9cfghfGH0jVFVzgTm/dv2a7gflP1TcbQhmtflc9qX
         LSMym0FoY1nV7YPjPsVWhotx1CeqbZvVNCWkQRlzxEisrq/npo/iw1dccJmwzh5fuY
         kWpzV4evbRmGJf+3ZmTM2Dm4m8xUkGornGjExLvE=
Date:   Mon, 8 Aug 2022 15:41:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH STABLE 5.18 v2 0/3] btrfs: backport zoned mode fixes
Message-ID: <YvESkXA2m7MCv+yY@kroah.com>
References: <20220808020201.712924-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220808020201.712924-1-naohiro.aota@wdc.com>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Aug 08, 2022 at 11:01:58AM +0900, Naohiro Aota wrote:
> These patches are backport for the 5.18 branch.
> 
> They all fixes zoned mode related issued on btrfs.
> 
> The patch 3 looks different from upstream commit b3a3b0255797 ("btrfs:
> zoned: drop optimization of zone finish") as a refactoring patch is not
> picked into the stable branch. But, essentially, they do the same thing
> which always zone finish the zones after (nearly) full write.
> 
> The v2 just amend a line to add a missing variable declaration.
> 
> Naohiro Aota (3):
>   btrfs: zoned: prevent allocation from previous data relocation BG
>   btrfs: zoned: fix critical section of relocation inode writeback
>   btrfs: zoned: drop optimization of zone finish
> 
>  fs/btrfs/block-group.h |  1 +
>  fs/btrfs/extent-tree.c | 20 +++++++++++++++--
>  fs/btrfs/extent_io.c   |  3 ++-
>  fs/btrfs/inode.c       |  2 ++
>  fs/btrfs/zoned.c       | 50 +++++++++++++++++++++++++++++++++++++-----
>  fs/btrfs/zoned.h       |  5 +++++
>  6 files changed, 73 insertions(+), 8 deletions(-)
> 
> -- 
> 2.35.1
> 

Now queued up.
