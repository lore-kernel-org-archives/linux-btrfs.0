Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:35010 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbbGTNeI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jul 2015 09:34:08 -0400
Received: by obbop1 with SMTP id op1so101346341obb.2
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2015 06:34:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$7f5c7$63eed743$33fa939$36f57317@cox.net>
References: <11148188.L9vtSMaNHV@merkaba> <559FA280.8090309@tty0.ch>
 <20150712035523.GI5274@merlins.org> <20150713004249.GP5274@merlins.org>
 <CAB3_QuKuTeT7t--=y917AASM9QQHSRin4ZKRm57A0b+z0m=yvA@mail.gmail.com>
 <20150715031412.GZ5274@merlins.org> <20150715080057.GA15200@panda>
 <CAC=t97CxDRoakqzoOAoHpN=1qS1jyvMEfOCe+RWvGTm6xSCqPQ@mail.gmail.com>
 <CAC=t97BS2gNNLZEatTRCmmiUHLH8m6NFbgtkbWnaqrEsCye1KQ@mail.gmail.com>
 <20150715214913.GG5274@merlins.org> <CAC=t97CcemZzBjABSLS5etSF6B-67SvwL25q62hxv2de3zLPbw@mail.gmail.com>
 <pan$7f5c7$63eed743$33fa939$36f57317@cox.net>
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Mon, 20 Jul 2015 08:33:47 -0500
Message-ID: <CAC=t97AK_4PMT4NAWiW_OwhGFidJOR6mrUh=9gnTqeRNHAjxRw@mail.gmail.com>
Subject: Re: Anyone tried out btrbk yet?
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 20, 2015 at 3:28 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Donald Pearson posted on Mon, 20 Jul 2015 00:15:26 -0500 as excerpted:
>
>> I'm starting to think there's something wrong with creating and removing
>> snapshots that leaves btrfs-cleaner either locked up or nearly so.  If
>> the btrfs-cleaner process was hard-disk limited I should be seeing some
>> HDD I/O to coincide but I don't.
>>
>> So far btrfs-cleaner is has been using lots of CPU for 1900+ hours and
>> my disk I/O is basically idle.  My hourly snaps via cronjob stalled 11
>> hours ago.
>>
>> Otherwise attempts to read/write to the filesystem appear to be
>> perfectly normal.
>
> Hourly snaps.  How many snapshots/subvolumes on the filesystem?  I assume
> the snap removal you mention is scheduled thinning?

I'm using Marc's scripts currently which handles the creation and
retention.  Including snapshots there are currently 94 subvolumes.
The maximum possible with my settings is 118 after 3 months.

>
> A general rule of thumb is under 2000 snapshots per filesystem total,
> under 1000 if at all reasonable.  At 250 snapshots per subvolume, 2000
> snapshots is eight subvolumes worth, and 250-ish snapshots per subvolume
> is well within reason with reasonable thinning.
>
> If you have lots of subvolumes, 3000 snapshots per filesystem isn't /too/
> bad, but filesystem maintenance including snapshot deletion simply does
> /not/ scale well, and you'll likely run into scalability issues if you
> let it reach 10K snapshots on the filesystem.
>
> If you're at 10K snapshots on the filesystem, it's quite likely the usual
> scalability issue's you're seeing, almost certain at 100K+ snapshots.
> OTOH, if you're under 1K or even 2K snapshots, it's very likely something
> abnormal.  2K-10K, should be usable in most cases, but there are likely
> corner-cases where it's bad.
>
> Also, FWIW, the btrfs quota subsystem increases snapshot management
> complexity dramatically, so if you're using that, aim for the low ends of
> the above recommendation if at all possible, and/or consider either
> turning off the quota stuff or using a filesystem other than btrfs, as in
> addition to the scaling issues, the quota management code has been a
> source of repeated bugs and isn't a feature I'd recommend relying on
> until it has at least several kernel cycles worth of trouble-free history
> behind it.

Thanks for the insight.  I just took a look at dmesg and found this.
Is this coincidental or is this maybe the reason things appear to be
stuck?  I'm not sure how to read this.

