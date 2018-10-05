Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39DD3C00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 15:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E83F6206B2
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 15:21:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nSYo+JhI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E83F6206B2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbeJEWU5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 18:20:57 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:33912 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727788AbeJEWU5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 18:20:57 -0400
Received: by mail-ua1-f67.google.com with SMTP id r15-v6so4836407uao.1
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Oct 2018 08:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=V8DvFKRnQ6fzfoD14SR5Q4WdFjEaFvL+SloRAwvBPcw=;
        b=nSYo+JhICjDY5yEJLCGrFdkRYmfuiRK+yd72Zw26mbq8ZCYMrhi+CvZKr7ctd77NYp
         Bv1Qel49+XbgIBkE3rCDnrMk+DFQIx/hC/PQDy4ZD/SniTHUePScm/qZAtsK/tQrQPWF
         s0/GbdmdfXoqJX+RDa1kvMRqpml6/ImUqMVAGhhSgC8C4oimKf+Ua762Nle6w9z2b7Zb
         fPFBw88BBX8KEiTDoQaK0hc6jkZwSY8PI4BCZVr8ApxN1Y19JvHRfEq3nbYplH14PS54
         BFko4b4yIyueGAZxx4LT3QqULwk7ctJ3juOl3x4AXtn+rhU32Dw+WyIFGXXtuxGOOJ+2
         Nm/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=V8DvFKRnQ6fzfoD14SR5Q4WdFjEaFvL+SloRAwvBPcw=;
        b=Jeq83F8JqqXtnyPGEbhcvZkyGZoeRVikdfKMsjGMGGOmX41An45oGTvzh12PjPEknz
         pnXT+a0Mx2RuiDW5HR6FgHUw1+INPWIRoXYgh4jr/MFrpMtXtkn1m9FYKg+k+4pcPxEm
         KB5dG9gDr/sjloxiVphAvKJbRFPgCM9wz0XKSi62neLpJLBRMvrCRTIpGFqr44AnjtAr
         3UeCN0oJzca7Ffq73mX37QLz5TLT4COd8VL/Si8eyIlcFBMlsZjCQuV2Ys68gCygIBqb
         G9gwaRkxZyGS6F3il6691hvKwaU4c2bcOmWm17eQWsEigVZZw43iSnEGPVOVCRRiDUzh
         U7gA==
X-Gm-Message-State: ABuFfoh5MoRchupx+CG6oaUKQ0agBj9Uepgm/41/splu/B7+Gl2VtzyX
        yPydgWLzTpXz0gclnRCQE63N5G08nX7xqbtlMm9vSw==
X-Google-Smtp-Source: ACcGV63hewMy/2SV/fiKyTugykywnaKaeTHp1RePD4db6SIgBAyt/Z6pby4RJkqXonGvf/40U+23nIncA/8aDz94WGs=
X-Received: by 2002:ab0:6057:: with SMTP id o23-v6mr4888711ual.30.1538752906365;
 Fri, 05 Oct 2018 08:21:46 -0700 (PDT)
MIME-Version: 1.0
References: <3666619.NTnn27ZJZE@merkaba>
In-Reply-To: <3666619.NTnn27ZJZE@merkaba>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 5 Oct 2018 16:21:34 +0100
Message-ID: <CAL3q7H5Hi_C7Qe1Tv2ig7HX0rj+p0g8ipCqDYoNfNoHu+LWKmw@mail.gmail.com>
Subject: Re: BTRFS related kernel backtrace on boot on 4.18.7 after blackout
 due to discharged battery
To:     Martin Steigerwald <martin@lichtvoll.de>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 5, 2018 at 3:23 PM Martin Steigerwald <martin@lichtvoll.de> wro=
te:
>
> Hello!
>
> On ThinkPad T520 after battery was discharged and machine just blacked
> out.
>
> Is that some sign of regular consistency check / replay or something to
> investigate further?

I think it's harmless, if anything were messed up with link counts or
mismatches between those and dir entries, fsck (btrfs check) should
have reported something.
I'll dig a big further and remove the warning if it's really harmless.

Thanks.

