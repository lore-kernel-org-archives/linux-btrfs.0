Return-Path: <SRS0=taZz=QO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCCBEC282C2
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 06:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F558218D3
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 06:26:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfBGG0V (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Feb 2019 01:26:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:35466 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725912AbfBGG0U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Feb 2019 01:26:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C4937AECD;
        Thu,  7 Feb 2019 06:26:17 +0000 (UTC)
Subject: Re: Another btrfs corruption (unable to find ref byte, kernel
 5.0-rc4)
To:     Nazar Mokrynskyi <nazar@mokrynskyi.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5b0d2e94-6e4e-aecd-3eda-459c4a96bb13@mokrynskyi.com>
Cc:     Josef Bacik <josef@toxicpanda.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <bfff2ebb-1399-859a-cb1c-16848ce858c2@suse.com>
Date:   Thu, 7 Feb 2019 08:26:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <5b0d2e94-6e4e-aecd-3eda-459c4a96bb13@mokrynskyi.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 7.02.19 г. 6:07 ч., Nazar Mokrynskyi wrote:
> NOTE: I don't need asistance with data recovery, everything was restored shortly from fully automated backups, I only hope this information is useful for developers in some way.
> 
> So my primary BTRFS filesystem corrupted itself again.
> 
<SNIP>

>> [   82.910327] BTRFS error (device dm-0): unable to find ref byte nr 65470324736 parent 62522359808 root 267  owner 819644 offset 1552384

Funnily enough, this looks like the problem that Josef sent patches for
several hours ago - 'Fix missing reference aborts when resuming snapshot
delete'

>> [   82.910329] ------------[ cut here ]------------
>> [   82.910329] BTRFS: Transaction aborted (error -2)
>> [   82.910339] WARNING: CPU: 14 PID: 6082 at fs/btrfs/extent-tree.c:6950 __btrfs_free_extent.isra.72+0x7ad/0xac0 [btrfs]
>> [   82.910339] Modules linked in: btrfs zstd_compress libcrc32c xor raid6_pq dm_crypt algif_skcipher af_alg intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel snd_hda_codec_hdmi snd_hda_intel kvm snd_usb_audio snd_hda_codec snd_usbmidi_lib snd_hda_core snd_hwdep snd_pcm irqbypass crct10dif_pclmul snd_seq_midi snd_seq_midi_event crc32_pclmul snd_rawmidi ghash_clmulni_intel uvcvideo pcbc snd_seq videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_common snd_seq_device snd_timer aesni_intel videodev snd aes_x86_64 crypto_simd cdc_acm soundcore media input_leds joydev cryptd mei_me glue_helper intel_wmi_thunderbolt intel_cstate mei intel_rapl_perf acpi_pad mac_hid sch_fq_codel parport_pc ppdev lp parport ip_tables x_tables autofs4 overlay nls_iso8859_1 dm_mirror dm_region_hash dm_log
>> [   82.910354]  hid_generic usbhid hid uas usb_storage amdkfd amd_iommu_v2 amdgpu nouveau chash gpu_sched ttm mxm_wmi drm_kms_helper syscopyarea sysfillrect sysimgblt nvme fb_sys_fops igb e1000e atlantic drm ahci dca i2c_algo_bit nvme_core libahci wmi video
>> [   82.910361] CPU: 14 PID: 6082 Comm: btrfs-cleaner Tainted: G        W         4.18.0-10-generic #11-Ubuntu
>> [   82.910361] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z370 Professional Gaming i7, BIOS P3.40 11/08/2018
>> [   82.910367] RIP: 0010:__btrfs_free_extent.isra.72+0x7ad/0xac0 [btrfs]
>> [   82.910367] Code: 48 8b 40 50 f0 48 0f ba a8 10 ce 00 00 02 0f 92 c0 41 59 84 c0 0f 85 1d c1 09 00 44 89 ee 48 c7 c7 70 e2 ee c0 e8 75 4a 45 f8 <0f> 0b e9 07 c1 09 00 4c 89 e7 e8 14 07 ff ff 48 8b 7d 88 4d 89 f9
>> [   82.910380] RSP: 0018:ffffa71bc6833bf8 EFLAGS: 00010282
>> [   82.910381] RAX: 0000000000000000 RBX: 0000000f3e55e000 RCX: 0000000000000006
>> [   82.910381] RDX: 0000000000000007 RSI: 0000000000000092 RDI: ffff89d09e5964b0
>> [   82.910382] RBP: ffffa71bc6833ca0 R08: 0000000000000001 R09: 0000000000000805
>> [   82.910382] R10: 0000000000000004 R11: 0000000000000000 R12: ffff89cfd8338af0
>> [   82.910382] R13: 00000000fffffffe R14: 0000000e8e9f8000 R15: 000000000000010b
>> [   82.910383] FS:  0000000000000000(0000) GS:ffff89d09e580000(0000) knlGS:0000000000000000
>> [   82.910383] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   82.910384] CR2: 0000564398e70760 CR3: 000000076ce0a002 CR4: 00000000003606e0
>> [   82.910384] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [   82.910385] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> [   82.910385] Call Trace:
>> [   82.910391]  __btrfs_run_delayed_refs+0x20e/0x1010 [btrfs]
>> [   82.910397]  ? add_pinned_bytes+0x67/0x70 [btrfs]
>> [   82.910402]  ? btrfs_free_tree_block+0x167/0x2d0 [btrfs]
>> [   82.910408]  btrfs_run_delayed_refs+0x80/0x190 [btrfs]
>> [   82.910415]  btrfs_should_end_transaction+0x47/0x60 [btrfs]
>> [   82.910421]  btrfs_drop_snapshot+0x3d1/0x800 [btrfs]
>> [   82.910428]  btrfs_clean_one_deleted_snapshot+0xbb/0xf0 [btrfs]
>> [   82.910434]  cleaner_kthread+0x136/0x160 [btrfs]
>> [   82.910435]  kthread+0x120/0x140
>> [   82.910442]  ? btree_submit_bio_start+0x20/0x20 [btrfs]
>> [   82.910443]  ? kthread_bind+0x40/0x40
>> [   82.910443]  ret_from_fork+0x35/0x40
>> [   82.910444] ---[ end trace 32964933c87d1d28 ]---
>> [   82.910445] BTRFS: error (device dm-0) in __btrfs_free_extent:6950: errno=-2 No such entry
>> [   82.910446] BTRFS info (device dm-0): forced readonly
>> [   82.910447] BTRFS: error (device dm-0) in btrfs_run_delayed_refs:3057: errno=-2 No such entry
>> [   82.910763] BTRFS error (device dm-0): pending csums is 221184
> It became clear that filesystem is ready to be thown to /dev/null, so I've made an image for future investigation and recreated everything from ~10 minutes old backup.
> 
> If there is anything suspicios there and I can run useful tests on filesystem image - let me know, I'll spin up qcow2 CoW image and can do anything with it in VMs.
> 
> Unfortunately, it was just over a month since filesystem creation. Other BTRFS filesystem containing backups is perfectly fine (was created late April 2018), but it is only used for sending snapshots to it and not much other activity.
> 
