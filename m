Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbaHAECu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Aug 2014 00:02:50 -0400
Date: Fri, 1 Aug 2014 12:02:41 +0800
From: Eryu Guan <eguan@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] common: get fs type again using device canonical name
 in _fs_type
Message-ID: <20140801040240.GK7382@dhcp-13-216.nay.redhat.com>
References: <1406479050-10601-1-git-send-email-eguan@redhat.com>
 <1406803957-10488-1-git-send-email-eguan@redhat.com>
 <20140801002159.GU26465@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140801002159.GU26465@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 01, 2014 at 10:21:59AM +1000, Dave Chinner wrote:
> On Thu, Jul 31, 2014 at 06:52:37PM +0800, Eryu Guan wrote:
> > When testing with lvm, a previous btrfsck run could change df output
> > from something like
> > 
> > /dev/mapper/rhel_hp--dl388eg8--01-testlv1 btrfs 15728640 900 13602172 1% /mnt/btrfs
> > 
> > to
> > 
> > /dev/dm-3 btrfs 15728640 900 13602172 1% /mnt/btrfs
> 
> I don't follow you. Why would running btrfsck change the name of the
> device? If the filesystem is umounted and mounted again, then the
> device could change, but btrfsck should not be not doing the
> unmount/mount, and so unless the TEST_DEV/SCRATCH_DEV is changing
> the output of df should be identical...
> 
> So before we change the _fs_type() code, can you explain exactly
> how, when and why the device name is changing to me?

Assume that we have two btrfs filesystems, kernel is 3.16.0-rc4+

[root@hp-dl388eg8-01 btrfs-progs]# btrfs fi show
Label: none  uuid: 1aba7da5-ce2b-4af0-a716-db732abc60b2
        Total devices 1 FS bytes used 384.00KiB
        devid    1 size 15.00GiB used 2.04GiB path /dev/mapper/rhel_hp--dl388eg8--01-testlv1

Label: none  uuid: 26ff4f12-f6d9-4cbc-aae2-57febeefde37
        Total devices 2 FS bytes used 112.00KiB
        devid    1 size 15.00GiB used 2.03GiB path /dev/mapper/rhel_hp--dl388eg8--01-testlv2
        devid    2 size 15.00GiB used 2.01GiB path /dev/mapper/rhel_hp--dl388eg8--01-testlv3

Btrfs v3.14.2

And testlv1 was mounted at /mnt/btrfs

[root@hp-dl388eg8-01 btrfs-progs]# df -TP /mnt/btrfs
Filesystem                                Type  1024-blocks  Used Available Capacity Mounted on
/dev/mapper/rhel_hp--dl388eg8--01-testlv1 btrfs    15728640   512  13602560       1% /mnt/btrfs

Now run btrfsck on testlv2, btrfsck will scan all btrfs devices and
somehow change the device name.

[root@hp-dl388eg8-01 btrfs-progs]# btrfsck /dev/mapper/rhel_hp--dl388eg8--01-testlv2 >/dev/null 2>&1

# device name changed in df output and btrfs fi show output
[root@hp-dl388eg8-01 btrfs-progs]# df -TP /mnt/btrfs
Filesystem     Type  1024-blocks  Used Available Capacity Mounted on
/dev/dm-3      btrfs    15728640   512  13602560       1% /mnt/btrfs
[root@hp-dl388eg8-01 btrfs-progs]# btrfs fi show
Label: none  uuid: 1aba7da5-ce2b-4af0-a716-db732abc60b2
        Total devices 1 FS bytes used 384.00KiB
        devid    1 size 15.00GiB used 2.04GiB path /dev/dm-3

Label: none  uuid: 26ff4f12-f6d9-4cbc-aae2-57febeefde37
        Total devices 2 FS bytes used 112.00KiB
        devid    1 size 15.00GiB used 2.03GiB path /dev/mapper/rhel_hp--dl388eg8--01-testlv2
        devid    2 size 15.00GiB used 2.01GiB path /dev/mapper/rhel_hp--dl388eg8--01-testlv3

Btrfs v3.14.2

This only happens when btrfsck a btrfs with multiple devices, so this
only affects xfstests run on btrfs with SCRATCH_DEV_POOL set to lvm
lvs.

Maybe this is a bug of btrfs-progs and we should fix it there?

If we decide to take this patch, I'll put more details in commit log
in v3.

Thanks,
Eryu
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
