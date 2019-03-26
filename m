Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 657F5C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 23:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1421E2087C
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 23:20:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hxEVekF8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732358AbfCZXUA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 19:20:00 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:41072 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731483AbfCZXUA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 19:20:00 -0400
Received: by mail-vs1-f68.google.com with SMTP id g187so8776699vsc.8
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2019 16:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=bdFBDvCCF1NFfEu7szEfaGyaD2iHgc/ZN/GoZvBMzZ0=;
        b=hxEVekF8IauituaXUB7EOF1BxE5aV8Zo8RW5GnH3kL1cg5lLrhDW4h48daFaQZ1mOx
         3KkPI4KZOAR2zOT73yAYyiiMFqVgLFOFGpjqKqCLenguQCZ5j8DaLPMyO94fKyq4O1i0
         VmH8ZgDLHIPY61G2bD7OG5Jw5kWbX8RWOTZCbnu8cpy3tpJ7EzdyqIy5RZ5xG6wAOior
         4OOJbthRyd66UY8q1F87ew0CHtJMWGUUjWcz1F/KpVBQBSIRR58oU3tjdmnepK3q2O+O
         hoUa+7dgZccBZXbJX/0oR7ryR5LcHWmeMImQ8LNHhfAYQuWe1i2aejp21RNm8OHGRLW+
         L4UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=bdFBDvCCF1NFfEu7szEfaGyaD2iHgc/ZN/GoZvBMzZ0=;
        b=mPaXeB7JICVhJ7R6P6JCqlhFxGYqteNdHoqauQsU8DDJqNpYXQO/tE2BCNV6G3Ot7F
         6WBSjMua4X7r126P2DqS1/A11C6K2tNlKQykvaQnvP01CXy70GITBtUqQ5w6SzQF/eCS
         eejr8850rPLI1Wfb3r7hRyOPcEUmuKyR3krPmzfXcLIX1nRZVgYcUkwuseQnSnnJq/4G
         L22OOzHohIT+7/Zby59nPEarc578rokujARNORBqUr6r7iHejSNRG1zH9GIYRz0TaLJi
         nSkLd5e6OXkpM8JOCaOT5QrNYCFM/iaArMQmtE83vGVwwyfZ2p5pFpc7TlzkYIa85/yB
         aDrQ==
X-Gm-Message-State: APjAAAXwph7sWrT9fu0sOo1ucQ98ybWkIiuLaG1IxyFW9KgfyjNLfwPL
        oi7Lna2LDei/SpjPGNAv/JvW4XkrzQ0RWR+WiyI=
X-Google-Smtp-Source: APXvYqzFS0WDFmbyG2QHg93SiPKjfH3nN8yrHMVzwiqzoSOrVdXs32uZSrjs+YV9hyvfnicGRONBtCPaW35scGOCkH0=
X-Received: by 2002:a67:e24b:: with SMTP id w11mr16106312vse.14.1553642399112;
 Tue, 26 Mar 2019 16:19:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190322041731.GF16651@hungrycats.org> <e5ae3abb-1451-58e9-40f1-83bc49e316a9@suse.com>
 <20190322155911.GE28481@twin.jikos.cz> <CAL3q7H4C_u1CeStAPgotd_UioN8VfmDCWC4h9aTC8hJuPvgg1A@mail.gmail.com>
 <20190326231218.GL16651@hungrycats.org>
