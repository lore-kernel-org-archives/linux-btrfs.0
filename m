Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:35328 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbbCWMgc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 08:36:32 -0400
Received: by igcau2 with SMTP id au2so40569293igc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2015 05:36:32 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <550FEC73.9010507@skagestad.org>
References: <550FEC73.9010507@skagestad.org>
Date: Mon, 23 Mar 2015 12:36:31 +0000
Message-ID: <CAL3q7H5E3ftp+02frB2Q3N+pt-wQmLS+1TWgYobqXZg=pu0O0A@mail.gmail.com>
Subject: Re: Linux 4.0.0-rc5 - [ 1851.858652] BTRFS: error (device sda1) in
 cleanup_transaction:1686: errno=-17 Object already exists
From: Filipe David Manana <fdmanana@gmail.com>
To: =?UTF-8?B?VG9yYmrDuHJu?= <lists@skagestad.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 23, 2015 at 10:35 AM, Torbjørn <lists@skagestad.org> wrote:
> Hi,
>
> After upgrading to 4.0.0-rc5 from 4.0.0-rc4 I see "Object already exists"
> after reboot.
> The fs is forced read only.
> The error does not disappear after additional reboots.

If you go back to 4.0.0-rc4, does the error still happens?

>
> mount|grep sda1
> /dev/sda1 on / type btrfs (rw,noatime,compress=lzo,space_cache,subvol=@)
> /dev/sda1 on /home type btrfs
> (rw,noatime,compress=lzo,space_cache,subvol=@home)
> /dev/sda1 on /mnt/volumes type btrfs (rw,noatime,compress=lzo,space_cache)
>
> Label: 'root'  uuid: 6a681300-faef-4195-a1b3-6699c7a5aa5e
>     Total devices 2 FS bytes used 66.87GiB
>     devid    1 size 298.09GiB used 124.03GiB path /dev/sda1
>     devid    2 size 298.09GiB used 124.03GiB path /dev/sdd1
>
> btrfs-progs v3.19
>
> Any additional info I can provide? Tests you want me to run?
>
> --
> Torbjørn
>
>
> [ 1851.856097] ------------[ cut here ]------------
> [ 1851.856166] WARNING: CPU: 4 PID: 350 at fs/btrfs/super.c:260
> __btrfs_abort_transaction+0x54/0x130 [btrfs]()
> [ 1851.856255] BTRFS: Transaction aborted (error -17)
> [ 1851.856256] Modules linked in: vhost_net vhost macvtap macvlan
> ipmi_devintf ipt_REJECT nf_reject_ipv4 xt_CHECKSUM ip6table_filter
> ip6_tables ebtable_nat ebtables sch_prio bridge stp llc xt_state
> iptable_filter xt_CLASSIFY xt_tcpudp xt_DSCP iptable_mangle iptable_nat
> nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables
> x_tables dm_crypt netconsole configfs ppdev coretemp kvm_intel mac_hid
> lpc_ich video kvm serio_raw parport_pc ipmi_si tpm_infineon ipmi_msghandler
> aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd nfsd lp
> auth_rpcgss nfs_acl nfs lockd parport grace sunrpc fscache btrfs raid10
> raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor
> raid6_pq raid0 multipath linear raid1 hid_generic usbhid hid psmouse ahci
> e1000e libahci ptp mpt2sas raid_class pps_core scsi_transport_sas
> [ 1851.856977] CPU: 4 PID: 350 Comm: btrfs-transacti Not tainted 4.0.0-rc5
> #97
> [ 1851.857057] Hardware name: To be filled by O.E.M. To be filled by
> O.E.M./P8B-X series, BIOS 2107 05/04/2012
> [ 1851.857151]  ffffffffc02ad832 ffff88041795fbf8 ffffffff8176aaed
> 0000000000000000
> [ 1851.857248]  ffff88041795fc48 ffff88041795fc38 ffffffff8107a0ea
> 0000000000000000
> [ 1851.857336]  ffff88041a3d49a0 ffff880417cc4000 00000000ffffffef
> ffffffffc02ac0d0
> [ 1851.857423] Call Trace:
> [ 1851.857466]  [<ffffffff8176aaed>] dump_stack+0x45/0x57
> [ 1851.857514]  [<ffffffff8107a0ea>] warn_slowpath_common+0x8a/0xc0
> [ 1851.857565]  [<ffffffff8107a166>] warn_slowpath_fmt+0x46/0x50
> [ 1851.857618]  [<ffffffffc01ffc84>] __btrfs_abort_transaction+0x54/0x130
> [btrfs]
> [ 1851.857704]  [<ffffffffc021d05c>]
> btrfs_run_delayed_refs.part.65+0x12c/0x2a0 [btrfs]
> [ 1851.857792]  [<ffffffffc021f4d1>] ? btrfs_update_root+0xe1/0x270 [btrfs]
> [ 1851.857849]  [<ffffffffc021d1e7>] btrfs_run_delayed_refs+0x17/0x20
> [btrfs]
> [ 1851.857908]  [<ffffffffc02a51c6>] commit_cowonly_roots+0x27d/0x294
> [btrfs]
> [ 1851.857967]  [<ffffffffc022dde1>] btrfs_commit_transaction+0x4c1/0xa50
> [btrfs]
> [ 1851.858053]  [<ffffffffc0229585>] transaction_kthread+0x1b5/0x240 [btrfs]
> [ 1851.858110]  [<ffffffffc02293d0>] ? btrfs_cleanup_transaction+0x570/0x570
> [btrfs]
> [ 1851.858192]  [<ffffffff81098ea2>] kthread+0xd2/0xf0
> [ 1851.858238]  [<ffffffff81098dd0>] ? kthread_create_on_node+0x180/0x180
> [ 1851.858291]  [<ffffffff81772518>] ret_from_fork+0x58/0x90
> [ 1851.858340]  [<ffffffff81098dd0>] ? kthread_create_on_node+0x180/0x180
> [ 1851.858391] ---[ end trace 7c2776e855cf008f ]---
> [ 1851.858437] BTRFS: error (device sda1) in btrfs_run_delayed_refs:2790:
> errno=-17 Object already exists
> [ 1851.858524] BTRFS info (device sda1): forced readonly
> [ 1851.858571] BTRFS warning (device sda1): Skipping commit of aborted
> transaction.
> [ 1851.858652] BTRFS: error (device sda1) in cleanup_transaction:1686:
> errno=-17 Object already exists
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
