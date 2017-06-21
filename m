Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:33541 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751223AbdFUNsM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 09:48:12 -0400
Received: by mail-pg0-f50.google.com with SMTP id f127so557223pgc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Jun 2017 06:48:12 -0700 (PDT)
Subject: Re: [PATCH] btrfs: use new block error code
To: dsterba@suse.cz, Dan Carpenter <dan.carpenter@oracle.com>,
        Chris Mason <clm@fb.com>, Christoph Hellwig <hch@lst.de>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20170619105536.GA24075@elgon.mountain>
 <20170621131723.GH21388@twin.jikos.cz>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <2bd7fd59-71ad-8ff5-65f7-3b6f1d51ccbd@kernel.dk>
Date: Wed, 21 Jun 2017 07:48:08 -0600
MIME-Version: 1.0
In-Reply-To: <20170621131723.GH21388@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/21/2017 07:17 AM, David Sterba wrote:
> On Mon, Jun 19, 2017 at 01:55:37PM +0300, Dan Carpenter wrote:
>> This function is supposed to return blk_status_t error codes now but
>> there was a stray -ENOMEM left behind.
>>
>> Fixes: 4e4cbee93d56 ("block: switch bios to blk_status_t")
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Acked-by: David Sterba <dsterba@suse.com>
> 
> The patch depends on the blk_status_t patchset, so I expect that it's
> going to be merged to that.

Added, thanks.

-- 
Jens Axboe

