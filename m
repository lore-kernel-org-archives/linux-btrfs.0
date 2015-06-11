Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33662 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751398AbbFKDw6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jun 2015 23:52:58 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'Omar Sandoval'" <osandov@osandov.com>, <linux-btrfs@vger.kernel.org>
CC: "'Miao Xie'" <miaoxie@huawei.com>, "'Philip'" <bugzilla@philip-seeger.de>
References: <cover.1431330020.git.osandov@osandov.com> <20150526170547.GA21342@mew.lv.cox.net>
In-Reply-To: <20150526170547.GA21342@mew.lv.cox.net>
Subject: RE: [PATCH 0/4] Btrfs: RAID 5/6 missing device replace
Date: Thu, 11 Jun 2015 11:52:30 +0800
Message-ID: <031201d0a3fa$0af404a0$20dc0de0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Omar Sandoval

I tested this patchset with my script, but see general protection fault
again.
NODE: kvm with virtio disk
ROOTFS: RHEL6 with btrfs-progs v4.0
KERNEL: v4.1-rc6 with 4 patchs in this patchset

Maybe my test have small different with yours,
but it seems is similar bug, could you check it?

My script:
****************
*** NOTE: update FS_DEVS in your own env before run ***
****************

#!/bin/bash

FS_DEVS=(/dev/vdd /dev/vde /dev/vdf)
PRUNE_DEV=/dev/vde
MNT=/mnt/btrfs_test_for_raid56_strip

do_cmd()
{
	echo "   $*"
	local output
	local ret
	output=$("$@" 2>&1)
	ret="$?"
	[[ "$ret" != 0 ]] && {
		echo "$output"
	}
	return "$ret"
}

mkdir -p "$MNT"
for ((i = 0; i < 10; i++)); do
	umount "$MNT" &>/dev/null
done
dmesg -c >/dev/null

echo "1: Creating filesystem"
do_cmd mkfs.btrfs -f -d raid5 -m raid5 "${FS_DEVS[@]}" || exit 1
do_cmd mount "$FS_DEVS" "$MNT" || exit 1

echo "2: Write some data"
DATA_CNT=4
for ((i = 0; i < DATA_CNT; i++)); do
	size_m="$((1<<i))"
	do_cmd dd bs=1M if=/dev/urandom of="$MNT"/file_"$i" count="$size_m" || exit 1
done

echo "3: Prune a disk in fs"
do_cmd umount "$MNT" || exit 1
do_cmd dd bs=1M if=/dev/zero of="$PRUNE_DEV" count=1
do_cmd mount -o "degraded" "$FS_DEVS" "$MNT" || exit 1

echo "4: Do scrub"
do_cmd btrfs scrub start -B "$MNT"

echo "5: Checking result"
if dmesg | grep -q 'general protection fault'; then
	echo "Result Fail"
	dmesg | grep -A10000 'general protection fault'	
else
	echo "Result OK"
fi

exit 0

Test result:
# ./bug.sh
1: Creating filesystem
   mkfs.btrfs -f -d raid5 -m raid5 /dev/vdd /dev/vde /dev/vdf
   mount /dev/vdd /mnt/btrfs_test_for_raid56_strip
2: Write some data
   dd bs=1M if=/dev/urandom of=/mnt/btrfs_test_for_raid56_strip/file_0 count=1
   dd bs=1M if=/dev/urandom of=/mnt/btrfs_test_for_raid56_strip/file_1 count=2
   dd bs=1M if=/dev/urandom of=/mnt/btrfs_test_for_raid56_strip/file_2 count=4
   dd bs=1M if=/dev/urandom of=/mnt/btrfs_test_for_raid56_strip/file_3 count=8
3: Prune a disk in fs
   umount /mnt/btrfs_test_for_raid56_strip
   dd bs=1M if=/dev/zero of=/dev/vde count=1
   mount -o degraded /dev/vdd /mnt/btrfs_test_for_raid56_strip
4: Do scrub
   btrfs scrub start -B /mnt/btrfs_test_for_raid56_strip
5: Checking result
Result Fail
[   48.899408] general protection fault: 0000 [#1] SMP
[   48.900021] Modules linked in:
[   48.900021] CPU: 0 PID: 2102 Comm: btrfs Not tainted 4.1.0-rc6_HEAD_c65b99f046843d2455aa231747b5a07a999a9f3d_ #53
[   48.900021] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5.1-0-g8936dbb-20141113_115728-nilsson.home.kraxel.org 04/01/2014
[   48.900021] task: ffff88003f6f5500 ti: ffff88003c954000 task.ti: ffff88003c954000
[   48.900021] RIP: 0010:[<ffffffff81441395>]  [<ffffffff81441395>] bio_add_page+0x15/0x70
[   48.900021] RSP: 0018:ffff88003c957718  EFLAGS: 00010246
[   48.900021] RAX: ffff88003b3ac6a8 RBX: ffff88003cb19000 RCX: 007fffc4001e58ca
[   48.900021] RDX: 000210868b41ffca RSI: ffffea0001273b60 RDI: ffff88003b3ac6a8
...

Thanks
Zhaolei

> From: linux-btrfs-owner@vger.kernel.org
> [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Omar Sandoval
> Sent: Wednesday, May 27, 2015 1:06 AM
> To: linux-btrfs@vger.kernel.org
> Cc: Miao Xie; Philip
> Subject: Re: [PATCH 0/4] Btrfs: RAID 5/6 missing device replace
> 
> On Mon, May 11, 2015 at 12:58:11AM -0700, Omar Sandoval wrote:
> > A user reported on Bugzilla that they were seeing kernel BUGs when
> > attempting to replace a missing device on a RAID 6 array. After
> > identifying the apparent cause of the BUG, I reached the conclusion
> > that there wasn't a quick fix. Maybe Miao Xie can point something out
> > that I missed, as he originally implemented device replace on RAID 5/6
> > :)
> >
> > Patch 4 has the details, but the main problem is that we can't create
> > bios for a missing device, so the main scrub code path isn't very
> > useful. On RAID 5/6, since we only have one mirror for any piece of
> > data, the missing device is the only mirror we can use. Clearly,
> > (unless I missed something), this case needs to be handled differently.
> >
> > These patches are on top of v4.1-rc2. I ran the scrub and replace
> > xfstests and the script below, which also reproduces the original BUG.
> >
> > Thanks!
> >
> > Omar Sandoval (4):
> >   Btrfs: remove misleading handling of missing device scrub
> >   Btrfs: count devices correctly in readahead during RAID 5/6 replace
> >   Btrfs: add RAID 5/6 BTRFS_RBIO_REBUILD_MISSING operation
> >   Btrfs: fix device replace of a missing RAID 5/6 device
> >
> >  fs/btrfs/raid56.c |  87 +++++++++++++++++++++++++----
> > fs/btrfs/raid56.h |  10 +++-
> >  fs/btrfs/reada.c  |   4 +-
> >  fs/btrfs/scrub.c  | 164
> > +++++++++++++++++++++++++++++++++++++++++++++---------
> >  4 files changed, 225 insertions(+), 40 deletions(-)
> >
> 
> Ping for review.
> 
> --
> Omar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

