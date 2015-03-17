Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:34757 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbbCQLia (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 07:38:30 -0400
Received: by lbbsy1 with SMTP id sy1so4792181lbb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2015 04:38:29 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1426273943-27013-1-git-send-email-jbacik@fb.com>
References: <1426273943-27013-1-git-send-email-jbacik@fb.com>
Date: Tue, 17 Mar 2015 11:38:29 +0000
Message-ID: <CAL3q7H5cmMsO2-913xT7GPvxYPapN8aQda3SPb8yk0911MqfVw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: account for the correct number of extents for
 delalloc reservations
From: Filipe David Manana <fdmanana@gmail.com>
To: Josef Bacik <jbacik@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 13, 2015 at 7:12 PM, Josef Bacik <jbacik@fb.com> wrote:
> Direct IO can easily pass in an buffer that is greater than
> BTRFS_MAX_EXTENT_SIZE, so take this into account when reserving extents in the
> delalloc reservation code.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 0e9b3b2..3ac3fef 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5136,7 +5136,11 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
>         num_bytes = ALIGN(num_bytes, root->sectorsize);
>
>         spin_lock(&BTRFS_I(inode)->lock);
> -       BTRFS_I(inode)->outstanding_extents++;
> +       nr_extents = (unsigned)div64_u64(num_bytes +
> +                                        BTRFS_MAX_EXTENT_SIZE - 1,
> +                                        BTRFS_MAX_EXTENT_SIZE);
> +       BTRFS_I(inode)->outstanding_extents += nr_extents;
> +       nr_extents = 0;
>
>         if (BTRFS_I(inode)->outstanding_extents >
>             BTRFS_I(inode)->reserved_extents)

Josef, this still doesn't fix all problems/regressions.
I just modified fstests/generic/300 with the following patch:

diff --git a/tests/generic/300 b/tests/generic/300
index d7523aa..ba29929 100755
--- a/tests/generic/300
+++ b/tests/generic/300
@@ -84,8 +84,8 @@ exitall=1
 ## by external task
 [direct_aio_raicer]
 ioengine=libaio
-iodepth=128*${LOAD_FACTOR}
-bs=128k
+iodepth=8*${LOAD_FACTOR}
+bs=129M
 direct=1
 numjobs=${NUM_JOBS}
 rw=randwrite
@@ -93,43 +93,6 @@ runtime=100*${TIME_FACTOR}
 time_based
 filename=racer

-# Run falloc and punch_hole threads in parallel
-# After activity file will be highly fragmented
-[falloc_raicer]
-ioengine=falloc
-runtime=100*${TIME_FACTOR}
-iodepth=1
-bssplit=128k/80:512k/10:32k/10
-rw=randwrite
-numjobs=1
-filename=racer
-
-[punch_hole_raicer]
-ioengine=falloc
-runtime=100*${TIME_FACTOR}
-bs=4k
-time_based=10
-rw=randtrim
-numjobs=2
-filename=racer
-time_based
-
-# Verifier thread continiously write to newly allcated blocks
-# and veryfy written content
-[aio-dio-verifier]
-ioengine=libaio
-iodepth=128*${LOAD_FACTOR}
-numjobs=1
-verify=crc32c-intel
-verify_fatal=1
-verify_dump=1
-verify_backlog=1024
-verify_async=4
-verifysort=1
-direct=1
-bs=4k
-rw=randwrite
-filename=aio-dio-verifier
 EOF

 _workout()

-------------------

So that the patched test is:

#! /bin/bash
# FSQA Test No. 300
#
# AIO/DIO stress test
# Run random AIO/DIO activity and fallocate/punch_hole simultaneously
# Test will operate on huge sparsed file so ENOSPC is expected.
#
#-----------------------------------------------------------------------
# (c) 2013 Dmitry Monakhov
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it would be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write the Free Software Foundation,
# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
#-----------------------------------------------------------------------
#

seq=`basename $0`
seqres=$RESULT_DIR/$seq
echo "QA output created by $seq"

here=`pwd`
tmp=/tmp/$$
fio_config=$tmp.fio
status=1 # failure is the default!
trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15

# get standard environment, filters and checks
. ./common/rc
. ./common/filter

# real QA test starts here
_supported_fs generic
_supported_os Linux
_need_to_be_root
_require_scratch
_require_odirect

# xfs_io is not required for this test, but it's the best way to verify
# the test system supports fallocate() for allocation and hole punching
_require_xfs_io_command "falloc"
_require_xfs_io_command "fpunch"

rm -f $seqres.full

NUM_JOBS=$((4*LOAD_FACTOR))
BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
if [ $((BLK_DEV_SIZE)) -gt 1048576 ]
then
    BLK_DEV_SIZE=1048576
fi
FS_SIZE=$((BLK_DEV_SIZE * 512))

cat >$fio_config <<EOF
###########
# $seq test fio activity
# Run DIO, fallocate and punch_hole threads on a single in parallel
#
# If race exist old dio request may rewrite punched block after it was
# allocated to another file, we will catch that by verifying blocks content
#
[global]
directory=${SCRATCH_MNT}
filesize=${FS_SIZE}
size=999G
continue_on_error=write
ignore_error=,ENOSPC
error_dump=0

create_on_open=1
fallocate=none
exitall=1

## Perform direct aio, to files which may be truncated
## by external task
[direct_aio_raicer]
ioengine=libaio
iodepth=8*${LOAD_FACTOR}
bs=129M
direct=1
numjobs=${NUM_JOBS}
rw=randwrite
runtime=100*${TIME_FACTOR}
time_based
filename=racer

EOF

_workout()
{
echo ""
echo "Run fio with random aio-dio pattern"
echo ""
cat $fio_config >>  $seqres.full
run_check $FIO_PROG $fio_config
}

_require_fio $fio_config

_scratch_mkfs_sized $FS_SIZE >> $seqres.full 2>&1
_scratch_mount

if ! _workout; then
umount $SCRATCH_DEV 2>/dev/null
exit
fi

if ! _scratch_unmount; then
echo "failed to umount"
status=1
exit
fi
status=0
exit

--------------------

Running it sill produces several warnings when evicting the inode:

[ 2441.619587] WARNING: CPU: 0 PID: 9964 at fs/btrfs/inode.c:8718
btrfs_destroy_inode+0x6a/0x227 [btrfs]()
[ 2441.621357] Modules linked in: btrfs crc32c_generic xor raid6_pq
nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc
loop parport_pc microcode parport psmouse evdev processor pcspkr
serio_raw thermal_sys i2c_piix4 button i2c_core ext4 crc16 jbd2
mbcache sd_mod sg sr_mod cdrom virtio_scsi ata_generic virtio_pci
virtio_ring ata_piix virtio floppy e1000 libata scsi_mod [last
unloaded: btrfs]
[ 2441.630275] CPU: 0 PID: 9964 Comm: umount Tainted: G        W
3.19.0-btrfs-next-7+ #1
[ 2441.632402] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org
04/01/2014
[ 2441.635379]  0000000000000009 ffff8804297bbca8 ffffffff81424bf8
ffff88043d20f2d8
[ 2441.637555]  0000000000000000 ffff8804297bbce8 ffffffff81045388
ffff8804297bbd08
[ 2441.639596]  ffffffffa04bfb0c ffff8803e88e0c70 ffff8803e88e0cf8
ffff8803e6db4000
[ 2441.642329] Call Trace:
[ 2441.642945]  [<ffffffff81424bf8>] dump_stack+0x4c/0x65
[ 2441.644182]  [<ffffffff81045388>] warn_slowpath_common+0xa1/0xbb
[ 2441.645602]  [<ffffffffa04bfb0c>] ? btrfs_destroy_inode+0x6a/0x227 [btrfs]
[ 2441.647152]  [<ffffffff81045445>] warn_slowpath_null+0x1a/0x1c
[ 2441.648529]  [<ffffffffa04bfb0c>] btrfs_destroy_inode+0x6a/0x227 [btrfs]
[ 2441.650030]  [<ffffffff81167cbf>] destroy_inode+0x3b/0x54
[ 2441.651182]  [<ffffffff81168531>] evict+0x140/0x148
[ 2441.652220]  [<ffffffff81168572>] dispose_list+0x39/0x43
[ 2441.654604]  [<ffffffff811690f1>] evict_inodes+0xdc/0xeb
[ 2441.655699]  [<ffffffff81153fa5>] generic_shutdown_super+0x49/0xef
[ 2441.656987]  [<ffffffff8115425e>] kill_anon_super+0x13/0x1e
[ 2441.658128]  [<ffffffffa048c1e3>] btrfs_kill_super+0x17/0x23 [btrfs]
[ 2441.659332]  [<ffffffff81154483>] deactivate_locked_super+0x3b/0x50
[ 2441.660680]  [<ffffffff81154923>] deactivate_super+0x3f/0x43
[ 2441.661870]  [<ffffffff8116b59a>] cleanup_mnt+0x59/0x78
[ 2441.662981]  [<ffffffff8116b5f9>] __cleanup_mnt+0x12/0x14
[ 2441.663994]  [<ffffffff8105d02b>] task_work_run+0x8f/0xbc
[ 2441.665090]  [<ffffffff810028d8>] do_notify_resume+0x5a/0x6b
[ 2441.666206]  [<ffffffff8123729b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 2441.667394]  [<ffffffff8142aaff>] int_signal+0x12/0x17
[ 2441.668420] ---[ end trace 1f6352c6ccf4d655 ]---
[ 2441.669199] ------------[ cut here ]------------
[ 2441.670662] WARNING: CPU: 0 PID: 9964 at fs/btrfs/inode.c:8719
btrfs_destroy_inode+0x81/0x227 [btrfs]()
[ 2441.672553] Modules linked in: btrfs crc32c_generic xor raid6_pq
nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc
loop parport_pc microcode parport psmouse evdev processor pcspkr
serio_raw thermal_sys i2c_piix4 button i2c_core ext4 crc16 jbd2
mbcache sd_mod sg sr_mod cdrom virtio_scsi ata_generic virtio_pci
virtio_ring ata_piix virtio floppy e1000 libata scsi_mod [last
unloaded: btrfs]
[ 2441.680234] CPU: 0 PID: 9964 Comm: umount Tainted: G        W
3.19.0-btrfs-next-7+ #1
[ 2441.681820] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org
04/01/2014
[ 2441.684221]  0000000000000009 ffff8804297bbca8 ffffffff81424bf8
ffff88043d20f2d8
[ 2441.686642]  0000000000000000 ffff8804297bbce8 ffffffff81045388
ffff8804297bbd08
[ 2441.688253]  ffffffffa04bfb23 ffff8803e88e0c70 ffff8803e88e0cf8
ffff8803e6db4000
[ 2441.689790] Call Trace:
[ 2441.690328]  [<ffffffff81424bf8>] dump_stack+0x4c/0x65
[ 2441.691307]  [<ffffffff81045388>] warn_slowpath_common+0xa1/0xbb
[ 2441.692506]  [<ffffffffa04bfb23>] ? btrfs_destroy_inode+0x81/0x227 [btrfs]
[ 2441.693809]  [<ffffffff81045445>] warn_slowpath_null+0x1a/0x1c
[ 2441.694911]  [<ffffffffa04bfb23>] btrfs_destroy_inode+0x81/0x227 [btrfs]
[ 2441.696196]  [<ffffffff81167cbf>] destroy_inode+0x3b/0x54
[ 2441.697194]  [<ffffffff81168531>] evict+0x140/0x148
[ 2441.697989]  [<ffffffff81168572>] dispose_list+0x39/0x43
[ 2441.698799]  [<ffffffff811690f1>] evict_inodes+0xdc/0xeb
[ 2441.699770]  [<ffffffff81153fa5>] generic_shutdown_super+0x49/0xef
[ 2441.701634]  [<ffffffff8115425e>] kill_anon_super+0x13/0x1e
[ 2441.702707]  [<ffffffffa048c1e3>] btrfs_kill_super+0x17/0x23 [btrfs]
[ 2441.703875]  [<ffffffff81154483>] deactivate_locked_super+0x3b/0x50
[ 2441.705069]  [<ffffffff81154923>] deactivate_super+0x3f/0x43
[ 2441.706152]  [<ffffffff8116b59a>] cleanup_mnt+0x59/0x78
[ 2441.707136]  [<ffffffff8116b5f9>] __cleanup_mnt+0x12/0x14
[ 2441.708241]  [<ffffffff8105d02b>] task_work_run+0x8f/0xbc
[ 2441.709209]  [<ffffffff810028d8>] do_notify_resume+0x5a/0x6b
[ 2441.710236]  [<ffffffff8123729b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 2441.711321]  [<ffffffff8142aaff>] int_signal+0x12/0x17
[ 2441.712355] ---[ end trace 1f6352c6ccf4d656 ]---
[ 2441.820404] ------------[ cut here ]------------
[ 2441.821786] WARNING: CPU: 0 PID: 9964 at
fs/btrfs/extent-tree.c:4848 btrfs_free_block_groups+0x18f/0x322
[btrfs]()
[ 2441.825336] Modules linked in: btrfs crc32c_generic xor raid6_pq
nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc
loop parport_pc microcode parport psmouse evdev processor pcspkr
serio_raw thermal_sys i2c_piix4 button i2c_core ext4 crc16 jbd2
mbcache sd_mod sg sr_mod cdrom virtio_scsi ata_generic virtio_pci
virtio_ring ata_piix virtio floppy e1000 libata scsi_mod [last
unloaded: btrfs]
[ 2441.835747] CPU: 0 PID: 9964 Comm: umount Tainted: G        W
3.19.0-btrfs-next-7+ #1
[ 2441.837400] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org
04/01/2014
[ 2441.839899]  0000000000000009 ffff8804297bbcf8 ffffffff81424bf8
ffff88043d20f2d8
[ 2441.841461]  0000000000000000 ffff8804297bbd38 ffffffff81045388
ffff8804297bbd08
[ 2441.842990]  ffffffffa04a3545 ffff8802e0878000 0000000000000000
ffff8802e08780b0
[ 2441.845368] Call Trace:
[ 2441.845904]  [<ffffffff81424bf8>] dump_stack+0x4c/0x65
[ 2441.846880]  [<ffffffff81045388>] warn_slowpath_common+0xa1/0xbb
[ 2441.847997]  [<ffffffffa04a3545>] ?
btrfs_free_block_groups+0x18f/0x322 [btrfs]
[ 2441.849480]  [<ffffffff81045445>] warn_slowpath_null+0x1a/0x1c
[ 2441.851393]  [<ffffffffa04a3545>] btrfs_free_block_groups+0x18f/0x322 [btrfs]
[ 2441.852868]  [<ffffffffa04aebc8>] close_ctree+0x203/0x33c [btrfs]
[ 2441.854406]  [<ffffffff811690f1>] ? evict_inodes+0xdc/0xeb
[ 2441.855716]  [<ffffffffa048c3da>] btrfs_put_super+0x19/0x1b [btrfs]
[ 2441.857232]  [<ffffffff81153fcf>] generic_shutdown_super+0x73/0xef
[ 2441.858600]  [<ffffffff8115425e>] kill_anon_super+0x13/0x1e
[ 2441.859633]  [<ffffffffa048c1e3>] btrfs_kill_super+0x17/0x23 [btrfs]
[ 2441.861047]  [<ffffffff81154483>] deactivate_locked_super+0x3b/0x50
[ 2441.862383]  [<ffffffff81154923>] deactivate_super+0x3f/0x43
[ 2441.863659]  [<ffffffff8116b59a>] cleanup_mnt+0x59/0x78
[ 2441.864902]  [<ffffffff8116b5f9>] __cleanup_mnt+0x12/0x14
[ 2441.866255]  [<ffffffff8105d02b>] task_work_run+0x8f/0xbc
[ 2441.867470]  [<ffffffff810028d8>] do_notify_resume+0x5a/0x6b
[ 2441.868729]  [<ffffffff8123729b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 2441.870036]  [<ffffffff8142aaff>] int_signal+0x12/0x17
[ 2441.871166] ---[ end trace 1f6352c6ccf4d657 ]---
[ 2441.872327] ------------[ cut here ]------------
[ 2441.873500] WARNING: CPU: 0 PID: 9964 at
fs/btrfs/extent-tree.c:4849 btrfs_free_block_groups+0x1aa/0x322
[btrfs]()
[ 2441.875983] Modules linked in: btrfs crc32c_generic xor raid6_pq
nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc
loop parport_pc microcode parport psmouse evdev processor pcspkr
serio_raw thermal_sys i2c_piix4 button i2c_core ext4 crc16 jbd2
mbcache sd_mod sg sr_mod cdrom virtio_scsi ata_generic virtio_pci
virtio_ring ata_piix virtio floppy e1000 libata scsi_mod [last
unloaded: btrfs]
[ 2441.884957] CPU: 0 PID: 9964 Comm: umount Tainted: G        W
3.19.0-btrfs-next-7+ #1
[ 2441.886629] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org
04/01/2014
[ 2441.888660]  0000000000000009 ffff8804297bbcf8 ffffffff81424bf8
ffff88043d20f2d8
[ 2441.890192]  0000000000000000 ffff8804297bbd38 ffffffff81045388
ffff8804297bbd08
[ 2441.891840]  ffffffffa04a3560 ffff8802e0878000 0000000000000000
ffff8802e08780b0
[ 2441.893575] Call Trace:
[ 2441.894149]  [<ffffffff81424bf8>] dump_stack+0x4c/0x65
[ 2441.895199]  [<ffffffff81045388>] warn_slowpath_common+0xa1/0xbb
[ 2441.896488]  [<ffffffffa04a3560>] ?
btrfs_free_block_groups+0x1aa/0x322 [btrfs]
[ 2441.897998]  [<ffffffff81045445>] warn_slowpath_null+0x1a/0x1c
[ 2441.898873]  [<ffffffffa04a3560>] btrfs_free_block_groups+0x1aa/0x322 [btrfs]
[ 2441.900528]  [<ffffffffa04aebc8>] close_ctree+0x203/0x33c [btrfs]
[ 2441.901812]  [<ffffffff811690f1>] ? evict_inodes+0xdc/0xeb
[ 2441.902953]  [<ffffffffa048c3da>] btrfs_put_super+0x19/0x1b [btrfs]
[ 2441.904160]  [<ffffffff81153fcf>] generic_shutdown_super+0x73/0xef
[ 2441.905907]  [<ffffffff8115425e>] kill_anon_super+0x13/0x1e
[ 2441.906960]  [<ffffffffa048c1e3>] btrfs_kill_super+0x17/0x23 [btrfs]
[ 2441.908189]  [<ffffffff81154483>] deactivate_locked_super+0x3b/0x50
[ 2441.909387]  [<ffffffff81154923>] deactivate_super+0x3f/0x43
[ 2441.911352]  [<ffffffff8116b59a>] cleanup_mnt+0x59/0x78
[ 2441.912570]  [<ffffffff8116b5f9>] __cleanup_mnt+0x12/0x14
[ 2441.913772]  [<ffffffff8105d02b>] task_work_run+0x8f/0xbc
[ 2441.914856]  [<ffffffff810028d8>] do_notify_resume+0x5a/0x6b
[ 2441.915957]  [<ffffffff8123729b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 2441.917342]  [<ffffffff8142aaff>] int_signal+0x12/0x17
[ 2441.918450] ---[ end trace 1f6352c6ccf4d658 ]---



> --
> 1.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
