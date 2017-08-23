Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:32781 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932395AbdHWSEs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 14:04:48 -0400
Received: by mail-it0-f50.google.com with SMTP id y62so969775itc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 11:04:48 -0700 (PDT)
Subject: Re: don't require a struct block_device to submit a bio
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org
References: <20170823171032.30529-1-hch@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <e94c9d00-824e-a90e-87b4-7791714dd96b@kernel.dk>
Date: Wed, 23 Aug 2017 12:04:45 -0600
MIME-Version: 1.0
In-Reply-To: <20170823171032.30529-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/23/2017 11:10 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series removes the need to have a struct block_device ready to
> submit a bio.   We basically don't use it anywhere in the block stack
> anyway - we always go for the gendisk or request_queue.  The only
> exception is partition remapping for which we'll now need an additional
> partition index.  This helps with cases where we submit I/O from a
> character device (nvme or lightnvm passthrough) or a different block
> device (upcoming nvme multipath support).

Looks fine to me. I can take it through the block tree, when the md/btrfs
parts are reviewed by the right parties.

-- 
Jens Axboe

