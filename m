Return-Path: <SRS0=zk84=PP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D32D7C43387
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 17:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FF4F2070B
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 17:53:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aWLDfHfj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbfAGRxk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Jan 2019 12:53:40 -0500
Received: from mail-ed1-f48.google.com ([209.85.208.48]:35179 "EHLO
        mail-ed1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728621AbfAGRxk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jan 2019 12:53:40 -0500
Received: by mail-ed1-f48.google.com with SMTP id x30so1753864edx.2
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Jan 2019 09:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YUd8cpeK+0IAEo3G4FNVNsJCWuoLz929yWI0mXojQIM=;
        b=aWLDfHfjdospu1GT6Mqf+8X3uorHr48+HiZTprzVT3rdO0hDx77JU6qCm/9SYfmo2e
         LPircG2HtXjxVV4xQ0pTi0lyY73Z+JKmXDmUkziG7q+xQcvp7yxBC12FWHy0Dy7QOpQv
         zhT50i4MBmeYCPgHNDX9QB7NMfbUW8mPw6cupMsEuSSzjDXgbXC7jPoXUykUhzzyQcpu
         r9MTmWMmzvlaZcKM/aDHiAAgmqGCi7hlEfSs2ZTbdtAWTzNUgci1OhZ5Ecim0gN1zdT6
         4/SD/AxqdRoacnAf6P/esoSFQeU+49mGKa/yLcVi3YPH2w6IHuqITbpOxwCZmGSwHkt0
         i37Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YUd8cpeK+0IAEo3G4FNVNsJCWuoLz929yWI0mXojQIM=;
        b=LwGPMJFx+2wa1pWGoZvoiFs/19Hjp3fjpOtoyQknOgptfMUz14r0hiTDw2hA+xB88J
         w+6xTS1jVA4kZfDRw8Q8X6aMiq40PDYQKsoW6jbNaI4Di1v2IWlvhC6qp12jTtifacKs
         +AdrcprFyRZ68oKPuDGCK+318mxytlao372bY8rvQUNoO+gr40+6CW8uvg/kzF1ezX4d
         DAtYXA49wu8PptECK2Rgyn5OF5zFuT/96PauG8tXPrHkb5mail2kzZyOIbRBvE2M0Dtk
         HLY2PAfdcZEhotFRUKBHsWtQNnAHZYQw27egwJSwctOiNyHD3yuYKIXf4RhsUKKoQduc
         5tTQ==
X-Gm-Message-State: AA+aEWZoWFtQKEgo5LUouQ1u6yisGdz0UldLETwgu3jl5PET8+EL7cpx
        Qlk4mELS6AKGJKZIXpMsxxXerTvksgRhpARB3Wc=
X-Google-Smtp-Source: AFSGD/XUeNkpE/lIYYDY5ZsXcgfR3qHPvY6Bnwsi+/SeKjAEucaZkhpt2vpGDoZbuvjOQX0Uwt0w8Vdm4V+HyxYEvBw=
X-Received: by 2002:a50:a55c:: with SMTP id z28mr56438858edb.124.1546883617793;
 Mon, 07 Jan 2019 09:53:37 -0800 (PST)
MIME-Version: 1.0
References: <2543962.HIiRWmuHEy@exnet.gdb.it> <2971657.kkKnYu9ILp@exnet.gdb.it>
 <dc635a98-32cc-4f84-2319-82ef651d3f49@gmx.com> <2025891.FNXETDMuRi@exnet.gdb.it>
 <f441516a-7704-4e20-100f-ddd046b61be3@gmx.com> <CAO6awePqby834dBSgLx5r6onmD9HhGWAfN4bno0zK6pU0QjrEQ@mail.gmail.com>
 <CAO6aweNy006hbwEVCuoQ_cSRKP-QRX2UWji6D-E8gkxH8tbm7w@mail.gmail.com>
 <5badae31-10cd-cb28-4808-8b8b56c1d444@gmx.com> <CAO6aweMu9HUn34406Kkh-UvoDyoJH2ZdGUQx3vdx1Rj955E4KQ@mail.gmail.com>
In-Reply-To: <CAO6aweMu9HUn34406Kkh-UvoDyoJH2ZdGUQx3vdx1Rj955E4KQ@mail.gmail.com>
From:   gius db <giusdbg@gmail.com>
Date:   Mon, 7 Jan 2019 18:53:33 +0100
Message-ID: <CAO6aweN5Nt3pcHarKCQOSt5U+UYB=TFamHy97kAsf3AnH3Cs0w@mail.gmail.com>
Subject: Fwd: Fwd: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz'
 can hangs.
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Il giorno lun 7 gen 2019 alle ore 14:31 Qu Wenruo
<quwenruo.btrfs@gmx.com> ha scritto:
]zac[
> >> It's relatively common that extent tree get corrupted before and some
> >> unfortunately operation touching the corrupted extent tree triggered
> >> some user affecting error.
> >
> > Yes, I understand, but the use of filesytem is very specific.
> >
> > This filesystem and others that have had problems with corruption, are
> > used only as backups.
> > So the only operations that are performed are snapshot receive,
> > snapshot create, snapshot delete.
> > After the operations are finished, the filesystem is unmounted.
> >
> > It may just be a coincidence, but the problems of corruptions have
> > occurred very often after a snapshoot delete.
>
> I think this should give us a pretty good clue.
>
> Specific workload, less active usage, and normally no concurrency.
>
> And for the backup usage, you're using relatively new kernel only, right?

Yes, until a few days ago kernel 4.13.9 - 4.17.7 , now kernel 4.19.10 .

> Then this should be something taking into consideration for stress test.
]zac[

I have never been able to reproduce the condition that causes the
problem, currently I wait a few months until the problem decides to
give news of itself.

Gdb
