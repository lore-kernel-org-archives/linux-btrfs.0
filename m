Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D16BDC282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 19:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 956762085A
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 19:37:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="T8cU//PK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfAVTht (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 14:37:49 -0500
Received: from mail-lj1-f180.google.com ([209.85.208.180]:44851 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbfAVThs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 14:37:48 -0500
Received: by mail-lj1-f180.google.com with SMTP id k19-v6so21665819lji.11
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2019 11:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FPEwA03MITkoe0MSY7mQ3qyaWrLMvEg9fwDyuOxq7uE=;
        b=T8cU//PKIa61hbmc2nJ9552mR6DjHn7xi0I5hIS5YEf2/hjT4mAr+TmnCTnktsshGD
         vL5UvLZs4YVV2HxZBYYGsPwFkI3ijCvaVvO1Fy1goMFkkoZKcjbr28vtl/Q9T7zACsoi
         xKhLLxKzbEmS2wIoHg6QRObZ+F1zXZYNw3ToNPvS74NXi0RlEfX2IJPaC4gHBIxItfjL
         KhTrdlO6W6OOHhbZ8KGwFFlmqGk5PjLkyh96WI8qx21JcpigUclu4MVdZClzdvzVOfTW
         PvV8+00waR94WikY4n4rzEQi/UROO6lb1ReprxiVJM+mtGRRm2DczK2ufST8iKJDeNxe
         gadA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FPEwA03MITkoe0MSY7mQ3qyaWrLMvEg9fwDyuOxq7uE=;
        b=M7tbl+St/nG6UM7p1EdGmJiobgP7Qx9Dpj+7u/kanh1cdKP5/Rn66WsigiN6B1fWwq
         kBuyvCJgmWxAoOL/jVilmIOXjsmB/eYIv0mlZVfvMn06N7jRVZUJVmAgf6cH5SwitCsC
         9CNld26OIEYW5UqWBJcvlOmyLbn59gGvPgKh+qODMDhyQD5KUgxow5da35C9Uh9jEE7i
         /z8P79GuYys3O2k7JeCVEfc1jq9muv13QYBG4v9it3MHMJHyqrDkge4462mNPYdAKdEt
         Nf6HLkMfpKWKrEZVHxzR3CJUrFz3PjznEHeEnK8HIut/cppZ9g7k6Zg2AxfYd/reVmsp
         stVA==
X-Gm-Message-State: AJcUukfhoui6O4QQocylM4NoRP3Z15JU1KdvDXf8tWEb9OFDwmqsNZK+
        54o50B2Xu2peuvGDXiuFES99cqdsMgRKKbu3c+QLOA==
X-Google-Smtp-Source: ALg8bN58U2e/wPPvX4n8qmX+0feuSTgYPdBQvtYw6uYU9PK2MapdbNfnAzxqeWSkr97YUzpJOQd0tIJmtNYrhcu8Q88=
X-Received: by 2002:a2e:8719:: with SMTP id m25-v6mr23447615lji.121.1548185865680;
 Tue, 22 Jan 2019 11:37:45 -0800 (PST)
MIME-Version: 1.0
References: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au>
 <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com>
 <CAJCQCtScPtJ=agTJbunPG9GT4hQg5VQWMOEM_JAyLseNKraqNw@mail.gmail.com>
 <f3075aa9-d475-43cb-45eb-e02acb1d2868@georgianit.com> <CAJCQCtTeiWKnBM5+7L+1PSqL+4aXLyYeK3A=GEyk6=gr1DUj0w@mail.gmail.com>
 <72d097cf-e4b9-80bf-556d-422767ee0376@gmail.com>
In-Reply-To: <72d097cf-e4b9-80bf-556d-422767ee0376@gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 22 Jan 2019 12:37:34 -0700
Message-ID: <CAJCQCtTnyTV=Q=vuF1Rg9EK3=S9C_sXf85r6u44UZWtwR3ayLQ@mail.gmail.com>
Subject: Re: Incremental receive completes succesfully despite missing files
To:     Andrei Borzenkov <arvidjaar@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Remi Gauvin <remi@georgianit.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 22, 2019 at 10:57 AM Andrei Borzenkov <arvidjaar@gmail.com> wro=
te:
>
> 22.01.2019 9:28, Chris Murphy =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > On Mon, Jan 21, 2019 at 11:00 PM Remi Gauvin <remi@georgianit.com> wrot=
e:
> >>
> >> On 2019-01-21 11:54 p.m., Chris Murphy wrote:
> >> #
> >>>
> >>> I expect the last command to fail because 1.ro1 is not the parent of
> >>> 2.ro2. The command completes, and 2.ro2 is on the destination, and at
> >>> least in this simple example it contains the expected files. However
> >>> 'btrfs show' indicates that the "parent UUID" of 2.ro2 is the "UUID"
> >>> of 1.ro1, which is definitely wrong. So it's a legit bug, not just a
> >>> cosmetic problem due to lack of error checking.
> >>>
> >>
> >>
> >> This is, as far as I understand, exactly how it's *supposed* to work, =
at
> >> least, as documented.  The only relationship needed between a "parent"
> >> snapshot, and the snapshot you're sending, is that the parent already
> >> exists on the destination.
> >
> > I disagree. From the man page:
> >
> >        -p <parent>
> >            send an incremental stream from parent to subvol
> >
> > You have to understand that the send and receive commands is a
> > unidirectional stream. The receive command can't talk to the send
> > side. It can only pass or fail. So to get the correct incremental send
> > stream, the send command must be correctly formed based on specific
> > parent child relationship.
> >
>
> "Parent" is too ambiguous in btrfs as it is used to denote completely
> independent things. Snapshot parent-child relationship is unrelated to
> "parent" as used in "btrfs send".
>
> Subvolume referred to by "btrfs send -p" is used as base to compute
> changes against. Nothing more nothing less. There is no implication that
> subvolume that is being transferred is snapshot of subvolume referred to
> by -p argument. Actually the most common scheme is - you have base
> subvolume "base"m you periodically create snapshots from these subvolume
> as "btrfs sub snap -r base snap1", "btrfs sub snap -r base snap2" etc
> and then do incremental transfer between each snapshots as "btrfs send
> -p snap1 snap2" etc. Neither of "snapX" is snapshot of another "snapX".
> You have fan-out structure on source and linear structure on destination.

base is the parent of all snapX

A totally unrelated subvolume "noodle" being used as -p is obviously
user error, it doesn't matter if it doesn't cause corruption. For sure
the resulting subvolume has the wrong "parent UUID" as a result, so
there are at least two unintended consequences.


> >>  Your example would be completely
> >> counter-productive, since there is no data shared between the two, but
> >> perfectly legitimate.  1.ro1 is the parent of 2.ro2 because *you
> >> explicitly told it to*.
> >
> > It's not legitimate, it's a mistake by the user. The actual stream
> > ends up being a full send of 2.ro2, rather than an incremental, and
> > then on the destination 2.ro2 ends up showing a parent UUID for a
> > subvolume that's totally unrelated. It's just not sane.
> >
> >
>
> It is still entirely legal operation. The result will be full
> replication stream of 2.ro2 + additional instructions to delete content
> of (clone of) 1.ro1 on destination.

Which is utterly absurd because the user, by virtue of using -p flag,
is indicating they want an incremental send and yet silently they will
not get an incremental send. They very clearly made a mistake.

> "Related" is in the eye of the beholder. Clone subvolume, delete content
> of clone, reflink content of another volume into clone. Are original
> subvolume and clone related now? Clone still have parent UUID ...

I'm not talking about -c option. Just -p. Conceptually -c is even more
complicated and effectively supports multiple "parents" as it can be
specified more than once.




--=20
Chris Murphy
