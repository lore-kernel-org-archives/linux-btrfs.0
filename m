Return-Path: <SRS0=iEal=RZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ABC5C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 17:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6091E20850
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 17:27:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PttJ0UaX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbfCVR1F (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Mar 2019 13:27:05 -0400
Received: from mail-vk1-f193.google.com ([209.85.221.193]:42561 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727741AbfCVR1E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Mar 2019 13:27:04 -0400
Received: by mail-vk1-f193.google.com with SMTP id j195so637002vkj.9
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Mar 2019 10:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=yOfqkt7jGFtFCx3fPFQbr2c0l7zUseWe3X12xNDcwPc=;
        b=PttJ0UaXaEmcYV76ien2Q1PwJ5zRMRuH+bF8KL0G8T0CgAi7DIGjCYq4W8Mpor16ZA
         MrvSLLysHAYVQgdoYkftGlV1UWg0H3kDkvEH8qWOiUKgkOh3YcXoePUIfj4Tws2PElcK
         IL9WffAbC4lPi+LWrmC7GPlNTTwIqvwNczTeqGVMgAWfvlTixS6rY5JeGrplK4ai8LRd
         GiVB8nSDLcAdRZNtG1IYQhN6WtASqIgyk0H9Ljf9fLMC8I3OTjx282TLh3DHw/nZ4IxG
         7vpVpRBxNYGYtTRlQYC42PwivdwcIIayvOXRGYfTUqpeM0H0jxgTX/3zz3jLyVgbrjGR
         k1bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=yOfqkt7jGFtFCx3fPFQbr2c0l7zUseWe3X12xNDcwPc=;
        b=WElfonQmy3Z5OA2z85L/efq6o7I1acUUYZKxJZuuW9v5aPXaGXQECfu6pC5kpnKEW9
         LWLx+JCKiSyg3C0jVRI9fkMHgYypcsMmoG4qoVec5KVlahn1N7PyQ5Nf3lDfHgs9pfCJ
         j06p5N72aYeHaYK6zBGKuxKYH2JbxDI+0AGsBjbQxiuSFvExsSoj9Zsgap60MGVjV3/a
         u/EzGx2kqvMmSCIul/Umk/CA0qFO/Xo4aNhCOPpUAc0l5Zx5JGBA4azKfkW1Xgdrcd/d
         64fYLS2uNh4QVptEufDF9rThvisOa24NEDtgUqZH13EunvhJn/zV/diFND1Fq+eZfQaz
         E1Jw==
X-Gm-Message-State: APjAAAURDElF9Tt4XDN779QHJ3tnu1+gSORRaxpzzsdv14RZ+9GPUuyC
        EZ1ra5eV44GbkWb8ke/OmCJEhYS9Ww4IC+L1WHhT0hrI
X-Google-Smtp-Source: APXvYqz8L8EmeBlxbzVQMMtEOrI5qmhuuiyx8CH5QawTqCriGBY+CTjMUlmw+TIM3pJH6MpD6vScv9chSdmma4Dm0y8=
X-Received: by 2002:a1f:1cd2:: with SMTP id c201mr6604820vkc.88.1553275622974;
 Fri, 22 Mar 2019 10:27:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190322041731.GF16651@hungrycats.org> <e5ae3abb-1451-58e9-40f1-83bc49e316a9@suse.com>
 <20190322155911.GE28481@twin.jikos.cz>
In-Reply-To: <20190322155911.GE28481@twin.jikos.cz>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 22 Mar 2019 17:26:52 +0000
Message-ID: <CAL3q7H4C_u1CeStAPgotd_UioN8VfmDCWC4h9aTC8hJuPvgg1A@mail.gmail.com>
Subject: Re: Kernels 4.15..5.0.3: "WARNING: CPU: 2 PID: 4150 at
 fs/fs-writeback.c:2363 __writeback_inodes_sb_nr+0xa9/0xc0"
To:     dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Cc:     Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 22, 2019 at 3:59 PM David Sterba <dsterba@suse.cz> wrote:
>
> On Fri, Mar 22, 2019 at 09:32:37AM +0200, Nikolay Borisov wrote:
> > On 22.03.19 =D0=B3. 6:17 =D1=87., Zygo Blaxell wrote:
> > > When filesystems are mounted flushoncommit, I get this warning roughl=
y
> > > every 30 seconds:
> > >
> > >     [ 4575.142805] WARNING: CPU: 3 PID: 4150 at fs/fs-writeback.c:236=
3 __writeback_inodes_sb_nr+0xa9/0xc0
> > >     [ 4575.145567] Modules linked in: crct10dif_pclmul crc32_pclmul d=
m_cache_smq crc32c_intel dm_cache snd_pcm ghash_clmulni_intel aesni_intel s=
r_mod dm_persistent_data ppdev joydev dm_bio_prison aes_x86_64 crypto_simd =
snd_timer dm_bufio cryptd cdrom snd glue_helper dm_mod parport_pc soundcore=
 sg floppy parport pcspkr psmouse bochs_drm rtc_cmos ide_pci_generic piix i=
nput_leds i2c_piix4 ide_core serio_raw evbug qemu_fw_cfg evdev ip_tables x_=
tables ipv6 crc_ccitt autofs4
> > >     [ 4575.160021] CPU: 3 PID: 4150 Comm: btrfs-transacti Tainted: G =
       W         5.0.3-zb64+ #1
> > >     [ 4575.162484] Hardware name: QEMU Standard PC (i440FX + PIIX, 19=
96), BIOS 1.10.2-1 04/01/2014
> > >     [ 4575.164505] RIP: 0010:__writeback_inodes_sb_nr+0xa9/0xc0
> > >     [ 4575.165809] Code: 0f b6 d2 e8 b9 f8 ff ff 48 89 ee 48 89 df e8=
 0e f8 ff ff 48 8b 44 24 48 65 48 33 04 25 28 00 00 00 75 0b 48 83 c4 50 5b=
 5d c3 <0f> 0b eb cb e8 4e e9 d6 ff 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00
> > >     [ 4575.171927] RSP: 0018:ffffa9cac0eabde8 EFLAGS: 00010246
> > >     [ 4575.173045] RAX: 0000000000000000 RBX: ffff9353e23af000 RCX: 0=
000000000000000
> > >     [ 4575.175639] RDX: 0000000000000002 RSI: 0000000000030c67 RDI: f=
fffa9cac0eabe30
> > >     [ 4575.177619] RBP: ffffa9cac0eabdec R08: ffffa9cac0eabdf0 R09: f=
fff9353f12da000
> > >     [ 4575.179736] R10: 0000000000000000 R11: 0000000000000001 R12: f=
fff9353e1980000
> > >     [ 4575.181661] R13: ffff9353e1981430 R14: ffff9353f27e4260 R15: f=
fff9353e1981518
> > >     [ 4575.183871] FS:  0000000000000000(0000) GS:ffff9353f6800000(00=
00) knlGS:0000000000000000
> > >     [ 4575.185940] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > >     [ 4575.188072] CR2: 00007fb81841fa20 CR3: 00000002218c0006 CR4: 0=
0000000001606e0
> > >     [ 4575.190094] Call Trace:
> > >     [ 4575.190828]  btrfs_commit_transaction+0x7a6/0x9e0
> > >     [ 4575.192115]  ? start_transaction+0x91/0x4d0
> > >     [ 4575.193197]  transaction_kthread+0x146/0x180
> > >     [ 4575.194415]  kthread+0x106/0x140
> > >     [ 4575.195403]  ? btrfs_cleanup_transaction+0x620/0x620
> > >     [ 4575.196903]  ? kthread_park+0x90/0x90
> > >     [ 4575.198412]  ret_from_fork+0x3a/0x50
> > >     [ 4575.199374] irq event stamp: 54922780
> > >     [ 4575.200218] hardirqs last  enabled at (54922779): [<ffffffffa3=
d5f2e2>] _raw_spin_unlock_irqrestore+0x32/0x60
> > >     [ 4575.202753] hardirqs last disabled at (54922780): [<ffffffffa3=
00379f>] trace_hardirqs_off_thunk+0x1a/0x1c
> > >     [ 4575.205921] softirqs last  enabled at (54922378): [<ffffffffa4=
0003a4>] __do_softirq+0x3a4/0x45f
> > >     [ 4575.208350] softirqs last disabled at (54922361): [<ffffffffa3=
0a3d44>] irq_exit+0xe4/0xf0
> > >     [ 4575.210616] ---[ end trace 5309dcf3a1920eca ]---
> > >
> > > For my own kernel builds I just comment out the line in fs-writeback.=
c,
> > > but that's not a real solution.
> > >
> >
> > This is a longstanding and known issue for which no good solution exist=
s
> > ATM.
>
> The s_umount mutex is taken around the writeback_inodes_sb_nr call in
> btrfs_writeback_inodes_sb_nr:
>
>  4689 static void btrfs_writeback_inodes_sb_nr(struct btrfs_fs_info *fs_i=
nfo,
>  4690                                          unsigned long nr_pages, in=
t nr_items)
>  4691 {
>  4692         struct super_block *sb =3D fs_info->sb;
>  4693
>  4694         if (down_read_trylock(&sb->s_umount)) {
>  4695                 writeback_inodes_sb_nr(sb, nr_pages, WB_REASON_FS_F=
REE_SPACE);
>  4696                 up_read(&sb->s_umount);
>  4697         } else {
>
> but __writeback_inodes_sb_nr still complains.

Yes, because btrfs_witeback_inodes_sb_nr() is not what is called
during transaction commit if the fs is mounted with -o flushoncommit.
What is called is writeback_inodes_sb() (which gets __writeback_inodes_sb_n=
r()).

Calling btrfs_witeback_inodes_sb_nr() would just fallback to
btrfs_start_delalloc_roots() during a concurrent freeze (which does a
down_write()
on that semaphore), bringing back the problem Josef tried to fix at [1].

This problem of the warning, and the original problem [1], could
possibly be solved by making sure no regular transaction joins happen
after we
start the transaction commit, something along the lines of:

https://friendpaste.com/45NhhVPko5txKuuzDPqhyK

Adding Josef to cc.

To just silence the warning, adding a down_read_trylock()/upread() at
btrfs_start_delalloc_flush() would be simple.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3Dce8ea7cc6eb3139f4c730d647325e69354159b0f

> So, that's a longstanding issue and I think there must be a precise
> analysis why this is hard to solve somewhere in the mailinglist but I'm
> not going to look it up right now.
>
> The other comment in btrfs_writeback_inodes_sb_nr says why it's ok to
> skip the s_umount mutex because we know there's other protection against
> remount.
>
> If the down_read_trylock does not help to get rid of the warning, why
> it's there or why is it not taken for write?



--
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
