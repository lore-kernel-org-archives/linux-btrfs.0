Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:17099 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbeDQAVk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 20:21:40 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 233C5AC0180
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Apr 2018 09:21:37 +0900 (JST)
Subject: Re: [PATCH v4 3/4] btrfs: Refactor btrfs_ioctl_snap_destroy() by
 using btrfs_delete_subvolume()
To: <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <d5c7d8e3-4c07-18c3-56a5-0482c899cfe5@jp.fujitsu.com>
 <e4e8ecc3-fc4f-5967-1bf3-9f5abbac0c62@jp.fujitsu.com>
 <20180416175330.GS21272@twin.jikos.cz>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <b373228a-a871-784a-0b46-45b77951a091@jp.fujitsu.com>
Date: Tue, 17 Apr 2018 09:21:16 +0900
MIME-Version: 1.0
In-Reply-To: <20180416175330.GS21272@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/04/17 2:53, David Sterba wrote:
> On Wed, Apr 11, 2018 at 02:20:49PM +0900, Misono Tomohiro wrote:
>> Use btrfs_delete_subvolume() to refactor btrfs_ioctl_snap_destroy().
>> The permission check is still done in btrfs_ioctl_snap_destroy(). Also,
>> call of d_delete() is still required since btrfs_delete_subvolume()
>> does not call it.
>>
>> As a result, btrfs_unlink_subvol() and may_destroy_subvol()
>> become static functions. No functional change happens.
>>
>> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> 
> Why is this still split into two patches? Factoring out a function
> should happen in one patch, ie 2 and 3 in one go. Do you have a reason
> not to do it like that?

I thought this reduces code change in one patch and might be good, but
I'm completely fine with merging 2nd and 3rd patches. Should I send v5?

