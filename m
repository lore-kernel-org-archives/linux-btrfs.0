Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA5CC6FD1F
	for <linux-btrfs@archiver.kernel.org>; Sat, 25 Mar 2023 08:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbjCYIWo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 25 Mar 2023 04:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCYIWo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 25 Mar 2023 04:22:44 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A6912CF7
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Mar 2023 01:22:43 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 751BC68AA6; Sat, 25 Mar 2023 09:22:39 +0100 (CET)
Date:   Sat, 25 Mar 2023 09:22:39 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Naohiro Aota <Naohiro.Aota@wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, Boris Burkov <boris@bur.io>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 01/11] btrfs: add function to create and return an
 ordered extent
Message-ID: <20230325082238.GA7598@lst.de>
References: <20230324023207.544800-1-hch@lst.de> <20230324023207.544800-2-hch@lst.de> <20230324054717.e3we3azhj2ava5qq@naota-xeon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324054717.e3we3azhj2ava5qq@naota-xeon>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 24, 2023 at 05:47:18AM +0000, Naohiro Aota wrote:
> I'm sorry to write a comment on this late, but isn't the function name
> confusing?  As I suggested a function only to allocate and initialize a
> btrfs_ordered_extent in the previous mail [1], I first thought this
> function is something like that.
> 
> [1] https://lore.kernel.org/linux-btrfs/20230323083608.m2ut2whbk2smjjpu@naota-xeon/
> 
> But, both btrfs_alloc_ordered_extent() and btrfs_add_ordered_extent() "add
> an ordered extent to the per-inode tree." The difference is that
> btrfs_alloc_ordered_extent() returns the created ordered extent to the
> caller taking a reference for them...
> 
> However, I can't think of a different name, so it might be OK...

I can't really think of a better name either. 

That being said, splitting out the accounting and having a version
that doesn't do it would be really useful for the split case.
And in the very long run I hope I can kill off the ordered_extent
tree entirely, but that's just futurism for now :)
