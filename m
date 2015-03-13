Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:33184 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbbCMVdX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Mar 2015 17:33:23 -0400
Received: by labmn12 with SMTP id mn12so25401462lab.0
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2015 14:33:21 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1426273928-26909-1-git-send-email-jbacik@fb.com>
References: <1426273928-26909-1-git-send-email-jbacik@fb.com>
Date: Fri, 13 Mar 2015 21:33:21 +0000
Message-ID: <CAL3q7H7A723zLdQz=ttmgGXWs7OYwNPk7_uU0UAhOLjhuv_pwA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix merge delalloc logic
From: Filipe David Manana <fdmanana@gmail.com>
To: Josef Bacik <jbacik@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 13, 2015 at 7:12 PM, Josef Bacik <jbacik@fb.com> wrote:
> My patch to properly count outstanding extents wrt MAX_EXTENT_SIZE introduced a
> regression when re-dirtying already dirty areas.  We have logic in split to make
> sure we are taking the largest space into account but didn't have it for merge,
> so it was sometimes making us think we were turning a tiny extent into a huge
> extent, when in reality we already had a huge extent and needed to use the other
> side in our logic.  This fixes the regression that was reported by a user on
> list.  Thanks,
>
> Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Josef,

Even with this patch applied (and the other patch you just sent) I
still get warnings during inode eviction (haven't checked however if
it's due to counter underflow or some other bad math). It's really
easy to reproduce, just run the fio job below on a fresh fs and umount
the fs when the fio job finishes.

[global]
ioengine=sync
direct=0
bssplit=130M/100
fallocate=none
filename=foobar

[job1]
numjobs=1
size=1G
rw=randwrite

The warnings:

[17246.258234] ------------[ cut here ]------------
[17246.259277] WARNING: CPU: 0 PID: 20795 at fs/btrfs/inode.c:8701
btrfs_destroy_inode+0x6a/0x227 [btrfs]()
[17246.261126] Modules linked in: btrfs dm_flakey dm_mod
crc32c_generic xor raid6_pq nfsd auth_rpcgss oid_registry nfs_acl nfs
lockd grace fscache sunrpc loop parport_pc psmouse microcode evdev
parport serio_raw pcspkr i2c_piix4 i2c_core processor thermal_sys
button ext4 crc16 jbd2 mbcache sg sr_mod cdrom sd_mod ata_generic
virtio_scsi floppy ata_piix virtio_pci virtio_ring libata e1000 virtio
scsi_mod [last unloaded: btrfs]
[17246.269427] CPU: 0 PID: 20795 Comm: umount Tainted: G        W
3.19.0-btrfs-next-7+ #1
[17246.271035] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org
04/01/2014
[17246.273523]  0000000000000009 ffff8802cc66bca8 ffffffff81424bf8
ffff88043d20f2d8
[17246.275049]  0000000000000000 ffff8802cc66bce8 ffffffff81045388
ffff8802cc66bd08
[17246.276284]  ffffffffa04b3af1 ffff88006dd5fc70 ffff88006dd5fcf8
ffff8802d5bad000
[17246.277862] Call Trace:
[17246.278386]  [<ffffffff81424bf8>] dump_stack+0x4c/0x65
[17246.279356]  [<ffffffff81045388>] warn_slowpath_common+0xa1/0xbb
[17246.281750]  [<ffffffffa04b3af1>] ? btrfs_destroy_inode+0x6a/0x227 [btrfs]
[17246.283265]  [<ffffffff81045445>] warn_slowpath_null+0x1a/0x1c
[17246.284576]  [<ffffffffa04b3af1>] btrfs_destroy_inode+0x6a/0x227 [btrfs]
[17246.286123]  [<ffffffff81167cbf>] destroy_inode+0x3b/0x54
[17246.287010]  [<ffffffff81168531>] evict+0x140/0x148
[17246.288152]  [<ffffffff81168572>] dispose_list+0x39/0x43
[17246.289336]  [<ffffffff811690f1>] evict_inodes+0xdc/0xeb
[17246.290521]  [<ffffffff81153fa5>] generic_shutdown_super+0x49/0xef
[17246.291852]  [<ffffffff8115425e>] kill_anon_super+0x13/0x1e
[17246.293108]  [<ffffffffa04801e3>] btrfs_kill_super+0x17/0x23 [btrfs]
[17246.294286]  [<ffffffff81154483>] deactivate_locked_super+0x3b/0x50
[17246.295431]  [<ffffffff81154923>] deactivate_super+0x3f/0x43
[17246.296575]  [<ffffffff8116b59a>] cleanup_mnt+0x59/0x78
[17246.297599]  [<ffffffff8116b5f9>] __cleanup_mnt+0x12/0x14
[17246.298619]  [<ffffffff8105d02b>] task_work_run+0x8f/0xbc
[17246.299645]  [<ffffffff810028d8>] do_notify_resume+0x5a/0x6b
[17246.300773]  [<ffffffff8123729b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[17246.302057]  [<ffffffff8142aaff>] int_signal+0x12/0x17
[17246.303039] ---[ end trace c7e9e410c129fbca ]---
[17246.303929] ------------[ cut here ]------------
[17246.304907] WARNING: CPU: 0 PID: 20795 at fs/btrfs/inode.c:8702
btrfs_destroy_inode+0x81/0x227 [btrfs]()
[17246.306722] Modules linked in: btrfs dm_flakey dm_mod
crc32c_generic xor raid6_pq nfsd auth_rpcgss oid_registry nfs_acl nfs
lockd grace fscache sunrpc loop parport_pc psmouse microcode evdev
parport serio_raw pcspkr i2c_piix4 i2c_core processor thermal_sys
button ext4 crc16 jbd2 mbcache sg sr_mod cdrom sd_mod ata_generic
virtio_scsi floppy ata_piix virtio_pci virtio_ring libata e1000 virtio
scsi_mod [last unloaded: btrfs]
[17246.317108] CPU: 0 PID: 20795 Comm: umount Tainted: G        W
3.19.0-btrfs-next-7+ #1
[17246.319040] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org
04/01/2014
[17246.321946]  0000000000000009 ffff8802cc66bca8 ffffffff81424bf8
ffff88043d20f2d8
[17246.323808]  0000000000000000 ffff8802cc66bce8 ffffffff81045388
ffff8802cc66bd08
[17246.325622]  ffffffffa04b3b08 ffff88006dd5fc70 ffff88006dd5fcf8
ffff8802d5bad000
[17246.327504] Call Trace:
[17246.328179]  [<ffffffff81424bf8>] dump_stack+0x4c/0x65
[17246.329300]  [<ffffffff81045388>] warn_slowpath_common+0xa1/0xbb
[17246.330441]  [<ffffffffa04b3b08>] ? btrfs_destroy_inode+0x81/0x227 [btrfs]
[17246.331706]  [<ffffffff81045445>] warn_slowpath_null+0x1a/0x1c
[17246.332877]  [<ffffffffa04b3b08>] btrfs_destroy_inode+0x81/0x227 [btrfs]
[17246.334143]  [<ffffffff81167cbf>] destroy_inode+0x3b/0x54
[17246.335157]  [<ffffffff81168531>] evict+0x140/0x148
[17246.336117]  [<ffffffff81168572>] dispose_list+0x39/0x43
[17246.337153]  [<ffffffff811690f1>] evict_inodes+0xdc/0xeb
[17246.338160]  [<ffffffff81153fa5>] generic_shutdown_super+0x49/0xef
[17246.339265]  [<ffffffff8115425e>] kill_anon_super+0x13/0x1e
[17246.341242]  [<ffffffffa04801e3>] btrfs_kill_super+0x17/0x23 [btrfs]
[17246.342555]  [<ffffffff81154483>] deactivate_locked_super+0x3b/0x50
[17246.344088]  [<ffffffff81154923>] deactivate_super+0x3f/0x43
[17246.345286]  [<ffffffff8116b59a>] cleanup_mnt+0x59/0x78
[17246.346375]  [<ffffffff8116b5f9>] __cleanup_mnt+0x12/0x14
[17246.347663]  [<ffffffff8105d02b>] task_work_run+0x8f/0xbc
[17246.348866]  [<ffffffff810028d8>] do_notify_resume+0x5a/0x6b
[17246.350072]  [<ffffffff8123729b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[17246.351375]  [<ffffffff8142aaff>] int_signal+0x12/0x17
[17246.352516] ---[ end trace c7e9e410c129fbcb ]---
[17246.508268] ------------[ cut here ]------------
[17246.509938] WARNING: CPU: 11 PID: 20795 at
fs/btrfs/extent-tree.c:4848 btrfs_free_block_groups+0x18f/0x322
[btrfs]()
[17246.513958] Modules linked in: btrfs dm_flakey dm_mod
crc32c_generic xor raid6_pq nfsd auth_rpcgss oid_registry nfs_acl nfs
lockd grace fscache sunrpc loop parport_pc psmouse microcode evdev
parport serio_raw pcspkr i2c_piix4 i2c_core processor thermal_sys
button ext4 crc16 jbd2 mbcache sg sr_mod cdrom sd_mod ata_generic
virtio_scsi floppy ata_piix virtio_pci virtio_ring libata e1000 virtio
scsi_mod [last unloaded: btrfs]
[17246.526586] CPU: 11 PID: 20795 Comm: umount Tainted: G        W
 3.19.0-btrfs-next-7+ #1
[17246.528835] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org
04/01/2014
[17246.531842]  0000000000000009 ffff8802cc66bcf8 ffffffff81424bf8
ffff88043d36f2d8
[17246.534668]  0000000000000000 ffff8802cc66bd38 ffffffff81045388
ffff8802cc66bd08
[17246.536798]  ffffffffa0497545 ffff880117a0c000 0000000000000000
ffff880117a0c0b0
[17246.538658] Call Trace:
[17246.539348]  [<ffffffff81424bf8>] dump_stack+0x4c/0x65
[17246.540612]  [<ffffffff81045388>] warn_slowpath_common+0xa1/0xbb
[17246.541993]  [<ffffffffa0497545>] ?
btrfs_free_block_groups+0x18f/0x322 [btrfs]
[17246.544558]  [<ffffffff81045445>] warn_slowpath_null+0x1a/0x1c
[17246.545830]  [<ffffffffa0497545>] btrfs_free_block_groups+0x18f/0x322 [btrfs]
[17246.547594]  [<ffffffffa04a2bc8>] close_ctree+0x203/0x33c [btrfs]
[17246.548799]  [<ffffffff811690f1>] ? evict_inodes+0xdc/0xeb
[17246.550806]  [<ffffffffa04803da>] btrfs_put_super+0x19/0x1b [btrfs]
[17246.551984]  [<ffffffff81153fcf>] generic_shutdown_super+0x73/0xef
[17246.553458]  [<ffffffff8115425e>] kill_anon_super+0x13/0x1e
[17246.554641]  [<ffffffffa04801e3>] btrfs_kill_super+0x17/0x23 [btrfs]
[17246.555834]  [<ffffffff81154483>] deactivate_locked_super+0x3b/0x50
[17246.557195]  [<ffffffff81154923>] deactivate_super+0x3f/0x43
[17246.558377]  [<ffffffff8116b59a>] cleanup_mnt+0x59/0x78
[17246.559472]  [<ffffffff8116b5f9>] __cleanup_mnt+0x12/0x14
[17246.560646]  [<ffffffff8105d02b>] task_work_run+0x8f/0xbc
[17246.561935]  [<ffffffff810028d8>] do_notify_resume+0x5a/0x6b
[17246.563127]  [<ffffffff8123729b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[17246.564528]  [<ffffffff8142aaff>] int_signal+0x12/0x17
[17246.565761] ---[ end trace c7e9e410c129fbcc ]---
[17246.566782] ------------[ cut here ]------------
[17246.567814] WARNING: CPU: 11 PID: 20795 at
fs/btrfs/extent-tree.c:4849 btrfs_free_block_groups+0x1aa/0x322
[btrfs]()
[17246.569950] Modules linked in: btrfs dm_flakey dm_mod
crc32c_generic xor raid6_pq nfsd auth_rpcgss oid_registry nfs_acl nfs
lockd grace fscache sunrpc loop parport_pc psmouse microcode evdev
parport serio_raw pcspkr i2c_piix4 i2c_core processor thermal_sys
button ext4 crc16 jbd2 mbcache sg sr_mod cdrom sd_mod ata_generic
virtio_scsi floppy ata_piix virtio_pci virtio_ring libata e1000 virtio
scsi_mod [last unloaded: btrfs]
[17246.581468] CPU: 11 PID: 20795 Comm: umount Tainted: G        W
 3.19.0-btrfs-next-7+ #1
[17246.583291] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org
04/01/2014
[17246.585940]  0000000000000009 ffff8802cc66bcf8 ffffffff81424bf8
ffff88043d36f2d8
[17246.588097]  0000000000000000 ffff8802cc66bd38 ffffffff81045388
ffff8802cc66bd08
[17246.590045]  ffffffffa0497560 ffff880117a0c000 0000000000000000
ffff880117a0c0b0
[17246.597886] Call Trace:
[17246.598538]  [<ffffffff81424bf8>] dump_stack+0x4c/0x65
[17246.599631]  [<ffffffff81045388>] warn_slowpath_common+0xa1/0xbb
[17246.601069]  [<ffffffffa0497560>] ?
btrfs_free_block_groups+0x1aa/0x322 [btrfs]
[17246.602758]  [<ffffffff81045445>] warn_slowpath_null+0x1a/0x1c
[17246.604005]  [<ffffffffa0497560>] btrfs_free_block_groups+0x1aa/0x322 [btrfs]
[17246.605508]  [<ffffffffa04a2bc8>] close_ctree+0x203/0x33c [btrfs]
[17246.606667]  [<ffffffff811690f1>] ? evict_inodes+0xdc/0xeb
[17246.607738]  [<ffffffffa04803da>] btrfs_put_super+0x19/0x1b [btrfs]
[17246.608976]  [<ffffffff81153fcf>] generic_shutdown_super+0x73/0xef
[17246.610822]  [<ffffffff8115425e>] kill_anon_super+0x13/0x1e
[17246.611927]  [<ffffffffa04801e3>] btrfs_kill_super+0x17/0x23 [btrfs]
[17246.613172]  [<ffffffff81154483>] deactivate_locked_super+0x3b/0x50
[17246.614287]  [<ffffffff81154923>] deactivate_super+0x3f/0x43
[17246.615155]  [<ffffffff8116b59a>] cleanup_mnt+0x59/0x78
[17246.616171]  [<ffffffff8116b5f9>] __cleanup_mnt+0x12/0x14
[17246.617287]  [<ffffffff8105d02b>] task_work_run+0x8f/0xbc
[17246.618386]  [<ffffffff810028d8>] do_notify_resume+0x5a/0x6b
[17246.619536]  [<ffffffff8123729b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[17246.620893]  [<ffffffff8142aaff>] int_signal+0x12/0x17
[17246.621987] ---[ end trace c7e9e410c129fbcd ]---


> ---
>  fs/btrfs/inode.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 91a87f5..97b601b 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1592,7 +1592,12 @@ static void btrfs_merge_extent_hook(struct inode *inode,
>                 return;
>
>         old_size = other->end - other->start + 1;
> -       new_size = old_size + (new->end - new->start + 1);
> +       if (old_size < (new->end - new->start + 1))
> +               old_size = (new->end - new->start + 1);
> +       if (new->start > other->start)
> +               new_size = new->end - other->start + 1;
> +       else
> +               new_size = other->end - new->start + 1;
>
>         /* we're not bigger than the max, unreserve the space and go */
>         if (new_size <= BTRFS_MAX_EXTENT_SIZE) {
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
