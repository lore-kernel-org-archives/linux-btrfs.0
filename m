Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:32965 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755766AbdGKQAn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Jul 2017 12:00:43 -0400
Received: by mail-lf0-f49.google.com with SMTP id z78so4325923lff.0
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Jul 2017 09:00:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170711062155.hvlx5ud4zphpzjnp@merlins.org>
References: <20170711062155.hvlx5ud4zphpzjnp@merlins.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 11 Jul 2017 10:00:40 -0600
Message-ID: <CAJCQCtREGq4i5mn+PPB__dFLBvo8YrDeU_=GPHdzD1CuVYAfwg@mail.gmail.com>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists
To: Marc MERLIN <marc@merlins.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 11, 2017 at 12:21 AM, Marc MERLIN <marc@merlins.org> wrote:
> Looks like btrfs has decided to give me hell.
> I'm still recovering my system.
> The biggest filesystem seems to work, but I just had it go read only:
>
> ------------[ cut here ]------------
> WARNING: CPU: 5 PID: 3734 at fs/btrfs/extent-tree.c:2960 btrfs_run_delayed_refs+0xb6/0x1dc
> BTRFS: Transaction aborted (error -17)
> Modules linked in: udp_diag tcp_diag inet_diag veth ip6table_filter ip6_tables ebtable_nat ebtables ppdev lp xt_addrtype br_
> fmt_misc ftdi_sio nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc ipt_REJECT nf_reject_ipv4 xt_conntrack xt_mark xt_
> ptable_mangle iptable_filter pl2303 dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
> e_ipv4 nf_nat nf_conntrack x_tables sg st snd_pcm_oss snd_mixer_oss bcache kvm_intel kvm irqbypass snd_hda_codec_realtek snd
> da_codec snd_cmipci rc_ati_x10 asus_wmi snd_hda_core snd_mpu401_uart snd_opl3_lib snd_hwdep snd_rawmidi snd_seq_device spars
> l tpm_infineon snd tpm_tis hwmon tpm_tis_core usbnet rc_core i2c_i801 usbserial libphy soundcore wmi i915 lpc_ich mfd_cor
> s evdev pcspkr parport_pc battery mei_me parport i2c_smbus e1000e ptp pps_core fuse raid456 multipath mmc_block mmc_core dm_
> r async_memcpy async_tx crc32c_intel blowfish_x86_64 blowfish_common aesni_intel aes_x86_64 lrw glue_helper ablk_helper cryp
> 4 thermal usbcore mvsas libsas fjes scsi_transport_sas fan r8169 mii usb_common [last unloaded: ftdi_sio]
> CPU: 1 PID: 3734 Comm: btrfs-transacti Tainted: G     U  W       4.8.10-amd64-preempt-sysrq-20161121vb3tj1 #12
> Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
>  0000000000200286 000000003f87d529 ffff9dcc9838fd00 ffffffffbb39e738
>  ffff9dcc9838fd50 0000000000000000 ffff9dcc9838fd40 ffffffffbb066e08
>  00000b909838fdc0 ffff9dc94fdc9be0 0000000000000000 ffff9dcca0d93000
> Call Trace:
>  [<ffffffffbb39e738>] dump_stack+0x63/0x7f
>  [<ffffffffbb066e08>] __warn+0xc2/0xdd
>  [<ffffffffbb066e7d>] warn_slowpath_fmt+0x5a/0x76
>  [<ffffffffbb291dc2>] btrfs_run_delayed_refs+0xb6/0x1dc
>  [<ffffffffbb2a4d1d>] btrfs_commit_transaction+0x5b/0x965
>  [<ffffffffbb2a030e>] transaction_kthread+0xf5/0x19f
>  [<ffffffffbb2a0219>] ? btrfs_cleanup_transaction+0x47b/0x47b
>  [<ffffffffbb081df3>] kthread+0xb4/0xbc
>  [<ffffffffbb6d23df>] ret_from_fork+0x1f/0x40
>  [<ffffffffbb081d3f>] ? init_completion+0x24/0x24
> ---[ end trace feb4b95c83ac065f ]---
> BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960: errno=-17 Object already exists
> BTRFS info (device dm-2): forced readonly


You've already had this same traceback, not sure whether it's the same
file system or not, but it was 4.7.2 kernel.


> Yes, I'm back with 4.8 since I need to get back to a working state,
> however this may be a totally unrelated bug that has been fixed since
> 4.8?

Probably fixed in 4.9, no idea when. I would just use the most recent
4.9 kernel you can get or build. Less chance of regressions in
longterm, greater chance of bug fixes. Same for 4.4.


-- 
Chris Murphy
