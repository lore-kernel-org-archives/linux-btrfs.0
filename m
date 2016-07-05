Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:33187 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbcGEXTr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jul 2016 19:19:47 -0400
Received: by mail-oi0-f50.google.com with SMTP id u201so249964393oie.0
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jul 2016 16:19:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b9647ec5-fe9b-4bfe-97d1-329f47dbf7b0@gmail.com>
References: <cc4fd464-271c-6b32-263c-ae91c19b8712@gmail.com>
 <CAJCQCtQoCtbt5NrggHPp+WrwUKbJ0nah4s6nJ0mPnKsGQ5i63Q@mail.gmail.com>
 <95f58623-95a4-b5d2-fa3a-bfb957840a31@gmail.com> <CAJCQCtSczHoBYyKB1DTyqGngdvC+BHtnXeZiG=1QHWkAWFO6EA@mail.gmail.com>
 <dc944146-50ce-b2fd-189c-a2c9f5a957c3@gmail.com> <CAJCQCtTPXY7=9vi9Ai2VrCEHzsEj_J0gurAVH5JGLJYmKmUpPw@mail.gmail.com>
 <577B2E1D.5070808@gmail.com> <CAJCQCtSW+3eA-amrGgQAds1F8sYPDPgTB9x49RjWnaq=vSePgw@mail.gmail.com>
 <b9647ec5-fe9b-4bfe-97d1-329f47dbf7b0@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 5 Jul 2016 17:19:46 -0600
Message-ID: <CAJCQCtRPhn0i0MkPn1QFr0wqovwQkuEdZ=eWtRZ0QR3O5z5T+w@mail.gmail.com>
Subject: Re: Unable to mount degraded RAID5
To: =?UTF-8?B?VG9tw6HFoSBIcmRpbmE=?= <thomas.rkh@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 5, 2016 at 12:40 PM, Tomáš Hrdina <thomas.rkh@gmail.com> wrote:
> I don't know, if it would be good idea, but my disk, which disconnected
> is connected again. Maybe it could help in getting data to the right
> state, so other two disk could be mounted alone. But don't know, if it
> would stay connected for some work. Or if it would make things even worst.

I'd stick to the read only commands:

btrfs check
btrfs-debug-tree -d
btrfs-find-root

Also, I'm surprised I didn't ask (seeing as I'm on a rampage about
this these days)


smartctl -l scterc /dev/sdX   ## for each drive
smartcl -a /dev/sdX  ## for each drive
cat /sys/block/sdX/device/timeout   ## for each drive

We should find out if there are bad sectors, and if they can even be
properly corrected by Btrfs self healing mechanism. The normal default
on Linux prevents this with consumer drives.



-- 
Chris Murphy
