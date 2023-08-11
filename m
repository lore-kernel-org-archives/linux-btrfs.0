Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3C9C001B0
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Aug 2023 10:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbjHKKbb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Aug 2023 06:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbjHKKb2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Aug 2023 06:31:28 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381B6F5
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Aug 2023 03:31:28 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3A04567373; Fri, 11 Aug 2023 12:31:24 +0200 (CEST)
Date:   Fri, 11 Aug 2023 12:31:23 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Linux regressions mailing list <regressions@lists.linux.dev>
Cc:     Christoph Hellwig <hch@lst.de>,
        Wang Yugui <wangyugui@e16-tech.com>,
        linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: btrfs write-bandwidth performance regression of 6.5-rc4/rc3
Message-ID: <20230811103123.GA17179@lst.de>
References: <20230801235123.B665.409509F4@e16-tech.com> <20230801155649.GA13009@lst.de> <20230802080451.F0C2.409509F4@e16-tech.com> <20230802092631.GA27963@lst.de> <adfdb843-2220-5969-e647-d31ba8684d42@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adfdb843-2220-5969-e647-d31ba8684d42@leemhuis.info>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Aug 11, 2023 at 10:58:27AM +0200, Linux regression tracking (Thorsten Leemhuis) wrote:
> > Ok, so you have a case where the offload for the checksumming generation
> > actually helps (by a lot).  Adding Chris to the Cc list as he was
> > involved with this.
> 
> Radio silence from Chris here and on lore in general afaics. Also
> nothing new in this thread for more than a week now.

We're also waiting for additional data from Wang.

I'll be off for a two weeks vacation tomorrow with rather limited
inter connectivity, so if we want to make progress I'd better be
today or tomorrow morning.

