Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33033 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbcHHS1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Aug 2016 14:27:07 -0400
MIME-Version: 1.0
In-Reply-To: <20160808080034.GA8581@yexl-desktop>
References: <20160808080034.GA8581@yexl-desktop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 8 Aug 2016 11:27:06 -0700
Message-ID: <CA+55aFzFFKaTMfDUmrV5QvLq0PsmmNrRYqVOLLujyQq7oa4Nkg@mail.gmail.com>
Subject: Re: [lkp] [dm flakey] 99f3c90d0d: WARNING: CPU: 20 PID: 1027 at
 fs/btrfs/extent-tree.c:2973 btrfs_run_delayed_refs+0x2c5/0x2f0 [btrfs]
To: kernel test robot <xiaolong.ye@intel.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Akira Hayakawa <ruby.wktk@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This report should probably have gone to the btrfs people, although it
doesn't really look like a bug.

It looks like it's just dm-flakey now returning more errors, and
causing btrfs to complain more.

Which seems entirely expected.

Maybe the robot just was testing a error case that didn't actually
happen before.

         Linus

On Mon, Aug 8, 2016 at 1:00 AM, kernel test robot <xiaolong.ye@intel.com> wrote:
>
> FYI, we noticed the following commit:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> commit 99f3c90d0d85708e7401a81ce3314e50bf7f2819 ("dm flakey: error READ bios during the down_interval")
>
> in testcase: xfstests
> with following parameters:
>
>         disk: 4HDD
>         fs: btrfs
>         test: generic-slow3
>
>
> on test machine: 24 threads Westmere-EP with 16G memory
>
> caused below changes:
>
>
> kern  :err   : [  326.754793] BTRFS error (device dm-0): bdev /dev/mapper/flakey-test errs: wr 0, rd 1, flush 0, corrupt 0, gen 0
> kern  :err   : [  326.765309] BTRFS error (device dm-0): bdev /dev/mapper/flakey-test errs: wr 0, rd 2, flush 0, corrupt 0, gen 0
> kern  :warn  : [  326.775848] ------------[ cut here ]------------
> kern  :warn  : [  326.780679] WARNING: CPU: 20 PID: 1027 at fs/btrfs/extent-tree.c:2973 btrfs_run_delayed_refs+0x2c5/0x2f0 [btrfs]
> kern  :debug : [  326.792555] BTRFS: Transaction aborted (error -5)
> kern  :warn  : [  326.797436] Modules linked in: dm_flakey ipmi_devintf dm_mod btrfs xor raid6_pq ses enclosure rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver sg sr_mod cdrom ata_generic sd_mod pata_acpi intel_powerclamp coretemp kvm_intel mptsas mptscsih kvm snd_pcm irqbypass crct10dif_pclmul crc32_pclmul snd_timer crc32c_intel pata_jmicron mptbase ahci libahci snd ghash_clmulni_intel soundcore ppdev aesni_intel lrw gf128mul glue_helper ablk_helper cryptd scsi_transport_sas i7core_edac ipmi_si serio_raw pcspkr libata parport_pc edac_core shpchp parport ipmi_msghandler acpi_cpufreq
> kern  :warn  : [  326.851992] CPU: 20 PID: 1027 Comm: umount Not tainted 4.7.0-10769-g99f3c90 #1
> kern  :warn  : [  326.859514] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/06/2010
> kern  :warn  : [  326.866388]  0000000000000000 ffff8803f905bc30 ffffffff8143e1d9 ffff8803f905bc80
> kern  :warn  : [  326.874322]  0000000000000000 ffff8803f905bc70 ffffffff8107e50b 00000b9d3bc41000
> kern  :warn  : [  326.882251]  ffffffffa04a25d0 ffff88043b7e0850 ffff88043dd56730 0000000000000000
> kern  :warn  : [  326.890185] Call Trace:
> kern  :warn  : [  326.892810]  [<ffffffff8143e1d9>] dump_stack+0x63/0x8a
> kern  :warn  : [  326.898123]  [<ffffffff8107e50b>] __warn+0xcb/0xf0
> kern  :warn  : [  326.903090]  [<ffffffff8107e57f>] warn_slowpath_fmt+0x4f/0x60
> kern  :warn  : [  326.909019]  [<ffffffffa04046c5>] btrfs_run_delayed_refs+0x2c5/0x2f0 [btrfs]
> kern  :warn  : [  326.916240]  [<ffffffff811e3df6>] ? kmem_cache_alloc+0x1a6/0x1c0
> kern  :warn  : [  326.922429]  [<ffffffffa041aa33>] btrfs_commit_transaction+0x43/0xa90 [btrfs]
> kern  :warn  : [  326.929744]  [<ffffffffa03e61e6>] btrfs_sync_fs+0x66/0x130 [btrfs]
> kern  :warn  : [  326.936096]  [<ffffffff8123dcb3>] sync_filesystem+0x73/0xa0
> kern  :warn  : [  326.941842]  [<ffffffff8120b347>] generic_shutdown_super+0x27/0x100
> kern  :warn  : [  326.948280]  [<ffffffff8120b6b2>] kill_anon_super+0x12/0x20
> kern  :warn  : [  326.954030]  [<ffffffffa03e73f8>] btrfs_kill_super+0x18/0x110 [btrfs]
> kern  :warn  : [  326.960649]  [<ffffffff8120b863>] deactivate_locked_super+0x43/0x70
> kern  :warn  : [  326.967087]  [<ffffffff8120bd4a>] deactivate_super+0x5a/0x60
> kern  :warn  : [  326.972918]  [<ffffffff8122a6cf>] cleanup_mnt+0x3f/0x90
> kern  :warn  : [  326.978317]  [<ffffffff8122a762>] __cleanup_mnt+0x12/0x20
> kern  :warn  : [  326.983890]  [<ffffffff8109c175>] task_work_run+0x85/0xc0
> kern  :warn  : [  326.989464]  [<ffffffff810032a2>] exit_to_usermode_loop+0xc2/0xd0
> kern  :warn  : [  326.995729]  [<ffffffff81003b41>] syscall_return_slowpath+0xa1/0xb0
> kern  :warn  : [  327.002175]  [<ffffffff819322ba>] entry_SYSCALL_64_fastpath+0xa2/0xa4
> kern  :warn  : [  327.002223] ---[ end trace 0e82b94d9eb7c6ea ]---
> kern  :crit  : [  327.002225] BTRFS: error (device dm-0) in btrfs_run_delayed_refs:2973: errno=-5 IO failure
>
>
>
> To reproduce:
>
>         git clone git://git.kernel.org/pub/scm/linux/kernel/git/wfg/lkp-tests.git
>         cd lkp-tests
>         bin/lkp install job.yaml  # job file is attached in this email
>         bin/lkp run     job.yaml
>
>
>
> Thanks,
> Xiaolong
