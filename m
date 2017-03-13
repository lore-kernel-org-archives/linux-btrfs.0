Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8251 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S933046AbdCMCWK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Mar 2017 22:22:10 -0400
Subject: Re: Oops in btrfs_recover_relocation, kernel 4.8.1
To: Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
References: <20170310122337.GQ29429@carfax.org.uk>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <8fb44084-87e6-2970-447f-776b17bce254@cn.fujitsu.com>
Date: Mon, 13 Mar 2017 10:22:04 +0800
MIME-Version: 1.0
In-Reply-To: <20170310122337.GQ29429@carfax.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/10/2017 08:23 PM, Hugo Mills wrote:
>    Does anyone recall seeing this oops before? Is it something that
> can be fixed with a newer kernel? (I'm on a USB stick for this, so a
> new kernel is a major undertaking, and I'd like some reasonable
> expectation of success if I do it).

Yes, v4.10 has the fix for the bug.
>
>    Background: I'm rebuilding a dead server. I needed to reduce the
> device count on this FS to 6. Stupidly, I attached one device using an
> external USB case, and the USB connection reset during the device
> delete (within a few seconds). I can mount the FS -o ro,recovery, but
> using -o recovery on its own causes the oops below. If I can recover
> in-place, that would save me a *lot* of time in restoring backups.
>
>    Also... qgroups, WTH? I've *never* enabled qgroups on this FS.

Did you use any auto-backup system?
Quite a lot of them will enable qgroup.

Anyway, after mounting with v4.10 kernel, you can easily find out if 
qgroup is enabled.

Thanks,
Qu

