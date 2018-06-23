Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:59623 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934209AbeFWDkx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 23:40:53 -0400
Subject: Re: [PATCH] btrfs: treat -ERANGE as an error case in btrfs_get_acl()
To: dsterba@suse.cz, clm@fb.com, jbacik@fb.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
References: <20180622025816.29239-1-cgxu519@gmx.com>
 <20180622104831.GY24375@twin.jikos.cz>
From: cgxu519 <cgxu519@gmx.com>
Message-ID: <d2fdef05-793f-5230-f5e3-6769edea8ebc@gmx.com>
Date: Sat, 23 Jun 2018 11:40:34 +0800
MIME-Version: 1.0
In-Reply-To: <20180622104831.GY24375@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/22/2018 06:48 PM, David Sterba wrote:
> On Fri, Jun 22, 2018 at 10:58:16AM +0800, Chengguang Xu wrote:
>> Currently, when encoutering -ERANGE in btrfs_get_acl(),
>> just set acl to NULL so that we cannot get proper
>> acl information but the operation looks successful.
> Do you have a reproducer for that?
>
> ERANGE is returned from btrfs_getxattr in case the buffer is not large
> enough to store the restult, but the first call to btrfs_getxattr will
> read the size and then a temporary buffer of that size is allocated.
>
> So ERANGE should not be able to make it to the the condition at all.
Yes, I think you are right.

It might only happen in distributed filesystems(like cephfs) by concurrent
set/get from different clients, so in this case, checking -ERANGE condition
is reasonable(can add retry or some other error handlings) but the check
seems meaningless for local filesystems.

I have tested on some local filesystems before posting patch and found
there is no chance to make it to the -ERANGE condition. Even if we can
get into that condition set acl to NULL looks not correct.

In any case, I think we should remove the check 'size == -ERANGE' in 
btrfs_gat_acl(),
maybe I should change commit log to avoid misunderstanding.


Thanks,
Chengguang.
