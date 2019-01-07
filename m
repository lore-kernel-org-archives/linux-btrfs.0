Return-Path: <SRS0=zk84=PP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B6AC43387
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 12:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E306D20651
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 12:55:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bMlqOOwX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbfAGMzt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Jan 2019 07:55:49 -0500
Received: from mail-ed1-f47.google.com ([209.85.208.47]:39905 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfAGMzs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jan 2019 07:55:48 -0500
Received: by mail-ed1-f47.google.com with SMTP id b14so770939edt.6
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Jan 2019 04:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YD6dg7fYQ8e+K9Mtolw/+biY5+NmuyilxzX8vWR7nHY=;
        b=bMlqOOwXo60epkFDm4GzW8FiKsxJY9CvisJvw9sxDl0s5Rnt7/G6eSRALOQyeo5xcN
         3rkjJp5KXa+xaw/iuOWqzgCgSAX3u624cmqT+rAQGy5nftzEK130IeBNC+bQrVlzcI/A
         YnNHygrfZMOpwbHpufOMjkmkpJMDuItv4tb8GpDzGr8ATBeY+KwWpCHN50wEiGTFX5Kg
         Ltt+UdpNG85kC7QXhFp65ZzaqDIHvFF1rItty08vcYL5/fJInUYh6tng1sbyE8QXaP+K
         5BS7nDiEcvyaHjXgmIN8mBviamUFEDi++EvwHBT5Ll75L/iIaibt8mhY/K0jhy5x77pH
         AdgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YD6dg7fYQ8e+K9Mtolw/+biY5+NmuyilxzX8vWR7nHY=;
        b=lNUt6Tin1JQswNBJ1Xv0EJ0cOpPgioKpwC/MBCX7e+LY+Z/uXWOZNtj307s/1J1wNL
         8bIgULQrOeziFTKfekw7QCtK2piqRPpMr3Az6xsZdipC27GWryBkR7rQet45DnF9AUNT
         DWmq0XXr8VRfX7V4w4tEw+u5OYURwqOVhQ4Y5wrd7GmufgFZAeXY8B3OBbcXZZYCSH0w
         CKij8SA7i2qdF8BIIEcdZbdOljsBl+8TMmj/J5bwrrg2YvWJ4ebzqml706y9Ci+bUpP1
         N1KH1MpyrBqvwyietQFQiCCmtZmdM7SZJyy+6XWW9MW7qDAQQ2+4RK/HIGjeRELvpHzF
         CyRQ==
X-Gm-Message-State: AA+aEWYO24NG+mkmdxY01lctEKQnta+XRAbJis8A2mny641Wa7Y4xvt8
        4TeKx2vntMxt36XiSMXux1r3sL1PY5ie+sK6ULdOh3wv
X-Google-Smtp-Source: AFSGD/W9th7hRPaUAZR2pwTUV9hBben3WYIyMkMGxIB+kmFAQFmU/V9/6brsAdr6W/y57q0i0qTWM5l21ihVY1aRoMg=
X-Received: by 2002:a17:906:92d1:: with SMTP id d17-v6mr46648881ejx.96.1546865747027;
 Mon, 07 Jan 2019 04:55:47 -0800 (PST)
MIME-Version: 1.0
References: <2543962.HIiRWmuHEy@exnet.gdb.it> <2971657.kkKnYu9ILp@exnet.gdb.it>
 <dc635a98-32cc-4f84-2319-82ef651d3f49@gmx.com> <2025891.FNXETDMuRi@exnet.gdb.it>
 <f441516a-7704-4e20-100f-ddd046b61be3@gmx.com> <CAO6awePqby834dBSgLx5r6onmD9HhGWAfN4bno0zK6pU0QjrEQ@mail.gmail.com>
In-Reply-To: <CAO6awePqby834dBSgLx5r6onmD9HhGWAfN4bno0zK6pU0QjrEQ@mail.gmail.com>
From:   gius db <giusdbg@gmail.com>
Date:   Mon, 7 Jan 2019 13:55:43 +0100
Message-ID: <CAO6aweNy006hbwEVCuoQ_cSRKP-QRX2UWji6D-E8gkxH8tbm7w@mail.gmail.com>
Subject: Fwd: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz' can hangs.
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Il giorno lun 7 gen 2019 alle ore 00:56 Qu Wenruo
<quwenruo.btrfs@gmx.com> ha scritto:
]zac[
> > I am quite convinced that it happens during the snapshot delete and the
> > subsequent cleanup.
> > And maybe even the umount is part of the problem.
>
> No, I mean the corruption which finally results the hang was there for a
> long time.
>
> It's relatively common that extent tree get corrupted before and some
> unfortunately operation touching the corrupted extent tree triggered
> some user affecting error.

Yes, I understand, but the use of filesytem is very specific.

This filesystem and others that have had problems with corruption, are
used only as backups.
So the only operations that are performed are snapshot receive,
snapshot create, snapshot delete.
After the operations are finished, the filesystem is unmounted.

It may just be a coincidence, but the problems of corruptions have
occurred very often after a snapshoot delete.

The other filesystems that are used in a generic way (operating
system, warehouse and data processing, snapshot creating etc.), have
never given problems.

]zac[
> >
> > btrfs check reported various corruptions and fixed them.
>
> Please paste the output if possible.
]zac[

Sorry, I didn't think to save the btrfs check messages.


Gdb
