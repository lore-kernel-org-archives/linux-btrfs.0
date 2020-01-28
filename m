Return-Path: <SRS0=Obef=3R=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD80EC33CB3
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Jan 2020 10:25:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6254A20661
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Jan 2020 10:25:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NELubtGC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgA1KZu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 28 Jan 2020 05:25:50 -0500
Received: from mail-vs1-f53.google.com ([209.85.217.53]:46381 "EHLO
        mail-vs1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgA1KZu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Jan 2020 05:25:50 -0500
Received: by mail-vs1-f53.google.com with SMTP id t12so7691353vso.13
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jan 2020 02:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=LgjIM9VOiYx7K1Tclfg+1DO3/dU/UrKt3rDpKP2avpc=;
        b=NELubtGCnjw0gMZwmD2Xojiz3dhMHLzVgyv/Bj/eb75UbqcU/yaa3ehTHpBtAIqoIZ
         Aq2ghNE5IigJYIhrKPxD43/a8q6YRPM9wruucDdTEU5wGb+Pzt77CD3UWEbqfFJzAyBM
         u1ux1vEJ6pQ9O96T2dB95YgYY7fyJJYn27FVOmGavgSCZQ9bKeA4lJ8+m418eyFLC0bd
         oFxJcDbizNV6oTapeio92/aNFND2btWnXPujsg14JcUCBjBxuvgnmwhhrQ+mrB3F2VnZ
         3tbmsXiSP4dnrNJABlyT1Ndp5dDxEn0mjxnuf3cWcQPMYzAanPW2d3efjbC9eMREVphK
         waNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=LgjIM9VOiYx7K1Tclfg+1DO3/dU/UrKt3rDpKP2avpc=;
        b=X12PIwBUaRWLApz+4+lFCf5R9ZYQOg69TUHF+A7B5Hdh2li0yj22HBaNYjyouSFAJa
         wTdeNN/HK6nVPHCVnjR7HRAcK1E3Nm76/r7XhkiVUrU79uq+VHcbOlSrckVCcdNvKYvx
         Rxo/igLn1PzLWEo++JIh9id/w1+CbSYp9Z5I4LPVtPeT14EtZs7GBooch2Dv1T2vQ7Kh
         xjqHgh6itD+BGDWFpQ38ybvxEFfH3cKz4uRfQb1jk3JOUs2eG+kXOBwimMv7tiWAU/bA
         Iy8xN/P4QGwd5x+sgOxzrdtZMbHM+jZ312By4jclrt1jdIrtbNPj9x9L8vvo0FP2AYbc
         3wiQ==
X-Gm-Message-State: APjAAAUCmAyCWk+MEJsphlrI5bMHaqT9CiaoP+YNEVfGo7GNUrBGkbEU
        i3+woIvkI9041PfzX1jyEwouzBAino3oXKPdMBLohBDh
X-Google-Smtp-Source: APXvYqytNLbkAg3dlFPegcapaVtUfFd8bVVm6VH+R/htoMZoY39mrACa5RWm5eQ+HtMqYWSja7jjhT0pcw0XZzLxK/o=
X-Received: by 2002:a67:e3b3:: with SMTP id j19mr13785853vsm.41.1580207149529;
 Tue, 28 Jan 2020 02:25:49 -0800 (PST)
MIME-Version: 1.0
From:   Robbie Smith <zoqaeski@gmail.com>
Date:   Tue, 28 Jan 2020 21:25:38 +1100
Message-ID: <CACurcBt_M-x=5CYhVUCiJq-yiUQF6-2a9PhWtmjfpJUYtAxt0Q@mail.gmail.com>
Subject: Unexpected deletion behaviour between subvolume and normal directory
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I wanted to try to convert my music library from a directory into a
subvolume so I could use btrfs send/receive to transfer (changed)
files between it and a USB backup. A bit of Googling suggested that
the approach would be:

> btrfs subvolume create /library/newmusic
> cp -ar --reflink=auto /library/music/* /library/newmusic/.
> rm -r /library/music

After about 30 seconds I realised that it was deleting files from both
/library/music and /library/newmusic. It appears I've only lost
everything starting with A, B or C, so I unmounted the device, and am
currently trying to use `btrfs restore` to get the files back and it
doesn't seem to be finding them.

I'm pretty sure deleting files from directory A isn't supposed to also
delete them from directory B, but that's what it did. Is this a bug?

Robbie
