Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:35481 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934261AbdDGQ6z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 12:58:55 -0400
Received: by mail-it0-f48.google.com with SMTP id y18so122959620itc.0
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Apr 2017 09:58:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <553d293f-67ba-fc66-5c6c-50ef44178137@gmail.com>
References: <CAD4AmV5UPAKOohdMvGGbb7FV+EaToMg-kRX2rTJFB3NmwD0iwQ@mail.gmail.com>
 <CAD4AmV7jYAoUnr4BkGDtMx_sNN++wWsBFA3McLXq285UM7y5fw@mail.gmail.com>
 <CAJCQCtQhcYYSoLoVE3i10De8V_CM9yGnMh4uzGsAZAczPfXerQ@mail.gmail.com>
 <CAD4AmV5PmFHW5Hm-K50g1e3ahWjkD8=d-FtOaBpcvDNO4u+M=g@mail.gmail.com>
 <CAJCQCtRyia+r7Qdwwzwoyw+aoxvav86d2HHyKpQkDD6guHp3iA@mail.gmail.com>
 <CAD4AmV68i-nUqzYMxc-QHuDAx8P=K4Jr4JrZdW=vFFyC0PK1+A@mail.gmail.com>
 <d531fd79-c08a-0ba1-ae51-5503bc56b121@gmail.com> <CAJCQCtRua7LzZzsdtN8c9YCGCeDCdzCtmgQWP1-eB0FccdndZA@mail.gmail.com>
 <553d293f-67ba-fc66-5c6c-50ef44178137@gmail.com>
From: John Petrini <jpetrini@coredial.com>
Date: Fri, 7 Apr 2017 12:58:33 -0400
Message-ID: <CAD4AmV6yD4s09H4q2QEyjb=pPRkGoESgNv1dEfNCpYWAWcAsqQ@mail.gmail.com>
Subject: Re: Volume appears full but TB's of space available
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When you say "running BTRFS raid1 on top of LVM RAID0 volumes" do you
mean creating two LVM RAID-0 volumes and then putting BTRFS RAID1 on
the two resulting logical volumes?
___

John Petrini

NOC Systems Administrator   //   CoreDial, LLC   //   coredial.com
//
Hillcrest I, 751 Arbor Way, Suite 150, Blue Bell PA, 19422
P: 215.297.4400 x232   //   F: 215.297.4401   //   E: jpetrini@coredial.com


Interested in sponsoring PartnerConnex 2017? Learn more.

The information transmitted is intended only for the person or entity
to which it is addressed and may contain confidential and/or
privileged material. Any review, retransmission,  dissemination or
other use of, or taking of any action in reliance upon, this
information by persons or entities other than the intended recipient
is prohibited. If you received this in error, please contact the
sender and delete the material from any computer.


On Fri, Apr 7, 2017 at 12:51 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2017-04-07 12:04, Chris Murphy wrote:
>>
>> On Fri, Apr 7, 2017 at 5:41 AM, Austin S. Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>
>>> I'm rather fond of running BTRFS raid1 on top of LVM RAID0 volumes,
>>> which while it provides no better data safety than BTRFS raid10 mode,
>>> gets
>>> noticeably better performance.
>>
>>
>> This does in fact have better data safety than Btrfs raid10 because it
>> is possible to lose more than one drive without data loss. You can
>> only lose drives on one side of the mirroring, however. This is a
>> conventional raid0+1, so it's not as scalable as raid10 when it comes
>> to rebuild time.
>>
> That's a good point that I don't often remember, and I'm pretty sure that
> such an array will rebuild slower from a single device loss than BTRFS
> raid10 would, but most of that should be that BTRFS is smart enough to only
> rewrite what it has to.
>
