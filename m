Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:33422 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933880AbdDGREq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 13:04:46 -0400
Received: by mail-io0-f173.google.com with SMTP id t68so19774901iof.0
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Apr 2017 10:04:46 -0700 (PDT)
Subject: Re: Volume appears full but TB's of space available
To: John Petrini <jpetrini@coredial.com>
References: <CAD4AmV5UPAKOohdMvGGbb7FV+EaToMg-kRX2rTJFB3NmwD0iwQ@mail.gmail.com>
 <CAD4AmV7jYAoUnr4BkGDtMx_sNN++wWsBFA3McLXq285UM7y5fw@mail.gmail.com>
 <CAJCQCtQhcYYSoLoVE3i10De8V_CM9yGnMh4uzGsAZAczPfXerQ@mail.gmail.com>
 <CAD4AmV5PmFHW5Hm-K50g1e3ahWjkD8=d-FtOaBpcvDNO4u+M=g@mail.gmail.com>
 <CAJCQCtRyia+r7Qdwwzwoyw+aoxvav86d2HHyKpQkDD6guHp3iA@mail.gmail.com>
 <CAD4AmV68i-nUqzYMxc-QHuDAx8P=K4Jr4JrZdW=vFFyC0PK1+A@mail.gmail.com>
 <d531fd79-c08a-0ba1-ae51-5503bc56b121@gmail.com>
 <CAJCQCtRua7LzZzsdtN8c9YCGCeDCdzCtmgQWP1-eB0FccdndZA@mail.gmail.com>
 <553d293f-67ba-fc66-5c6c-50ef44178137@gmail.com>
 <CAD4AmV6yD4s09H4q2QEyjb=pPRkGoESgNv1dEfNCpYWAWcAsqQ@mail.gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <3ae6ec4c-fd30-66ab-2976-a9aa03e4dd22@gmail.com>
Date: Fri, 7 Apr 2017 13:04:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAD4AmV6yD4s09H4q2QEyjb=pPRkGoESgNv1dEfNCpYWAWcAsqQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-07 12:58, John Petrini wrote:
> When you say "running BTRFS raid1 on top of LVM RAID0 volumes" do you
> mean creating two LVM RAID-0 volumes and then putting BTRFS RAID1 on
> the two resulting logical volumes?
Yes, although it doesn't have to be LVM, it could just as easily be MD 
or even hardware RAID (I just prefer LVM for the flexibility it offers).

A quick tip regarding this, it seems to get the best performance if the 
stripe size (the -I option for lvcreate) is chosen so that it either 
matches the BTRFS block size, or such that each block in BTRFS gets 
striped across all the disks.

