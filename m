Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:37071 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932668AbdGXUzC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 16:55:02 -0400
Received: by mail-wm0-f44.google.com with SMTP id c184so41276051wmd.0
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 13:55:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170724204257.GJ7140@carfax.org.uk>
References: <1500895655.2781.6.camel@cloud.haefemeier.eu> <CAJCQCtT3nEaHox7jiO-jf6hCjpUSRz=AahrapgZDajJdeYr1Rw@mail.gmail.com>
 <20170724204257.GJ7140@carfax.org.uk>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 24 Jul 2017 14:55:00 -0600
Message-ID: <CAJCQCtTpdn0zNmogkbDr0h4RjNvb8u21w7Sj3xjUrj77A+ss8w@mail.gmail.com>
Subject: Re: Best Practice: Add new device to RAID1 pool
To: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        Cloud Admin <admin@cloud.haefemeier.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 24, 2017 at 2:42 PM, Hugo Mills <hugo@carfax.org.uk> wrote:

>
>    In my experience, it's pretty consistent at about a minute per 1
> GiB for data on rotational drives on RAID-1. For metadata, it can go
> up to several hours (or more) per 256 MiB chunk, depending on what
> kind of metadata it is. With extents shared between lots of files, it
> slows down. In my case, with a few hundred snapshots of the same
> thing, my system was taking 4h per chunk for the chunks full of the
> extent tree.

Egads.

Maybe Cloud Admin ought to consider using a filter to just balance the
data chunks across the three devices, and just leave the metadata on
the original two disks?

Maybe

sudo btrfs balance start -dusage=100 <mp>


-- 
Chris Murphy
