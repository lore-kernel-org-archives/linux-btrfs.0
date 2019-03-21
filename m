Return-Path: <SRS0=tkEE=RY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E81C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 18:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FD18205F4
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 18:56:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="PkyjkyG2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbfCUS45 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Mar 2019 14:56:57 -0400
Received: from mout.web.de ([217.72.192.78]:37285 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728651AbfCUS44 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Mar 2019 14:56:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1553194614;
        bh=1LsqqPR7wPagzlI1RrUP04XzAUetM8yzrCR/o1otCXM=;
        h=X-UI-Sender-Class:From:To:Subject:Date;
        b=PkyjkyG26l784fdXQD18kkDI8kCwQAX4taXTENMg9cjdYEH0Bx9FFAczjAelPpTTu
         LIEeHIgBBOV8TVgljLw9SxIm3hOUpb6j3jyCl3Msgegb6WWdhoZeKushrDwcDHDAAj
         LrHBAW4Lcs3sd2sOWCObP+YVi4G/1V0jN5v4N6+0=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [178.203.184.97] ([178.203.184.97]) by web-mail.web.de
 (3c-app-webde-bap65.server.lan [172.19.172.161]) (via HTTP); Thu, 21 Mar
 2019 19:56:54 +0100
MIME-Version: 1.0
Message-ID: <trinity-49be13bc-b1ea-4ab2-81a5-6d32096c62fb-1553194614498@3c-app-webde-bap65>
From:   "Thorsten Hirsch" <T.Hirsch@web.de>
To:     linux-btrfs@vger.kernel.org
Subject: kernel oops when mounting btrfs
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 21 Mar 2019 19:56:54 +0100
Importance: normal
Sensitivity: Normal
Content-Transfer-Encoding: quoted-printable
X-Priority: 3
X-Provags-ID: V03:K1:qJNo2kUMOpUqxpUUbnGn606yNHuxHUfF9iNMjc2KrFOoAFQfTi6T4zHWA6PJCDJJD6mih
 vOUCobKl5z9ogTxe7YAcB3iPfxC23MWH2PKUnc06+ePkSRRSzX7diWwc7sEHFbfSO20w7RPM3oek
 Df/M2gW74plPbV39JHkufAarlpa4IcHYOQ8HpBzKfOOb9QIOHWCwbkA1mc8T7V2Qn4VmTFTmymMg
 LAWXJrG+3r4Q+LA5XaENO/VKXzMYJWeKHqW9M9THoYZOxEwBj7hsbJGw6OcN30wscIS7k6BW8Iaw
 GM=
X-UI-Out-Filterresults: notjunk:1;V03:K0:Dt9yLn8N3P4=:S4DfHaP8enJL5sNKxS14l/
 40iG1AnjE5pLc/qnfE8lwv+SZUpIGgW8VmHwgQKCpKkYrB7HMfK0J6+aVWqbsYPuBkbAqxFXp
 CynlB2g2NlfS0PMSThxsTCiekpJXNLIkoecmzHThOQoFetydIm5//tNAShUzSWFdIfBv9h8KX
 iQWPI8nUPzL2An2YDA17pkOqpyXqVSWgWotBPvy+NDDyChzpq3Jzu8c0IRI/JzjrE75zNOqE2
 l5xcDYo8W3KZPWxDVzkNW9kVt2AnZ2WmVWpQI58jhdwJo8z4MnIWMQnOcOHiZlMeH+u/mIGu9
 /WN0L4vfv2UjHxSYjrU4Gswk3cA2ZI5jI53TLIdZhCOCwUrOw+fFe9JEf5p58u7/exhID/VZF
 PDQ3KkIZhSkuexl6RL2fpnbYRuFGUdpMSLmvB7TsQyU81sAVWXgYEXP2X5xHOqBKyo5PPguTO
 x5Cqei8oaq0Pzcs4tdN8zdKIoul3FUs9H0MDk9nOfe886p5McELkVqH3o1ABQ+BjdpQKo0V3g
 Bd2ZT/51QW2scSnZEnyQD8GEU2CpRiarSIAMKAA2q2EXnNrNVsWEQMruHKlyyEYxt7Ve8AWWh
 SdJfBpNEhUjfs=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi=2E
=C2=A0
Yesterday when powering off my PC systemd's umount service run in a timeou=
t=2E Today linux couldn't boot anymore, instead I suddenly found myself in =
the kernel's rescue shell=2E Seems like btrfs is broken on my root partitio=
n=2E

# mount -t btrfs -o ro /dev/nvme0n1p3 /mnt
=2E=2E=2Eproduces a kernel oops=2E I attached the dmesg output=2E

# mount -t btrfs -o ro,recovery /dev/nvme0n1p3 /mnt
Killed

I'm afraid of calling btrfsck, because of the warnings in the btrfs wiki, =
that this tool might make the situation worse=2E Any suggestions how to pro=
ceed?

Thorsten Hirsch



[  223=2E023202] BTRFS warning (device nvme0n1p3): 'recovery' is deprecate=
d, use 'usebackuproot' instead
[  223=2E023204] BTRFS info (device nvme0n1p3): trying to use backup root =
at mount time
[  223=2E023206] BTRFS info (device nvme0n1p3): disk space caching is enab=
led
[  223=2E023207] BTRFS info (device nvme0n1p3): has skinny extents
[  223=2E052188] BTRFS info (device nvme0n1p3): enabling ssd optimizations
[  223=2E054170] init_special_inode: bogus i_mode (0) for inode nvme0n1p3:=
882
[  223=2E054184] BUG: unable to handle kernel NULL pointer dereference at =
0000000000000000
[  223=2E054187] PGD 0 P4D 0=20
[  223=2E054190] Oops: 0010 [#1] PREEMPT SMP NOPTI
[  223=2E054193] CPU: 6 PID: 2841 Comm: mount Not tainted 4=2E19=2E28-1-MA=
NJARO #1
[  223=2E054194] Hardware name: Gigabyte Technology Co=2E, Ltd=2E AB350M-D=
S3H/AB350M-DS3H-CF, BIOS F24 12/25/2018
[  223=2E054196] RIP: 0010:          (null)
[  223=2E054199] Code: Bad RIP value=2E
[  223=2E054200] RSP: 0018:ffffb36dcaa570b8 EFLAGS: 00010246
[  223=2E054202] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000=
00000000
[  223=2E054203] RDX: 0000000000000006 RSI: fffff00c0dd2fb40 RDI: 00000000=
00000000
[  223=2E054204] RBP: ffffb36dcaa57140 R08: 0000000000000000 R09: fffff00c=
0dd2fb40
[  223=2E054205] R10: ffff9ea7ee5846a8 R11: 0000000000000000 R12: ffff9ea7=
ee584698
[  223=2E054207] R13: ffffb36dcaa57190 R14: fffff00c0dd2fb48 R15: fffff00c=
0dd2fb40
[  223=2E054208] FS:  00007fbe1d015780(0000) GS:ffff9ea88eb80000(0000) knl=
GS:0000000000000000
[  223=2E054210] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  223=2E054211] CR2: ffffffffffffffd6 CR3: 000000038c148000 CR4: 00000000=
003406e0
[  223=2E054212] Call Trace:
[  223=2E054217]  ? read_pages+0x116/0x180
[  223=2E054221]  ? __do_page_cache_readahead+0x1a5/0x1c0
[  223=2E054224]  ? ondemand_readahead+0x211/0x2e0
[  223=2E054227]  ? kmem_cache_alloc_trace+0x176/0x1d0
[  223=2E054245]  ? __load_free_space_cache+0x1c4/0x5d0 [btrfs]
[  223=2E054261]  ? load_free_space_cache+0xb6/0x190 [btrfs]
[  223=2E054271]  ? cache_block_group+0x73/0x3e0 [btrfs]
[  223=2E054281]  ? cache_block_group+0x1c1/0x3e0 [btrfs]
[  223=2E054284]  ? wait_woken+0x80/0x80
[  223=2E054295]  ? find_free_extent+0x87e/0x1110 [btrfs]
[  223=2E054298]  ? syscall_return_via_sysret+0x14/0x83
[  223=2E054301]  ? __switch_to_asm+0x34/0x70
[  223=2E054302]  ? __switch_to_asm+0x40/0x70
[  223=2E054314]  ? btrfs_reserve_extent+0x9b/0x180 [btrfs]
[  223=2E054325]  ? btrfs_alloc_tree_block+0x1ab/0x5b0 [btrfs]
[  223=2E054335]  ? alloc_tree_block_no_bg_flush+0x47/0x50 [btrfs]
[  223=2E054345]  ? __btrfs_cow_block+0x11b/0x500 [btrfs]
[  223=2E054355]  ? btrfs_cow_block+0xdc/0x1a0 [btrfs]
[  223=2E054365]  ? btrfs_search_slot+0x22e/0x9f0 [btrfs]
[  223=2E054375]  ? btrfs_search_slot+0x858/0x9f0 [btrfs]
[  223=2E054385]  ? btrfs_insert_empty_items+0x67/0xc0 [btrfs]
[  223=2E054399]  ? overwrite_item+0xfb/0x5e0 [btrfs]
[  223=2E054413]  ? replay_one_buffer+0x6af/0x870 [btrfs]
[  223=2E054427]  ? walk_down_log_tree+0x76/0x3b0 [btrfs]
[  223=2E054441]  ? walk_log_tree+0xce/0x1d0 [btrfs]
[  223=2E054453]  ? btrfs_recover_log_trees+0x221/0x420 [btrfs]
[  223=2E054466]  ? replay_one_dir_item+0x170/0x170 [btrfs]
[  223=2E054478]  ? open_ctree+0x1a21/0x1b60 [btrfs]
[  223=2E054489]  ? btrfs_mount_root+0x656/0x720 [btrfs]
[  223=2E054491]  ? pcpu_block_update_hint_alloc+0x18a/0x1d0
[  223=2E054495]  ? cpumask_next+0x16/0x20
[  223=2E054496]  ? pcpu_alloc+0x1cb/0x670
[  223=2E054499]  ? mount_fs+0x3b/0x167
[  223=2E054502]  ? vfs_kern_mount=2Epart=2E11+0x54/0x110
[  223=2E054512]  ? btrfs_mount+0x16f/0x860 [btrfs]
[  223=2E054514]  ? path_lookupat=2Eisra=2E13+0xa6/0x230
[  223=2E054515]  ? legitimize_path=2Eisra=2E9+0x2d/0x60
[  223=2E054518]  ? pcpu_alloc_area+0xe2/0x130
[  223=2E054519]  ? pcpu_next_unpop+0x37/0x50
[  223=2E054521]  ? cpumask_next+0x16/0x20
[  223=2E054523]  ? pcpu_alloc+0x1cb/0x670
[  223=2E054525]  ? mount_fs+0x3b/0x167
[  223=2E054526]  ? mount_fs+0x3b/0x167
[  223=2E054529]  ? vfs_kern_mount=2Epart=2E11+0x54/0x110
[  223=2E054531]  ? do_mount+0x1fd/0xc80
[  223=2E054533]  ? _copy_from_user+0x37/0x60
[  223=2E054535]  ? kmem_cache_alloc_trace+0x176/0x1d0
[  223=2E054537]  ? copy_mount_options+0x28/0x210
[  223=2E054539]  ? ksys_mount+0xba/0xd0
[  223=2E054540]  ? __x64_sys_mount+0x21/0x30
[  223=2E054543]  ? do_syscall_64+0x65/0x180
[  223=2E054545]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  223=2E054547] Modules linked in: fuse sg st mousedev joydev input_leds =
amdkfd amd_iommu_v2 amdgpu snd_hda_codec_ca0110 snd_hda_codec_generic chash=
 snd_hda_codec_hdmi gpu_sched i2c_algo_bit snd_hda_intel snd_hda_codec ttm =