>
> I already scrubbed all data and there are no errors. Also btrfs device st=
ats
> reports no errors. SMART status appears to be okay as well on both SSD.
>
> [    4.524355] BTRFS info (device dm-4): disk space caching is enabled
> [    4.524356] BTRFS info (device dm-4): has skinny extents
> [    4.563950] BTRFS info (device dm-4): enabling ssd optimizations
> [    5.463085] Console: switching to colour frame buffer device 240x67
> [    5.492236] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
> [    5.882661] BTRFS info (device dm-3): disk space caching is enabled
> [    5.882664] BTRFS info (device dm-3): has skinny extents
> [    5.918579] SGI XFS with ACLs, security attributes, realtime, scrub, n=
o debug enabled
> [    5.927421] Adding 20971516k swap on /dev/mapper/sata-swap.  Priority:=
-2 extents:1 across:20971516k SSDsc
> [    5.935051] XFS (sdb1): Mounting V5 Filesystem
> [    5.935218] XFS (sda1): Mounting V5 Filesystem
> [    5.961100] XFS (sda1): Ending clean mount
> [    5.970857] BTRFS info (device dm-3): enabling ssd optimizations
> [    5.972358] XFS (sdb1): Ending clean mount
> [    5.975955] WARNING: CPU: 1 PID: 1104 at fs/inode.c:342 inc_nlink+0x28=
/0x30
> [    5.978271] Modules linked in: xfs msr pktcdvd intel_rapl x86_pkg_temp=
_thermal intel_powerclamp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pc=
lmul ghash_clmulni_intel snd_hda_codec_hdmi pcbc arc4 snd_hda_codec_conexan=
t snd_hda_codec_generic iwldvm mac80211 iwlwifi aesni_intel snd_hda_intel s=
nd_hda_codec aes_x86_64 crypto_simd cryptd snd_hda_core glue_helper intel_c=
state snd_hwdep intel_rapl_perf snd_pcm pcspkr input_leds i915 sg cfg80211 =
snd_timer thinkpad_acpi nvram drm_kms_helper snd soundcore tpm_tis tpm_tis_=
core drm rfkill ac tpm i2c_algo_bit fb_sys_fops battery rng_core video sysc=
opyarea sysfillrect sysimgblt button evdev sbs sbshc coretemp bfq hdaps(O) =
tp_smapi(O) thinkpad_ec(O) loop ecryptfs cbc sunrpc mcryptd sha256_ssse3 sh=
a256_generic encrypted_keys ip_tables x_tables autofs4 dm_mod
> [    5.990499]  btrfs xor zstd_decompress zstd_compress xxhash zlib_defla=
te raid6_pq libcrc32c crc32c_generic sr_mod cdrom sd_mod hid_lenovo hid_gen=
eric usbhid hid ahci libahci libata ehci_pci crc32c_intel psmouse i2c_i801 =
sdhci_pci cqhci lpc_ich sdhci ehci_hcd e1000e scsi_mod i2c_core mfd_core mm=
c_core usbcore usb_common thermal
> [    5.990529] CPU: 1 PID: 1104 Comm: mount Tainted: G           O      4=
.18.7-tp520 #63
> [    5.990532] Hardware name: LENOVO 42433WG/42433WG, BIOS 8AET69WW (1.49=
 ) 06/14/2018
