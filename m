Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:34744 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752502AbdCPXXy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Mar 2017 19:23:54 -0400
Received: by mail-yw0-f181.google.com with SMTP id p77so43284543ywg.1
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Mar 2017 16:22:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69cc700e-5597-594c-cfb7-8f8a0c2a544e@cn.fujitsu.com>
References: <CAJCQCtQ-WkNShYNGi9hk8s7M_RdLGHV3Jw0zArt_W-uzYQ9BAg@mail.gmail.com>
 <6ee63ff7-6a0c-7828-0751-5769d59bb85f@cn.fujitsu.com> <CAJCQCtTdfD6=xWttk5D4JqLpzG9ZMxb-c=GopZPPNsLP6eHHpw@mail.gmail.com>
 <aea6f1e7-7621-a32a-9cce-2e37357f4b82@cn.fujitsu.com> <CAJCQCtSDHdytGS51uLAuS9Ki7_CDKsy2x9OpPUmvwYpQ7iRrLQ@mail.gmail.com>
 <69cc700e-5597-594c-cfb7-8f8a0c2a544e@cn.fujitsu.com>
From: Chris Murphy <chris@colorremedies.com>
Date: Thu, 16 Mar 2017 17:22:20 -0600
Message-ID: <CAJCQCtTpuXQPaogXYyVqz=A_3AV9+wwu711aKqgY0wj1QA2bdg@mail.gmail.com>
Subject: Re: btrfs check lowmem vs original
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With kernel 4.10.3, and btrfs-progs 4.10, I'm still seeing the
following errors only with --mode=lowmem with a single device volume.


ERROR: data extent[16913485824 7577600] backref lost
(hundreds of lines of the same thing)

btrfs-image (no errors reported during capture) 518MiB
https://drive.google.com/open?id=0B7NttHfq6wAJd3ZXM3AxS0dVQlU


Chris Murphy
