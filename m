Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:44350 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750872AbeDRTYw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 15:24:52 -0400
Received: by mail-oi0-f43.google.com with SMTP id e11-v6so2636254oii.11
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 12:24:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f336feb1-5da4-6d08-53f5-0a591253218b@gmail.com>
References: <271cf4a5-92d6-04eb-5f7a-471c2997ca48@swiftspirit.co.za> <f336feb1-5da4-6d08-53f5-0a591253218b@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 18 Apr 2018 13:24:50 -0600
Message-ID: <CAJCQCtQc3QQmwhVcBgNKChVyMhaMtKwa9vAYDpcPHCQ4Fsw62Q@mail.gmail.com>
Subject: Re: nvme+btrfs+compression sensibility and benchmark
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 18, 2018 at 10:38 AM, Austin S. Hemmelgarn <ahferroin7@gmail.com
> wrote:

> For reference, the zstd compression in BTRFS uses level 3 by default (as
> does zlib compression IIRC), though I'm not sure about lzop (I think it
> uses the lowest compression setting).
>


The user space tool, zstd, does default to 3, according to its man page.

       -#     # compression level [1-19] (default: 3)


However, the kernel is claiming it's level 0, which doesn't exist in the
man page. So I have no idea what we're using. This is what I get with mount
option compress=zstd

[    4.097858] BTRFS info (device nvme0n1p9): use zstd compression, level 0



--
Chris Murphy
