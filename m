Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:37485 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756016AbdDGN25 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 09:28:57 -0400
Received: by mail-it0-f49.google.com with SMTP id a140so42647243ita.0
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Apr 2017 06:28:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d531fd79-c08a-0ba1-ae51-5503bc56b121@gmail.com>
References: <CAD4AmV5UPAKOohdMvGGbb7FV+EaToMg-kRX2rTJFB3NmwD0iwQ@mail.gmail.com>
 <CAD4AmV7jYAoUnr4BkGDtMx_sNN++wWsBFA3McLXq285UM7y5fw@mail.gmail.com>
 <CAJCQCtQhcYYSoLoVE3i10De8V_CM9yGnMh4uzGsAZAczPfXerQ@mail.gmail.com>
 <CAD4AmV5PmFHW5Hm-K50g1e3ahWjkD8=d-FtOaBpcvDNO4u+M=g@mail.gmail.com>
 <CAJCQCtRyia+r7Qdwwzwoyw+aoxvav86d2HHyKpQkDD6guHp3iA@mail.gmail.com>
 <CAD4AmV68i-nUqzYMxc-QHuDAx8P=K4Jr4JrZdW=vFFyC0PK1+A@mail.gmail.com> <d531fd79-c08a-0ba1-ae51-5503bc56b121@gmail.com>
From: John Petrini <jpetrini@coredial.com>
Date: Fri, 7 Apr 2017 09:28:55 -0400
Message-ID: <CAD4AmV7-tFesnWbYR=geRVcFedgb4zcfKeVXuEVNnNtJN0qg1w@mail.gmail.com>
Subject: Re: Volume appears full but TB's of space available
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Austin,

Thanks for taking to time to provide all of this great information!

You've got me curious about RAID1. If I were to convert the array to
RAID1 could it then sustain a multi drive failure? Or in other words
do I actually end up with mirrored pairs or can a chunk still be
mirrored to any disk in the array? Are there performance implications
to using RAID1 vs RAID10?
