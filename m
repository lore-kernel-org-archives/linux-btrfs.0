Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51612 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755920AbdC2NWI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 09:22:08 -0400
Date: Wed, 29 Mar 2017 15:21:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: track exclusive filesystem operation in flags
Message-ID: <20170329132122.GD4781@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170328124421.30585-1-dsterba@suse.com>
 <ac95c9c4-ed2b-3a9f-f763-697bd63db56f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ac95c9c4-ed2b-3a9f-f763-697bd63db56f@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 29, 2017 at 06:01:37PM +0800, Anand Jain wrote:
> 
> 
> On 03/28/2017 08:44 PM, David Sterba wrote:
> > There are several operations, usually started from ioctls, that cannot
> > run concurrently. The status is tracked in
> > mutually_exclusive_operation_running as an atomic_t. We can easily track
> > the status as one of the per-filesystem flag bits with same
> > synchronization guarantees.
> >
> > The conversion replaces:
> >
> > * atomic_xchg(..., 1)    ->   test_and_set_bit(FLAG, ...)
> > * atomic_set(..., 0)     ->   clear_bit(FLAG, ...)
> 
> 
>     Makes sense.
> 
>    Reviewed-by: Anand Jain <anand.jain@oracle.com>
> 
>     However in the long term do you think its better to have
>     BTRFS_FS_EXCL_OP flag in the struct btrfs_fs_devices
>     rather than in struct btrfs_fs_info ? because we don't have
>     fs_info until device is mounted and in the long term we could
>     have a feature where volume can be maintained just after the
>     device scan without device being mounted.

I can't think of an example where it would be useful to move it out of
fs_info, so I'd need to know more details about the usecase. But the
flag makes sense only after the filesystem is mounted and all devices
are known, so what you suggest would be probably tracked by other flag
if necessary.
