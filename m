Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47115 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751207AbdBXAz6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Feb 2017 19:55:58 -0500
Subject: Re: Downgrading kernel 4.9 to 4.4 with space_cache=v2 enabled?
To: Christian Theune <ct@flyingcircus.io>, <linux-btrfs@vger.kernel.org>
References: <BB064A3C-6F5C-4490-80A6-F42BEFAA945A@flyingcircus.io>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <fe942684-deb3-08f1-d4c1-ae25a912f799@cn.fujitsu.com>
Date: Fri, 24 Feb 2017 08:54:52 +0800
MIME-Version: 1.0
In-Reply-To: <BB064A3C-6F5C-4490-80A6-F42BEFAA945A@flyingcircus.io>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/23/2017 06:51 PM, Christian Theune wrote:
> Hi,
>
> not sure whether it’s possible, but we tried space_cache=v2 and obviously after working fine in staging it broke in production. Or rather: we upgraded from 4.4 to 4.9 and enabled the space_cache. Our production volume is around 50TiB usable (underlying HW Raid 6).
>
> The machine crashes silently every 15 hours or so and takes _ages_ to reboot. It current is stuck trying to mount the local filesystems and I guess btrfs is doing something, but I don’t have shell access yet.
>
> I’m wondering whether we can downgrade by booting back into 4.4 or will this break things even further? (We’ve had some unpleasant surprises with FS’ in the last months, so I thought I’d rather ask.)

You could use "btrfs check --clear-space-cache" to completely cleanup 
space cache. Both v1(free space cache, file based) or v2(free space 
tree) are supported.

And specially for v2 space cache (space cache tree), "btrfs check 
--clear-space-cache" will also clear the ro_compat flag, so older kernel 
should mount the fs without problem.

In free-space-cache.c
------
         features = btrfs_super_compat_ro_flags(fs_info->super_copy);
         features &= ~(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID |
                       BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE);
         btrfs_set_super_compat_ro_flags(fs_info->super_copy, features);
------

Thanks,
Qu

>
> Kind regards,
> Christian
>
> --
> Christian Theune · ct@flyingcircus.io · +49 345 219401 0
> Flying Circus Internet Operations GmbH · http://flyingcircus.io
> Forsterstraße 29 · 06112 Halle (Saale) · Deutschland
> HR Stendal HRB 21169 · Geschäftsführer: Christian. Theune, Christian. Zagrodnick
>


