Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:51859 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753857AbdKMSkI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Nov 2017 13:40:08 -0500
Received: by mail-ot0-f175.google.com with SMTP id b54so2367064otd.8
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Nov 2017 10:40:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <90b045d0-deb8-ba66-0a43-fa373e630279@gmx.com>
References: <CAJCQCtQ-WkNShYNGi9hk8s7M_RdLGHV3Jw0zArt_W-uzYQ9BAg@mail.gmail.com>
 <6ee63ff7-6a0c-7828-0751-5769d59bb85f@cn.fujitsu.com> <CAJCQCtTdfD6=xWttk5D4JqLpzG9ZMxb-c=GopZPPNsLP6eHHpw@mail.gmail.com>
 <aea6f1e7-7621-a32a-9cce-2e37357f4b82@cn.fujitsu.com> <CAJCQCtSDHdytGS51uLAuS9Ki7_CDKsy2x9OpPUmvwYpQ7iRrLQ@mail.gmail.com>
 <69cc700e-5597-594c-cfb7-8f8a0c2a544e@cn.fujitsu.com> <CAJCQCtTpuXQPaogXYyVqz=A_3AV9+wwu711aKqgY0wj1QA2bdg@mail.gmail.com>
 <f4bc7f4a-d11c-6887-f148-286c1f0e7cd2@cn.fujitsu.com> <CAJCQCtTYDGRoMsqbCCz0tFF86_PT73wUDezfOGGYn2LXZyz2CQ@mail.gmail.com>
 <923a9714-c7fb-cb1e-6753-71caffeb0657@cn.fujitsu.com> <CAJCQCtRzxu8-QaZ+VLJLskMkOe=Sw4vdA-dJ7e-WCbrpRWtU9A@mail.gmail.com>
 <90b045d0-deb8-ba66-0a43-fa373e630279@gmx.com>
From: Chris Murphy <chris@colorremedies.com>
Date: Mon, 13 Nov 2017 11:40:06 -0700
Message-ID: <CAJCQCtS4YCRHSoahmqR64Qwd7o1iu8YZY1vdhwsb80icPFxq5A@mail.gmail.com>
Subject: Re: btrfs check lowmem vs original
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 12, 2017 at 9:37 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

>
> The final bug about backref counts mismatch, without the image I'm not
> really sure what's going on.
>
> (But extent tree verification is really buggy though)

Ahh I imaged the wrong file system! Sorry about that:


>>ERROR: extent[366498091008, 134217728] referencer count mismatch
>>(root: 827, owner: 73782, offset: 134217728) wanted: 4, have: 26

>>Complete output, with filtered btrfs-debug-tree info for extent
>>address 366498091008.
>>https://drive.google.com/open?id=1LUMtLIc1LcXhYN3twFcxTyFuJ6ScMlyQ

Here is the image for that two device raid1:

https://drive.google.com/open?id=1LO96omP3BQh9C3ZYVXoUDT4-H8P5lZ6D



-- 
Chris Murphy
