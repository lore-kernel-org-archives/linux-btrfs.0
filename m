Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f180.google.com ([209.85.213.180]:34335 "EHLO
        mail-yb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933633AbdDGQEQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 12:04:16 -0400
Received: by mail-yb0-f180.google.com with SMTP id m133so18095959ybb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Apr 2017 09:04:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d531fd79-c08a-0ba1-ae51-5503bc56b121@gmail.com>
References: <CAD4AmV5UPAKOohdMvGGbb7FV+EaToMg-kRX2rTJFB3NmwD0iwQ@mail.gmail.com>
 <CAD4AmV7jYAoUnr4BkGDtMx_sNN++wWsBFA3McLXq285UM7y5fw@mail.gmail.com>
 <CAJCQCtQhcYYSoLoVE3i10De8V_CM9yGnMh4uzGsAZAczPfXerQ@mail.gmail.com>
 <CAD4AmV5PmFHW5Hm-K50g1e3ahWjkD8=d-FtOaBpcvDNO4u+M=g@mail.gmail.com>
 <CAJCQCtRyia+r7Qdwwzwoyw+aoxvav86d2HHyKpQkDD6guHp3iA@mail.gmail.com>
 <CAD4AmV68i-nUqzYMxc-QHuDAx8P=K4Jr4JrZdW=vFFyC0PK1+A@mail.gmail.com> <d531fd79-c08a-0ba1-ae51-5503bc56b121@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 7 Apr 2017 10:04:14 -0600
Message-ID: <CAJCQCtRua7LzZzsdtN8c9YCGCeDCdzCtmgQWP1-eB0FccdndZA@mail.gmail.com>
Subject: Re: Volume appears full but TB's of space available
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: John Petrini <jpetrini@coredial.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 7, 2017 at 5:41 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

> I'm rather fond of running BTRFS raid1 on top of LVM RAID0 volumes,
> which while it provides no better data safety than BTRFS raid10 mode, gets
> noticeably better performance.

This does in fact have better data safety than Btrfs raid10 because it
is possible to lose more than one drive without data loss. You can
only lose drives on one side of the mirroring, however. This is a
conventional raid0+1, so it's not as scalable as raid10 when it comes
to rebuild time.



-- 
Chris Murphy