> [    6.000153] RIP: 0010:inc_nlink+0x28/0x30
> [    6.000154] Code: 00 00 8b 47 48 85 c0 74 07 83 c0 01 89 47 48 c3 f6 8=
7 a1 00 00 00 04 74 11 48 8b 47 28 f0 48 ff 88 98 04 00 00 8b 47 48 eb df <=
0f> 0b eb eb 0f 1f 40 00 41 54 8b 0d 70 3f aa 00 48 ba eb 83 b5 80
> [    6.008573] RSP: 0018:ffffc90002283828 EFLAGS: 00010246
> [    6.008575] RAX: 0000000000000000 RBX: ffff8804018bed58 RCX: 000000000=
0022261
> [    6.008576] RDX: 0000000000022251 RSI: 0000000000000000 RDI: ffff88040=
18bed58
> [    6.008577] RBP: ffffc90002283a50 R08: 000000000002a330 R09: ffffffffa=
02f3873
> [    6.008578] R10: 30ffffffffffffff R11: 0000000000007763 R12: 000000000=
0000011
> [    6.008579] R13: 0000000000003d5f R14: ffff880403e19800 R15: ffff88040=
a3c69a0
> [    6.008580] FS:  00007f071598f100(0000) GS:ffff88041e240000(0000) knlG=
S:0000000000000000
> [    6.008581] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    6.008589] CR2: 00007fda4fbf8218 CR3: 0000000403e42001 CR4: 000000000=
00606e0
> [    6.008590] Call Trace:
> [    6.008614]  replay_one_buffer+0x80e/0x890 [btrfs]
> [    6.008632]  walk_up_log_tree+0x1dc/0x260 [btrfs]
> [    6.046858]  walk_log_tree+0xaf/0x1e0 [btrfs]
> [    6.046872]  btrfs_recover_log_trees+0x21c/0x410 [btrfs]
> [    6.046885]  ? btree_read_extent_buffer_pages+0xcd/0x210 [btrfs]
> [    6.055941]  ? fixup_inode_link_counts+0x170/0x170 [btrfs]
> [    6.055953]  open_ctree+0x1a0d/0x1b60 [btrfs]
> [    6.055965]  btrfs_mount_root+0x67b/0x760 [btrfs]
> [    6.065039]  ? pcpu_alloc_area+0xdd/0x120
> [    6.065040]  ? pcpu_next_unpop+0x32/0x40
> [    6.065052]  mount_fs+0x36/0x162
> [    6.065055]  vfs_kern_mount.part.34+0x4f/0x120
> [    6.065064]  btrfs_mount+0x15f/0x890 [btrfs]
> [    6.065067]  ? pcpu_cnt_pop_pages+0x40/0x50
> [    6.065069]  ? pcpu_alloc_area+0xdd/0x120
> [    6.065071]  ? pcpu_next_unpop+0x32/0x40
> [    6.065073]  ? cpumask_next+0x16/0x20
> [    6.065075]  ? pcpu_alloc+0x1c3/0x690
> [    6.065078]  ? mount_fs+0x36/0x162
> [    6.099840]  mount_fs+0x36/0x162
> [    6.099843]  vfs_kern_mount.part.34+0x4f/0x120
> [    6.099845]  do_mount+0x1f7/0xc80
> [    6.099856]  ksys_mount+0xb5/0xd0
> [    6.099859]  __x64_sys_mount+0x1c/0x20
> [    6.099861]  do_syscall_64+0x43/0xd0
> [    6.099864]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [    6.099866] RIP: 0033:0x7f0715b89a1a
> [    6.099867] Code: 48 8b 0d 71 e4 0b 00 f7 d8 64 89 01 48 83 c8 ff c3 6=
6 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <=
48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 3e e4 0b 00 f7 d8 64 89 01 48
> [    6.123872] RSP: 002b:00007ffc0e3466a8 EFLAGS: 00000202 ORIG_RAX: 0000=
0000000000a5
> [    6.131285] RAX: ffffffffffffffda RBX: 000055f3ed7ee9c0 RCX: 00007f071=
5b89a1a
> [    6.131286] RDX: 000055f3ed7eebc0 RSI: 000055f3ed7eec40 RDI: 000055f3e=
d7ef900
> [    6.131287] RBP: 00007f0715ecff04 R08: 000055f3ed7eec00 R09: 000055f3e=
d7eebc0
> [    6.131288] R10: 00000000c0ed0400 R11: 0000000000000202 R12: 000000000=
0000000
> [    6.131289] R13: 00000000c0ed0400 R14: 000055f3ed7ef900 R15: 000055f3e=
d7eebc0
> [    6.131292] ---[ end trace bd5d30b2fea7fb77 ]---
> [    6.251219] BTRFS info (device dm-3): checking UUID tree
>
> Thanks,
> --
> Martin
>
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
