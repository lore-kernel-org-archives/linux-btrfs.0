Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50AC2C433F5
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Oct 2021 19:02:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37F6F60E74
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Oct 2021 19:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbhJYTE4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Oct 2021 15:04:56 -0400
Received: from vps.thesusis.net ([34.202.238.73]:54428 "EHLO vps.thesusis.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233588AbhJYTEz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Oct 2021 15:04:55 -0400
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 0C83861FD2; Mon, 25 Oct 2021 15:02:27 -0400 (EDT)
References: <YXHK5HrQpJu9oy8w@casper.infradead.org>
 <87tuh9n9w2.fsf@vps.thesusis.net> <20211022084127.GA1026@quack2.suse.cz>
User-agent: mu4e 1.7.0; emacs 27.1
From:   Phillip Susi <phill@thesusis.net>
To:     Jan Kara <jack@suse.cz>
Cc:     Matthew Wilcox <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev,
        linux-bcache@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Hsin-Yi Wang <hsinyi@chromium.org>
Subject: Re: Readahead for compressed data
Date:   Mon, 25 Oct 2021 14:59:45 -0400
In-reply-to: <20211022084127.GA1026@quack2.suse.cz>
Message-ID: <87fssprkql.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Jan Kara <jack@suse.cz> writes:

> Well, one of the problems with keeping compressed data is that for mmap(2)
> you have to have pages decompressed so that CPU can access them. So keeping
> compressed data in the page cache would add a bunch of complexity. That
> being said keeping compressed data cached somewhere else than in the page
> cache may certainly me worth it and then just filling page cache on demand
> from this data...

True... Did that multi generational LRU cache ever get merged?  I was
thinking you could use that to make sure that the kernel prefers to
reclaim the decompressed pages in favor of keeping the compressed ones
around.