In-Reply-To: <20190326231218.GL16651@hungrycats.org>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 26 Mar 2019 23:19:47 +0000
Message-ID: <CAL3q7H4APxb7PjLAQuri=TiQh3Cner0oNfq=Jkscdqab5R0mLg@mail.gmail.com>
Subject: Re: Kernels 4.15..5.0.3: "WARNING: CPU: 2 PID: 4150 at
 fs/fs-writeback.c:2363 __writeback_inodes_sb_nr+0xa9/0xc0"
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc:     dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 11:13 PM Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
>
> On Fri, Mar 22, 2019 at 05:26:52PM +0000, Filipe Manana wrote:
> > On Fri, Mar 22, 2019 at 3:59 PM David Sterba <dsterba@suse.cz> wrote:
> > >
> > > On Fri, Mar 22, 2019 at 09:32:37AM +0200, Nikolay Borisov wrote:
> > > > On 22.03.19 =D0=B3. 6:17 =D1=87., Zygo Blaxell wrote:
> > > > > When filesystems are mounted flushoncommit, I get this warning ro=
ughly
> > > > > every 30 seconds:
> > > > >
> > > > >     [ 4575.142805] WARNING: CPU: 3 PID: 4150 at fs/fs-writeback.c=
:2363 __writeback_inodes_sb_nr+0xa9/0xc0
> > > > >     [ 4575.145567] Modules linked in: crct10dif_pclmul crc32_pclm=
ul dm_cache_smq crc32c_intel dm_cache snd_pcm ghash_clmulni_intel aesni_int=
el sr_mod dm_persistent_data ppdev joydev dm_bio_prison aes_x86_64 crypto_s=
imd snd_timer dm_bufio cryptd cdrom snd glue_helper dm_mod parport_pc sound=
core sg floppy parport pcspkr psmouse bochs_drm rtc_cmos ide_pci_generic pi=
ix input_leds i2c_piix4 ide_core serio_raw evbug qemu_fw_cfg evdev ip_table=
s x_tables ipv6 crc_ccitt autofs4
> > > > >     [ 4575.160021] CPU: 3 PID: 4150 Comm: btrfs-transacti Tainted=
: G        W         5.0.3-zb64+ #1
> > > > >     [ 4575.162484] Hardware name: QEMU Standard PC (i440FX + PIIX=
, 1996), BIOS 1.10.2-1 04/01/2014
> > > > >     [ 4575.164505] RIP: 0010:__writeback_inodes_sb_nr+0xa9/0xc0
> > > > >     [ 4575.165809] Code: 0f b6 d2 e8 b9 f8 ff ff 48 89 ee 48 89 d=
f e8 0e f8 ff ff 48 8b 44 24 48 65 48 33 04 25 28 00 00 00 75 0b 48 83 c4 5=
0 5b 5d c3 <0f> 0b eb cb e8 4e e9 d6 ff 0f 1f 40 00 66 2e 0f 1f 84 00 00 00=
 00
