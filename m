Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:40111 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753917AbeFTCce (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 22:32:34 -0400
Subject: Re: btrfs check lowmem vs original
To: Chris Murphy <chris@colorremedies.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtQ-WkNShYNGi9hk8s7M_RdLGHV3Jw0zArt_W-uzYQ9BAg@mail.gmail.com>
 <6ee63ff7-6a0c-7828-0751-5769d59bb85f@cn.fujitsu.com>
 <CAJCQCtTdfD6=xWttk5D4JqLpzG9ZMxb-c=GopZPPNsLP6eHHpw@mail.gmail.com>
 <aea6f1e7-7621-a32a-9cce-2e37357f4b82@cn.fujitsu.com>
 <CAJCQCtSDHdytGS51uLAuS9Ki7_CDKsy2x9OpPUmvwYpQ7iRrLQ@mail.gmail.com>
 <69cc700e-5597-594c-cfb7-8f8a0c2a544e@cn.fujitsu.com>
 <CAJCQCtTpuXQPaogXYyVqz=A_3AV9+wwu711aKqgY0wj1QA2bdg@mail.gmail.com>
 <f4bc7f4a-d11c-6887-f148-286c1f0e7cd2@cn.fujitsu.com>
 <CAJCQCtTYDGRoMsqbCCz0tFF86_PT73wUDezfOGGYn2LXZyz2CQ@mail.gmail.com>
 <923a9714-c7fb-cb1e-6753-71caffeb0657@cn.fujitsu.com>
 <CAJCQCtRzxu8-QaZ+VLJLskMkOe=Sw4vdA-dJ7e-WCbrpRWtU9A@mail.gmail.com>
 <90b045d0-deb8-ba66-0a43-fa373e630279@gmx.com>
 <CAJCQCtS4YCRHSoahmqR64Qwd7o1iu8YZY1vdhwsb80icPFxq5A@mail.gmail.com>
 <CAJCQCtTDHJ1zEr0HNP_kaQP1Lv6sLOgucyuZ=cuMZt_mgb4h_A@mail.gmail.com>
 <CAJCQCtToHCdmdnoDL_HfNmd-oBdYQHpsv+1ERJ+y_yNEo-fPWA@mail.gmail.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <3ab02b18-7f4f-345f-26c0-85b24ec59e73@cn.fujitsu.com>
Date: Wed, 20 Jun 2018 10:38:51 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtToHCdmdnoDL_HfNmd-oBdYQHpsv+1ERJ+y_yNEo-fPWA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/20/2018 10:19 AM, Chris Murphy wrote:
> I've retested btrfs-progs 4.17 lowmem mode and still get a bunch of
> 'referencer count mismatch' that I don't see with original mode.
> 
My bad. The bug is existed for long time since I changed lowmem mode
to traverse all trees.

Due to laziness then time passed, I have lost images you provided and
links are invalid.
It will be so nice of you if a image can be provided again.

I will look for causes immediately.

Thanks for the reports.

> e.g.
> ERROR: extent[1299275636736, 2654208] referencer count mismatch (root:
> 2192, owner: 317900, offset: 0) wanted: 5, have: 21
> 
> Complete output attached as a text file, since the MUA will mess up
> the line wrap.
> 
> 
> --
> Chris Murphy
> 
> 


