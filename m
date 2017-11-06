Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38453 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753054AbdKFNit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 08:38:49 -0500
Date: Mon, 6 Nov 2017 14:36:57 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/11] btrfs: document device locking
Message-ID: <20171106133657.GB28789@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1509471604.git.dsterba@suse.com>
 <5f3dc05b0b44803e9d20498970f259ead2bfe7de.1509471604.git.dsterba@suse.com>
 <798c9b24-4688-27f0-3553-c4313ba6bc91@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <798c9b24-4688-27f0-3553-c4313ba6bc91@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 03, 2017 at 07:13:01PM +0800, Anand Jain wrote:
> 
> 
> Thanks for writing this.
> 
> > + * - fs_devices::device_list_mutex (per-fs, with RCU)
> > + *
> > + *   protects updates to fs_devices::devices, ie. adding and deleting
> > + *
> > + *   simple list traversal with read-only actions can be done with RCU
> > + *   protection
> > + *
> > + *   may be used to exclude some operations from running concurrently without
> > + *   any modifications to the list (see write_all_supers)
> 
> > + * - volume_mutex
> > + *
> > + *   coarse lock owned by a mounted filesystem; used to exclude some operations
> > + *   that cannot run in parallel and affect the higher-level properties of the
> > + *   filesystem like: device add/deleting/resize/replace, or balance
> 
> > + * - chunk_mutex
> > + *
> > + *   protects chunks, adding or removing during allocation, trim or when
> > + *   a new device is added/removed
> 
> ::
> 
> > + * Lock nesting
> > + * ------------
> > + *
> > + * uuid_mutex
> > + *   volume_mutex
> > + *     device_list_mutex
> > + *       chunk_mutex
> > + *     balance_mutex
> 
> 
> If we have a list of operations that would consume these locks then we 
> can map it accordingly for better clarity.
> 
> To me it looks like we have too many locks.

I agree. Trivially we can remove the volume_mutex, because it copies
setting of BTRFS_FS_EXCL_OP, but this still needs some preparatory work
in the mount path. I have patches for that but I wanted to send out the
documentation first, that is supposed to reflect the current state.

>   - we don't have to differentiate the mounted and unmounted context
>     for device locks.

I'm not sure about that, the device registering happens outside of
mounted filesystems yet we touch the same structures on mounted
filesystem.

>   - Two lock would be sufficient, one for the device list
>     (add/rm,replace,..) and another for device property changes
>     (resize, trim,..).

I think this will be sorted once the volume_mutex is gone. The nature of
add/remove and trim is different, as trim does not change the high-level
status of devices, only locks the bloc groups. Resize and add/remove are
mutually exclusive so they need to be protected by a common lock.
