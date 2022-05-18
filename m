Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5723C433F5
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 May 2022 08:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbiERIrr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 18 May 2022 04:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbiERIrr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 May 2022 04:47:47 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDEF3134E2E
        for <linux-btrfs@vger.kernel.org>; Wed, 18 May 2022 01:47:45 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id CC28F68AFE; Wed, 18 May 2022 10:47:42 +0200 (CEST)
Date:   Wed, 18 May 2022 10:47:42 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 10/15] btrfs: add a btrfs_map_bio_wait helper
Message-ID: <20220518084742.GE6933@lst.de>
References: <20220517145039.3202184-1-hch@lst.de> <20220517145039.3202184-11-hch@lst.de> <35c12a78-fe5d-c683-58c7-d600e8f7ce14@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35c12a78-fe5d-c683-58c7-d600e8f7ce14@gmx.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, May 18, 2022 at 06:26:08AM +0800, Qu Wenruo wrote:
>
>
> On 2022/5/17 22:50, Christoph Hellwig wrote:
>> This helpers works like submit_bio_wait, but goes through the btrfs bio
>> mapping using btrfs_map_bio.
>
> I hate the naming of btrfs_map_bio(), which should be
> btrfs_map_and_submit_bio(), but I also totally understand my poor naming
> scheme is even worse for most cases.
>
> Maybe we can add the "submit" part into the new function?

I was tempted to rename btrfs_map_bio to just btrfs_submit_bio a
few times, but always had more important things to do first.  But
either way this helper should match the naming of the main async
function.

>> +	DECLARE_COMPLETION_ONSTACK(done);
>> +	blk_status_t ret;
>
> Is there any lockdep assert to make sure we're in wq context?


No.  You can build some asserts manually, but wait_for_completion will
already do that, so I'm not sure what the benefit would be.

