Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:29907 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754189AbaHAIsq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Aug 2014 04:48:46 -0400
Date: Fri, 1 Aug 2014 18:48:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] common: get fs type again using device canonical name
 in _fs_type
Message-ID: <20140801084830.GW26465@dastard>
References: <1406479050-10601-1-git-send-email-eguan@redhat.com>
 <1406803957-10488-1-git-send-email-eguan@redhat.com>
 <20140801002159.GU26465@dastard>
 <20140801040240.GK7382@dhcp-13-216.nay.redhat.com>
 <20140801044910.GV26465@dastard>
 <20140801050258.GL7382@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140801050258.GL7382@dhcp-13-216.nay.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 01, 2014 at 01:02:58PM +0800, Eryu Guan wrote:
> On Fri, Aug 01, 2014 at 02:49:10PM +1000, Dave Chinner wrote:
> > On Fri, Aug 01, 2014 at 12:02:41PM +0800, Eryu Guan wrote:
> > > On Fri, Aug 01, 2014 at 10:21:59AM +1000, Dave Chinner wrote:
> > > > On Thu, Jul 31, 2014 at 06:52:37PM +0800, Eryu Guan wrote:
> > > > > When testing with lvm, a previous btrfsck run could change df output
> > > > > from something like
> > > > > 
> > > > > /dev/mapper/rhel_hp--dl388eg8--01-testlv1 btrfs 15728640 900 13602172 1% /mnt/btrfs
> > > > > 
> > > > > to
> > > > > 
> > > > > /dev/dm-3 btrfs 15728640 900 13602172 1% /mnt/btrfs
> > > > 
> > > > I don't follow you. Why would running btrfsck change the name of the
> > > > device? If the filesystem is umounted and mounted again, then the
> > > > device could change, but btrfsck should not be not doing the
> > > > unmount/mount, and so unless the TEST_DEV/SCRATCH_DEV is changing
> > > > the output of df should be identical...
> > > > 
> > > > So before we change the _fs_type() code, can you explain exactly
> > > > how, when and why the device name is changing to me?
> > > 
> > > Assume that we have two btrfs filesystems, kernel is 3.16.0-rc4+
> > > 
> > > [root@hp-dl388eg8-01 btrfs-progs]# btrfs fi show
> > > Label: none  uuid: 1aba7da5-ce2b-4af0-a716-db732abc60b2
> > >         Total devices 1 FS bytes used 384.00KiB
> > >         devid    1 size 15.00GiB used 2.04GiB path /dev/mapper/rhel_hp--dl388eg8--01-testlv1
> > > 
> > > Label: none  uuid: 26ff4f12-f6d9-4cbc-aae2-57febeefde37
> > >         Total devices 2 FS bytes used 112.00KiB
> > >         devid    1 size 15.00GiB used 2.03GiB path /dev/mapper/rhel_hp--dl388eg8--01-testlv2
> > >         devid    2 size 15.00GiB used 2.01GiB path /dev/mapper/rhel_hp--dl388eg8--01-testlv3
> > > 
> > > Btrfs v3.14.2
> > > 
> > > And testlv1 was mounted at /mnt/btrfs
> > > 
> > > [root@hp-dl388eg8-01 btrfs-progs]# df -TP /mnt/btrfs
> > > Filesystem                                Type  1024-blocks  Used Available Capacity Mounted on
> > > /dev/mapper/rhel_hp--dl388eg8--01-testlv1 btrfs    15728640   512  13602560       1% /mnt/btrfs
> > > 
> > > Now run btrfsck on testlv2, btrfsck will scan all btrfs devices and
> > > somehow change the device name.
> > > 
> > > [root@hp-dl388eg8-01 btrfs-progs]# btrfsck /dev/mapper/rhel_hp--dl388eg8--01-testlv2 >/dev/null 2>&1
> > > 
> > > # device name changed in df output and btrfs fi show output
> > > [root@hp-dl388eg8-01 btrfs-progs]# df -TP /mnt/btrfs
> > > Filesystem     Type  1024-blocks  Used Available Capacity Mounted on
> > > /dev/dm-3      btrfs    15728640   512  13602560       1% /mnt/btrfs
> > > [root@hp-dl388eg8-01 btrfs-progs]# btrfs fi show
> > > Label: none  uuid: 1aba7da5-ce2b-4af0-a716-db732abc60b2
> > >         Total devices 1 FS bytes used 384.00KiB
> > >         devid    1 size 15.00GiB used 2.04GiB path /dev/dm-3
> > > 
> > > Label: none  uuid: 26ff4f12-f6d9-4cbc-aae2-57febeefde37
> > >         Total devices 2 FS bytes used 112.00KiB
> > >         devid    1 size 15.00GiB used 2.03GiB path /dev/mapper/rhel_hp--dl388eg8--01-testlv2
> > >         devid    2 size 15.00GiB used 2.01GiB path /dev/mapper/rhel_hp--dl388eg8--01-testlv3
> > > 
> > > Btrfs v3.14.2
> > > 
> > > This only happens when btrfsck a btrfs with multiple devices, so this
> > > only affects xfstests run on btrfs with SCRATCH_DEV_POOL set to lvm
> > > lvs.
> > > 
> > > Maybe this is a bug of btrfs-progs and we should fix it there?
> > 
> > Yes, that smells of a btrfs-progs bug. If your /etc/mtab a link to
> > /proc/mounts? If not, does the contents change when you run btrfsck,
> > and does the problem go away when you replace /etc/mtab with a link
> > to /proc/mounts?
> 
> /etc/mtab is a symlink to /proc/self/mounts, so does /proc/mounts
> 
> [root@hp-dl388eg8-01 btrfs-progs]# ls -l /etc/mtab
> lrwxrwxrwx. 1 root root 17 Sep 22  2013 /etc/mtab -> /proc/self/mounts
> [root@hp-dl388eg8-01 btrfs-progs]# ls -l /proc/mounts
> lrwxrwxrwx. 1 root root 11 Aug  1 00:59 /proc/mounts -> self/mounts
> 
> And the device name also changed in /proc/mounts
> 
> [root@hp-dl388eg8-01 btrfs-progs]# grep btrfs /proc/mounts
> /dev/dm-3 /mnt/btrfs btrfs rw,seclabel,relatime,space_cache 0 0

Well, that's exactly the last thing *I* expected. The kernel just
doesn't change device names on mounted filesystems like that.

Oh, the device name comes from btrfs_show_devname().

So this definitely seems to me to be a btrfs bug - btrfsck is
causing the btrfs kernel code to change the name of devices
associated with unrelated, mounted filesystems to that which it is
operating on. That's just wrong. IOWs, btrfs needs fixing, not
xfstests, because that can bite during any test that runs btrfsck in
the middle of it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
