Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E05C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 02:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FD552086E
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 02:54:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=etsukata-com.20150623.gappssmtp.com header.i=@etsukata-com.20150623.gappssmtp.com header.b="dcF1daII"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4FD552086E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=etsukata.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbeKZNrE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Nov 2018 08:47:04 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:38176 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbeKZNrD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Nov 2018 08:47:03 -0500
Received: by mail-ed1-f68.google.com with SMTP id h50so14536658ede.5
        for <linux-btrfs@vger.kernel.org>; Sun, 25 Nov 2018 18:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsukata-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vkWEAly9FUxn7hnC+4ktliJ58hiXPQ+bN95nnzUFmnA=;
        b=dcF1daII7k2k/xP4+GryfbIXqmhDTA8LcaUV08kJtonWkqBUX4RNh1IGx/bEeExpzZ
         Xbf1MUA1F5vbvlRDm6WyExEbYmKTC/ghCTGh/r2ig75RzuAnhJoKemmrJ4/mV+qvG19h
         6mlBsmZ7qMeBTje5IUnTROFdpcvasCus3A8Mw5blQALwq+SR1U1Xmu1vLSDFi5AO27yO
         oVdHprWkuMvAz775I7e75hYST2GOAhy3mF+GJ5z1YWFC02Soy9bRZEVwH1RhDIkQyodc
         eqCWXVseLGFeJmOodPKt5l8eaMnJeHD+f5pQF4rv75nG+nuyKyz4PomUIghrnwEBaOoF
         gV0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vkWEAly9FUxn7hnC+4ktliJ58hiXPQ+bN95nnzUFmnA=;
        b=UC1tHX5otHTYiFQ1QU2tD3gGVwblXJK6Yv9Fykd6pdumyAkPEtKR4wduA3PTaGB2qc
         Qo73yDhSzFkNNH9qN9TEX0VmxDFnCUvJiD0oNhKQw8aG1vZbyh8YjkdMi7Z6+tZQ2ytt
         RwB1nny2MEUSkoccTvmZS3H02f5MTyNS3G558v/Q5+sS1xIyQpB9IXNvufLqW2OWxpXm
         UZMncX1USRtyzdhdxfDgdQzkBgenT3eEcGJXqSPuqdyR08hdEfvTLuerTDAxUGZ4d+zv
         CBBCgvtE0mEK6r4fiY0GEc0j8aFxBq8n+CBXB3IV+PTsCS5r2sNxbGgnKv+qvsKHNd4p
         v0nQ==
X-Gm-Message-State: AGRZ1gKwlPDVEdjJ+1+0cO8AgIJwk7bNdsSxxv8UJ7d7QgJehUdjtAJF
        w18SUk0qUCewxVdQZit2GlJehOun48iIPfAQtr93kg==
X-Google-Smtp-Source: AJdET5eX60nMT+rIdToChn37ROA3Cwf0CD8UUWqLq5h0Tebbtmj+csg1q+Ovr6kjOlrMaxsbvOLUa97V45+Oz6i9nCg=
X-Received: by 2002:a17:906:1c5b:: with SMTP id l27-v6mr18858495ejg.118.1543200862639;
 Sun, 25 Nov 2018 18:54:22 -0800 (PST)
MIME-Version: 1.0
References: <20181121024400.4346-1-devel@etsukata.com> <20181121045440.GM32577@ZenIV.linux.org.uk>
 <CANhTXPQzKmsyPO9QrGz6eijjuMFzLN4BhUV=6ABDJysX0xyKfw@mail.gmail.com> <20181122070650.GN32577@ZenIV.linux.org.uk>
In-Reply-To: <20181122070650.GN32577@ZenIV.linux.org.uk>
From:   Eiichi Tsukata <devel@etsukata.com>
Date:   Mon, 26 Nov 2018 11:54:06 +0900
Message-ID: <CANhTXPSsh8mdedkm6wVAAQXk3wY7J2aSdgojZGxFR+ctArBsJw@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] fs: fix race between llseek SEEK_END and write
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     andi@firstfloor.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

2018=E5=B9=B411=E6=9C=8822=E6=97=A5(=E6=9C=A8) 16:06 Al Viro <viro@zeniv.li=
nux.org.uk>:
>
> Can you show me where does POSIX/SuS/whatever it's called these days prom=
ise
> that kind of atomicity?

No. I couldn't found it.
That's why I previously posted RFC Patch:
https://marc.info/?t=3D154237277900001&r=3D1&w=3D2
I wasn't sure this is a bug in the kernel or not.

> that kind of atomicity?  TBH, I would be very surprised if any Unix promi=
sed
> to have file size updated no more than once per write(2).  Any userland c=
ode
> that relies on such property is, as minimum, non-portable and I would arg=
ue
> that it is outright broken.

Thanks. Now It's clear. It is not a bug in the kernel, but in
userspace if `tail` assumes such
atomicity.

> Note, BTW, that your example depends upon rather non-obvious details of e=
cho
> implementation, starting with the bufferization logics used by particular
> shell.  And AFAICS ash(1) ends up with possibility of more than one write=
(2)

I've never imagined such a difference in echo implementation, thanks.
