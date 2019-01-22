Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A945C282C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 17:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34CF6217D4
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 17:20:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lRwgL7j8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbfAVRU2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 12:20:28 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:43323 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729336AbfAVRU1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 12:20:27 -0500
Received: by mail-yw1-f66.google.com with SMTP id n21so9709364ywd.10
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2019 09:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=F9N/f5vjVeHOpOnrfBGvjvCxmWwh6WhzX01+0PAoVWQ=;
        b=lRwgL7j8hm8LKl4jQGG6zpG7XcHjpKerm5Qe8gRSh8PZ1V0JNSsseTkWr3A7NL+NFk
         5FmlH0aCphVbIswkuIiV7t/OvVMmina9h38dxsQrfq1za0dDWy20+fpBTYlLDhdbPgAH
         /TmMoi3rpO7EFpF+y2uFIhWo09OEV7kSzQ2u/YxM0lesabYe6+o3AgQuBXp4gKFWUKpc
         HQkCYawJaXMI4uEOMqeu5iAhDVcLz2xhvuxjMaemxO8yXgNytiIu1fwh/RiZh+oYoS30
         bXeIEjZnlOpb0HIJxG+KNxPwvadHX1Qq6/s+dfMeHsu6/0IaW+CA4FB2So391rrVOlp8
         VpQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=F9N/f5vjVeHOpOnrfBGvjvCxmWwh6WhzX01+0PAoVWQ=;
        b=WmwV5wDl9GIiuvkY94C4Xq5Ud8jfyCqSaEJQ/PYocbGsazbbUAAWEjEAfoxk/g6L65
         vjcMP92rhU2gknuN+IGCoFAGak5wGFDzNCpY20pPc/A5rPOvBFO2Th9WWwTmMBN2gxyw
         tUd9XyqR7VRSHIOtS6GC3rBFZkq1m9ZTojaLlIW8rS+0/TdYDM58EN6hhKO4qr5FfWqu
         ii2gRPew5E6yrqo6Lc7PEI8Nnjq1t5yQDrkfEz67ZtaseWHvowHtMERkVE/heshdqeVQ
         n/ibKNS+prd7E/XcY++jaohchRulMCK+YfGbvCypTCh70GyufBDZCvPnjxBq4X9JDtAY
         qoTw==
X-Gm-Message-State: AJcUukedX3jpKNCek3SdrmgI4IRLhAQ0H36TDErZr5jJFIMPtC83rgke
        qhOxqueHDWHNMqstY1ZmAC0gmLIe6PP5IkhDaXdR81Jh
X-Google-Smtp-Source: ALg8bN5V2pcwJK62dXyLgYpchdnu18FO3LEqNdpvx/JB5nVKwjJKRW0EWWXkwr9qh0wnaXosk5TJvbXOmNAHwIMjBRY=
X-Received: by 2002:a81:27d6:: with SMTP id n205mr33460785ywn.305.1548177626538;
 Tue, 22 Jan 2019 09:20:26 -0800 (PST)
MIME-Version: 1.0
References: <CAJtFHURMDnM9EMAeLE4yr-UbWHa=o8M0=Yvm-MZp8ixWykfxFw@mail.gmail.com>
 <CAL3q7H4HsGMLS5mjTLSugQ-YoF-M24Fy6eCEAF9=04g_=A=jFA@mail.gmail.com> <CAJtFHUR8G927m1bx3UEgps9-dxPbZh+j4JTvzAn-yqcKRMLfTg@mail.gmail.com>
In-Reply-To: <CAJtFHUR8G927m1bx3UEgps9-dxPbZh+j4JTvzAn-yqcKRMLfTg@mail.gmail.com>
From:   Eli V <eliventer@gmail.com>
Date:   Tue, 22 Jan 2019 12:20:15 -0500
Message-ID: <CAJtFHUSKxDBwCzp71m=E6grxAkzfsaZO7P0paGn_L-MibDpeZw@mail.gmail.com>
Subject: Re: btrfs receive deadlock and questions
To:     fdmanana@gmail.com
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 22, 2019 at 11:03 AM Eli V <eliventer@gmail.com> wrote:
>
> On Tue, Jan 22, 2019 at 10:42 AM Filipe Manana <fdmanana@gmail.com> wrote=
:
> >
> > On Tue, Jan 22, 2019 at 3:26 PM Eli V <eliventer@gmail.com> wrote:
> > >
> > > I seem to have it a deadlock trying out btrfs send & receive. Now I
> > > haven't used btrfs send & receive much, so don't have much experience
> > > with them. Anyways, bug report and stack traces:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=3D202383
> >
> > This is the same you reported at:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D199753
> >
> > It just happens through a different path, unrelated to send/receive.
> > You are running a 4.19.16 kernel, which doesn't have the fix [1]:
> >
> > $ git tag --contains 5ce555578e0919237fa4bda92b4670e2dd176f85
> > v4.20
> > v4.20-rc1
> > v4.20-rc2
> > v4.20-rc3
> > v4.20-rc4
> > v4.20-rc5
> > v4.20-rc6
> > v4.20-rc7
> > v4.20.1
> > v4.20.2
> > v4.20.3
> > v5.0-rc1
> > v5.0-rc2
> > v5.0-rc3
> >
> > All the deadlock problems you reported are fixed by [1] and [2].
> > The second, related to the free space tree, is very recent and only on =
5.0-rcs:
> >
> > $ git tag --contains a6d8654d885d7d79a3fb82da64eaa489ca332a82
> > v5.0-rc2
> > v5.0-rc3
> >
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3D5ce555578e0919237fa4bda92b4670e2dd176f85
> > [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3Da6d8654d885d7d79a3fb82da64eaa489ca332a82
> >

Hmm, as far as I can tell these are both already in 4.19.16, according
to the linux-stable git repo as:

d7068618ae1fbb80fc16bd7c58798e208a696483
ea9c846f54dbf03da159a1b7566aa95e9bf1674b

So I guess that would mean the btrfs receive deadlock i.e. kernel
bugzilla 202383, isn't fixed by these commits.


>
> Sounds good, thanks for the links. I thought the stack traces looked
> different, thus the 2 different reports. I guess no further info is
> needed from the hung tasks and I can start killing it and figuring out
> how to resume the process.
>
>
> > >
> > > Seems like the receive is hung as well as several kworkers. It's abou=
t
> > > 1.2TB into a 9TB or so transfer onto a brand new pretty empty fs. Thi=
s
> > > is just a btrfs send snapshot, not an incremental. That was supposed
> > > to come next. If this was an rsync based backup I'd just kill the
> > > rsync process and restart it, not sure if there's a way to restart a
> > > btrfs send receive, or if I'd have to delete the partially created
> > > snapshot on the destination and restart the send. I guess I could jus=
t
> > > use rsync to finish the copy of the initial snapshot as well before
> > > using send | receive for the incrementals. Thoughts and options would
> > > be appreciated, thanks.
> > >
> > > -Eli
> >
> >
> >
> > --
> > Filipe David Manana,
> >
> > =E2=80=9CWhether you think you can, or you think you can't =E2=80=94 yo=
u're right.=E2=80=9D