snd_hda_core edac_mce_amd drm_kms_helper sp5100_tco snd_hwdep kvm_amd snd_p=
cm drm snd_timer i2c_piix4 kvm snd agpgart syscopyarea sysfillrect ccp soun=
dcore sysimgblt irqbypass fb_sys_fops pcc_cpufreq rng_core evdev k10temp pc=
spkr crct10dif_pclmul ghash_clmulni_intel acpi_cpufreq pinctrl_amd gpio_amd=
pt mac_hid wmi_bmof uinput crypto_user ip_tables x_tables overlay squashfs =
isofs sr_mod cdrom sd_mod uas usb_storage btrfs libcrc32c crc32c_generic xo=
r hid_generic usbhid hid serio_raw atkbd crc32_pclmul crc32c_intel libps2 r=
aid6_pq ahci libahci libata aesni_intel aes_x86_64 crypto_simd
[  223=2E054580]  r8169 xhci_pci cryptd realtek glue_helper scsi_mod xhci_=
hcd libphy wmi i8042 serio dm_snapshot dm_bufio dm_mod loop
[  223=2E054588] CR2: 0000000000000000
[  223=2E054590] ---[ end trace e933e8be13130720 ]---
[  223=2E054592] RIP: 0010:          (null)
[  223=2E054594] Code: Bad RIP value=2E
[  223=2E054595] RSP: 0018:ffffb36dcaa570b8 EFLAGS: 00010246
[  223=2E054596] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000=
00000000
[  223=2E054598] RDX: 0000000000000006 RSI: fffff00c0dd2fb40 RDI: 00000000=
00000000
[  223=2E054599] RBP: ffffb36dcaa57140 R08: 0000000000000000 R09: fffff00c=
0dd2fb40
[  223=2E054600] R10: ffff9ea7ee5846a8 R11: 0000000000000000 R12: ffff9ea7=
ee584698
[  223=2E054601] R13: ffffb36dcaa57190 R14: fffff00c0dd2fb48 R15: fffff00c=
0dd2fb40
[  223=2E054603] FS:  00007fbe1d015780(0000) GS:ffff9ea88eb80000(0000) knl=
GS:0000000000000000
[  223=2E054604] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  223=2E054605] CR2: ffffffffffffffd6 CR3: 000000038c148000 CR4: 00000000=
003406e0
