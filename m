Return-Path: <SRS0=OwrN=QM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51290C282CB
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 06:46:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 145142080D
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 06:46:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="JWWQdFFS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbfBEGqw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Feb 2019 01:46:52 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38279 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbfBEGqw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2019 01:46:52 -0500
Received: by mail-lj1-f194.google.com with SMTP id c19-v6so1950161lja.5
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Feb 2019 22:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GfKbrLZzwiii3olDEZj2RFiCyUsqCcdJ2mnKvmYlf/Q=;
        b=JWWQdFFSzanOtQPMIvJmcanlM5NGCTtgZj/VX2thf30ef/42bMYGrz9f2XHrrrNf1k
         GUXCMbZWsJ1CwS47E1jNflwOOSpbclBXVeWiV3BPu9PDiHY8svGSu0px2o8nVdGpXddu
         PvlJLuyUJ3AEomDR8acWAaQKQQOqGWX6BGarNs9dHP7qpfr3hW0sOURRyP5tD0Uh1E6H
         6YSAqHzMxko7OCXliMGHAs7LNfALYtGjttI1R1ucCBc8OUJDH8tvInSuEzuXKG9zyK/6
         7qFRKwvhwbJVEAGs8rrPVbMRxzQZ8wKwbSAm14dJ2uQClSfjKIyxkMAJgc2gmG3x98pQ
         Cbrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GfKbrLZzwiii3olDEZj2RFiCyUsqCcdJ2mnKvmYlf/Q=;
        b=BhrCsr6x5vg5utWjVVwQvkkIJVlq0lm9oQHq9Pr+BHaM5XlVnAKk6xgu9OtIHYBxv4
         jDeSynENoxbcMhBSP1nBv6oXWpf6G/kS9ZPeuwpZcJLtXfAJpSVgRzcbYbq4kDSvSjZv
         s1hWudO7xJaZ8mu4sjqyZq42KE1Vspj82dzVrQtHLrmZruA4zU/KtI9mmpl6n5hLz5qc
         +QX6BKAZr184CX2HN+HaRcgunV/tM7lsiiJYuWvTxy1bh/YKQlb7sI5WEEg4tYHX6FUR
         cWnWpqbjudaR0l2n/MVPka3MJ5U3nfppl+0QLuC8A9TvXDrd9yThnFYSh1i9kp1Hm1lb
         1vEQ==
X-Gm-Message-State: AHQUAuYvgAdcxDE4i0JmWvaUOs2gLKh4J0d34JsDw+8Y8zfMds+67Yv1
        jDSbKu4B/6mWepbFE2cwPAHch1HQwksS/Gkmq53xsQ==
X-Google-Smtp-Source: AHgI3IY3IcmbE1IzzM67zq6aLCNM44QcWu+p4zzfeqwA1wEhiMmNqM1fMyNWhxC2WdqdrXAVKINb5sjfuXHvILkItgU=
X-Received: by 2002:a2e:8719:: with SMTP id m25-v6mr2033148lji.121.1549349210187;
 Mon, 04 Feb 2019 22:46:50 -0800 (PST)
MIME-Version: 1.0
References: <33679024.u47WPbL97D@t460-skr> <CAJCQCtR=WZGk4eaG63_-uqb0wzGVDDrS1SsxhzxT7k3qbWVtCg@mail.gmail.com>
 <CAA7pwKN9B7LZEo7Op0PndTnU6jo3JdtLi0vdphXZakgbKBB-9w@mail.gmail.com>
 <b879a985-c991-b4b3-590e-d2aa1a5fa5c5@gmail.com> <CAA7pwKOXcsh__Cw0WBLW8g1LA239kmcyWcDmz6ksZ+Tbu1NK-Q@mail.gmail.com>
In-Reply-To: <CAA7pwKOXcsh__Cw0WBLW8g1LA239kmcyWcDmz6ksZ+Tbu1NK-Q@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 4 Feb 2019 23:46:38 -0700
Message-ID: <CAJCQCtQh3hmShOzSCaYRjpKZ6B7rN1QPd9Ak2EyeTMKpLCy_2A@mail.gmail.com>
Subject: Re: btrfs as / filesystem in RAID1
To:     Patrik Lundquist <patrik.lundquist@gmail.com>
Cc:     "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Stefan K <shadow_7@gmx.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 4, 2019 at 3:19 PM Patrik Lundquist
<patrik.lundquist@gmail.com> wrote:
>
> On Mon, 4 Feb 2019 at 18:55, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
> >
> > On 2019-02-04 12:47, Patrik Lundquist wrote:
> > > On Sun, 3 Feb 2019 at 01:24, Chris Murphy <lists@colorremedies.com> wrote:
> > >>
> > >> 1. At least with raid1/10, a particular device can only be mounted
> > >> rw,degraded one time and from then on it fails, and can only be ro
> > >> mounted. There are patches for this but I don't think they've been
> > >> merged still.
> > >
> > > That should be fixed since Linux 4.14.
> > >
> >
> > Did the patches that fixed chunk generation land too?  Last I knew, 4.14
> > had the patch that fixed mounting volumes that had this particular
> > issue, but not the patches that prevented a writable degraded mount from
> > producing the issue on-disk in the first place.
>
> A very good question and at least 4.19.12 creates single chunks
> instead of raid1 chunks if I rip out one disk of two in a raid1 setup
> and mount it degraded. So a balance from single chunks to raid1 chunks
> is still needed after the failed device has been replaced.

Kernel 4.20.3 I can confirm that I can do at least three rw,degraded
mounts, adding data each mount, on a two device raid1 with a missing
device. When rw,degraded, it's writing data to single profile chunks,
and to raid1 metadata chunks. There's no warning about this.

After remounting both devices and scrubbing, it's dog slow. 14 minutes
to scrub a 4GiB file system, complaining the whole time about
checksums on the files not replicated. All it appears to be doing is
replicating metadata at a snails pace, less than 2MB/s. That's
unexpected. But while it's expected single data is not magically
converted to raid1; the fact that it's single profile just because
it's a degraded raid1 is not expected, and not warned about. I don't
like this behavior - so now the user has to do a balance convert to
get back to the replicated state they thought they had when
formatting?

-- 
Chris Murphy