[195400.023165] ------------[ cut here ]------------
[195400.023199] WARNING: CPU: 2 PID: 16987 at fs/btrfs/qgroup.c:1028
__qgroup_excl_accounting+0x1dc/0x270 [btrfs]()
[195400.023201] Modules linked in: ext4(E) mbcache(E) jbd2(E) ppdev(E)
snd_hda_codec_realtek(E) snd_hda_codec_generic(E) snd_hda_intel(E)
snd_hda_controller(E) snd_hda_codec(E) snd_hda_core(E) snd_hwdep(E)
snd_seq(E) snd_seq_device(E) kvm_amd(E) kvm(E) snd_pcm(E) pcspkr(E)
serio_raw(E) k10temp(E) edac_mce_amd(E) edac_core(E) snd_timer(E)
snd(E) soundcore(E) sp5100_tco(E) i2c_piix4(E) ses(E) enclosure(E)
8250_fintek(E) parport_pc(E) parport(E) tpm_infineon(E) shpchp(E)
acpi_cpufreq(E) nfsd(E) auth_rpcgss(E) nfs_acl(E) lockd(E) grace(E)
sunrpc(E) btrfs(E) xor(E) raid6_pq(E) ata_generic(E) pata_acpi(E)
sd_mod(E) nouveau(E) video(E) mxm_wmi(E) i2c_algo_bit(E)
drm_kms_helper(E) ttm(E) drm(E) pata_atiixp(E) ahci(E) pata_jmicron(E)
libahci(E) lpfc(E) scsi_transport_fc(E) firewire_ohci(E) libata(E)
firewire_core(E)
[195400.023225]  crc_itu_t(E) r8169(E) mii(E) mpt2sas(E) raid_class(E)
scsi_transport_sas(E) wmi(E)
[195400.023231] CPU: 2 PID: 16987 Comm: kworker/u12:5 Tainted: G
     E   4.1.0-1.el7.elrepo.x86_64 #1
[195400.023232] Hardware name: MICRO-STAR INTERNATIONAL CO.,LTD
MS-7577/790FX-GD70(MS-7577), BIOS V1.16 12/01/2010
[195400.023244] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[195400.023246]  0000000000000000 0000000031fd5f58 ffff880368a03b68
ffffffff816d4638
[195400.023248]  0000000000000000 0000000000000000 ffff880368a03ba8
ffffffff8107c51a
[195400.023250]  c000000000000000 ffff880409018d60 ffff88040a28ec88
ffffffffffff9000
[195400.023252] Call Trace:
[195400.023257]  [<ffffffff816d4638>] dump_stack+0x45/0x57
[195400.023261]  [<ffffffff8107c51a>] warn_slowpath_common+0x8a/0xc0
[195400.023263]  [<ffffffff8107c64a>] warn_slowpath_null+0x1a/0x20
[195400.023274]  [<ffffffffa05b5bdc>]
__qgroup_excl_accounting+0x1dc/0x270 [btrfs]
[195400.023277]  [<ffffffff811dd8b9>] ? kmem_cache_alloc_trace+0x199/0x220
[195400.023289]  [<ffffffffa05b8e37>]
btrfs_delayed_qgroup_accounting+0x317/0xc60 [btrfs]
[195400.023291]  [<ffffffff810afd68>] ? __enqueue_entity+0x78/0x80
[195400.023293]  [<ffffffff811dd699>] ? kmem_cache_alloc+0x1a9/0x230
[195400.023302]  [<ffffffffa053cb0a>]
btrfs_run_delayed_refs.part.66+0x20a/0x270 [btrfs]
[195400.023311]  [<ffffffffa053cc18>] delayed_ref_async_start+0x88/0xa0 [btrfs]
[195400.023322]  [<ffffffffa0580562>] normal_work_helper+0xc2/0x280 [btrfs]
[195400.023332]  [<ffffffffa0580952>] btrfs_extent_refs_helper+0x12/0x20 [btrfs]
[195400.023335]  [<ffffffff810959cd>] process_one_work+0x14d/0x420
[195400.023337]  [<ffffffff81096192>] worker_thread+0x112/0x520
[195400.023339]  [<ffffffff81096080>] ? rescuer_thread+0x3e0/0x3e0
[195400.023341]  [<ffffffff8109bee8>] kthread+0xd8/0xf0
[195400.023342]  [<ffffffff8109be10>] ? kthread_create_on_node+0x1b0/0x1b0
[195400.023344]  [<ffffffff816dc3a2>] ret_from_fork+0x42/0x70
[195400.023346]  [<ffffffff8109be10>] ? kthread_create_on_node+0x1b0/0x1b0
[195400.023347] ---[ end trace 1abc27647fe906a5 ]---


>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
