Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA96C282C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 17:29:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A0D821019
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 17:29:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JPgE1V0F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbfAVR3d (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 12:29:33 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:39719 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfAVR3c (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 12:29:32 -0500
Received: by mail-ua1-f67.google.com with SMTP id c12so8340929uas.6
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2019 09:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=kRaQxBcGoTIEs/Wj925P9Ot2RnqXyAer8hkn2t2uBt8=;
        b=JPgE1V0FWW6dVE4fC3eHUDmZb5YsPIZqZ0ivB0easXRoBEOxfPAZTyx6tVINFUUICT
         WXQUVYKywtyQc40JdPthPw2B0hde7H9bSs1iqg4ndzHN+jBI3vrlE7ih68CWddOZGgBo
         CKZkhzu1eGIREkoSt9KGm1qjsiQIkgTLO0l7mbjRPJy9S4U+SsBj9F7kDzPzB3wGy5O8
         yfYxJTIvI0AOMB8yd7IgE0CK4ub4RWKLcjCNgJWceceYZVig1A98jf1FF7RA50wNloCw
         bDzsbVfpE2M0y/y+0rEwldY0YthduQkY+KmHfEvU+MdPsCF/L6xAWtWzICmky2fVbiGk
         KmvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=kRaQxBcGoTIEs/Wj925P9Ot2RnqXyAer8hkn2t2uBt8=;
        b=OAjRDmFDNDQ6XFJrNHyHtVOVqWQWyl5d2pm3Zr7GthQlqs/Z8njoN9r4ZRlyyh6JJl
         L47Q14sWGnriD1czOA3TmnaBeqiMkrq9AQGNimEWhGKFtlUghhs/+oZ5tRBw3BBg/Spv
         qL5/VLS23/sd/o/HuWQqxsfn65i790bestn1HbMsgAtxhIm6+i84CmlUyqZr4+UWbrWJ
         rxrzbCHmeH2JqncolOXRVOD6PHr/OpQ7VEBg/DD++uIVR4OLqZ25C2mJ8FQZegbyZxWO
         5P8vhokJ8s7XrxiwhdaEMzOkF99gAoUha2D9nScNhnjtD1553zA5Qw9nN7iLmPjUiasY
         +vpQ==
X-Gm-Message-State: AJcUukcAbNaWRLB277iMeEkKv9jfSnuMAI+wyUNlcBt20x09Syr0FFM0
        gS/m5DEEFG2nSXWa83IaqSnP5BYaDn2wF1ts3c8=
X-Google-Smtp-Source: ALg8bN7sISQQqlxJWNr6RKuoSsRht1UCGWi411fJRQxBtJ5048IdY36JP38RdeEokbzX44z+Fpos4gXl7Txi+HjxorI=
X-Received: by 2002:ab0:3259:: with SMTP id r25mr13280107uan.108.1548178171592;
 Tue, 22 Jan 2019 09:29:31 -0800 (PST)
MIME-Version: 1.0
References: <CAJtFHURMDnM9EMAeLE4yr-UbWHa=o8M0=Yvm-MZp8ixWykfxFw@mail.gmail.com>
 <CAL3q7H4HsGMLS5mjTLSugQ-YoF-M24Fy6eCEAF9=04g_=A=jFA@mail.gmail.com>
 <CAJtFHUR8G927m1bx3UEgps9-dxPbZh+j4JTvzAn-yqcKRMLfTg@mail.gmail.com> <CAJtFHUSKxDBwCzp71m=E6grxAkzfsaZO7P0paGn_L-MibDpeZw@mail.gmail.com>
In-Reply-To: <CAJtFHUSKxDBwCzp71m=E6grxAkzfsaZO7P0paGn_L-MibDpeZw@mail.gmail.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 22 Jan 2019 17:29:20 +0000
Message-ID: <CAL3q7H4yx8MW4S8seryupj5dhV-uWYWbp7gDP1UaSmj1D+hh4A@mail.gmail.com>
Subject: Re: btrfs receive deadlock and questions
To:     Eli V <eliventer@gmail.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 22, 2019 at 5:20 PM Eli V <eliventer@gmail.com> wrote:
>
> On Tue, Jan 22, 2019 at 11:03 AM Eli V <eliventer@gmail.com> wrote:
> >
> > On Tue, Jan 22, 2019 at 10:42 AM Filipe Manana <fdmanana@gmail.com> wro=
te:
> > >
> > > On Tue, Jan 22, 2019 at 3:26 PM Eli V <eliventer@gmail.com> wrote:
> > > >
> > > > I seem to have it a deadlock trying out btrfs send & receive. Now I
> > > > haven't used btrfs send & receive much, so don't have much experien=
ce
> > > > with them. Anyways, bug report and stack traces:
> > > > https://bugzilla.kernel.org/show_bug.cgi?id=3D202383
> > >
> > > This is the same you reported at:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=3D199753
> > >
> > > It just happens through a different path, unrelated to send/receive.
> > > You are running a 4.19.16 kernel, which doesn't have the fix [1]:
> > >
> > > $ git tag --contains 5ce555578e0919237fa4bda92b4670e2dd176f85
> > > v4.20
> > > v4.20-rc1
> > > v4.20-rc2
> > > v4.20-rc3
> > > v4.20-rc4
> > > v4.20-rc5
> > > v4.20-rc6
> > > v4.20-rc7
> > > v4.20.1
> > > v4.20.2
> > > v4.20.3
> > > v5.0-rc1
> > > v5.0-rc2
> > > v5.0-rc3
> > >
> > > All the deadlock problems you reported are fixed by [1] and [2].
> > > The second, related to the free space tree, is very recent and only o=
n 5.0-rcs:
> > >
> > > $ git tag --contains a6d8654d885d7d79a3fb82da64eaa489ca332a82
> > > v5.0-rc2
> > > v5.0-rc3
> > >
> > > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/commit/?id=3D5ce555578e0919237fa4bda92b4670e2dd176f85
> > > [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/commit/?id=3Da6d8654d885d7d79a3fb82da64eaa489ca332a82
> > >
>
> Hmm, as far as I can tell these are both already in 4.19.16, according
> to the linux-stable git repo as:
>
> d7068618ae1fbb80fc16bd7c58798e208a696483
> ea9c846f54dbf03da159a1b7566aa95e9bf1674b
>
> So I guess that would mean the btrfs receive deadlock i.e. kernel
> bugzilla 202383, isn't fixed by these commits.

So there are a few different paths that lead to the same deadlock and
I missed them before.
I'll got those fixed in the next few days.

Btw, it's not related to send/receive at all, it can happen from anywhere.

Thanks for the report.

>
>
> >
> > Sounds good, thanks for the links. I thought the stack traces looked
> > different, thus the 2 different reports. I guess no further info is
> > needed from the hung tasks and I can start killing it and figuring out
> > how to resume the process.
> >
> >
> > > >
> > > > Seems like the receive is hung as well as several kworkers. It's ab=
out
> > > > 1.2TB into a 9TB or so transfer onto a brand new pretty empty fs. T=
his
> > > > is just a btrfs send snapshot, not an incremental. That was suppose=
d
> > > > to come next. If this was an rsync based backup I'd just kill the
> > > > rsync process and restart it, not sure if there's a way to restart =
a
> > > > btrfs send receive, or if I'd have to delete the partially created
> > > > snapshot on the destination and restart the send. I guess I could j=
ust
> > > > use rsync to finish the copy of the initial snapshot as well before
> > > > using send | receive for the incrementals. Thoughts and options wou=
ld
> > > > be appreciated, thanks.
> > > >
> > > > -Eli
> > >
> > >
> > >
> > > --
> > > Filipe David Manana,
> > >
> > > =E2=80=9CWhether you think you can, or you think you can't =E2=80=94 =
you're right.=E2=80=9D



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
