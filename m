Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:58505 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750903AbdIDE5p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Sep 2017 00:57:45 -0400
Subject: Re: block group 11778977169408 has wrong amount of free space
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <1504485081.5569.2.camel@scientia.net>
 <1504489875.5569.4.camel@scientia.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <64955e14-a40d-6de0-13ac-b289dfb32c62@gmx.com>
Date: Mon, 4 Sep 2017 12:57:38 +0800
MIME-Version: 1.0
In-Reply-To: <1504489875.5569.4.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月04日 09:51, Christoph Anton Mitterer wrote:
> Did another mount with clear_cache,rw (cause it was ro before)... now I
> get even more errors:
> # btrfs check  /dev/mapper/data-a2 ; echo $?
> Checking filesystem on /dev/mapper/data-a2
> UUID: f8acb432-7604-46ba-b3ad-0abe8e92c4db
> checking extents
> checking free space cache
> block group 9857516175360 has wrong amount of free space
> failed to load free space cache for block group 9857516175360
> block group 11778977169408 has wrong amount of free space
> failed to load free space cache for block group 11778977169408
> checking fs roots
> checking csums
> checking root refs
> found 4404625330176 bytes used, no error found
> total csum bytes: 4293007908
> total tree bytes: 7511883776
> total fs tree bytes: 1856258048
> total extent tree bytes: 1097842688
> btree space waste bytes: 887738230
> file data blocks allocated: 4397113446400
>   referenced 4515055595520
> 0
> 
> what the???
>

IIRC clear_cache will only clear the cache of modified block groups for 
v1 space cache.

And that's why we have btrfs check --clear-space-cache v1, which will 
wipe out all (v1) space cache.

Thanks,
Qu
