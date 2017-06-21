Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:34581 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752601AbdFUD03 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 23:26:29 -0400
Received: by mail-wr0-f177.google.com with SMTP id 77so116109146wrb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jun 2017 20:26:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170620154429.GC22987@merlins.org>
References: <20170620143916.GA22987@merlins.org> <20170620152354.GD7140@carfax.org.uk>
 <20170620152648.GB22987@merlins.org> <20170620153601.GE7140@carfax.org.uk> <20170620154429.GC22987@merlins.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 20 Jun 2017 21:26:27 -0600
Message-ID: <CAJCQCtQJmWaPYvvcApcR6_mVVkFvyALaTpcazhBGSDQAwzcBPQ@mail.gmail.com>
Subject: Re: 4.11.3: BTRFS critical (device dm-1): unable to add free space
 :-17 => btrfs check --repair runs clean
To: Marc MERLIN <marc@merlins.org>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 20, 2017 at 9:44 AM, Marc MERLIN <marc@merlins.org> wrote:

> In the meantime, I ran into this again:
> https://bugzilla.kernel.org/show_bug.cgi?id=195863
> btrfs check of a big filesystem kills the kernel due to OOM (but btrfs userspace is not OOM killed)
>
> Is it achievable at all for btrfs check to realize that it's taking all the
> available RAM in kernel space, is about to crash the system, and cancel the
> check before the system crashes?
> I've already confirmed that it doesn't use swap. I've just had to order new
> RAM to upgrade my machine from 24GB to 32GB, but 32GB is max for that
> hardware, so hopefully the lowmem repair stuff will work before I hit the
> 32GB limit next time.

Right now Btrfs isn't scalable if you have to repair it because large
volumes run into this problem; one of the reasons for the lowmem mode.

It's a separate bug that it OOMs even with swap, I don't know why it
won't use that, it should be up to kernel memory management to deal
with this; I know this works with xfs_repair. I don't know if the idea
is that normal mode will go away, in favor of lowmem mode, or if there
are fixes still planned for normal mode. If it's going to stick
around, it needs to be able to use swap, same for lowmem mode. Just
running into a total inability to --repair isn't OK.


-- 
Chris Murphy
