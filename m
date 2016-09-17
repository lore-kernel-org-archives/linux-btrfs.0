Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:33373 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752385AbcIQPYK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Sep 2016 11:24:10 -0400
Received: by mail-oi0-f53.google.com with SMTP id r126so144092080oib.0
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Sep 2016 08:24:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160917143404.GF2290@comcast.net>
References: <CAA3ktqmQ+kGddhuw6gC9Hoct+eayxjZFrDjigffCgmDa09=PBA@mail.gmail.com>
 <CAJCQCtR6bcBjK+Npd1+8KOYFOp5GWUBQ8hxvjwNU7vEaLHH9Hg@mail.gmail.com> <20160917143404.GF2290@comcast.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 17 Sep 2016 09:24:04 -0600
Message-ID: <CAJCQCtTtk0mSnz_g2HXYbOfPV3VL57JP3v4mYVtVC_Fjtj4OWA@mail.gmail.com>
Subject: Re: Size of scrubbed Data
To: Tim Walberg <twalberg@comcast.net>
Cc: Chris Murphy <lists@colorremedies.com>,
        Stefan Malte Schumacher <stefan.m.schumacher@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 17, 2016 at 8:34 AM, Tim Walberg <twalberg@comcast.net> wrote:
> On 09/15/2016 15:18 -0600, Chris Murphy wrote:
>>>      > System, single: total=4.00MiB, used=0.00B
>>>      > Metadata, RAID1: total=10.00GiB, used=8.14GiB
>>>      > GlobalReserve, single: total=512.00MiB, used=0.00B
>>>
>>>      btrfs balance start -mconvert=raid1,soft <mp>
>
>
> Since the single profile data is single, that should probably be
> "-s" instead of "-m"... I.e.
>
>         btrfs balance start -sconvert=raid1,soft <mp>
>
> It may also need "-f", since btrfs balance is a bit more paranoid
> about reprofiling system data.

Originally -m only handled metadata, not system chunks. But these days
-m includes metadata and system chunks, where -s is only system
chunks.

-- 
Chris Murphy
