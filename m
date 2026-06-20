Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292441799F
	for <linux-btrfs@vger.kernel.org>; Sat, 20 Jun 2026 00:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781916269; cv=none; b=TI9OgP+DKzXVA9eQIdIjAXrDM+76WXkix6IPSC70sBavZfTaAxU1xhGt3844rUMpHEsKztUFYOPyerb9kGu+7y9lp0cqK8YkAskdGO4ucTWwhZXmLw8M/M4YKip3Ujz+IQz5YvtwHlNNjDzu+eiCy3iaLvDUZ8Q0SbvbnkoFq9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781916269; c=relaxed/simple;
	bh=OFM/91irasDpAdGK1uJ/363sgV83gG4n+n3A5KEQAzE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=qH0/3du3UuEVMUXQLqhy1gWpj75bClejMwl2JhJkGH9ObFCTTQBub/2nZhaYLk9gSvNTjfXJDVbkkNQHNOLpyFMKICnTWxSUsjHd3KIg1g+Hr9epLmnnJQLyyIIRCjFKTXZOJRWrgghlkELWMOsLYtcST22xE+0gkxCooRfi3b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LJrPgnTb; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LJrPgnTb"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4903d730b1fso35236705e9.2
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 17:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781916265; x=1782521065; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ths5tBiy0phk0xx2hMEA0IqscASbnuY6ehR+OePfTwA=;
        b=LJrPgnTbLPqDHN5QycMdTD+zmwF4NhURYD/wf2d97hGD7FZvk4CKGSIz6v383rv+jI
         OzLABLt07288+DWqiE2aihUTNCFk7aRgHbGzogYLJVEN9hmfaxgGjmA6MdKRl1H9T9Jm
         X74CehUNBeZcgJ2IHGmQuIxS8P3FiOGit4PC29yHDtpWQztLz3/u1JAqDNfY4rNEKkH/
         IcEUu/qviBXzmCYSag37knelHkvS3EzMAR362B+IuiT4/u2cK4hc9ghCLu4mbt382yLI
         rjvgFjdwDYPc2jVqaSygOYK2qF1MffdvSY8OvOvj6uDOzd6WKZsH0CTF5UC7tpZMycN4
         77Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781916265; x=1782521065;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ths5tBiy0phk0xx2hMEA0IqscASbnuY6ehR+OePfTwA=;
        b=UA9gp1r5sCtV/mkuox+m6mQb/fgyoifI1+3GNM/DpqtHwtKJQ6XrfyIPpaYf1WLCcW
         vubD4eCmeexdW9vZFAca+MTWo19mxTXVV7f7nrqjXHQNzt9TgoPf9kPduq0uXQZXmsNy
         9W8oWquo1unG3ZaTXnYdZ8yLu6Ib1Z/FEYAk1a7slaW9ZfLkd60ZrRzpXgSnJsy9YhIy
         tUw46NC3pARWZhmKDjckvrcw7muqdVb/yeDFFsR6O7pMQ/4BS7Syg9Vdobhu6YNpRxrC
         8Wux5vK8SHtPOjUq+TkBSklZuu05KGOOitneTbCqW0InuopJ325YyyNfvsqtE2AJKug0
         Jz8g==
X-Gm-Message-State: AOJu0YwQxIWpqC92d+8w0IvT0zMu1co2Z4/VogHIXcrSaYAa3Q3Uu0B4
	h46lSJzM4J6+v1TdGzyNhD7sD9BtAA7MgEtRGvR4Tkp5wND1PkOLoqeW5ZygO+ZJWpk=
X-Gm-Gg: AfdE7cnU/eyUKWbabigMyIwo7vBGO/cK1G1LcAJrYep9DwxPh+oh7QIGud6AAFrBqzw
	xxJl4CTKhQCdohs50qXIobjo7sfPuqi4+SSLWPOKGuVK0CoLx9iwRR/3qUAb0RvWsl+yR1vmiuL
	cXpQlnMjvYf/TREu9JcZEgEPxvbGw0ro/9r3SKS6NgZQKCxdLd1FbXNrI5eQkCZcoikiJLGt51S
	h0FLeLsKlf2OBUV9SWgQqOWN49DY+DtqPCutOQ940SLKdzZZfgTglDtVjTghM7QGpNrU6Wew17D
	T39d67Sc/Bx+9r3vnKabaHW7LI9fyzL27SpT+QKwNlv5wey59N2pH8Ym0oUJZnIuVSINKt5T0fX
	A5MRsTkVWOPGoeAPFYnOPlNKSldIOY0zYP2FFGmIutkfsHFLPdW2B1fnv7xQ6Vvttd2WmtPZ7ux
	3dJur364rnMfcq7C8=
