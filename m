Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:36081 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932075AbdDGRL5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 13:11:57 -0400
Received: by mail-it0-f50.google.com with SMTP id 19so27137223itj.1
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Apr 2017 10:11:57 -0700 (PDT)
Subject: Re: Volume appears full but TB's of space available
To: John Petrini <jpetrini@coredial.com>
References: <CAD4AmV5UPAKOohdMvGGbb7FV+EaToMg-kRX2rTJFB3NmwD0iwQ@mail.gmail.com>
 <CAD4AmV7jYAoUnr4BkGDtMx_sNN++wWsBFA3McLXq285UM7y5fw@mail.gmail.com>
 <CAJCQCtQhcYYSoLoVE3i10De8V_CM9yGnMh4uzGsAZAczPfXerQ@mail.gmail.com>
 <CAD4AmV5PmFHW5Hm-K50g1e3ahWjkD8=d-FtOaBpcvDNO4u+M=g@mail.gmail.com>
 <CAJCQCtRyia+r7Qdwwzwoyw+aoxvav86d2HHyKpQkDD6guHp3iA@mail.gmail.com>
 <CAD4AmV68i-nUqzYMxc-QHuDAx8P=K4Jr4JrZdW=vFFyC0PK1+A@mail.gmail.com>
 <d531fd79-c08a-0ba1-ae51-5503bc56b121@gmail.com>
 <CAD4AmV7-tFesnWbYR=geRVcFedgb4zcfKeVXuEVNnNtJN0qg1w@mail.gmail.com>
 <56b58b49-a4ab-56f9-25e5-94d64699da83@gmail.com>
 <CAJCQCtQqomcKRn-J8bJchVng=D4od346p18CKvjYp86zKSZysA@mail.gmail.com>
 <12332db1-c52a-f483-e2e7-e23e508e6066@gmail.com>
 <CAD4AmV6HTJS7BvduLjetj3K2KWqiBoBs3zS1Ca0axAvTK8WJtw@mail.gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <27d219e4-2f44-bfdc-06e3-d86db1349183@gmail.com>
Date: Fri, 7 Apr 2017 13:11:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAD4AmV6HTJS7BvduLjetj3K2KWqiBoBs3zS1Ca0axAvTK8WJtw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-07 13:05, John Petrini wrote:
> The use case actually is not Ceph, I was just drawing a comparison
> between Ceph's object replication strategy vs BTRF's chunk mirroring.
That's actually a really good comparison that I hadn't thought of 
before.  From what I can tell from my limited understanding of how Ceph 
works, the general principals are pretty similar, except that BTRFS 
doesn't understand or implement failure domains (although having CRUSH 
implemented in BTRFS for chunk placement would be a killer feature IMO).
>
> I do find the conversation interesting however as I work with Ceph
> quite a lot but have always gone with the default XFS filesystem for
> on OSD's.
>
 From a stability perspective, I would normally go with XFS still for 
the OSD's.  Most of the data integrity features provided by BTRFS are 
also implemented in Ceph, so you don't gain much other than flexibility 
currently by using BTRFS instead of XFS.  The one advantage BTRFS has in 
my experience over XFS for something like this is that it seems (with 
recent versions at least) to be more likely to survive a power-failure 
without any serious data loss than XFS is, but that's not really a 
common concern in Ceph's primary use case.
