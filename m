Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:34168 "EHLO
        mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754139AbdHWP2O (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 11:28:14 -0400
Received: by mail-vk0-f52.google.com with SMTP id s199so1635281vke.1
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 08:28:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170802202720.GB12533@localhost.localdomain>
References: <20170801161439.13426-1-bo.li.liu@oracle.com> <ac334d78-77e1-081d-1cf0-48e36e25268f@libero.it>
 <20170801172411.GE26357@localhost.localdomain> <dc65edc8-82bd-ac1b-fa90-6076bea13df9@inwind.it>
 <20170802175738.GA12533@localhost.localdomain> <91f2f70c-151d-d0ff-1acf-c5eb55e4fc9c@inwind.it>
 <20170802202720.GB12533@localhost.localdomain>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 23 Aug 2017 09:28:13 -0600
Message-ID: <CAJCQCtRrGRgU0u3+qU1pMgsyLfhOWHDrF6CCgVc8c9+JsLuoow@mail.gmail.com>
Subject: Re: [PATCH 00/14 RFC] Btrfs: Add journal for raid5/6 writes
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Goffredo Baroncelli <kreijack@inwind.it>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 2, 2017 at 2:27 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Wed, Aug 02, 2017 at 10:41:30PM +0200, Goffredo Baroncelli wrote:

>> What I want to understand, is if it is possible to log only the "partial stripe"  RMW cycle.
>>
>
> I think your point is valid if all data is written with datacow.  In
> case of nodatacow, btrfs does overwrite in place, so a full stripe
> write may pollute on-disk data after unclean shutdown.  Checksum can
> detect errors but repair thru raid5 may not recover the correct data.

What's simpler? raid56 journal for everything (cow, nocow, data,
metadata), or to apply some limitations to available layouts?

-  if raid56, then cow only (no such thing as nodatacow)
-  permit raid56 for data bg only, system and metadata can be raid1, or raid10

I'm hard pressed thinking of a use case where metadata raid56 is
beneficial over raid10; a metadata heavy workload is not well suited
for any parity raid. And if it isn't metadata heavy, then chances are
you don't even need raid10 but raid1 is sufficient.

Of the more complicated ways to solve it:

- journal
- dynamically sized stripes, so that writes can always be full stripe
writes, no overwrites, and atomic
- mixed block groups where only sequential full stripe writes use
raid56 block group; random and smaller writes go in a raid 1 or 10
block group.

-- 
Chris Murphy
