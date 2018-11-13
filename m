Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C68D1C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 17:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81DF7208A3
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 17:58:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nmHT0Sxd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81DF7208A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731971AbeKND5h (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 22:57:37 -0500
Received: from mail-vs1-f68.google.com ([209.85.217.68]:39303 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731625AbeKND5h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 22:57:37 -0500
Received: by mail-vs1-f68.google.com with SMTP id h78so7834793vsi.6
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2018 09:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=8RGbRHdxZ/IlioIeueGwJ9Hu3A0cE68cO5ztJZ3Mf9E=;
        b=nmHT0SxdSanfVclLze/0xd6NYQEIIkdR0eJ4wam8+1wqrPX+K0pv8eEJuWSxViWVOD
         Wxrr575v2nYSE5us1GroUbD9fZZu9mlQ5oqxTrN07geHmrYq6d+MA1ir0cP8MmvB0YHT
         nXeQz41j1yyYH4aOtKwio00Sbnc78PQyigPtfIRlz2YHTitLzHrLBIXH2LN/n5LnRaBF
         thdR6KNXR2ApeMqyIVuHKmNeloCT/3jcyt+H5GM+Dp3O7fAWzQt+J1H8+jwUijwmOew5
         t/of/5Lvt7s7MiPrI7lqUBTzwNsINroSSzc+UvWXsf3pvFvd0hKmg1EFf/d/XtyVzIwn
         C4Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:content-transfer-encoding;
        bh=8RGbRHdxZ/IlioIeueGwJ9Hu3A0cE68cO5ztJZ3Mf9E=;
        b=N0qOSOCCE3e+4B3/UGwIHZkhKJKJEz/+2YNxk7tz9NTKuQ8+/5Zf2b51W03JbkRGYk
         jtQyJnOuv0CuYgFIpJVaX1Jfbfz494nce4+vQZwrzVg39MWsmove4z752yJyrCX6FLUE
         d+8aSAEEOLLbC96BQspPlli06q4Z/dBOomuaEuzti5TVyrG+ZhniXZrYiQaHlUH/Vc9j
         GKjmGSX79UQws0PpjctpgD5t/ai81lcurfhn9Xg4a+BV9Hr22aYZk0j0oxJTijVhRdYf
         3t/ns26Z90FCCP6Tzy6qxd+xuN99rH3kkWCYFsC3sQlFvl9xP+P6U5pXewI5atJGqhPg
         f5JA==
X-Gm-Message-State: AGRZ1gKwkQsaKzWbBRBOWa0DBjB1YS1mq6OwiDnhCgQMe4UDQg3kKfc6
        bFbIdTTYnv0zoMBXr3+3yPdcYaHgL6DLYnD1ZhQ=
X-Google-Smtp-Source: AJdET5d12nVVuHUm/qCYA13mMKskU5BGwh2zAnZiT/NZ1X7ZvqV5FJAXct9PUC4eyaArbp94iExrsUscwj/aTRVvLQM=
X-Received: by 2002:a67:e34e:: with SMTP id s14mr2631371vsm.95.1542131906317;
 Tue, 13 Nov 2018 09:58:26 -0800 (PST)
MIME-Version: 1.0
References: <20181108054919.18253-1-wqu@suse.com> <20181112213332.GS24115@twin.jikos.cz>
 <20181113170724.GE24115@twin.jikos.cz>
In-Reply-To: <20181113170724.GE24115@twin.jikos.cz>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 13 Nov 2018 17:58:14 +0000
Message-ID: <CAL3q7H5H+c6XzwCQP9=bS_TdUam1fFh3HOiWojDkNfdDsKj=yQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] btrfs: qgroup: Delay subtree scan to reduce overhead
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 13, 2018 at 5:08 PM David Sterba <dsterba@suse.cz> wrote:
>
> On Mon, Nov 12, 2018 at 10:33:33PM +0100, David Sterba wrote:
> > On Thu, Nov 08, 2018 at 01:49:12PM +0800, Qu Wenruo wrote:
> > > This patchset can be fetched from github:
> > > https://github.com/adam900710/linux/tree/qgroup_delayed_subtree_rebas=
ed
> > >
> > > Which is based on v4.20-rc1.
> >
> > Thanks, I'll add it to for-next soon.
>
> During test generic/517, the logs were full of the warning below. The ref=
erence
> test on current master, effectively misc-4.20 which was used as base of y=
our
> branch did not get the warning.
>
> [11540.167829] BTRFS: end < start 2519039 2519040
> [11540.170513] WARNING: CPU: 1 PID: 539 at fs/btrfs/extent_io.c:436 inser=
t_state+0xd8/0x100 [btrfs]
> [11540.174411] Modules linked in: dm_thin_pool dm_persistent_data dm_bufi=
o dm_bio_prison btrfs libcrc32c xor zstd_decompress zstd_compress xxhash ra=
id6_pq dm_mod loop [last unloaded: libcrc32c]
> [11540.178279] CPU: 1 PID: 539 Comm: xfs_io Tainted: G      D W         4=
.20.0-rc1-default+ #329
> [11540.180616] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S rel-1.11.2-0-gf9626cc-prebuilt.qemu-project.org 04/01/2014
> [11540.183754] RIP: 0010:insert_state+0xd8/0x100 [btrfs]
> [11540.189173] RSP: 0018:ffffa0d245eafb20 EFLAGS: 00010282
> [11540.189885] RAX: 0000000000000000 RBX: ffff9f0bb3267320 RCX: 000000000=
0000000
> [11540.191646] RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffffffffa=
40c400d
> [11540.192942] RBP: 0000000000266fff R08: 0000000000000001 R09: 000000000=
0000000
> [11540.193871] R10: 0000000000000000 R11: ffffffffa629da2d R12: ffff9f0ba=
0281c60
> [11540.195527] R13: 0000000000267000 R14: ffffa0d245eafb98 R15: ffffa0d24=
5eafb90
> [11540.197026] FS:  00007fa338eb4b80(0000) GS:ffff9f0bbd600000(0000) knlG=
S:0000000000000000
> [11540.198251] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [11540.199698] CR2: 00007fa33873bfb8 CR3: 000000006fb6e000 CR4: 000000000=
00006e0
> [11540.201428] Call Trace:
> [11540.202164]  __set_extent_bit+0x43b/0x5b0 [btrfs]
> [11540.203223]  lock_extent_bits+0x5d/0x210 [btrfs]
> [11540.204346]  ? _raw_spin_unlock+0x24/0x40
> [11540.205381]  ? test_range_bit+0xdf/0x130 [btrfs]
> [11540.206573]  lock_extent_range+0xb8/0x150 [btrfs]
> [11540.207696]  btrfs_double_extent_lock+0x78/0xb0 [btrfs]
> [11540.208988]  btrfs_extent_same_range+0x131/0x4e0 [btrfs]
> [11540.210237]  btrfs_remap_file_range+0x337/0x350 [btrfs]
> [11540.211448]  vfs_dedupe_file_range_one+0x141/0x150
> [11540.212622]  vfs_dedupe_file_range+0x146/0x1a0
> [11540.213795]  do_vfs_ioctl+0x520/0x6c0
> [11540.214711]  ? __fget+0x109/0x1e0
> [11540.215616]  ksys_ioctl+0x3a/0x70
> [11540.216233]  __x64_sys_ioctl+0x16/0x20
> [11540.216860]  do_syscall_64+0x54/0x180
> [11540.217409]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [11540.218126] RIP: 0033:0x7fa338a4daa7

That's the infinite loop issue fixed by one of the patches submitted
for 4.20-rc2:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
h=3Dv4.20-rc2&id=3D11023d3f5fdf89bba5e1142127701ca6e6014587

The branch you used for testing doesn't have that fix?

>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
