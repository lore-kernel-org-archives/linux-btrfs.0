Return-Path: <SRS0=iEal=RZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB41AC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 07:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82B1D218B0
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 07:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfCVHcl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Mar 2019 03:32:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:41228 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726014AbfCVHck (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Mar 2019 03:32:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C740BAD6B;
        Fri, 22 Mar 2019 07:32:38 +0000 (UTC)
Subject: Re: Kernels 4.15..5.0.3: "WARNING: CPU: 2 PID: 4150 at
 fs/fs-writeback.c:2363 __writeback_inodes_sb_nr+0xa9/0xc0"
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        linux-btrfs@vger.kernel.org
References: <20190322041731.GF16651@hungrycats.org>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <e5ae3abb-1451-58e9-40f1-83bc49e316a9@suse.com>
Date:   Fri, 22 Mar 2019 09:32:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190322041731.GF16651@hungrycats.org>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 22.03.19 г. 6:17 ч., Zygo Blaxell wrote:
> When filesystems are mounted flushoncommit, I get this warning roughly
> every 30 seconds:
> 
> 	[ 4575.142805] WARNING: CPU: 3 PID: 4150 at fs/fs-writeback.c:2363 __writeback_inodes_sb_nr+0xa9/0xc0
> 	[ 4575.145567] Modules linked in: crct10dif_pclmul crc32_pclmul dm_cache_smq crc32c_intel dm_cache snd_pcm ghash_clmulni_intel aesni_intel sr_mod dm_persistent_data ppdev joydev dm_bio_prison aes_x86_64 crypto_simd snd_timer dm_bufio cryptd cdrom snd glue_helper dm_mod parport_pc soundcore sg floppy parport pcspkr psmouse bochs_drm rtc_cmos ide_pci_generic piix input_leds i2c_piix4 ide_core serio_raw evbug qemu_fw_cfg evdev ip_tables x_tables ipv6 crc_ccitt autofs4
> 	[ 4575.160021] CPU: 3 PID: 4150 Comm: btrfs-transacti Tainted: G        W         5.0.3-zb64+ #1
> 	[ 4575.162484] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
> 	[ 4575.164505] RIP: 0010:__writeback_inodes_sb_nr+0xa9/0xc0
> 	[ 4575.165809] Code: 0f b6 d2 e8 b9 f8 ff ff 48 89 ee 48 89 df e8 0e f8 ff ff 48 8b 44 24 48 65 48 33 04 25 28 00 00 00 75 0b 48 83 c4 50 5b 5d c3 <0f> 0b eb cb e8 4e e9 d6 ff 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00
> 	[ 4575.171927] RSP: 0018:ffffa9cac0eabde8 EFLAGS: 00010246
> 	[ 4575.173045] RAX: 0000000000000000 RBX: ffff9353e23af000 RCX: 0000000000000000
> 	[ 4575.175639] RDX: 0000000000000002 RSI: 0000000000030c67 RDI: ffffa9cac0eabe30
> 	[ 4575.177619] RBP: ffffa9cac0eabdec R08: ffffa9cac0eabdf0 R09: ffff9353f12da000
> 	[ 4575.179736] R10: 0000000000000000 R11: 0000000000000001 R12: ffff9353e1980000
> 	[ 4575.181661] R13: ffff9353e1981430 R14: ffff9353f27e4260 R15: ffff9353e1981518
> 	[ 4575.183871] FS:  0000000000000000(0000) GS:ffff9353f6800000(0000) knlGS:0000000000000000
> 	[ 4575.185940] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> 	[ 4575.188072] CR2: 00007fb81841fa20 CR3: 00000002218c0006 CR4: 00000000001606e0
> 	[ 4575.190094] Call Trace:
> 	[ 4575.190828]  btrfs_commit_transaction+0x7a6/0x9e0
> 	[ 4575.192115]  ? start_transaction+0x91/0x4d0
> 	[ 4575.193197]  transaction_kthread+0x146/0x180
> 	[ 4575.194415]  kthread+0x106/0x140
> 	[ 4575.195403]  ? btrfs_cleanup_transaction+0x620/0x620
> 	[ 4575.196903]  ? kthread_park+0x90/0x90
> 	[ 4575.198412]  ret_from_fork+0x3a/0x50
> 	[ 4575.199374] irq event stamp: 54922780
> 	[ 4575.200218] hardirqs last  enabled at (54922779): [<ffffffffa3d5f2e2>] _raw_spin_unlock_irqrestore+0x32/0x60
> 	[ 4575.202753] hardirqs last disabled at (54922780): [<ffffffffa300379f>] trace_hardirqs_off_thunk+0x1a/0x1c
> 	[ 4575.205921] softirqs last  enabled at (54922378): [<ffffffffa40003a4>] __do_softirq+0x3a4/0x45f
> 	[ 4575.208350] softirqs last disabled at (54922361): [<ffffffffa30a3d44>] irq_exit+0xe4/0xf0
> 	[ 4575.210616] ---[ end trace 5309dcf3a1920eca ]---
> 
> For my own kernel builds I just comment out the line in fs-writeback.c,
> but that's not a real solution.
> 

This is a longstanding and known issue for which no good solution exists
ATM.
