Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:34523 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753547AbcI0Tnx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Sep 2016 15:43:53 -0400
Received: by mail-oi0-f51.google.com with SMTP id a62so27924656oib.1
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Sep 2016 12:43:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+Fk0X+qCjYA9VDdUh=rrxj6xj98cZqcWe83zt+M5XjV1Xrh-Q@mail.gmail.com>
References: <CA+Fk0XLfXVaMVTKyovwedBAAAMhpoiuF2b1yuAPbxsOQrkR3=A@mail.gmail.com>
 <CA+Fk0XKZbf1wamCuT7AZPNVOTmapyr-e9ACnjJ0kqzav561ysA@mail.gmail.com>
 <20160926205639.GB4624@coach.home> <CAJCQCtS_94x5goiiB=knzX06=qLCgMOu9tH=zHSX9ZtoJVTw9Q@mail.gmail.com>
 <CA+Fk0XLGd6ZySLL7RwAeoxK249m+RWAADLJmdncGbaW90L4sPA@mail.gmail.com>
 <CAJCQCtT=SXBBEEFUxq3Lk_iyL8xHtbe9_v+VqRBVupaQGuVD3Q@mail.gmail.com> <CA+Fk0X+qCjYA9VDdUh=rrxj6xj98cZqcWe83zt+M5XjV1Xrh-Q@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 27 Sep 2016 13:43:51 -0600
Message-ID: <CAJCQCtSVVsXqfszpC9-ODxG05Hbm+d+fcn59w4zdKTVk=Ypm0A@mail.gmail.com>
Subject: Re: Fwd: OS X Time Machine and BTRFS
To: Ruben Salzgeber <ruben.salzgeber@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

readding btrfs list

On Tue, Sep 27, 2016 at 12:05 PM, Ruben Salzgeber
<ruben.salzgeber@gmail.com> wrote:
> Hi Chris
>
> Again thanks for your help here. I've tried to see how badly the files
> in the sparsbundle are fragmented, unfortunatlly I wasn't able to run
> filefrag (FIBMAP unsupported).

What command did you use? It will not work on directories, it only
works on files, or you will get that error message.

>Iotop was showing lots of processes accessing the disks:

Use -o option, it will show only processes producing I/O.



> I'll copy the sparsbundle to the macbook, set chattr +C on the
> timemachine folder and copy all back. This should deactivate CoW on
> all subfolders and files.

Yeah just realize it also disables compression and checksumming as well.



-- 
Chris Murphy
