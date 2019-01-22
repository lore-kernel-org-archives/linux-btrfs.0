Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6081C282C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 17:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9277B21019
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 17:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbfAVRjc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 12:39:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:54772 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725916AbfAVRjc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 12:39:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 107A9B0C0
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2019 17:39:31 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 375BBDA84A; Tue, 22 Jan 2019 18:38:57 +0100 (CET)
Date:   Tue, 22 Jan 2019 18:38:56 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 3/5] btrfs: extent_io: Kill the BUG_ON() in
 flush_write_bio()
Message-ID: <20190122173856.GQ2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190118021956.22949-1-wqu@suse.com>
 <20190118021956.22949-4-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190118021956.22949-4-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 18, 2019 at 10:19:54AM +0800, Qu Wenruo wrote:
> This BUG_ON() is really just a crappy way to workaround the _must_check
> attribute of submit_one_bio().
> 
> Now kill the BUG_ON() and allow flush_write_bio() to return error
> number.
> 
> Also add _must_check attribute to flush_write_bio(), and modify all
> callers to handle the possible error returned.

Can you please spit that to several steps:

1. handle errors in submit_one_bio or pass it to the callers
   ie. drop the BUG_ON and move it to all callers

2. in all callers do
   ret = flush_write_bio(...)
   BUG_ON(ret)

So now it's one level up in the call chain and up to all callers to
handle the errors properly. The code is equivalent to the previous
state, though there are more BUG_ONs.

3. one patch per function that handles errors of flush_write_bio, ie.
   actual replacement of BUG_ON with if (ret < 0) etc

As there are several different functions, each has own things to clean
up and it's easier to review them one by one. Sometimes it's necessary
to check more callers and keeping multiple contexts in mind at once does
not work very well.

Counting all the affected functions:

lock_extent_buffer_for_io(struct extent_buffer *eb,
btree_write_cache_pages(struct address_space *mapping,
extent_write_cache_pages(struct address_space *mapping,
extent_write_full_page(struct page *page, struct writeback_control *wbc)
extent_write_locked_range(struct inode *inode, u64 start, u64 end,
extent_writepages(struct address_space *mapping,

the 3rd point would produce 6 patches.