> > > > >     [ 4575.171927] RSP: 0018:ffffa9cac0eabde8 EFLAGS: 00010246
> > > > >     [ 4575.173045] RAX: 0000000000000000 RBX: ffff9353e23af000 RC=
X: 0000000000000000
> > > > >     [ 4575.175639] RDX: 0000000000000002 RSI: 0000000000030c67 RD=
I: ffffa9cac0eabe30
> > > > >     [ 4575.177619] RBP: ffffa9cac0eabdec R08: ffffa9cac0eabdf0 R0=
9: ffff9353f12da000
> > > > >     [ 4575.179736] R10: 0000000000000000 R11: 0000000000000001 R1=
2: ffff9353e1980000
> > > > >     [ 4575.181661] R13: ffff9353e1981430 R14: ffff9353f27e4260 R1=
5: ffff9353e1981518
> > > > >     [ 4575.183871] FS:  0000000000000000(0000) GS:ffff9353f680000=
0(0000) knlGS:0000000000000000
> > > > >     [ 4575.185940] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050=
033
> > > > >     [ 4575.188072] CR2: 00007fb81841fa20 CR3: 00000002218c0006 CR=
4: 00000000001606e0
> > > > >     [ 4575.190094] Call Trace:
> > > > >     [ 4575.190828]  btrfs_commit_transaction+0x7a6/0x9e0
> > > > >     [ 4575.192115]  ? start_transaction+0x91/0x4d0
> > > > >     [ 4575.193197]  transaction_kthread+0x146/0x180
> > > > >     [ 4575.194415]  kthread+0x106/0x140
> > > > >     [ 4575.195403]  ? btrfs_cleanup_transaction+0x620/0x620
> > > > >     [ 4575.196903]  ? kthread_park+0x90/0x90
> > > > >     [ 4575.198412]  ret_from_fork+0x3a/0x50
> > > > >     [ 4575.199374] irq event stamp: 54922780
> > > > >     [ 4575.200218] hardirqs last  enabled at (54922779): [<ffffff=
ffa3d5f2e2>] _raw_spin_unlock_irqrestore+0x32/0x60
> > > > >     [ 4575.202753] hardirqs last disabled at (54922780): [<ffffff=
ffa300379f>] trace_hardirqs_off_thunk+0x1a/0x1c
> > > > >     [ 4575.205921] softirqs last  enabled at (54922378): [<ffffff=
ffa40003a4>] __do_softirq+0x3a4/0x45f
> > > > >     [ 4575.208350] softirqs last disabled at (54922361): [<ffffff=
ffa30a3d44>] irq_exit+0xe4/0xf0
> > > > >     [ 4575.210616] ---[ end trace 5309dcf3a1920eca ]---
> > > > >
> > > > > For my own kernel builds I just comment out the line in fs-writeb=
ack.c,
> > > > > but that's not a real solution.
> > > > >
> > > >
> > > > This is a longstanding and known issue for which no good solution e=
xists
> > > > ATM.
> > >
> > > The s_umount mutex is taken around the writeback_inodes_sb_nr call in
> > > btrfs_writeback_inodes_sb_nr:
> > >
> > >  4689 static void btrfs_writeback_inodes_sb_nr(struct btrfs_fs_info *=
fs_info,
> > >  4690                                          unsigned long nr_pages=
, int nr_items)
> > >  4691 {
> > >  4692         struct super_block *sb =3D fs_info->sb;
> > >  4693
> > >  4694         if (down_read_trylock(&sb->s_umount)) {
> > >  4695                 writeback_inodes_sb_nr(sb, nr_pages, WB_REASON_=
FS_FREE_SPACE);
> > >  4696                 up_read(&sb->s_umount);
> > >  4697         } else {
> > >
> > > but __writeback_inodes_sb_nr still complains.
> >
> > Yes, because btrfs_witeback_inodes_sb_nr() is not what is called
> > during transaction commit if the fs is mounted with -o flushoncommit.
> > What is called is writeback_inodes_sb() (which gets __writeback_inodes_=
sb_nr()).
> >
> > Calling btrfs_witeback_inodes_sb_nr() would just fallback to
> > btrfs_start_delalloc_roots() during a concurrent freeze (which does a
> > down_write()
> > on that semaphore), bringing back the problem Josef tried to fix at [1]=
.
> >
> > This problem of the warning, and the original problem [1], could
> > possibly be solved by making sure no regular transaction joins happen
> > after we
> > start the transaction commit, something along the lines of:
> >
> > https://friendpaste.com/45NhhVPko5txKuuzDPqhyK
>
> I threw that patch at a test machine to see what happens, and what happen=
s
> is that the filesystem is destroyed a few hours later.  So something alon=
g
> those lines...but definitely not exactly that.  ;)

Not surprised, it was only compile tested. Didn't run it, but it has
some room for races.

>
> I wonder if this is related to the deadlocks on 4.14 that are
> taking my machines down daily.  The symptoms sound similar:
> btrfs_start_delalloc_roots and __sb_start_write (which is called by
> sb_start_intwrite) are on call traces in 7 out of 15 deadlock cases
> (all 15 have btrfs_start_delalloc_roots, 8 do not have __sb_start_write).
> That would mean that there's two distinct deadlock bugs in 4.14, but hey,
> I'm willing to fix them one at a time...
>
> I'll try putting ce8ea7cc6eb3139f4c730d647325e69354159b0f on a 4.14
> kernel during the next testing cycle and see what happens.
>
> > Adding Josef to cc.
> >
> > To just silence the warning, adding a down_read_trylock()/upread() at
> > btrfs_start_delalloc_flush() would be simple.
> >
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3Dce8ea7cc6eb3139f4c730d647325e69354159b0f
> >
> > > So, that's a longstanding issue and I think there must be a precise
> > > analysis why this is hard to solve somewhere in the mailinglist but I=
'm
> > > not going to look it up right now.
> > >
> > > The other comment in btrfs_writeback_inodes_sb_nr says why it's ok to
> > > skip the s_umount mutex because we know there's other protection agai=
nst
> > > remount.
> > >
> > > If the down_read_trylock does not help to get rid of the warning, why
> > > it's there or why is it not taken for write?
> >
> >
> >
> > --
> > Filipe David Manana,
> >
> > =E2=80=9CWhether you think you can, or you think you can't =E2=80=94 yo=
u're right.=E2=80=9D



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
