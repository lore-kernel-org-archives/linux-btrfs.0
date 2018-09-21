Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36528 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391251AbeIVC2l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 22:28:41 -0400
Subject: Re: [PATCH 3/6] btrfs-progs: Pull free space tree related code from
 kernel
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org
References: <1529060762-4372-1-git-send-email-nborisov@suse.com>
 <1529060762-4372-4-git-send-email-nborisov@suse.com>
 <20180921201918.GD31081@vader>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <778e01af-8014-d1ed-06ac-074c99654f89@suse.com>
Date: Fri, 21 Sep 2018 23:38:04 +0300
MIME-Version: 1.0
In-Reply-To: <20180921201918.GD31081@vader>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 21.09.2018 23:19, Omar Sandoval wrote:
> On Fri, Jun 15, 2018 at 02:05:59PM +0300, Nikolay Borisov wrote:
>> To help implement free space tree checker in user space some kernel
>> function are necessary, namely iterating/deleting/adding freespace
>> items, some internal search functions. Functions to populate a block
>> group based on the extent tree. The code is largely copy/paste from
>> the kernel with locking eliminated (i.e free_space_lock). It supports
>> reading/writing of both bitmap and extent based FST trees.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> Why doesn't this include the bitmap <-> extent conversions? If we end up
> rebuilding the free space tree, we're never going to use the bitmap
> format, which sucks if the free space is fragmented.
> 

The idea was to have *something* working initially and then add as
deemed appropriate.
