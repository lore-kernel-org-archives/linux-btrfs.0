Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:34363 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751276AbdH2RoH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Aug 2017 13:44:07 -0400
Received: by mail-io0-f195.google.com with SMTP id d81so3761397ioj.1
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Aug 2017 10:44:07 -0700 (PDT)
Subject: Re: Decompression success/failure dependent on PAGE_SIZE?
To: =?UTF-8?Q?Marek_Beh=c3=ban?= <marek.behun@nic.cz>,
        linux-btrfs@vger.kernel.org
References: <20170829184342.2f6ec0b0@dellmb.labs.office.nic.cz>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <bfe3e720-00e5-1a5a-7b08-c2cd32b62a08@gmail.com>
Date: Tue, 29 Aug 2017 20:44:03 +0300
MIME-Version: 1.0
In-Reply-To: <20170829184342.2f6ec0b0@dellmb.labs.office.nic.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 29.08.2017 19:43, Marek Behún wrote:
> Hello,
> 
> so I've been studying the linux btrfs code and have come across this:
> 
> in inode.c function uncompress_inline the max_size size variable is set
> to min(max_size, PAGE_SIZE) and only max_size of output data are
> decompressed.
> 
> The code for compression (in lzo.c for example) uses PAGE_SIZEd chunks
> to compress an inline extent.
> 
> If I understand it correctly, then if the filesystem is created and used
> on a computer with PAGE_SIZE for example 16KB, and an extent of size
> 16KB is compressed to (for example 9KB) and stored as inline extent,
> and then the filesystem is mounted on a computer with PAGE_SIZE = 4KB,
> reading the extent will result in a failure or incomplete read.
> 
> Is this a bug, or is this behaviour a feature?

Please have a look in btrfs_check_super_valid(), which is being called
from open_ctree, which in turn is called when a filesystem is mounted.

Currently btrfs supports a single blocksize value - PAGE_SIZE, also it's
forbidden to mount a filesystem on systems with different page_sizes.
When the sub-page blocksizes patch is merged this might be have to be
taken into consideration but certainly not at present times.

> 
> Thank you.
> 
> Marek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
