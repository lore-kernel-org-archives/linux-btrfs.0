Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:35925 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932139AbdHWPrV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 11:47:21 -0400
Received: by mail-io0-f178.google.com with SMTP id p141so1781233iop.3
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 08:47:21 -0700 (PDT)
Subject: Re: [PATCH 00/14 RFC] Btrfs: Add journal for raid5/6 writes
To: Chris Murphy <lists@colorremedies.com>, Liu Bo <bo.li.liu@oracle.com>
Cc: Goffredo Baroncelli <kreijack@inwind.it>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
 <ac334d78-77e1-081d-1cf0-48e36e25268f@libero.it>
 <20170801172411.GE26357@localhost.localdomain>
 <dc65edc8-82bd-ac1b-fa90-6076bea13df9@inwind.it>
 <20170802175738.GA12533@localhost.localdomain>
 <91f2f70c-151d-d0ff-1acf-c5eb55e4fc9c@inwind.it>
 <20170802202720.GB12533@localhost.localdomain>
 <CAJCQCtRrGRgU0u3+qU1pMgsyLfhOWHDrF6CCgVc8c9+JsLuoow@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0236e735-8b68-a0a9-1dc3-e32975b01e29@gmail.com>
Date: Wed, 23 Aug 2017 11:47:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRrGRgU0u3+qU1pMgsyLfhOWHDrF6CCgVc8c9+JsLuoow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-23 11:28, Chris Murphy wrote:
> On Wed, Aug 2, 2017 at 2:27 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> On Wed, Aug 02, 2017 at 10:41:30PM +0200, Goffredo Baroncelli wrote:
> 
>>> What I want to understand, is if it is possible to log only the "partial stripe"  RMW cycle.
>>>
>>
>> I think your point is valid if all data is written with datacow.  In
>> case of nodatacow, btrfs does overwrite in place, so a full stripe
>> write may pollute on-disk data after unclean shutdown.  Checksum can
>> detect errors but repair thru raid5 may not recover the correct data.
> 
> What's simpler? raid56 journal for everything (cow, nocow, data,
> metadata), or to apply some limitations to available layouts?
> 
> -  if raid56, then cow only (no such thing as nodatacow)
This should obviously be something that will be contentious to certain 
individuals.
> -  permit raid56 for data bg only, system and metadata can be raid1, or raid10
> 
> I'm hard pressed thinking of a use case where metadata raid56 is
> beneficial over raid10; a metadata heavy workload is not well suited
> for any parity raid. And if it isn't metadata heavy, then chances are
> you don't even need raid10 but raid1 is sufficient.
Until BTRFS gets n-way replication, raid6 remains the only way to 
configure a BTRFS volume to survive more than one device failure.
> 
> Of the more complicated ways to solve it:
> 
> - journal
> - dynamically sized stripes, so that writes can always be full stripe
> writes, no overwrites, and atomic
> - mixed block groups where only sequential full stripe writes use
> raid56 block group; random and smaller writes go in a raid 1 or 10
> block group.
> 

