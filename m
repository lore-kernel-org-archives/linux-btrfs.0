Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:34703 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934085AbdDGRFW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 13:05:22 -0400
Received: by mail-io0-f170.google.com with SMTP id b140so53606997iof.1
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Apr 2017 10:05:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <12332db1-c52a-f483-e2e7-e23e508e6066@gmail.com>
References: <CAD4AmV5UPAKOohdMvGGbb7FV+EaToMg-kRX2rTJFB3NmwD0iwQ@mail.gmail.com>
 <CAD4AmV7jYAoUnr4BkGDtMx_sNN++wWsBFA3McLXq285UM7y5fw@mail.gmail.com>
 <CAJCQCtQhcYYSoLoVE3i10De8V_CM9yGnMh4uzGsAZAczPfXerQ@mail.gmail.com>
 <CAD4AmV5PmFHW5Hm-K50g1e3ahWjkD8=d-FtOaBpcvDNO4u+M=g@mail.gmail.com>
 <CAJCQCtRyia+r7Qdwwzwoyw+aoxvav86d2HHyKpQkDD6guHp3iA@mail.gmail.com>
 <CAD4AmV68i-nUqzYMxc-QHuDAx8P=K4Jr4JrZdW=vFFyC0PK1+A@mail.gmail.com>
 <d531fd79-c08a-0ba1-ae51-5503bc56b121@gmail.com> <CAD4AmV7-tFesnWbYR=geRVcFedgb4zcfKeVXuEVNnNtJN0qg1w@mail.gmail.com>
 <56b58b49-a4ab-56f9-25e5-94d64699da83@gmail.com> <CAJCQCtQqomcKRn-J8bJchVng=D4od346p18CKvjYp86zKSZysA@mail.gmail.com>
 <12332db1-c52a-f483-e2e7-e23e508e6066@gmail.com>
From: John Petrini <jpetrini@coredial.com>
Date: Fri, 7 Apr 2017 13:05:19 -0400
Message-ID: <CAD4AmV6HTJS7BvduLjetj3K2KWqiBoBs3zS1Ca0axAvTK8WJtw@mail.gmail.com>
Subject: Re: Volume appears full but TB's of space available
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The use case actually is not Ceph, I was just drawing a comparison
between Ceph's object replication strategy vs BTRF's chunk mirroring.

I do find the conversation interesting however as I work with Ceph
quite a lot but have always gone with the default XFS filesystem for
on OSD's.
