Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:32845 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753411AbdIDLJZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Sep 2017 07:09:25 -0400
Received: by mail-qk0-f173.google.com with SMTP id o129so610077qkd.0
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Sep 2017 04:09:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$75cde$b9b6710$ed24172a$22c271cc@cox.net>
References: <710ec5d1-adbf-4ce5-50a5-8b8266ccb672@rqc.ru> <pan$75cde$b9b6710$ed24172a$22c271cc@cox.net>
From: Henk Slager <eye1tm@gmail.com>
Date: Mon, 4 Sep 2017 13:09:24 +0200
Message-ID: <CAPmG0jaQL5PcRWUrTBkboLxhmfpQ5-W8h3toPasSK1nvk42e3Q@mail.gmail.com>
Subject: Re: Is autodefrag recommended?
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 4, 2017 at 12:34 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> * Autodefrag works very well when these internal-rewrite-pattern files
> are relatively small, say a quarter GiB or less, but, again with near-
> capacity throughput, not necessarily so well with larger databases or VM
> images of a GiB or larger.  (The quarter-gig to gig size is intermediate,
> not as often a problem and not a problem for many, but it can be for
> slower devices, while those on fast ssds may not see a problem until
> sizes reach multiple GiB.)

I have seen you stating this before about some quarter GiB filesize or
so, but it is irrelevant, it is simply not how it works. See
explanation of Hugo for how it works. I can post/store an actual
filefrag output of a vm image that is around for 2 years on the one of
my btrfs fs, then you can do some statistics on it and see from there
how it works.
