Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31247 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755543AbcDGIWH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Apr 2016 04:22:07 -0400
Subject: Re: [PATCH] btrfs: qgroup: Fix qgroup accounting when creating
 snapshot
To: Mark Fasheh <mfasheh@suse.de>
References: <1459908294-11200-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160407024337.GI2187@wotan.suse.de>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <570618A1.2080609@cn.fujitsu.com>
Date: Thu, 7 Apr 2016 16:21:53 +0800
MIME-Version: 1.0
In-Reply-To: <20160407024337.GI2187@wotan.suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Mark,

Thanks for the test and reporting.

Mark Fasheh wrote on 2016/04/06 19:43 -0700:
> Hi Qu,
>
> On Wed, Apr 06, 2016 at 10:04:54AM +0800, Qu Wenruo wrote:
>> Current btrfs qgroup design implies a requirement that after calling
>> btrfs_qgroup_account_extents() there must be a commit root switch.
>>
>> Normally this is OK, as btrfs_qgroup_accounting_extents() is only called
>> inside btrfs_commit_transaction() just be commit_cowonly_roots().
>>
>> However there is a exception at create_pending_snapshot(), which will
>> call btrfs_qgroup_account_extents() but no any commit root switch.
>>
>> In case of creating a snapshot whose parent root is itself (create a
>> snapshot of fs tree), it will corrupt qgroup by the following trace:
>> (skipped unrelated data)
>> ======
>> btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 1
>> qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 0, excl = 0
>> qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 16384, excl = 16384
>> btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 0
>> ======
>>
>> The problem here is in first qgroup_account_extent(), the
>> nr_new_roots of the extent is 1, which means its reference got
>> increased, and qgroup increased its rfer and excl.
>>
>> But at second qgroup_account_extent(), its reference got decreased, but
>> between these two qgroup_account_extent(), there is no switch roots.
>> This leads to the same nr_old_roots, and this extent just got ignored by
>> qgroup, which means this extent is wrongly accounted.
>>
>> Fix it by call commit_cowonly_roots() after qgroup_account_extent() in
>> create_pending_snapshot(), with needed preparation.
>
> Thanks for the patch - I gave this all a whirl and get a locked up
> transaction thread. Here's the trace:
>
> [  172.187269] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [btrfs-transacti:1293]
> [  172.188299] Modules linked in: btrfs(OE) rpcsec_gss_krb5(E) auth_rpcgss(E) nfsv4(E) dns_resolver(E) nfs(E) lockd(E) grace(E) sunrpc(E) fscache(E) iscsi_ibft(E) iscsi_boot_sysfs(E) af_packet(E) xor(E) raid6_pq(E) ppdev(E) pcspkr(E) serio_raw(E) virtio_balloon(E) i2c_piix4(E) parport_pc(E) parport(E) processor(E) button(E) dm_mod(E) ext4(E) crc16(E) mbcache(E) jbd2(E) ata_generic(E) virtio_blk(E) virtio_net(E) ata_piix(E) ahci(E) libahci(E) cirrus(E) drm_kms_helper(E) syscopyarea(E) sysfillrect(E) floppy(E) uhci_hcd(E) ehci_hcd(E) usbcore(E) usb_common(E) libata(E) virtio_pci(E) virtio_ring(E) virtio(E) sysimgblt(E) fb_sys_fops(E) ttm(E) drm(E) sg(E) scsi_mod(E) autofs4(E) [last unloaded: btrfs]
> [  172.195789] CPU: 1 PID: 1293 Comm: btrfs-transacti Tainted: G           OE   4.5.0-remove_qgroup+ #4
> [  172.196805] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20150524_160643-cloud127 04/01/2014
> [  172.198094] task: ffff8800bb90dbc0 ti: ffff880037204000 task.ti: ffff880037204000
> [  172.199077] RIP: 0010:[<ffffffff81561abb>]  [<ffffffff81561abb>] _raw_spin_lock+0xb/0x20
> [  172.200076] RSP: 0018:ffff880037207d40  EFLAGS: 00000246
> [  172.200679] RAX: 0000000000000000 RBX: ffff88006f9aaf20 RCX: 0000000000000017
> [  172.201524] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8800af6704e0
> [  172.202314] RBP: ffff880037207da0 R08: 0000000000000006 R09: 0000000000000000
> [  172.203102] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800b6301800
> [  172.203892] R13: ffffffffffffffff R14: ffff8800af670370 R15: ffff8800b6301800
> [  172.204687] FS:  0000000000000000(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
> [  172.205586] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  172.206229] CR2: 00007f9db0ae4090 CR3: 0000000137510000 CR4: 00000000000006e0
> [  172.207025] Stack:
> [  172.207259]  ffffffffa05c51f4 0000000000000000 0000000000000006 000000000110ebb0
> [  172.208316]  ffff8800af6704d0 ffff8800af6704e0 ffff88006f9aafb0 ffff88006f9aaf20
> [  172.209186]  ffff8800ba10e828 ffff8800ba10ebb0 ffff8800ba10e9df ffff8800b6301800
> [  172.210034] Call Trace:
> [  172.210322]  [<ffffffffa05c51f4>] ? btrfs_run_delayed_refs+0xc4/0x2d0 [btrfs]
> [  172.211128]  [<ffffffffa05d7e8d>] commit_cowonly_roots+0x20d/0x2d0 [btrfs]
> [  172.211904]  [<ffffffffa05da5bc>] btrfs_commit_transaction+0x4cc/0xaa0 [btrfs]
> [  172.212697]  [<ffffffffa05d503a>] transaction_kthread+0x18a/0x210 [btrfs]
> [  172.213465]  [<ffffffffa05d4eb0>] ? btrfs_cleanup_transaction+0x530/0x530 [btrfs]
> [  172.214422]  [<ffffffff8107f7c4>] kthread+0xc4/0xe0
> [  172.214973]  [<ffffffff8107f700>] ? kthread_park+0x50/0x50
> [  172.215589]  [<ffffffff8156218f>] ret_from_fork+0x3f/0x70
> [  172.216171]  [<ffffffff8107f700>] ? kthread_park+0x50/0x50
> [  172.216765] Code: 55 48 89 e5 8b 07 85 c0 74 04 31 c0 5d c3 ba 01 00 00 00 f0 0f b1 17 85 c0 75 ef b0 01 5d c3 90 31 c0 ba 01 00 00 00 f0 0f b1 17 <85> c0 75 01 c3 55 89 c6 48 89 e5 e8 a5 6d b4 ff 5d c3 0f 1f 00
>

