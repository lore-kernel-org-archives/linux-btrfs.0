Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54634 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932341AbeFUOIz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 10:08:55 -0400
Subject: Re: [PATCH] btrfs: check-integrity: Fix NULL pointer dereference for
 degraded mount
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180620073858.10794-1-wqu@suse.com>
 <20180621135809.GQ24375@twin.jikos.cz>
 <c5d09030-cd4f-914a-0d22-689592ba3be5@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <4e67e607-83f6-536e-0029-3ef8389288d8@suse.com>
Date: Thu, 21 Jun 2018 17:08:52 +0300
MIME-Version: 1.0
In-Reply-To: <c5d09030-cd4f-914a-0d22-689592ba3be5@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 21.06.2018 17:02, Qu Wenruo wrote:
> 
> 
> On 2018年06月21日 21:58, David Sterba wrote:
>> On Wed, Jun 20, 2018 at 03:38:58PM +0800, Qu Wenruo wrote:
>>> Commit f8f84b2dfda5 ("btrfs: index check-integrity state hash by a dev_t")
>>> changed how btrfsic how we index device state hash.
>>>
>>> Now we need to access device->bdev->bd_dev, while for degraded mount
>>> it's completely possible to have device->bdev as NULL, thus it will
>>> trigger a NULL pointer dereference at mount time.
>>>
>>> Fix it by checking if the device is degraded before accessing
>>> device->bdev->bd_dev.
>>>
>>> There are a lot of other places accessing device->bdev->bd_dev, however
>>> the other call sites have either checked device->bdev, or the
>>> device->bdev is passed from btrfsic_map_block(), so it won't cause harm.
>>>
>>> Fixes: f8f84b2dfda5 ("btrfs: index check-integrity state hash by a dev_t")
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>
>> Added to misc-next. As it is a fix it could go to 4.18 but I'd rather
>> have a good reason for that because it's in a debugging feature.
> 
> No need to push it to 4.18.
> 
> Indeed it's a debug feature, and furthermore, there are tons of bugs
> exposed by fstests, so it's better to fix it as a large serious patchset.
> 

If buffer heads are eliminated from btrfs then we can remove a
substantial portion of the integrity checking code.
