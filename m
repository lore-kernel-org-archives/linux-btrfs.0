Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:37153 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751078AbdBWNjd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Feb 2017 08:39:33 -0500
Received: by mail-it0-f42.google.com with SMTP id 203so16151794ith.0
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Feb 2017 05:38:08 -0800 (PST)
Subject: Re: Downgrading kernel 4.9 to 4.4 with space_cache=v2 enabled?
To: Christian Theune <ct@flyingcircus.io>
References: <BB064A3C-6F5C-4490-80A6-F42BEFAA945A@flyingcircus.io>
 <029c96aa-9c1e-f12c-8b63-4e4485428c67@gmail.com>
 <71958378-5AB4-4E66-8F54-60215141D1BB@flyingcircus.io>
 <3DCDD3DC-4201-4529-AACA-07A431AB4D6C@flyingcircus.io>
Cc: linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <21390090-717d-2dff-35ec-86bcbab342ae@gmail.com>
Date: Thu, 23 Feb 2017 08:38:02 -0500
MIME-Version: 1.0
In-Reply-To: <3DCDD3DC-4201-4529-AACA-07A431AB4D6C@flyingcircus.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-23 08:19, Christian Theune wrote:
> Hi,
>
> just for future reference if someone finds this thread: there is a bit of output I’m seeing with this crashing kernel (unclear whether related to btrfs or not):
>
>   31 | 02/23/2017 | 09:51:22 | OS Stop/Shutdown #0x4f | Run-time critical stop | Asserted
>   32 | Linux kernel panic: Out of memo
>   33 | Linux kernel panic: ry and no k
>   34 | Linux kernel panic: illable pro
>   35 | Linux kernel panic: cesses...
>
OK, an OOM condition is (probably) not BTRFS related FWIW.  IIRC, there 
were a couple of issues with the OOM killer in 4.9, but I don't remember 
specifics.  To be able to determine anything useful though, you'd need a 
lot more context in the kernel logs than just that.

