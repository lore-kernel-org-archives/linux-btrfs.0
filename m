Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47781 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751846AbdK1Xyb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 18:54:31 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vASNsUSs017161
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Nov 2017 23:54:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vASNsTQK015703
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Nov 2017 23:54:30 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vASNsTO6024474
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Nov 2017 23:54:29 GMT
Date: Tue, 28 Nov 2017 15:52:33 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: handle dynamically reappearing missing device
Message-ID: <20171128225233.GA11789@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <20171112105650.3248-1-anand.jain@oracle.com>
 <20171116232826.GB23614@dhcp-whq-twvpn-1-vpnpool-10-159-142-193.vpn.oracle.com>
 <1c1f74f1-5531-dc22-70a8-8d93a0571c7f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1c1f74f1-5531-dc22-70a8-8d93a0571c7f@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 17, 2017 at 07:53:29PM +0800, Anand Jain wrote:
> 
> 
> On 11/17/2017 07:28 AM, Liu Bo wrote:
> > On Sun, Nov 12, 2017 at 06:56:50PM +0800, Anand Jain wrote:
> > > If the device is not present at the time of (-o degrade) mount
> > > the mount context will create a dummy missing struct btrfs_device.
> > > Later this device may reappear after the FS is mounted.
> 
> > This commit log doesn't explain what would happen when the missing
> > device re-appears.
> 
>  Hm. You mean in the current design without this patch.?
>  Just nothing it gives a false impression to the user by
> 'btrfs dev ready' and 'btrfs fi show' that missing device
>  has been included. Will update change log.
> 
> > > So this
> > > patch handles that case by going through the open_device steps
> 
> > > which this device missed and finally adds to the device alloc list.
> > > 
> > > So now with this patch, to bring back the missing device user can run,
> > > 
> > >     btrfs dev scan <path-of-missing-device>
> > 
> > Most common distros already have some udev rules of btrfs to process a
> > reappeared disk.
> 
>  Right. Do you see anything that will break ?
>  Planning to add comments [1] in v2 for more clarity around this.
> 
> > > 
> > > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> > > ---
> > > This patch needs:
> > >   [PATCH 0/4]  factor __btrfs_open_devices()
> > > 
> > >   fs/btrfs/volumes.c | 43 +++++++++++++++++++++++++++++++++++++++++--
> > >   1 file changed, 41 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > > index d24e966ee29f..e7dd996831f2 100644
> > > --- a/fs/btrfs/volumes.c
> > > +++ b/fs/btrfs/volumes.c
> > > @@ -769,8 +769,47 @@ static noinline int device_list_add(const char *path,
> > >   		rcu_string_free(device->name);
> > >   		rcu_assign_pointer(device->name, name);
> > >   		if (device->missing) {
> > > -			fs_devices->missing_devices--;
> > > -			device->missing = 0;
> > > +			int ret;
> > > +			struct btrfs_fs_info *fs_info = fs_devices->fs_info;
> > > +			fmode_t fmode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
> > > +
> > > +			if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_SEEDING)
> > > +				fmode &= ~FMODE_WRITE;
> > > +
> > > +			/*
> > > +			 * Missing can be set only when FS is mounted.
> > > +			 * So here its always fs_devices->opened > 0 and most
> > > +			 * of the struct device members are already updated by
> > > +			 * the mount process even if this device was missing, so
> > > +			 * now follow the normal open device procedure for this
> > > +			 * device. The scrub will take care of filling the
> > > +			 * missing stripes for raid56 and balance for raid1 and
> > > +			 * raid10.
> > > +			 */
> > 
> > 
> > The idea looks good to me.
> > 
> > What if users skip balance/scrub given both could take a while?
> > 
> > Then btrfs takes the disks back and reads content from it, and it's OK
> > for raid1/10 as they may have a good copy,
> 
>  Yes, except for the split brain situation for which patches are
>  in the ML, review comments appreciated.
> 
> > but in case of raid56, it
> > might hit the reconstruction bug if two disks are missing and added
> > back, which I tried to address recently.
> 
> > At least ->writable should not be set until balance/scrub completes
> > the re-sync job.
> 
>  Hm. Why ?
>

(Sorry for the late reply.)

On second thought, write is OK since parity will be calculated along
writes.

Will check the v2.


Thanks,

-liubo
