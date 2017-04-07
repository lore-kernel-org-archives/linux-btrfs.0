Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:34529 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751081AbdDGCmU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Apr 2017 22:42:20 -0400
Received: by mail-yw0-f169.google.com with SMTP id p77so29048885ywg.1
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Apr 2017 19:42:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD4AmV5PmFHW5Hm-K50g1e3ahWjkD8=d-FtOaBpcvDNO4u+M=g@mail.gmail.com>
References: <CAD4AmV5UPAKOohdMvGGbb7FV+EaToMg-kRX2rTJFB3NmwD0iwQ@mail.gmail.com>
 <CAD4AmV7jYAoUnr4BkGDtMx_sNN++wWsBFA3McLXq285UM7y5fw@mail.gmail.com>
 <CAJCQCtQhcYYSoLoVE3i10De8V_CM9yGnMh4uzGsAZAczPfXerQ@mail.gmail.com> <CAD4AmV5PmFHW5Hm-K50g1e3ahWjkD8=d-FtOaBpcvDNO4u+M=g@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 6 Apr 2017 20:42:19 -0600
Message-ID: <CAJCQCtRyia+r7Qdwwzwoyw+aoxvav86d2HHyKpQkDD6guHp3iA@mail.gmail.com>
Subject: Re: Volume appears full but TB's of space available
To: John Petrini <jpetrini@coredial.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 6, 2017 at 7:31 PM, John Petrini <jpetrini@coredial.com> wrote:
> Hi Chris,
>
> I've followed your advice and converted the system chunk to raid10. I
> hadn't noticed it was raid0 and it's scary to think that I've been
> running this array for three months like that. Thank you for saving me
> a lot of pain down the road!

For what it's worth, it is imperative to keep frequent backups with
Btrfs raid10, it is in some ways more like raid0+1. It can only
tolerate the loss of a single device. It will continue to function
with 2+ devices in a very deceptive degraded state, until it
inevitably hits dual missing chunks of metadata or data, and then it
will faceplant. And then you'll be looking at a scrape operation.

It's not like raid10 where you can lose one of each mirrored pair.
Btrfs raid10 mirrors chunks, not drives. So your metadata and data are
all distributed across all of the drives, and that in effect means you
can only lose 1 drive. If you lose a 2nd drive, some amount of
metadata and data will have been lost.


-- 
Chris Murphy
