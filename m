Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34745 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751288AbdDGQvq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 12:51:46 -0400
Received: by mail-io0-f180.google.com with SMTP id b140so53381864iof.1
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Apr 2017 09:51:46 -0700 (PDT)
Subject: Re: Volume appears full but TB's of space available
To: Chris Murphy <lists@colorremedies.com>
References: <CAD4AmV5UPAKOohdMvGGbb7FV+EaToMg-kRX2rTJFB3NmwD0iwQ@mail.gmail.com>
 <CAD4AmV7jYAoUnr4BkGDtMx_sNN++wWsBFA3McLXq285UM7y5fw@mail.gmail.com>
 <CAJCQCtQhcYYSoLoVE3i10De8V_CM9yGnMh4uzGsAZAczPfXerQ@mail.gmail.com>
 <CAD4AmV5PmFHW5Hm-K50g1e3ahWjkD8=d-FtOaBpcvDNO4u+M=g@mail.gmail.com>
 <CAJCQCtRyia+r7Qdwwzwoyw+aoxvav86d2HHyKpQkDD6guHp3iA@mail.gmail.com>
 <CAD4AmV68i-nUqzYMxc-QHuDAx8P=K4Jr4JrZdW=vFFyC0PK1+A@mail.gmail.com>
 <d531fd79-c08a-0ba1-ae51-5503bc56b121@gmail.com>
 <CAJCQCtRua7LzZzsdtN8c9YCGCeDCdzCtmgQWP1-eB0FccdndZA@mail.gmail.com>
Cc: John Petrini <jpetrini@coredial.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <553d293f-67ba-fc66-5c6c-50ef44178137@gmail.com>
Date: Fri, 7 Apr 2017 12:51:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRua7LzZzsdtN8c9YCGCeDCdzCtmgQWP1-eB0FccdndZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-07 12:04, Chris Murphy wrote:
> On Fri, Apr 7, 2017 at 5:41 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>
>> I'm rather fond of running BTRFS raid1 on top of LVM RAID0 volumes,
>> which while it provides no better data safety than BTRFS raid10 mode, gets
>> noticeably better performance.
>
> This does in fact have better data safety than Btrfs raid10 because it
> is possible to lose more than one drive without data loss. You can
> only lose drives on one side of the mirroring, however. This is a
> conventional raid0+1, so it's not as scalable as raid10 when it comes
> to rebuild time.
>
That's a good point that I don't often remember, and I'm pretty sure 
that such an array will rebuild slower from a single device loss than 
BTRFS raid10 would, but most of that should be that BTRFS is smart 
enough to only rewrite what it has to.