X-Received: by 2002:a05:600c:1f90:b0:490:3fdd:d353 with SMTP id 5b1f17b1804b1-4923ef47cfdmr107062095e9.8.1781916265435;
        Fri, 19 Jun 2026 17:44:25 -0700 (PDT)
Received: from smtpclient.apple ([154.26.180.185])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139adcaad8fsm890653c88.1.2026.06.19.17.44.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jun 2026 17:44:24 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3891.100.17.1.3\))
Subject: Re: [PATCH v3] btrfs: warn about extent buffer that can not be
 released
From: Glass Su <glass.su@suse.com>
In-Reply-To: <4ac4a9f2c599841b00f39f3be082432f43130f3e.1776379191.git.wqu@suse.com>
Date: Sat, 20 Jun 2026 08:44:08 +0800
Cc: linux-btrfs@vger.kernel.org,
 AHN SEOK-YOUNG <iamsyahn@gmail.com>,
 Teng Liu <27rabbitlt@gmail.com>,
 Su Yue <l@damenly.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DC0C775E-13B3-47D9-9AB2-895BB11C029D@suse.com>
References: <4ac4a9f2c599841b00f39f3be082432f43130f3e.1776379191.git.wqu@suse.com>
To: Qu Wenruo <wqu@suse.com>
X-Mailer: Apple Mail (2.3891.100.17.1.3)




