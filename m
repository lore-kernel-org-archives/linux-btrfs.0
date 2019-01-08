Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53367C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 12:15:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E5BC206B7
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 12:15:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mMtoG/jX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbfAHMO7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 07:14:59 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43734 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728652AbfAHMO6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 07:14:58 -0500
Received: by mail-ed1-f68.google.com with SMTP id f9so3959873eds.10
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Jan 2019 04:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1DnkBwdjZAY0I8+Yku6l8djtc1T+Q2KUbirNoO1D73o=;
        b=mMtoG/jXWbMsQtRgmE8lsM1pq2Y+5nA2rbP0MomiMuZkWtB/9E7wqsZVvfMviyUY4Y
         yo0hRT5wgpKYxmHZqpZiBYYDEtVJ3+yueRVRftdhfteuNvPipWA4kLQVgdeAnH7eFg76
         dasfsahk4dhwEZmyC1fzPbU6BRndwx6q3MFzJ82P8pU763rmzvXI7FTw38tIfzbsYjQi
         ZcVpaZT1LX7RAb21prva5jCKdra0R38eLIMhZMsFkD4ta1xt1VK9xlbMwwuc90RzSujL
         Zvy0CHgj5Z96ePOv89mzPsNj2j/Bc1mVE8/TYk0si1hcNDl5VkICQ2BXBjPLPaw7ejMK
         ckuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1DnkBwdjZAY0I8+Yku6l8djtc1T+Q2KUbirNoO1D73o=;
        b=KNES9uWE425NqobQ2Vey4E9fhpP0M2AkLb0vNwMAuRLpD4O41nOkERzLMGXYGMKaaA
         /RIBg36ib3tdo1vtAaNpLGfFAJdHT7qNyHYRzsMS1iSFbLYgXOMdAzrXUvo6hoAwWmHF
         hhyxnV3qaCeSE1eWo9JkG0fF8f4LHb1YpYv5RBFHn0bIPKIzXJvW3XumFVtEeW/K05Cn
         xxj8T7SebyxnC+x296J04KarpMRZgebuzDDnvfrWNj3oCdqxawcFqS0uNsBl7FCnlQtM
         Rfnc6mMtjDmNIHTa6cQ5GRkpg44yi6ufjT8fJmbNJFYuK+iNWOnxuoQ+wkd2MH7GFxJC
         SdvQ==
X-Gm-Message-State: AJcUukcamS6Kl5VW8Uf5rCzJygXCdN3rt4K4tpw1kMwl/f6qKOLsQQkz
        69gxPbjau3WIKZgRKHAzLE75oDPj1e+IEyiap0U=
X-Google-Smtp-Source: ALg8bN44IHay+MmQ/hiz7dW6rGP8zxJGV9A6UUa+GGezod5S4aMSWuWGbIMVdzqx0ie6zI74ZOaUSP0vHaE+WDz4F4A=
X-Received: by 2002:a50:9ac4:: with SMTP id p62mr1883236edb.179.1546949696754;
 Tue, 08 Jan 2019 04:14:56 -0800 (PST)
MIME-Version: 1.0
References: <2543962.HIiRWmuHEy@exnet.gdb.it> <3834bc23-03bf-f6e4-dd56-2cf028469a82@suse.com>
 <2282965.574ZSNQ4d8@exnet.gdb.it> <CAL3q7H6XWfo1HwRrV0BDVOhQJ3=8R7qd6qoZAQrTNimEYZFh8A@mail.gmail.com>
In-Reply-To: <CAL3q7H6XWfo1HwRrV0BDVOhQJ3=8R7qd6qoZAQrTNimEYZFh8A@mail.gmail.com>
From:   gius db <giusdbg@gmail.com>
Date:   Tue, 8 Jan 2019 13:14:54 +0100
Message-ID: <CAO6aweODMWZrsmBKvZQp0sgjQq4ZaBhJM04jEu7YpSbvvfyjDQ@mail.gmail.com>
Subject: Re: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz' can hangs.
To:     fdmanana@gmail.com
Cc:     Jeff Mahoney <jeffm@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Il giorno mar 8 gen 2019 alle ore 00:11 Filipe Manana
<fdmanana@gmail.com> ha scritto:

]zac[
> > [ 1558.056931] Call Trace:
> > [ 1558.057011]  __btrfs_run_delayed_refs+0x216/0x10b0 [btrfs]
> > [ 1558.057011]  ? btrfs_free_tree_block+0x82/0x2c0 [btrfs]
> > [ 1558.057011]  btrfs_run_delayed_refs+0x78/0x180 [btrfs]
> > [ 1558.057011]  btrfs_should_end_transaction+0x3e/0x60 [btrfs]
> > [ 1558.057011]  btrfs_drop_snapshot+0x3cf/0x820 [btrfs]
> > [ 1558.057011]  ? btree_submit_bio_start+0x20/0x20 [btrfs]
> > [ 1558.057011]  btrfs_clean_one_deleted_snapshot+0xba/0xe0 [btrfs]
> > [ 1558.057011]  cleaner_kthread+0x129/0x160 [btrfs]
> > [ 1558.057011]  kthread+0x112/0x130
> > [ 1558.057011]  ? kthread_create_worker_on_cpu+0x70/0x70
> > [ 1558.057011]  ret_from_fork+0x35/0x40
> > [ 1558.057011] Code: 10 48 8b 40 50 f0 48 0f ba a8 30 23 00 00 02 0f 92 c0 41
> > 59 84 c0 0f 85 cc a4 09 00 44 89 ee 48 c7 c7 98 9e 75 c0 e8 58 33 a0 e7 <0f>
> > 0b e9 b6 a4 09 00 48 89 df e8 bf 0c ff ff 49 8b 74 24 28 4d
> > [ 1558.057011] ---[ end trace c4eefd1fdc016ceb ]---
> > [ 1558.057734] BTRFS: error (device sda3) in __btrfs_free_extent:7007:
> > errno=-2 No such entry
> > [ 1558.057742] BTRFS info (device sda3): forced readonly
> > [ 1558.057757] BTRFS: error (device sda3) in btrfs_run_delayed_refs:3076:
> > errno=-2 No such entry

> Very recently, a fix for this went into kernel 5.0-rc1:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0568e82dbe2510fc1fa664f58e5c997d3f1e649e
]zac[

Thanks for the answer.

If I understand correctly the problem is caused by the concurrence of
the cleanup process (which is started a few seconds after the end of
the snapshot deletion) with the other operations on the filesystem.

It matches what I seem to have noticed (problem that occurs after a
snapshot deletion, occurs randomly due to a race condition, etc..).

P.S. I suppose the 4.x.x kernel will not be corrected.
