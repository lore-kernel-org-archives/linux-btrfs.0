Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.datenkhaos.de ([81.89.99.198]:56811 "EHLO
        mail.datenkhaos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934345AbcKNPp1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 10:45:27 -0500
Date: Mon, 14 Nov 2016 16:37:20 +0100
From: Johannes Hirte <johannes.hirte@datenkhaos.de>
To: Peter Becker <floyd.net@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Tomasz Chmielewski <mangoo@wpkg.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: how to understand "btrfs fi show" output? "No space left" issues
Message-ID: <20161114153720.GA23564@probook>
References: <566e9000fe30d5b8e0d7e73ebe1d44a0@admin.virtall.com>
 <20160920065827.GO7138@carfax.org.uk>
 <CAEtw4r16f10PPsVw6r5t0KP-gJbSmKEYP-zt-s5De9kSBpZEqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAEtw4r16f10PPsVw6r5t0KP-gJbSmKEYP-zt-s5De9kSBpZEqg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016 Sep 20, Peter Becker wrote:
> Data, RAID1: total=417.12GiB, used=131.33GiB
> 
> You have 417(total)-131(used) blocks wo are only partial filled.
> You should balance your file-system.
> 
> At first you need some free space. You could remove some files / old
> snapshots etc. or you add a empty USB-Stick with min. 4 GB to your
> BTRFS-Pool (after balancing complete you can remove the stick from the
> pool).

He has plenty of space. What you're describing is the case that either
data pool or metadata pool is full, the other has enough space and
nothing is left that could be allocated to the full pool. In this case
rebalancing would help. But in Tomasz' case there is enough space in
every pool, so the allocator should use it. This really sounds like a
bug.

> But at first you should try to free emty data and meta data blocks:
> 
> btrfs balance start -musage=0 /mnt
> btrfs balance start -dusage=0 /mnt

Since kernel 3.18 this is done automatically.


regards,
  Johannes
