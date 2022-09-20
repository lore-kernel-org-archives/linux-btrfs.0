Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 704E6C54EE9
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Sep 2022 17:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiITRVO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 13:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiITRVN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2022 13:21:13 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A276E5F7FD;
        Tue, 20 Sep 2022 10:21:11 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B875568AFE; Tue, 20 Sep 2022 19:21:06 +0200 (CEST)
Date:   Tue, 20 Sep 2022 19:21:06 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Suren Baghdasaryan <surenb@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Gao Xiang <xiang@kernel.org>, Chris Mason <clm@fb.com>,
        linux-block@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Chao Yu <chao@kernel.org>, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org
Subject: Re: improve pagecache PSI annotations v2
Message-ID: <20220920172106.GA24750@lst.de>
References: <20220915094200.139713-1-hch@lst.de> <166368389821.10447.12312122039024559092.b4-ty@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166368389821.10447.12312122039024559092.b4-ty@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Sep 20, 2022 at 08:24:58AM -0600, Jens Axboe wrote:
> Applied, thanks!

I think Andrew applied these as well already.  I'll let you two fight
that out as I'm happy as long as it goes in :)

