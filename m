Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40348 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752609AbdLRNn5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 08:43:57 -0500
Subject: Re: Unexpected raid1 behaviour
To: Nikolay Borisov <nborisov@suse.com>,
        Peter Grandi <pg@btrfs.list.sabi.co.UK>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <5A357909.8010206@yandex.ru>
 <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk>
 <be7e5573-4247-89bd-00f0-7d84120ce582@oracle.com>
 <9a2f4ed4-26a0-833d-1225-5a5773ab7a61@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <e7149a09-969a-4164-be4e-705720e4fe11@oracle.com>
Date: Mon, 18 Dec 2017 21:43:59 +0800
MIME-Version: 1.0
In-Reply-To: <9a2f4ed4-26a0-833d-1225-5a5773ab7a61@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>>> what was intended that it should be able to detect a previous
>>> member block-device becoming available again as a different
>>> device inode, which currently is very dangerous in some vital
>>> situations.

  Peter, What's the dangerous part here ?

>>   If device disappears, the patch [4] will completely take out the
>>   device from btrfs, and continues to RW in degraded mode.
>>   When it reappears then [5] will bring it back to the RW list.
> 
> but [5] relies on someone from userspace (presumably udev) actually
> invoking BTRFS_IOC_SCAN_DEV/IOSC_DEVICES_READY, no ?

  Nikoly, Yes. Most of the destro udev already does that. udev calls
  btrfs dev scan when SB is overwritten from userland or when a device
  with primary SB as btrfs (re)appears.

> Because
> device_list_add is only ever called from btrfs_scan_one_device, which in
> turn is called by either of the aforementioned IOCTLS or during mount
> (which is not at play here).

  Hm. as above.

Thanks Anand

