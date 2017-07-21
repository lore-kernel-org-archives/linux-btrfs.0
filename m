Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34039 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751504AbdGUTK6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 15:10:58 -0400
Received: by mail-qk0-f194.google.com with SMTP id q66so4937210qki.1
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Jul 2017 12:10:58 -0700 (PDT)
Date: Fri, 21 Jul 2017 15:10:56 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        stable@vger.kernel.org
Subject: Re: [PATCH RESEND] Btrfs: fix early ENOSPC due to delalloc
Message-ID: <20170721191055.GB17477@destiny>
References: <33ac56aa74691de6109709168939cfe9f56cbd70.1500588286.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <33ac56aa74691de6109709168939cfe9f56cbd70.1500588286.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 20, 2017 at 03:10:35PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> If a lot of metadata is reserved for outstanding delayed allocations, we
> rely on shrink_delalloc() to reclaim metadata space in order to fulfill
> reservation tickets. However, shrink_delalloc() has a shortcut where if
> it determines that space can be overcommitted, it will stop early. This
> made sense before the ticketed enospc system, but now it means that
> shrink_delalloc() will often not reclaim enough space to fulfill any
> tickets, leading to an early ENOSPC. (Reservation tickets don't care
> about being able to overcommit, they need every byte accounted for.)
> 
> Fix it by getting rid of the shortcut so that shrink_delalloc() reclaims
> all of the metadata it is supposed to. This fixes early ENOSPCs we were
> seeing when doing a btrfs receive to populate a new filesystem, as well
> as early ENOSPCs Christoph saw when doing a big cp -r onto Btrfs.
> 
> Fixes: 957780eb2788 ("Btrfs: introduce ticketed enospc infrastructure")
> Tested-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
> Cc: stable@vger.kernel.org
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
