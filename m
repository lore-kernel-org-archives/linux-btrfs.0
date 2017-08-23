Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:37841 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932521AbdHWSuP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 14:50:15 -0400
Received: by mail-it0-f52.google.com with SMTP id 190so3791416itx.0
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 11:50:14 -0700 (PDT)
Subject: Re: don't require a struct block_device to submit a bio
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org
References: <20170823171032.30529-1-hch@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5e4171a6-1cbe-5753-e35d-6c9b89a9c9e5@kernel.dk>
Date: Wed, 23 Aug 2017 12:50:12 -0600
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

Added for 4.14, thanks.

-- 
Jens Axboe

