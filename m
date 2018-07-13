Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37698 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729643AbeGMNJm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 09:09:42 -0400
Date: Fri, 13 Jul 2018 14:55:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/7] btrfs: extend critical section when scanning a new
 device
Message-ID: <20180713125504.GU3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1529516226.git.dsterba@suse.com>
 <92caa5382783c709d6ddab7d06747327bd7c120c.1529516228.git.dsterba@suse.com>
 <d5b69aad-2ffb-4322-9c8d-e0003056b430@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d5b69aad-2ffb-4322-9c8d-e0003056b430@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 04, 2018 at 04:18:09PM +0800, Anand Jain wrote:
> 
> 
> On 06/21/2018 01:51 AM, David Sterba wrote:
> > The stale device list removal needs to be protected by device_list_mutex
> > too as this could delete from the list and could race with another list
> > modification and cause crash.
> > 
> > The device needs to be fully initialized before it's added to the list
> > so the fs_devices also need to be set under the mutex.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >   fs/btrfs/volumes.c | 5 ++---
> >   1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index 1da162928d1a..02246f9af0a3 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -791,12 +791,11 @@ static noinline struct btrfs_device *device_list_add(const char *path,
> >   		rcu_assign_pointer(device->name, name);
> >   
> >   		mutex_lock(&fs_devices->device_list_mutex);
> > +		device->fs_devices = fs_devices;
> >   		list_add_rcu(&device->dev_list, &fs_devices->devices);
> >   		fs_devices->num_devices++;
> > -		mutex_unlock(&fs_devices->device_list_mutex);
> > -
> > -		device->fs_devices = fs_devices;
> >   		btrfs_free_stale_devices(path, device);
> 
> 
> This is not correct.
> 
> btrfs_free_stale_devices need the per fs_devices local device_list_mutex
> lock as it traverses through the fs_uuids list. Holding just the lock of
> the %fs_devices which is being scanned or mounted is not correct.

I see, ok. The use of fs_devs is not very visible in
btrfs_free_stale_devices but at least the function comment hints that
all devices are being traversed.
