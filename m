Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD8A2C5479D
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Jan 2023 04:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbjAKE3Z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 10 Jan 2023 23:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235867AbjAKE2c (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2023 23:28:32 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45CBDFC6;
        Tue, 10 Jan 2023 20:26:46 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 13E4B68BEB; Wed, 11 Jan 2023 05:26:42 +0100 (CET)
Date:   Wed, 11 Jan 2023 05:26:41 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Dave Kleikamp <shaggy@kernel.org>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Evgeniy Dushistov <dushistov@mail.ru>,
        linux-btrfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/7] minix: don't flush page immediately for DIRSYNC
 directories
Message-ID: <20230111042641.GA15181@lst.de>
References: <20230108165645.381077-1-hch@lst.de> <20230108165645.381077-4-hch@lst.de> <Y7sy5jzjT7tpPX6Z@casper.infradead.org> <20230110082225.GB11947@lst.de> <Y74c+WSEajAic3Kh@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y74c+WSEajAic3Kh@ZenIV>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 11, 2023 at 02:20:41AM +0000, Al Viro wrote:
> More seriously, all those ..._set_link() need to return an error and their
> callers (..._rename()) need to deal with failures.

That's actually what I did yesterday:

http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/remove-write_one_page
