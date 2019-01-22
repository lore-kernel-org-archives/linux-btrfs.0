Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 794F9C282C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 06:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27C2E20879
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 06:28:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="hstFAsh4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfAVG2h (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 01:28:37 -0500
Received: from mail-lj1-f178.google.com ([209.85.208.178]:45758 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbfAVG2h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 01:28:37 -0500
Received: by mail-lj1-f178.google.com with SMTP id s5-v6so19505247ljd.12
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2019 22:28:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GPUZWeW9Y3lagg4vfnFdRjN1M385CIYHZ1VwaqIbeXk=;
        b=hstFAsh4KW2Uyt5y1rODr5IjsG3gKs3ZTtgWAP2oklBRpqNOHmXW1Nlaj81ahCwzEP
         /lmUc6li6Y5ky7Qp0C57RkYnBNEH7sPgSzYXTnfktv0P+L6gyPDi5lrbol8cAxT8AOkn
         Yp7DKc2ldeL8rCl6eJp5MND00e9xOQbd7Ys/e2aYEKUA1OoRBvjLvndRjPa10jt3Lxql
         iGM5SkGFH/VcnNJqCjdzPkNrITc5uRvPZhRz6CuUmToF9BA+Fdi0HMM2LIiyRx1UrHur
         fa4DbbCpKWH4PazAe/xLpY95lI9kUQ3MA+LFzAZjIUYS7mQ1SyE+94y8RIU4FZLO+EEK
         GNyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GPUZWeW9Y3lagg4vfnFdRjN1M385CIYHZ1VwaqIbeXk=;
        b=Fo9MwBfMlPtHKP37VnySN9Xk6nHPVLh9iiRDbfxIEVLA7fIlVb936ThXDG6E5f6Yrs
         F+ckvgR7bFlPFIq4JIcVdjku7pPIFOT+fmNYFBpAQgd3sZOGaMYawbKitlbGr+zaXuXn
         HBCur2FGn3mKqAwyPSGjPTi4cRqfMc1JdjvV/6I0sGsX5h8A6HLuQHfblKRpJZHFK6yU
         It72BKhap8Bw2cU7BzizorNxUWLtm1VvmAKH8s2Uc3aKceqEmwoeZGw0tM1pnduHWe/U
         NKLKE2OCrBRwMXTw3jT+R2XDI7ztHmr6VVwnCYUzPq7GWSN8S24Uq3OdACayoGUhzSJ8
         xd2Q==
X-Gm-Message-State: AJcUukerE+aPniZRZGpKAFdN3zq3CUPd5/OJb13ul6Zw3ulo5aMq+DxG
        4P/wgOjbwPseOK8WUUDfiiDkN8BFILqISR3C9spe+jekIXM=
X-Google-Smtp-Source: ALg8bN5LfGktoYq+zyg8E+9c/vuxB+cQ/34ZoeV4C7R0B3L5unSGiV61q7HvD1wR8jVXkfJmu0Hm1nfRaXyYIakfTGs=
X-Received: by 2002:a2e:841:: with SMTP id g1-v6mr21127302ljd.21.1548138515227;
 Mon, 21 Jan 2019 22:28:35 -0800 (PST)
MIME-Version: 1.0
References: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au>
 <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com>
 <CAJCQCtScPtJ=agTJbunPG9GT4hQg5VQWMOEM_JAyLseNKraqNw@mail.gmail.com> <f3075aa9-d475-43cb-45eb-e02acb1d2868@georgianit.com>
In-Reply-To: <f3075aa9-d475-43cb-45eb-e02acb1d2868@georgianit.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 21 Jan 2019 23:28:23 -0700
Message-ID: <CAJCQCtTeiWKnBM5+7L+1PSqL+4aXLyYeK3A=GEyk6=gr1DUj0w@mail.gmail.com>
Subject: Re: Incremental receive completes succesfully despite missing files
To:     Remi Gauvin <remi@georgianit.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 21, 2019 at 11:00 PM Remi Gauvin <remi@georgianit.com> wrote:
>
> On 2019-01-21 11:54 p.m., Chris Murphy wrote:
> #
> >
> > I expect the last command to fail because 1.ro1 is not the parent of
> > 2.ro2. The command completes, and 2.ro2 is on the destination, and at
> > least in this simple example it contains the expected files. However
> > 'btrfs show' indicates that the "parent UUID" of 2.ro2 is the "UUID"
> > of 1.ro1, which is definitely wrong. So it's a legit bug, not just a
> > cosmetic problem due to lack of error checking.
> >
>
>
> This is, as far as I understand, exactly how it's *supposed* to work, at
> least, as documented.  The only relationship needed between a "parent"
> snapshot, and the snapshot you're sending, is that the parent already
> exists on the destination.

I disagree. From the man page:

       -p <parent>
           send an incremental stream from parent to subvol

You have to understand that the send and receive commands is a
unidirectional stream. The receive command can't talk to the send
side. It can only pass or fail. So to get the correct incremental send
stream, the send command must be correctly formed based on specific
parent child relationship.


>  Your example would be completely
> counter-productive, since there is no data shared between the two, but
> perfectly legitimate.  1.ro1 is the parent of 2.ro2 because *you
> explicitly told it to*.

It's not legitimate, it's a mistake by the user. The actual stream
ends up being a full send of 2.ro2, rather than an incremental, and
then on the destination 2.ro2 ends up showing a parent UUID for a
subvolume that's totally unrelated. It's just not sane.


-- 
Chris Murphy
