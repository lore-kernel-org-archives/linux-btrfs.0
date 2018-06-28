Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40676 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S968043AbeF1TD4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 15:03:56 -0400
Subject: Re: call trace: WARNING: at
 /build/linux-uwVqDp/linux-4.16.16/fs/btrfs/ctree.h:1565 btrfs_update_device
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <50443c666dc4509d74f9f23d7012080845a20940.camel@scientia.net>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a80da87b-6c38-3b37-542c-17718bad8d5c@suse.com>
Date: Thu, 28 Jun 2018 16:25:57 +0300
MIME-Version: 1.0
In-Reply-To: <50443c666dc4509d74f9f23d7012080845a20940.camel@scientia.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 28.06.2018 16:19, Christoph Anton Mitterer wrote:
> Hey.
> 
> On a 4.16.16 kernel with a RAID 1 btrfs I got the following messages
> since today.
> 
> Data seems still to be readable (correctly)... and there are no other
> errors (like SATA errors) in the kernel log.
> 
> Any idea what these could mean?

It means you have a device, whose size is not aligned to 4k. You can fix
this either by resizing the device to be properly aligned to a 4k
boundary (if you are on x86) or better yet, just run :


btrfs rescue fix-device-size /dev/<device to fix>

> 
> Thanks,
> Chris.
