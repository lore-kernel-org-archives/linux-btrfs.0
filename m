Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E79DBC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 19:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1CF62192B
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 19:11:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="nVhvnhqt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732877AbfBOTLn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 14:11:43 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:47038 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbfBOTLn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 14:11:43 -0500
Received: by mail-lj1-f195.google.com with SMTP id v16so9242233ljg.13
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2019 11:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eZ2UpLl+r2tVqgGy/qbG2Nx8sH9HdcACQUiudvLI8Y0=;
        b=nVhvnhqtpi4ap3QoK8pEvD6oWRNamgQr5fwCuAYnvfSgA6e+vDGzsv+OLBouzI6dVm
         B/AWdIgEMchUeekAYUpoSeUNYLM95pMvluNAVwa5W7FiDnHXQZp0T3B9ND+Ps8ABi56x
         VFLkqNxXl7plxG1LsI1XTlvWt7dEs4ioxCR6n8s/6dSIEWard7AkTu2FmjuxJCmu+Dmh
         OJCTq44xkY0kVEuTpdjUiQi8/UzWYLISL7Bn3GIfTtzfQXY920vwFMTG0Z9ZNY5EQ+4i
         B7xh+aKac+1Tl6TDMvyQGSZZl45t1XGWwcoQHdIfBioE9ui2UEpr5nhPZX/xrDpg3ymi
         gerQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eZ2UpLl+r2tVqgGy/qbG2Nx8sH9HdcACQUiudvLI8Y0=;
        b=Q5YExLRAiAAKroQR80q1ZimkBtVYuDoghRCB2aZM5RUC1B2Ew7rEJjjik9oY5R8e5i
         bDOp8V41qcKfJwHYASFI0+KEXEJCZBkLklD8NYYTCidYh43zuk4NhRVREqw6syQDYTjZ
         hvGKey72YME/DgdCyTdikRlHvySX3rrbz/MZZ2+VVaMh3nIkUcxpgvpE6GRfgYMFJRTr
         hsYNHVEYgQ2clS7sm2G1acuU306+Q1XbKzqO52f3lffHrBJN9EyJuM+5fIFY5vhORWGb
         1KxJmwdYKZxaYn2CzzAu2znwEAwyeMSaL3L6fWsaCqubk+6fhtJCA8uTcsekGYanAkdo
         OdLQ==
X-Gm-Message-State: AHQUAuaSg4qblvLE48Hwvebxc35KLLLAjuulAySN9pg3HqJ/Z1+hpIRe
        Y14CaXzMj/wRnO9BqEWWxnBt91Ek7iDE1Sbv5HvaGg==
X-Google-Smtp-Source: AHgI3IZvBlVOqDalgEYgedXPc+PycNT+JcZrK/t7AvEstHPzFElcVPhBd7upC9jsHZdWDan2d8ddPy+8TT+MltXTS2A=
X-Received: by 2002:a2e:3308:: with SMTP id d8-v6mr6388795ljc.38.1550257900045;
 Fri, 15 Feb 2019 11:11:40 -0800 (PST)
MIME-Version: 1.0
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <CAJCQCtQnNQeGsi=K+pgq1sa9t8GQO1yMNx=UcchGs79zM46cTg@mail.gmail.com> <1c6a1abb-1e6e-504a-b51c-0da580c49d66@gmail.com>
In-Reply-To: <1c6a1abb-1e6e-504a-b51c-0da580c49d66@gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 15 Feb 2019 12:11:28 -0700
Message-ID: <CAJCQCtTO0-WG+mHHvsUdQBJhuQ63dPkBqJP96vz7CU4jGF+hxA@mail.gmail.com>
Subject: Re: Btrfs send with parent different size depending on source of files.
To:     Andrei Borzenkov <arvidjaar@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        =?UTF-8?Q?Andr=C3=A9_Malm?= <admin@sheepa.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 15, 2019 at 10:45 AM Andrei Borzenkov <arvidjaar@gmail.com> wro=
te:
>
> 15.02.2019 1:37, Chris Murphy =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > On Thu, Feb 14, 2019 at 4:37 AM Andr=C3=A9 Malm <admin@sheepa.org> wrot=
e:
> >>
> >> Hello,
> >>
> >> I'm not sure this is the right forum to ask on but I'll try and if its
> >> not I do apologize. I have also created a stack overflow question
> >> without success (
> >> https://stackoverflow.com/questions/54634703/btrfs-send-with-parent-di=
fferent-size-depending-on-source-of-files
> >> ) but ill paste the question here too. Thank you.
> >>
> >> What i'm trying to achieve is sending only the diff of the parent with
> >> btrfs send -p
> >>
> >> Running this will produce a file 'out' with size 639 bytes, i.e only
> >> diff sent.
> >>
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >>
> >> btrfs subvolume create A
> >> btrfs subvolume create B
> >> mkdir A/dir
> >>
> >> dd if=3D/dev/urandom of=3DA/dir/server.jar bs=3D1024 count=3D40K
> >> cp --reflink=3Dalways A/dir/server.jar B/server.jar
> >>
> >> btrfs subvolume snapshot -r A a
> >> btrfs subvolume snapshot -r B b
> >> btrfs send -p a b > out
> >
> > It doesn't work this way.
>
> It works exactly this way.

Unproven. And in fact we have an example where it does not work, hence
the point of the thread!

The proven way it works, is as I've described, and many emails over a
decade on this list, inferred from the man page, and the step by step
recipe on the Wiki.

> > The gist is that you would keep changing A,
> > and take additional snapshots of A, such as a.1 a.2 a.3, and you can
> > do incremental send with 'btrfs send -p a.1 a.2' which describes the
> > difference between those two snapshots of A at their respective
> > moments in time. You could also do 'btrfs send -p a.2 a.3' or even
> > 'btrfs send -p a.1 a.3'
> >
>
> That it is intended to be used this way does not mean it is restricted
> to this way technically. Whether it should have been restricted is
> another question.

That's fair. But also the alternative cannot be stated to "work
exactly this way" when this very thread starts with two examples
leading to different and therefore unexpected results, differing only
in how the file was created: dd vs wget

And no one can explain that. Which tells me none of us really
understands the full scope and operation of send.

By the way, it is possible for send to succeed in producing a stream,
that receive will reject. So there is a difference in the error
checking when using send with receive, than send without receive.


> > But as there's no relationship between snapshots a and b, I consider
> > it a bug/missing error handling feature, that btrfs send doesn't fail
> > in this case. By using -p you're claiming there is a parent-child
> > relationship between a and b, but there plainly isn't.
> >
>
> No. By using "-p" you designate subvolume which must be used as base to
> apply differential (I explicitly does not use "incremental") stream on
> remote side. Nothing more. Whether it should have different semantic is
> subject to discussion, but it does not do what you wish it to do.

man page and wiki use incremental - and linguistically incremental !=3D
differential, increment is a subset of difference.

Difference suggests the order does not matter. Increment suggests it
does matter.

btrfs sub create A
cp somestuff A
btrfs sub snap -r A a.1
cp morestuff A
btrfs sub snap -r A a.2

The normal case of send is:

btrfs send -p a.1 a.2

However, is it valid to do?

btrfs send -p a.2 a1

I haven't tried this. Maybe send allows it and it works as expected?
Maybe receive also works. If it's allows *and* also if it works as
expected, then maybe the command is differential and not incremental.
That is a rather fundamental thing to know!


--=20
Chris Murphy
