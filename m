From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Way to quickly "revert back" to a snapshot?
Date: Fri, 30 Oct 2009 11:35:11 -0400
Message-ID: <20091030153511.GA9857@think>
References: <4AD9FCDC.6060107@ubuntu.com>
 <20091026093842.GF5564@think>
 <4AEA8D20.3020504@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: zheng.yan@oracle.com, linux-btrfs@vger.kernel.org
To: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AEA8D20.3020504@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 30, 2009 at 03:52:16PM +0900, TARUISI Hiroaki wrote:
> I'm trying to make this snapshots/subvolumes listing feature,
> I wonder how the interface should be.
> 
> I tried to make this feature using ioctl interface, but I don't
> know how to notify all subvolume informations because number
> of subvolumes are not known before search.
> (It may work, that we call number-notify ioctl before subvol-
>  listing ioctl itself, or we call subvol-listing ioctl repeatedly
>  to last subvolume. But both seem to be not good to me.)
> 
> Is there any other idea?

Thank you for working on this feature.

We find the subvolumes and snapshots by using the forward references in
the tree of tree roots, and the offset field of the key is set to the
root objectid of the subvolume/snapshot we have a reference on (see
root-tree.c:btrfs_add_root_ref())

So, my plan was to have a 'starting objectid' field in the struct we pass
from userland in the ioctl.   The ioctl would find the first reference
that is greater than the starting objectid.  rootid 0 is never used, so
passing zero is fine for the first call.

The ioctl would be called over and over again until it finds zero
subvols/snapshots.  I'd pass a buffer from userland so that it can
return a large list.

I think the ioctl should return the path name to the
subvolume/snapshot, which the kernel will have to find by walking the
directory back references up to the top level directory of the snapshot.
It will also need to return the root objectid so the application can
pass that into the next ioctl call.

Does this make sense?

-chris

