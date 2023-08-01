Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F99EB64DD
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Aug 2023 08:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbjHAIgC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 1 Aug 2023 04:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjHAIgA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2023 04:36:00 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9761B6
        for <linux-btrfs@vger.kernel.org>; Tue,  1 Aug 2023 01:36:00 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B901768AFE; Tue,  1 Aug 2023 10:35:56 +0200 (CEST)
Date:   Tue, 1 Aug 2023 10:35:56 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs write-bandwidth performance regression of 6.5-rc4/rc3
Message-ID: <20230801083556.GA24287@lst.de>
References: <20230731152223.4EFB.409509F4@e16-tech.com> <20230801102253.1AF4.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230801102253.1AF4.409509F4@e16-tech.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Aug 01, 2023 at 10:22:58AM +0800, Wang Yugui wrote:
> 'git bisect' show that this patch is the root cause of performance
> regression.
> 
> e917ff56c8e7 :Christoph Hellwig: btrfs: determine synchronous writers from bio
> or writeback control

Odd.  What CPU are you using to test?  It seems like it doesn't set
BTRFS_FS_CSUM_IMPL_FAST as that is the only way to even hit a potential
difference.  Or are you using a non-standard checksum type?

