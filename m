Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:38883 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751645AbdDGDZd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Apr 2017 23:25:33 -0400
Received: by mail-it0-f52.google.com with SMTP id y18so36898020itc.1
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Apr 2017 20:25:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRyia+r7Qdwwzwoyw+aoxvav86d2HHyKpQkDD6guHp3iA@mail.gmail.com>
References: <CAD4AmV5UPAKOohdMvGGbb7FV+EaToMg-kRX2rTJFB3NmwD0iwQ@mail.gmail.com>
 <CAD4AmV7jYAoUnr4BkGDtMx_sNN++wWsBFA3McLXq285UM7y5fw@mail.gmail.com>
 <CAJCQCtQhcYYSoLoVE3i10De8V_CM9yGnMh4uzGsAZAczPfXerQ@mail.gmail.com>
 <CAD4AmV5PmFHW5Hm-K50g1e3ahWjkD8=d-FtOaBpcvDNO4u+M=g@mail.gmail.com> <CAJCQCtRyia+r7Qdwwzwoyw+aoxvav86d2HHyKpQkDD6guHp3iA@mail.gmail.com>
From: John Petrini <jpetrini@coredial.com>
Date: Thu, 6 Apr 2017 23:25:32 -0400
Message-ID: <CAD4AmV68i-nUqzYMxc-QHuDAx8P=K4Jr4JrZdW=vFFyC0PK1+A@mail.gmail.com>
Subject: Re: Volume appears full but TB's of space available
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Interesting. That's the first time I'm hearing this. If that's the
case I feel like it's a stretch to call it RAID10 at all. It sounds a
lot more like basic replication similar to Ceph only Ceph understands
failure domains and therefore can be configured to handle device
failure (albeit at a higher level)

I do of course keep backups but I chose RAID10 for the mix of
performance and reliability. It doesn't seems worth it losing 50% of
my usable space for the performance gain alone.

Thank you for letting me know about this. Knowing that I think I may
have to reconsider my choice here. I've really been enjoying the
flexibility of BTRS which is why I switched to it in the first place
but with experimental RAID5/6 and what you've just told me I'm
beginning to doubt that it's the right choice.

What's more concerning is that I haven't found a good way to monitor
BTRFS. I might be able to accept that the array can only handle a
single drive failure if I was confident that I could detect it but so
far I haven't found a good solution for this.
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


On Thu, Apr 6, 2017 at 10:42 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Thu, Apr 6, 2017 at 7:31 PM, John Petrini <jpetrini@coredial.com> wrote:
>> Hi Chris,
>>
>> I've followed your advice and converted the system chunk to raid10. I
>> hadn't noticed it was raid0 and it's scary to think that I've been
>> running this array for three months like that. Thank you for saving me
>> a lot of pain down the road!
>
> For what it's worth, it is imperative to keep frequent backups with
> Btrfs raid10, it is in some ways more like raid0+1. It can only
> tolerate the loss of a single device. It will continue to function
> with 2+ devices in a very deceptive degraded state, until it
> inevitably hits dual missing chunks of metadata or data, and then it
> will faceplant. And then you'll be looking at a scrape operation.
>
> It's not like raid10 where you can lose one of each mirrored pair.
> Btrfs raid10 mirrors chunks, not drives. So your metadata and data are
> all distributed across all of the drives, and that in effect means you
> can only lose 1 drive. If you lose a 2nd drive, some amount of
> metadata and data will have been lost.
>
>
> --
> Chris Murphy
