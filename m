Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:48964 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408AbcECUey (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2016 16:34:54 -0400
Date: Tue, 3 May 2016 23:34:50 +0300
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: s_bdev is not null after missing replace
Message-ID: <20160503203449.GF1110@jeknote.loshitsa1.net>
References: <1460629450-2271-1-git-send-email-anand.jain@oracle.com>
 <20160503173148.GL29353@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160503173148.GL29353@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 03, 2016 at 07:31:48PM +0200, David Sterba wrote:
> On Thu, Apr 14, 2016 at 06:24:10PM +0800, Anand Jain wrote:
> > Yauhen reported in the ML that s_bdev is null at mount, and
> > s_bdev gets updated to some device when missing device is
> > replaced, as because bdev is null for missing device, things
> > gets matched up. Fix this by checking if s_bdev is set. I
> > didn't want to completely remove updating s_bdev because
> > the future multi device support at vfs layer may need it.
> > 
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> > Reported-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
> 
> Do you have a testcase for that? As there are more patches touching the
> device pointers I'd rather see some test coverage. Thanks.

Testcase is ('global spare' patchset is needed for device closing
support):

1) create RAID, mount -> s_bdev is NULL
2) replace latest device by another -> s_bdev is bdev of new drive
3) remove drive added by replace
4) touch mountpount and do btrfs fi sync (device will be closed and
marked as missing here) -> s_bdev is invalid pointer to closed and freed
bdev
5) unmount FS -> oops

Something like:

mkfs.btrfs -d raid5 -m raid5 <dev1> <dev2>... <devN-1>
mount <dev1> /mnt
btrfs replace start -B <devN-1> <devN> /mnt
_devmgt_remove <devN> # _devmgt_remove is helper for detaching scsi device
touch /mnt
btrfs fi sync /mnt
umount /mnt


I will try to make xfstest scripts for this case and for other cases
reported by me.

-- 
Yauhen Kharuzhy
