Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:33535 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751128AbdGOHJp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Jul 2017 03:09:45 -0400
Received: by mail-pg0-f44.google.com with SMTP id k14so55616921pgr.0
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Jul 2017 00:09:45 -0700 (PDT)
Date: Sat, 15 Jul 2017 00:09:42 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: fix early ENOSPC due to delalloc
Message-ID: <20170715070942.GA10038@vader>
References: <0cf8577381f6ebe99b584ca60f920c630000c343.1499407060.git.osandov@fb.com>
 <20170714213645.GC13690@vader.DHCP.thefacebook.com>
 <1b7c8283-b585-27c4-6b95-12e889b3b96f@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1b7c8283-b585-27c4-6b95-12e889b3b96f@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 15, 2017 at 09:43:18AM +0300, Nikolay Borisov wrote:
> 
> 
> On 15.07.2017 00:36, Omar Sandoval wrote:
> > On Thu, Jul 06, 2017 at 10:59:27PM -0700, Omar Sandoval wrote:
> >> From: Omar Sandoval <osandov@fb.com>
> >>
> >> If a lot of metadata is reserved for outstanding delayed allocations, we
> >> rely on shrink_delalloc() to reclaim metadata space in order to fulfill
> >> reservation tickets. However, shrink_delalloc() has a shortcut where if
> >> it determines that space can be overcommitted, it will stop early. This
> >> made sense before the ticketed enospc system, but now it means that
> >> shrink_delalloc() will often not reclaim enough space to fulfill any
> >> tickets, leading to an early ENOSPC. (Reservation tickets don't care
> >> about being able to overcommit, they need every byte accounted for.)
> >>
> >> Fix it by getting rid of the shortcut so that shrink_delalloc() reclaims
> >> all of the metadata it is supposed to. This fixes early ENOSPCs we were
> >> seeing when doing a btrfs receive to populate a new filesystem.
> > 
> > Jeff, Nikolay, did either of you get a chance to test this yet?
> 
> I tested this patch with generic/273 and it didn't prevent ENOSPC there.

Weird, I've never seen generic/273 fail. Anyways, I'm more interested in
the installer ENOSPCs Jeff mentioned.
