Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 445AFC43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 12:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12F9E20685
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 12:29:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FUUZID9P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbfAHM3u (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 07:29:50 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:36891 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728655AbfAHM3u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 07:29:50 -0500
Received: by mail-vs1-f66.google.com with SMTP id n13so2342251vsk.4
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Jan 2019 04:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=1N2xt29pdUBwJGmdP2pDS0gLmckSbN3Q9vpTNx7mxVg=;
        b=FUUZID9PyX6p8Efs/T28QlnqcdaLRNXxzAQ5XWvG8+4NjlhQnEI3I1NueAOH/47THq
         hIRTIM3GJ4EUF/POoKA9JR5N9sbwduQ25SHEME1XX2fERCJ+jW8nUERpTabpxr2ZXycl
         pwyfzytS4M7pGS9KPGQGQ0rKL6fFU6EreXFX2TKU25VHYMlCKC0nSVcI2phWDNDt3E+r
         hoIoF5wA1+Bpp7jvQOjUzHsYRA9ycpfEfeHdkjhA+WEeZME1h34k2GsGF6IRKH1wjrvm
         uVopVYgAxjL3a1CJCnekt3GWgggTt9isbnreE8Y70JHuPbNGrs0c25616V1WTVqz+5Jt
         PLog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=1N2xt29pdUBwJGmdP2pDS0gLmckSbN3Q9vpTNx7mxVg=;
        b=ceH/gY7ipkav9pR9nBC9CANQfo2XcQZO9YppGRehrQuMOeIFKrcfTWolJNWfrcgn0s
         3npPB3NMlYjPNZic8SdQXfcyAtRS/Ftq1wz469sCrh9knp3io1oiKLTpSBPes7H4SjtV
         ztiHVqcY2/dRPsgOM6ss8B0RlRV/NSVsy/QLX9cWQE5rpnhMPjO9fjaozDKvVAIaTz+M
         W9MM2dTL4ZI5CX3puY5iBx0l3yDdjCzvqkqjilB2pRmGK/k1iNWdqgIRQ0Tg8dLnKVOj
         usSVbMje4B+VdrEh1p7fupbz0BXrulSXKX+ORsEG7D3C2T7zaZXo0pH3ySv/zhfs9yY+
         qumQ==
X-Gm-Message-State: AJcUukerF1jGD0w2nePXfWRc4+RBMRLjN0zED/u9GOY9/aY7aiheAdMy
        wHiqNT5O07YTtxGin5Z6juBQzlQeESWnj8oXIqu5AXZG
X-Google-Smtp-Source: ALg8bN7ZyjYKGj81/QM915FkfxVrGr4/y3mCOSiIkhjp5GxgWuKAqKFVA3zwMXMUFJ9K0S/jZOwwJO2XwLfuIiwNu3M=
X-Received: by 2002:a67:c806:: with SMTP id u6mr618171vsk.206.1546950589051;
 Tue, 08 Jan 2019 04:29:49 -0800 (PST)
MIME-Version: 1.0
References: <2543962.HIiRWmuHEy@exnet.gdb.it> <3834bc23-03bf-f6e4-dd56-2cf028469a82@suse.com>
 <2282965.574ZSNQ4d8@exnet.gdb.it> <CAL3q7H6XWfo1HwRrV0BDVOhQJ3=8R7qd6qoZAQrTNimEYZFh8A@mail.gmail.com>
 <CAO6aweODMWZrsmBKvZQp0sgjQq4ZaBhJM04jEu7YpSbvvfyjDQ@mail.gmail.com>
In-Reply-To: <CAO6aweODMWZrsmBKvZQp0sgjQq4ZaBhJM04jEu7YpSbvvfyjDQ@mail.gmail.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 8 Jan 2019 12:29:37 +0000
Message-ID: <CAL3q7H5AXzJfQg=nLPBKL3TWk9Zf1Q5sET5eL+yuF4XzFynr4g@mail.gmail.com>
Subject: Re: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz' can hangs.
To:     gius db <giusdbg@gmail.com>
Cc:     Jeff Mahoney <jeffm@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 8, 2019 at 12:14 PM gius db <giusdbg@gmail.com> wrote:
>
> Il giorno mar 8 gen 2019 alle ore 00:11 Filipe Manana
> <fdmanana@gmail.com> ha scritto:
>
> ]zac[
> > > [ 1558.056931] Call Trace:
> > > [ 1558.057011]  __btrfs_run_delayed_refs+0x216/0x10b0 [btrfs]
> > > [ 1558.057011]  ? btrfs_free_tree_block+0x82/0x2c0 [btrfs]
> > > [ 1558.057011]  btrfs_run_delayed_refs+0x78/0x180 [btrfs]
> > > [ 1558.057011]  btrfs_should_end_transaction+0x3e/0x60 [btrfs]
> > > [ 1558.057011]  btrfs_drop_snapshot+0x3cf/0x820 [btrfs]
> > > [ 1558.057011]  ? btree_submit_bio_start+0x20/0x20 [btrfs]
> > > [ 1558.057011]  btrfs_clean_one_deleted_snapshot+0xba/0xe0 [btrfs]
> > > [ 1558.057011]  cleaner_kthread+0x129/0x160 [btrfs]
> > > [ 1558.057011]  kthread+0x112/0x130
> > > [ 1558.057011]  ? kthread_create_worker_on_cpu+0x70/0x70
> > > [ 1558.057011]  ret_from_fork+0x35/0x40
> > > [ 1558.057011] Code: 10 48 8b 40 50 f0 48 0f ba a8 30 23 00 00 02 0f =
92 c0 41
> > > 59 84 c0 0f 85 cc a4 09 00 44 89 ee 48 c7 c7 98 9e 75 c0 e8 58 33 a0 =
e7 <0f>
> > > 0b e9 b6 a4 09 00 48 89 df e8 bf 0c ff ff 49 8b 74 24 28 4d
> > > [ 1558.057011] ---[ end trace c4eefd1fdc016ceb ]---
> > > [ 1558.057734] BTRFS: error (device sda3) in __btrfs_free_extent:7007=
:
> > > errno=3D-2 No such entry
> > > [ 1558.057742] BTRFS info (device sda3): forced readonly
> > > [ 1558.057757] BTRFS: error (device sda3) in btrfs_run_delayed_refs:3=
076:
> > > errno=3D-2 No such entry
>
> > Very recently, a fix for this went into kernel 5.0-rc1:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D0568e82dbe2510fc1fa664f58e5c997d3f1e649e
> ]zac[
>
> Thanks for the answer.
>
> If I understand correctly the problem is caused by the concurrence of
> the cleanup process (which is started a few seconds after the end of
> the snapshot deletion) with the other operations on the filesystem.
>
> It matches what I seem to have noticed (problem that occurs after a
> snapshot deletion, occurs randomly due to a race condition, etc..).
>
> P.S. I suppose the 4.x.x kernel will not be corrected.

Why do you suppose that?
The patch has a tag (see the bottom of the changelog) to signal it
should be added to stable kernels 4.4+:

CC: stable@vger.kernel.org # 4.4+



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
