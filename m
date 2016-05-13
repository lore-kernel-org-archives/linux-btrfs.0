Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34898 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbcEMRqg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 13:46:36 -0400
Received: by mail-oi0-f67.google.com with SMTP id w198so18708212oiw.2
        for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 10:46:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1463114957.3636.140.camel@clone1.com>
References: <CACTfMoQmco=yBP+e8tn0MoTVZsMauw0_=N1yc42NVNM9Krqv7A@mail.gmail.com>
	<97b8a0bd-3707-c7d6-4138-c8fe81937b72@gmail.com>
	<1463075341.3636.56.camel@clone1.com>
	<CAJCQCtSSbv5dAC-uBN9RnYKKRMtr04KmLZVzhvAh7=Xq3ej7dQ@mail.gmail.com>
	<1463114957.3636.140.camel@clone1.com>
Date: Fri, 13 May 2016 11:46:35 -0600
Message-ID: <CAJCQCtSNwpaPs6jWFxzoHdUFJUyUZFjX6vocYf7RCWc=f_n5Hg@mail.gmail.com>
Subject: Re: BTRFS Data at Rest File Corruption
From: Chris Murphy <lists@colorremedies.com>
To: "Richard A. Lochner" <lochner@clone1.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 12, 2016 at 10:49 PM, Richard A. Lochner <lochner@clone1.com> wrote:

> My apologies, they were from different boots.  After the dd, I get
> these:
>
> [109479.550836] BTRFS warning (device sdb1): csum failed ino 1437377
> off 75754369024 csum 1689728329 expected csum 2165338402
> [109479.596626] BTRFS warning (device sdb1): csum failed ino 1437377
> off 75754369024 csum 1689728329 expected csum 2165338402
> [109479.601969] BTRFS warning (device sdb1): csum failed ino 1437377
> off 75754369024 csum 1689728329 expected csum 2165338402
> [109479.602189] BTRFS warning (device sdb1): csum failed ino 1437377
> off 75754369024 csum 1689728329 expected csum 2165338402
> [109479.602323] BTRFS warning (device sdb1): csum failed ino 1437377
> off 75754369024 csum 1689728329 expected csum 2165338402

That's it? Only errors from sdb1? And this time no attempt to fix it?

Normally when there is failure to match data checksums stored in
metadata to the newly computed data checksums as the blocks are read
there's an attempt to read the mismatching blocks from another stripe.
I don't see that this is being attempted.


>>
>> Also what do you get for these for each device:
>>
>> smartctl scterc -l /dev/sdX
>> cat /sys/block/sdX/device/timeout
>>
> # smartctl -l scterc  /dev/sdb
> sartctl 6.4 2015-06-04 r4109 [x86_64-linux-4.4.8-300.fc23.x86_64]
> (local build)
> Copyright (C) 2002-15, Bruce Allen, Christian Franke, www.smartmontools
> .org
>
> SCT Error Recovery Control:
>            Read:     70 (7.0 seconds)
>           Write:     70 (7.0 seconds)
>
> # smartctl -l scterc  /dev/sdc
> smartctl 6.4 2015-06-04 r4109 [x86_64-linux-4.4.8-300.fc23.x86_64]
> (local build)
> Copyright (C) 2002-15, Bruce Allen, Christian Franke, www.smartmontools
> .org
>
> SCT Error Recovery Control:
>            Read:     70 (7.0 seconds)
>           Write:     70 (7.0 seconds)
>
> # cat /sys/block/sdb/device/timeout
> 30
> # cat /sys/block/sdc/device/timeout
> 30
>>

That's appropriate. So at least any failures have a chance of being
fixed before the command timer does a reset on the bus.


-- 
Chris Murphy
