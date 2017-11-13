Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:44622 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751243AbdKMDhL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Nov 2017 22:37:11 -0500
Received: by mail-oi0-f43.google.com with SMTP id a75so4769577oib.1
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Nov 2017 19:37:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <923a9714-c7fb-cb1e-6753-71caffeb0657@cn.fujitsu.com>
References: <CAJCQCtQ-WkNShYNGi9hk8s7M_RdLGHV3Jw0zArt_W-uzYQ9BAg@mail.gmail.com>
 <6ee63ff7-6a0c-7828-0751-5769d59bb85f@cn.fujitsu.com> <CAJCQCtTdfD6=xWttk5D4JqLpzG9ZMxb-c=GopZPPNsLP6eHHpw@mail.gmail.com>
 <aea6f1e7-7621-a32a-9cce-2e37357f4b82@cn.fujitsu.com> <CAJCQCtSDHdytGS51uLAuS9Ki7_CDKsy2x9OpPUmvwYpQ7iRrLQ@mail.gmail.com>
 <69cc700e-5597-594c-cfb7-8f8a0c2a544e@cn.fujitsu.com> <CAJCQCtTpuXQPaogXYyVqz=A_3AV9+wwu711aKqgY0wj1QA2bdg@mail.gmail.com>
 <f4bc7f4a-d11c-6887-f148-286c1f0e7cd2@cn.fujitsu.com> <CAJCQCtTYDGRoMsqbCCz0tFF86_PT73wUDezfOGGYn2LXZyz2CQ@mail.gmail.com>
 <923a9714-c7fb-cb1e-6753-71caffeb0657@cn.fujitsu.com>
From: Chris Murphy <chris@colorremedies.com>
Date: Sun, 12 Nov 2017 20:37:09 -0700
Message-ID: <CAJCQCtRzxu8-QaZ+VLJLskMkOe=Sw4vdA-dJ7e-WCbrpRWtU9A@mail.gmail.com>
Subject: Re: btrfs check lowmem vs original
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 12, 2017 at 7:25 PM, Su Yue <suy.fnst@cn.fujitsu.com> wrote:

>
> I have some patches for lowmem mode. But they are not fully tested and
> unstable.
> It will be so nice if you can provide some images.

Sorry, Qu got the image offline, I wasn't paying attention that btrfs
list wasn't cc'd.  The -ss option was taking too long and during the
imaging a systemd unit mounted the file system so I figured the image
might be useless or contain extra confusion.

Here is the -s image I send to Qu.

https://drive.google.com/open?id=1cIAANqMicIMp9NfgnvN_SA90kjM0kP0C




-- 
Chris Murphy
