Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60236 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389387AbeHGROi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Aug 2018 13:14:38 -0400
Date: Tue, 7 Aug 2018 16:59:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/4] btrfs: fix race between free_stale_devices and
 close_fs_devices
Message-ID: <20180807145948.GH3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180726065334.30594-1-anand.jain@oracle.com>
 <20180726065334.30594-3-anand.jain@oracle.com>
 <20180801142948.GH3218@twin.jikos.cz>
 <ff16322e-6f2c-1e81-032d-651cfa23877f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ff16322e-6f2c-1e81-032d-651cfa23877f@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 02, 2018 at 05:29:12PM +0800, Anand Jain wrote:
> 
> 
> On 08/01/2018 10:29 PM, David Sterba wrote:
> > On Thu, Jul 26, 2018 at 02:53:32PM +0800, Anand Jain wrote:
> >> From: Anand Jain <Anand.Jain@oracle.com>
> >>
> >> %fs_devices can be free-ed by btrfs_free_stale_devices() when the
> >> close_fs_devices() drops fs_devices::opened to zero, but close_fs_devices
> >> tries to access the %fs_devices again without the device_list_mutex.
> >>
> >> Fix this by bringing the %fs_devices access with in the device_list_mutex.
> > 
> > AFAICS this cannot happen anymore because the two calls are serialized
> > by the uuid_mutex. But this was not the case when syzbot reported the
> > problem where your patch would apply.
> > 
> > The parallell access to opened and device list cannot happen when:
> > 
> > * btrfs_scan_one_device that wants to call btrfs_free_stale_devices
> > * btrfs_close_devices calls close_fs_devices
> > 
> > Fixed by the series:
> > 
> > btrfs: lift uuid_mutex to callers of btrfs_scan_one_device
> > btrfs: lift uuid_mutex to callers of btrfs_open_devices
> > btrfs: lift uuid_mutex to callers of btrfs_parse_early_options
> > btrfs: reorder initialization before the mount locks uuid_mutex
> > btrfs: fix mount and ioctl device scan ioctl race
> > 
> > If there's a race I don't see, please describe in more detail.
> 
>   Right. There is no race with the uuid_mutex patches as above.
> 
>   And I just found this- can we make close be consistent with its
>   open part.
>   btrfs_open_devices() hold device_list_mutex before the update to
>   fs_devices::opened. So close_fs_device() could do the same, and be
>   theoretically correct.

Or it can be the other way around, to push the device_list_mutex only
around the list_sort and open_fs_devices like:

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1144,15 +1144,15 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 
        lockdep_assert_held(&uuid_mutex);
 
-       mutex_lock(&fs_devices->device_list_mutex);
        if (fs_devices->opened) {
                fs_devices->opened++;
                ret = 0;
        } else {
+               mutex_lock(&fs_devices->device_list_mutex);
                list_sort(NULL, &fs_devices->devices, devid_cmp);
                ret = open_fs_devices(fs_devices, flags, holder);
+               mutex_unlock(&fs_devices->device_list_mutex);
        }
-       mutex_unlock(&fs_devices->device_list_mutex);
 
        return ret;
 }
