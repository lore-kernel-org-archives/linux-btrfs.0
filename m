Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35261 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933166AbcIZVpW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Sep 2016 17:45:22 -0400
Received: by mail-oi0-f50.google.com with SMTP id w11so223526564oia.2
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Sep 2016 14:45:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160926205639.GB4624@coach.home>
References: <CA+Fk0XLfXVaMVTKyovwedBAAAMhpoiuF2b1yuAPbxsOQrkR3=A@mail.gmail.com>
 <CA+Fk0XKZbf1wamCuT7AZPNVOTmapyr-e9ACnjJ0kqzav561ysA@mail.gmail.com> <20160926205639.GB4624@coach.home>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 26 Sep 2016 15:45:20 -0600
Message-ID: <CAJCQCtS_94x5goiiB=knzX06=qLCgMOu9tH=zHSX9ZtoJVTw9Q@mail.gmail.com>
Subject: Re: Fwd: OS X Time Machine and BTRFS
To: Sean Greenslade <sean@seangreenslade.com>
Cc: Ruben Salzgeber <ruben.salzgeber@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 26, 2016 at 2:56 PM, Sean Greenslade
<sean@seangreenslade.com> wrote:
> On Mon, Sep 26, 2016 at 10:15:11PM +0200, Ruben Salzgeber wrote:
>> Hi everyone
>>
>> I'm reaching out to you because I experience unusually slow read and
>> write speeds on my Arch Linux server in combination with OS X time
>> machine. My setup is consists of an Core i3 6300, 16GB Ram, 128GB SSD
>> for the OS and a 8 drive RAID5 BTRFS volume as archive. The latest
>> version of Avahi, Netatalk and BTRFS-Progs are installed. On a wired
>> connection I reach 120MB/s for normal filetransfers from OS X to the
>> Server. When using Time Machine I measure peak network trafic around
>> 1-2MB/s and long durations of almost no trafic. Could this be in any
>> relation to BTRFS? Is there a special configuration necessary for
>> folders containing the Time Machine sparsebundle file?
>
> Have you done any inspection with tools like [h]top, iotop, etc.?
> Identifying the bottleneck is usually pretty straightforward with those,
> and it's nice to try and dismiss things like cpu bottlenecks before
> going to more advanced diagnostics.

Good idea.

Another possibly useful one would be using filefrag to get some idea
how badly fragmented the bands (individual files) in the bundle are
getting.

$ filefrag backup.sparsebundle/bands/*

This is likely going to be excessively long. And example output


backup.sparsebundle/bands/0: 43 extents found
backup.sparsebundle/bands/1: 1 extent found
backup.sparsebundle/bands/10: 212 extents found
backup.sparsebundle/bands/11: 1 extent found

Maybe sort -k can sort by the number of extents, and then use head to
just show the top 50 offenders.


-- 
Chris Murphy
