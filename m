Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:32864 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbdIDIoA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Sep 2017 04:44:00 -0400
Received: by mail-qt0-f178.google.com with SMTP id e2so20345147qta.0
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Sep 2017 01:44:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1841512.lHhB7WV3Ld@russell.coker.com.au>
References: <1841512.lHhB7WV3Ld@russell.coker.com.au>
From: Henk Slager <eye1tm@gmail.com>
Date: Mon, 4 Sep 2017 10:43:59 +0200
Message-ID: <CAPmG0jZ97vX-QvhRxDa_P8sm0C2g8fT2nC4b16uUtD3YQkUPWw@mail.gmail.com>
Subject: Re: read-only for no good reason on 4.9.30
To: russell+btrfs@coker.com.au
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 4, 2017 at 7:19 AM, Russell Coker
<russell+btrfs@coker.com.au> wrote:
> I have a system with less than 50% disk space used.  It just started rejecting
> writes due to lack of disk space.  I ran "btrfs balance" and then it started
> working correctly again.  It seems that a btrfs filesystem if left alone will
> eventually get fragmented enough that it rejects writes (I've had similar
> issues with other systems running BTRFS with other kernel versions).
>
> Is this a known issue?
This is a known issue, but with kernel 4.8 or later it more rare. At
least I myself have never had it since then on 10+ active btrfs
filesystems.

> Is there any good way of recognising when it's likely to happen?  Is there
> anything I can do other than rewriting a medium size file to determine when
> it's happened?
I am not aware of an easy way of recognizing it, but there are some
python tools that can show you the usage per chunk and that can give
an indication.

A way to prevent the issue might be adding/changing mount options,
although I have no hard proof, only good experiences.

What are the mount options fpor this filesystem?
I think compress=lzo, noatime, and autodefrag might help for various
reasons. I use the first 2 on SSDs en the last one on HDDs (with and
without bcache).
Maybe someone else has more tips or comments.