On Fri, Apr 17, 2026 at 6:47=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>=20
> When we unmount the fs or during mount failures, btrfs will call
> invalidate_inode_pages() to release all btree inode folios.
>=20
> However that function can return -EBUSY if any folios can not be
> invalidated.
> This can be caused by:
>=20
> - Some extent buffers are still held by btrfs
>  This is a logic error, as we should release all tree root nodes
>  during unmount and mount failure handling.
>=20
> - Some extent buffers are under readahead and haven't yet finished
>  This is much rarer but valid cases.
>  In that case we should wait for those extent buffers.
>=20
> Introduce a new helper invalidate_btree_folios() which will:
>=20
> - Call invalidate_inode_pages2() and catch its return value
>  If it returned 0 as expected, that's great and we can call it a day.
>=20
> - Otherwise go through each extent buffer in buffer_tree
>  Increase the ref by one first for the eb we're checking.
>  This is to ensure the eb won't be freed after the readahead is
>  finished.
>=20
>  For eb that still has EXTENT_BUFFER_READING flag, wait for them to
>  finish first.
>=20
>  After waiting for the readahead, check the refs of the eb and if it's
>  still dirty.
>=20
>  If the eb refs is greater than 2 (one for the buffer tree, one hold =
by
>  us), it means we are still holding the extent buffer somewhere else,
>  which is a logic bug.
>=20
>  If the eb is still dirty, it means a bug in transaction handling.
>  Unfortunately there are already test cases triggering this warning, =
so
>  our transaction cleanup hasn't done its work reliably.
>=20
>  For either case, show a warning message about the eb, including its
>  bytenr, owner, refs and flags.
>  And if it's a debug build, also trigger WARN_ON_ONCE() so that =
fstests
>  can properly catch such situation.
>=20
> Furthermore, to help debugging the unreleased extent buffers, output =
the
> transid of the current aborted transaction, so that we can know which
> transaction the unreleased extent buffers belong to.
>=20
> This will help future debugging as we're already hitting the new
> warnings from test cases like generic/388.
>=20
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D221270
> Reported-by: AHN SEOK-YOUNG <iamsyahn@gmail.com>
> Cc: Teng Liu <27rabbitlt@gmail.com>
> Tested-by: Teng Liu <27rabbitlt@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v3:
> - Revert the DEBUG_WANR_ON_ONCE() change
>  As there is only one user, a simple
>  WARN_ON_ONCE(IS_ENABLED(CONFIG_BTRFS_DEBUG)) is more than enough.
>=20
> - Output the generation of the unreleased eb too
>  Since it's possible to have 2 transactions (one committing and =
reached
>  UNBLOCKED state, one new running), the generation output will help us
>  to know which transaction the unreleased eb belongs to.
>=20
> - Also output the transid when a transaction is aborted
>  To co-operate with the above change for debugging.
>=20
> v2:
> - Add one extra ref before checking the eb
>  Although readahead has one extra ref, after the readahead finished =
the
>  extra ref will be dropped, and memory pressure can kick in to free =
the
>  extent buffer.
>=20
> - Use rcu lock with xa_for_each() instead of xas lock and =
xas_for_each()
>  Since we're holding one extra eb ref to prevent eb from disappearing,
>  we no longer needs the more strict xas lock nor the extra xas
>  pause/unlock.
>=20
>  Although xa_for_each() is more time consuming, we're at the cold path
>  already, not a huge cost.
>=20
> - Remove the temporarary void pointer
>  And pass eb pointer directly into xas_for_each().
>=20
> - Introduce DEBUG_WARN_ON_ONCE() helper
>  To follow the existing DEBUG_WARN() helper.
>=20
> - Fix a typo
>=20
> - Also fix the checkpatch warning on the exist DEBUG_WARN()
> ---
> fs/btrfs/disk-io.c     | 49 ++++++++++++++++++++++++++++++++++++++++--
> fs/btrfs/extent_io.c   |  6 ------
> fs/btrfs/extent_io.h   |  6 ++++++
> fs/btrfs/transaction.h |  8 +++----
> 4 files changed, 57 insertions(+), 12 deletions(-)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 7800a1b20290..241acdc16da1 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3272,6 +3272,51 @@ static bool fs_is_full_ro(const struct =
btrfs_fs_info *fs_info)
>        return false;
> }
>=20
> +static void invalidate_btree_folios(struct btrfs_fs_info *fs_info)
> +{
> +       unsigned long index =3D 0;
> +       struct extent_buffer *eb;
> +       int ret;
> +
> +       ret =3D =
invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> +       if (likely(ret =3D=3D 0))
> +               return;
> +
> +       /*
> +        * Some btree pages can not be invalidated, this happens when =
some
> +        * tree blocks are still held (either by some pointer or =
readahead).
> +        */
> +       rcu_read_lock();
> +       xa_for_each(&fs_info->buffer_tree, index, eb) {
> +               /* Increase the ref so that the eb won't disappear. */
> +               if (!refcount_inc_not_zero(&eb->refs))
> +                       continue;
> +               rcu_read_unlock();
> +
> +               /* Wait for any readahead first. */
> +               if (test_bit(EXTENT_BUFFER_READING, &eb->bflags))
> +                       wait_on_bit_io(&eb->bflags, =
EXTENT_BUFFER_READING,
> +                                      TASK_UNINTERRUPTIBLE);
> +               /*
> +                * The refs threshold is 2, one hold by us at the =
beginning
> +                * of the loop, one for the ownership in the buffer =
tree.
> +                */

However, IIUC, there is still a small window between =
clear_extent_buffer_reading()
and free_extent_buffer() in end_bbio_meta_read().=20

btrfs/298 with added DEBUG output:

[47724.849583] BTRFS info (device sdd): first mount of filesystem =
f9bf732a-a19b-44b9-99a7-614ddff168e2
[47724.849597] BTRFS info (device sdd): using crc32c checksum algorithm
[47724.854471] DEBUG: before clear_extent_buffer_reading on 365985792 =
refs 3
[47724.855333] BTRFS error (device sdd): failed to find fsid =
cb2fdb42-b638-4f2f-badd-4127467ba674 when attempting to open seed =
devices
[47724.855349] BTRFS error (device sdd): failed to read chunk tree: -2
[47724.855403] ------------[ cut here ]------------
[47724.855405] WARNING: disk-io.c:3342 at =
invalidate_and_check_btree_folios+0x260/0x3c0 [btrfs], CPU#4: =
mount/125993
[47724.855503] Modules linked in: btrfs(OE) xor(E) libblake2b(E) =
raid6_pq(E) sctp(E) ip6_udp_tunnel(E) udp_tunnel(E) dm_mod(E) =
virtio_net(E) net_failover(E) arm_smccc_trng(E) failover(E) =
virtio_balloon(E) vfat(E) fat(E) drm(E) fuse(E) xfs(E) virtio_scsi(E) =
qemu_fw_cfg(E) virtio_pci(E) virtio_pci_legacy_dev(E) =
virtio_pci_modern_dev(E) virtio_console(E) virtio_rng(E) rng_core(E) =
[last unloaded: xor(E)]
[47724.855549] CPU: 4 UID: 0 PID: 125993 Comm: mount Tainted: G        W =
 OE       7.1.0-rc7-custom+ #1 PREEMPT(full)
[47724.855555] Tainted: [W]=3DWARN, [O]=3DOOT_MODULE, =
[E]=3DUNSIGNED_MODULE
[47724.855558] Hardware name: QEMU KVM Virtual Machine, BIOS =
edk2-20250812-19.fc42 08/12/2025
[47724.855561] pstate: 21400005 (nzCv daif +PAN -UAO -TCO +DIT -SSBS =
BTYPE=3D--)
[47724.855564] pc : invalidate_and_check_btree_folios+0x260/0x3c0 =
[btrfs]
[47724.855648] lr : invalidate_and_check_btree_folios+0x11c/0x3c0 =
[btrfs]
[47724.855728] sp : ffff80008e123b90
[47724.855730] x29: ffff80008e123ba0 x28: ffff0000d1e41000 x27: =
ffff000127d14558
[47724.855736] x26: ffffaa8f7cfc0000 x25: ffff00010734e400 x24: =
ffff0000d1e44000
[47724.855741] x23: ffff0000ca10c000 x22: 0000000000001000 x21: =
ffff000125509000
[47724.855746] x20: ffff00011d54c000 x19: ffff00011bf5eb58 x18: =
000000000000000a
[47724.855751] x17: 663266342d383336 x16: ffffaa8f7ba36cf0 x15: =
0000000000000000
[47724.855756] x14: 0000000000000000 x13: 322d203a65657274 x12: =
206b6e7568632064
[47724.855761] x11: 0000000000003cd8 x10: 0000000000000000 x9 : =
ffffaa8f3721d7cc
[47724.855767] x8 : ffffaa8f7cefe848 x7 : ffff00010bdc8bf0 x6 : =
0000000000000009
[47724.855772] x5 : 0000000000000003 x4 : ffff00010bdc8040 x3 : =
ffff80008e123b44
[47724.855777] x2 : 0000000000000000 x1 : 0000000000000000 x0 : =
0000000000000003
[47724.855782] Call trace:
[47724.855784]  invalidate_and_check_btree_folios+0x260/0x3c0 [btrfs] =
(P)
[47724.855865]  open_ctree+0x1f50/0x23b0 [btrfs]
[47724.855944]  btrfs_get_tree+0x89c/0xc48 [btrfs]
[47724.856019]  vfs_get_tree+0x30/0x110
[47724.856025]  vfs_cmd_create+0x58/0xe8
[47724.856031]  __arm64_sys_fsconfig+0x39c/0x518
[47724.856035]  invoke_syscall.constprop.0+0x48/0x120
[47724.856042]  el0_svc_common.constprop.0+0x40/0xe8
[47724.856046]  do_el0_svc+0x24/0x38
[47724.856051]  el0_svc+0x50/0x310
[47724.856057]  el0t_64_sync_handler+0xa0/0xe8
[47724.856061]  el0t_64_sync+0x198/0x1a0
[47724.856065] irq event stamp: 16018
[47724.856067] hardirqs last  enabled at (16017): [<ffffaa8f7c81029c>] =
_raw_spin_unlock_irqrestore+0x74/0x80
[47724.856073] hardirqs last disabled at (16018): [<ffffaa8f7c7f65a0>] =
el1_brk64+0x20/0x68
[47724.856077] softirqs last  enabled at (13320): [<ffffaa8f7b8fdeec>] =
kernel_neon_begin+0x11c/0x178
[47724.856082] softirqs last disabled at (13318): [<ffffaa8f7b8fde90>] =
kernel_neon_begin+0xc0/0x178
[47724.856085] ---[ end trace 0000000000000000 ]---
[47724.856089] BTRFS warning (device sdd): unable to release extent =
buffer 365985792 owner 3 gen 17 refs 3 flags 0x5
[47724.856195] DEBUG: before free_extent_buffer on 365985792 refs 2
[47724.856200] DEBUG: after free_extent_buffer on 365985792 refs 1

Standard Output

Full:
#setup seed sprout device
btrfs-progs v7.0
See https://btrfs.readthedocs.io for more information.

Performing full device TRIM /dev/sdc (300.00MiB) ...
NOTE: default settings have changed in version 6.19 (supported since =
linux 6.1):
     - enable block-group-tree (-O bgt)

Label:              (null)
UUID:               43f147f8-e91b-4306-82ef-4829ce018dae
Node size:          16384
Sector size:        4096 (CPU page size: 4096)
Filesystem size:    300.00MiB
Block group profiles:
 Data:             single            8.00MiB
 Metadata:         DUP              32.00MiB
 System:           DUP               8.00MiB
SSD detected:       no
Zoned device:       no
Features:           extref, skinny-metadata, no-holes, free-space-tree, =
block-group-tree
Checksum:           crc32c
Number of devices:  1
Devices:
  ID        SIZE  PATH   =20
   1   300.00MiB  /dev/sdc

mount: /mnt/scratch: WARNING: source write-protected, mounted read-only.
Performing full device TRIM /dev/sdd (8.00GiB) ...
#Scan seed device and check using mount
Scanning for btrfs filesystems on '/dev/sdc'
#check again, ensures seed device still in kernel
#Now scan of non-seed device makes kernel forget
WARNING: seeding flag cleared on /dev/sdc
Scanning for btrfs filesystems on '/dev/sdc'
#Sprout mount must fail for missing seed device
umount: /mnt/scratch: not mounted.


> +               if (unlikely(refcount_read(&eb->refs) > 2 ||
> +                            extent_buffer_under_io(eb))) {
> +                       WARN_ON_ONCE(IS_ENABLED(CONFIG_BTRFS_DEBUG));
> +                       btrfs_warn(fs_info,
> +                       "unable to release extent buffer %llu owner =
%llu gen %llu refs %u flags 0x%lx",
> +                                  eb->start, btrfs_header_owner(eb),
> +                                  btrfs_header_generation(eb),
> +                                  refcount_read(&eb->refs), =
eb->bflags);
> +               }
> +               free_extent_buffer(eb);
> +               rcu_read_lock();
> +       }
> +       rcu_read_unlock();
> +       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> +}
> +
> int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices =
*fs_devices)
> {
>        u32 sectorsize;
> @@ -3702,7 +3747,7 @@ int __cold open_ctree(struct super_block *sb, =
struct btrfs_fs_devices *fs_device
>        if (fs_info->data_reloc_root)
>                btrfs_drop_and_free_fs_root(fs_info, =
fs_info->data_reloc_root);
>        free_root_pointers(fs_info, true);
> -       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> +       invalidate_btree_folios(fs_info);
>=20
> fail_sb_buffer:
>        btrfs_stop_all_workers(fs_info);
> @@ -4431,7 +4476,7 @@ void __cold close_ctree(struct btrfs_fs_info =
*fs_info)
>         * We must make sure there is not any read request to
>         * submit after we stop all workers.
>         */
> -       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> +       invalidate_btree_folios(fs_info);
>        btrfs_stop_all_workers(fs_info);
>=20
>        /*
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 8d241a7a880f..4eab0f9909e3 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2872,12 +2872,6 @@ bool try_release_extent_mapping(struct folio =
*folio, gfp_t mask)
>        return try_release_extent_state(io_tree, folio);
> }
>=20
> -static int extent_buffer_under_io(const struct extent_buffer *eb)
> -{
> -       return (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
> -               test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
> -}
> -
> static bool folio_range_has_eb(struct folio *folio)
> {
>        struct btrfs_folio_state *bfs;
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index fd209233317f..b284aee1bfb0 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -326,6 +326,12 @@ static inline bool extent_buffer_uptodate(const =
struct extent_buffer *eb)
>        return test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
> }
>=20
> +static inline bool extent_buffer_under_io(const struct extent_buffer =
*eb)
> +{
> +       return (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
> +               test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
> +}
> +
> int memcmp_extent_buffer(const struct extent_buffer *eb, const void =
*ptrv,
>                         unsigned long start, unsigned long len);
> void read_extent_buffer(const struct extent_buffer *eb, void *dst,
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 7d70fe486758..264dcd4b3788 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -255,13 +255,13 @@ do {                                             =
                 \
>                __first =3D true;                                 \
>                if (WARN(btrfs_abort_should_print_stack(error), \
>                        KERN_ERR                                \
> -                       "BTRFS: Transaction aborted (error %d)\n",     =
 \
> -                       (error))) {                                    =
 \
> +                       "BTRFS: Transaction %llu aborted (error =
%d)\n", \
> +                       (trans)->transid, (error))) {                  =
 \
>                        /* Stack trace printed. */                      =
\
>                } else {                                                =
\
>                        btrfs_err((trans)->fs_info,                     =
\
> -                                 "Transaction aborted (error %d)",    =
 \
> -                                 (error));                     \
> +                       "Transaction %llu aborted (error %d)",  \
> +                                 (trans)->transid, (error));   \
>                }                                               \
>        }                                                       \
>        __btrfs_abort_transaction((trans), __func__,            \
> --
> 2.53.0
>=20
>=20
