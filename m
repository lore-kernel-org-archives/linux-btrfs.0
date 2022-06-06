Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02728C43334
	for <linux-btrfs@archiver.kernel.org>; Mon,  6 Jun 2022 16:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241746AbiFFQ3u (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 12:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241760AbiFFQ3k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jun 2022 12:29:40 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED8D329361
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Jun 2022 09:29:33 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6A19468AFE; Mon,  6 Jun 2022 18:29:29 +0200 (CEST)
Date:   Mon, 6 Jun 2022 18:29:29 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: pass the btrfs_bio_ctrl to submit_one_bio
Message-ID: <20220606162929.GA10835@lst.de>
References: <20220603071103.43440-1-hch@lst.de> <20220603071103.43440-4-hch@lst.de> <0eb3ddf9-af5f-e67f-c8f8-17c80c731359@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0eb3ddf9-af5f-e67f-c8f8-17c80c731359@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jun 06, 2022 at 01:41:50PM +0300, Nikolay Borisov wrote:
>> +static void submit_one_bio(struct btrfs_bio_ctrl *bio_ctrl)
>> +{
>> +	if (bio_ctrl->bio)
>> +		__submit_one_bio(bio_ctrl);
>>   }
>
> Why do you need a function just to put an if in it, just move this atop 
> __submit_one_bio :
>
> if (!bio_ctrl->bio)
>     return
>
> and rename it to submit_one_bio.

Because just moving it to the top will lead to null pointer dereferences.
I'd also have to move some initialization down.  Based on that the
wrapper seems cleaner and safer to me.