I also got one locked up with similar test script.

However I can't reproduce it in a stable rate.

My test script is much the same with yours, but more controlled contents 
to populate the fs:
------
#!/bin/bash

dev=/dev/sdb5
mnt=/mnt/test

populate_mnt() {
         prefix=$1
         size=$2
         nr=$3
         path=$4

         local i
         for ((i = 0; i < $nr; i++)) do
                 filename=$(printf "$prefix_%08d" $i)
                 xfs_io -f -c "pwrite 0 $size" $path/$filename &> /dev/null
         done
}

do_one_test() {
         umount $dev &> /dev/null

         mkfs.btrfs -f $dev
         mount $dev $mnt

         btrfs quota enable $mnt
         mkdir $mnt/snapshots
         echo "populating base fs"
         populate_mnt inline1 2k 32 $mnt
         populate_mnt normal 1m 16 $mnt
         populate_mnt inline2 2k 32 $mnt
         btrfs qgroup create 1/0 $mnt

         for i in $(seq -w 0 25); do
                 echo "populating snapshots $i"
                 btrfs subvolume snapshot -i 1/0 $mnt $mnt/snapshots/snap_$i
                 populate_mnt excl$i 1m 8 $mnt/snapshots/snap_$i
                 sync
         done

         btrfs qgroup show -prce $mnt
}

for x in $(seq -w 0 25); do
         echo "loop $x"
         do_one_test
done
------

I ran into one soft lockup with my patch only. So I assume it's not 
caused by your inherit patch though.
But I didn't reproduce it once more. Not sure why.

What's the reproduce rate in your environment?

Thanks,
Qu
>
> I made a fresh file system, mounted it, populated it with some data and made
> a bunch of snapshots with some of their own exclusive data. The pertinent
> commands from my test script are:
>
> btrfs quota enable /btrfs
> mkdir /btrfs/snaps
> echo "populate /btrfs/ with some data"
> cp -a /usr/share /btrfs/
> btrfs qgroup create 1/0 /btrfs
> for i in `seq -w 0 14`; do
>          S="/btrfs/snaps/snap$i"
>          echo "create and populate $S"
>          btrfs su snap -i 1/0 /btrfs/ $S;
>          cp -a /boot $S;
> done;
> for i in `seq -w 3 11 `; do
>          S="/btrfs/snaps/snap$i"
>          echo "remove snapshot $S"
>          btrfs su de $S
> done;
>
>
> This is on Linux 4.5 with my inherit fix and your patch applied. The script
> I pasted above ran with no problems until I added your patch to my kernel so
> my guess is it's not related to the btrfs_qgroup_inherit() patch.
> Nonetheless, here's a link to it in case you want a 2nd look:
>
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/54755
>
> Thanks,
> 	--Mark
>
> --
> Mark Fasheh
>
>