>
>    For what it's worth, the FS passes btrfs check --readonly with no
> errors reported. (btrfs --version is 4.7.3).
>
>    Hugo.
>
> [  566.852589] BTRFS warning (device sdh1): 'recovery' is deprecated, use 'usebackuproot' instead
> [  566.852591] BTRFS info (device sdh1): trying to use backup root at mount time
> [  566.852592] BTRFS info (device sdh1): disk space caching is enabled
> [  566.922803] BTRFS info (device sdh1): bdev /dev/sdh1 errs: wr 0, rd 20, flush 0, corrupt 0, gen 0
> [  578.715616] BUG: unable to handle kernel paging request at fffffffffffffe50
> [  578.715619] IP: [<ffffffffc0a7714b>] qgroup_fix_relocated_data_extents+0x2b/0x2c0 [btrfs]
> [  578.715638] PGD 2f400f067 PUD 2f4011067 PMD 0
> [  578.715640] Oops: 0000 [#1]
> [  578.715642] Modules linked in: cpufreq_userspace(E) cpufreq_powersave(E) cpufreq_conservative(E) kvm_amd(E) kvm(E) irqbypass(E) crc32_pclmul(E) efi_pstore(E) ghash_clmulni_intel(E) pcspkr(E) serio_raw(E) efivars(E) fam15h_power(E) k10temp(E) btrfs(E) acpi_cpufreq(E) tpm_tis(E) tpm_tis_core(E) tpm(E) sp5100_tco(E) sg(E) snd_hda_codec_realtek(E) snd_hda_codec_hdmi(E) snd_hda_codec_generic(E) snd_hda_intel(E) 9p(E) snd_hda_codec(E) 9pnet(E) snd_hda_core(E) fscache(E) snd_hwdep(E) snd_pcm(E) snd_timer(E) snd(E) soundcore(E) shpchp(E) ib_iser(E) rdma_cm(E) iw_cm(E) ib_cm(E) ib_core(E) configfs(E) iscsi_tcp(E) libiscsi_tcp(E) libiscsi(E) scsi_transport_iscsi(E) fuse(E) evdev(E) aoe(E) efivarfs(E) ip_tables(E) x_tables(E) autofs4(E) loop(E) overlay(E) nls_utf8(E) isofs(E) raid10(E) raid456(E) async_raid6_recov(E)
> [  578.715663]  async_memcpy(E) async_pq(E) async_xor(E) async_tx(E) xor(E) raid6_pq(E) libcrc32c(E) crc32c_generic(E) raid0(E) multipath(E) linear(E) dm_mirror(E) dm_region_hash(E) dm_log(E) dm_mod(E) raid1(E) md_mod(E) sd_mod(E) hid_generic(E) usbhid(E) hid(E) uas(E) usb_storage(E) crc32c_intel(E) aesni_intel(E) aes_x86_64(E) glue_helper(E) lrw(E) gf128mul(E) ablk_helper(E) cryptd(E) ohci_pci(E) ahci(E) libahci(E) sata_sil24(E) i2c_piix4(E) r8169(E) mii(E) ehci_pci(E) ohci_hcd(E) ehci_hcd(E) libata(E) scsi_mod(E) radeon(E) i2c_algo_bit(E) drm_kms_helper(E) xhci_pci(E) xhci_hcd(E) usbcore(E) usb_common(E) ttm(E) drm(E) button(E)
> [  578.715684] CPU: 0 PID: 3532 Comm: mount Tainted: G            E   4.8.0-1-grml-amd64 #1 Debian 4.8.15-1+grml.1
> [  578.715684] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./970A-DS3P, BIOS FD 02/26/2016
> [  578.715686] task: ffff8fd7ead82fc0 task.stack: ffff8fd7db15c000
> [  578.715687] RIP: 0010:[<ffffffffc0a7714b>]  [<ffffffffc0a7714b>] qgroup_fix_relocated_data_extents+0x2b/0x2c0 [btrfs]
> [  578.715699] RSP: 0018:ffff8fd7db15fa08  EFLAGS: 00010246
> [  578.715700] RAX: ffff8fd7db133800 RBX: ffff8fd7e30c79a0 RCX: 0000000000000000
> [  578.715701] RDX: ffff8fd7ddb5cd10 RSI: ffff8fd7dc6b5000 RDI: ffff8fd7ddb5cc80
> [  578.715701] RBP: ffff8fd7e7445000 R08: 0000000000000000 R09: ffff8fd7ddb5cc80
> [  578.715702] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8fd7db15faa0
> [  578.715703] R13: ffff8fd7dc6b5000 R14: 0000000000000000 R15: ffff8fd7ddb5cc80
> [  578.715704] FS:  00007f23cd67f480(0000) GS:ffffffffbca35000(0000) knlGS:0000000000000000
> [  578.715705] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  578.715706] CR2: fffffffffffffe50 CR3: 000000042302f000 CR4: 00000000000406b0
> [  578.715707] Stack:
> [  578.715707]  0000000000000000 0000000000000801 ffff8fd7ddb5cc80 0000000000000801
> [  578.715710]  ffff8fd7ddb5cc80 ffffffffc0a24c44 0000000000000000 0000000000000000
> [  578.715711]  ffff8f00db15fa40 0000000036d3c76a ffff8fd7e30c79a0 ffff8fd7e7445000
> [  578.715713] Call Trace:
> [  578.715726]  [<ffffffffc0a24c44>] ? start_transaction+0x94/0x4c0 [btrfs]
> [  578.715738]  [<ffffffffc0a7ab68>] ? btrfs_recover_relocation+0x2e8/0x420 [btrfs]
> [  578.715750]  [<ffffffffc0a21a48>] ? open_ctree+0x2158/0x2680 [btrfs]
> [  578.715752]  [<ffffffffbc2d5249>] ? snprintf+0x49/0x60
> [  578.715762]  [<ffffffffc09f6d06>] ? btrfs_mount+0xd26/0xe70 [btrfs]
> [  578.715765]  [<ffffffffbc1b5e52>] ? lookup_fast+0x52/0x300
> [  578.715767]  [<ffffffffbc1af1a6>] ? mount_fs+0x36/0x170
> [  578.715770]  [<ffffffffbc15ac85>] ? kstrdup+0x45/0x50
> [  578.715772]  [<ffffffffbc1c925f>] ? vfs_kern_mount+0x5f/0x100
> [  578.715781]  [<ffffffffc09f619c>] ? btrfs_mount+0x1bc/0xe70 [btrfs]
> [  578.715784]  [<ffffffffbc2cb1b4>] ? ida_get_new_above+0x1e4/0x210
> [  578.715786]  [<ffffffffbc1af1a6>] ? mount_fs+0x36/0x170
> [  578.715788]  [<ffffffffbc15ac85>] ? kstrdup+0x45/0x50
> [  578.715790]  [<ffffffffbc1c925f>] ? vfs_kern_mount+0x5f/0x100
> [  578.715791]  [<ffffffffbc1c8b1c>] ? __get_fs_type+0x1c/0x30
> [  578.715793]  [<ffffffffbc1cc1ac>] ? do_mount+0x1dc/0xbb0
> [  578.715794]  [<ffffffffbc1cce64>] ? SyS_mount+0x84/0xc0
> [  578.715797]  [<ffffffffbc577caf>] ? entry_SYSCALL_64_fastpath+0x1a/0xa4
> [  578.715798] Code: 0f 1f 44 00 00 41 57 41 56 41 55 41 54 55 53 48 83 ec 50 4c 8b 76 10 65 48 8b 04 25 28 00 00 00 48 89 44 24 48 31 c0 48 8b 46 08 <49> 8b ae 50 fe ff ff 48 8b 98 f0 01 00 00 31 c0 f6 83 78 0a 00
> [  578.715816] RIP  [<ffffffffc0a7714b>] qgroup_fix_relocated_data_extents+0x2b/0x2c0 [btrfs]
> [  578.715828]  RSP <ffff8fd7db15fa08>
> [  578.715828] CR2: fffffffffffffe50
> [  578.715830] ---[ end trace 3153f530aca9e6aa ]---
>


