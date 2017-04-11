Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:34322 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753334AbdDKUnR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Apr 2017 16:43:17 -0400
Received: by mail-yw0-f170.google.com with SMTP id k13so4001531ywk.1
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Apr 2017 13:43:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACh0r45KQb+wLCbRP50WUfe8Loa=zF-Y13n2MhgUbRKi=UT8bw@mail.gmail.com>
References: <CACh0r45KQb+wLCbRP50WUfe8Loa=zF-Y13n2MhgUbRKi=UT8bw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 11 Apr 2017 14:43:10 -0600
Message-ID: <CAJCQCtTEO4-n3+Nohbbv9g_6s1BC9VJ6m6Yc6S_LueqHfU4EwA@mail.gmail.com>
Subject: Re: Btrfs disk layout question
To: Amin Hassani <ahassani@chromium.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 11, 2017 at 1:15 PM, Amin Hassani <ahassani@chromium.org> wrote:
> Hi,
>
> I am working on a project with Btrfs and I was wondering if there is
> any way to see the disk layout of the btrfs image. Let's assume I have
> a read-only btrfs image with compression on and only using one disk
> (no raid or anything). Is it possible to get a set of offset-lengths
> for each file or metadata parts of the image. I know there is an
> unfinished documentation for On-disk Formant in here:
> https://btrfs.wiki.kernel.org/index.php/On-disk_Format
> But it is not complete and does not show what I am looking for. Is
> there any other documentation on this? Is there any public API that I
> can use to get this information. For example can I iterate on all
> files starting from the root node and get all offset-lengths? This way
> any part that doesn't come can be assumed as metadata. I don't really
> care what is inside the metadata, I just want to know their
> offset-lengths in the file system.


btrfs-debug-tree contains this information in human readable form.
There's also btrfs-heatmap

https://github.com/knorrie/btrfs-heatmap



-- 
Chris Murphy
