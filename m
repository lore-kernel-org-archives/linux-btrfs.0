Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:38338 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753165AbdHQU6w (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 16:58:52 -0400
Received: by mail-vk0-f49.google.com with SMTP id g189so26460476vke.5
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Aug 2017 13:58:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADJPUQ_va-S7BjG6f0a+Wu8fx6jnWjG8kMDVWQ=bj8W443MQmg@mail.gmail.com>
References: <CADJPUQ9awnz30XzGZLGQAUhAqeH5ek6stDN5N5JTzc3dGtdiug@mail.gmail.com>
 <CAJCQCtQPMNnC4wHfubV1aHstdUnZXQoRMuss85=_ZAv51qFpSw@mail.gmail.com>
 <pan$b0a14$8f1e0555$f8f395d6$3ede559@cox.net> <CAJCQCtQjh07f6EYGVUPpWL7aXChVSXdok1DOg-+ZwOSqNMq_7Q@mail.gmail.com>
 <CADJPUQ_va-S7BjG6f0a+Wu8fx6jnWjG8kMDVWQ=bj8W443MQmg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 17 Aug 2017 14:58:50 -0600
Message-ID: <CAJCQCtTudHOYHwNemGaGWHWD_Q0rc+_06gx9FjZZ6VNuy+n9fw@mail.gmail.com>
Subject: Re: qcow2 images make scrub believe the filesystem is corrupted.
To: Paulo Dias <paulo.miguel.dias@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First post

235 POR_Recovery_Count      0x0012   099   099   000    Old_age
Always       -       54

Recent post

235 POR_Recovery_Count      -O--C-   099   099   000    -    55

So you've had one more of these POR events.

http://www.samsung.com/semiconductor/minisite/ssd/downloads/document/Samsung_SSD_White_Paper.pdf
ID # 235 Power Recovery Count
A count of the number of sudden power off cases. If there is a sudden
power off, the firmware must recover all of the
mapping and user data during the next power on. This is a count of the
number of times this has happened.

I wonder if there is a correlation with these POR events and
corruption? And I wonder what's causing the POR event? Is this machine
crashing/hanging and you're doing a force power off? Or is it suspend
to RAM or suspend to disk? And if you stop doing those things, does
the corruption still happen?


--------------
Chris Murphy
