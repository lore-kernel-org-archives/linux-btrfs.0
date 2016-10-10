Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:34294 "EHLO
        mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbcJJCZV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Oct 2016 22:25:21 -0400
Received: by mail-lf0-f44.google.com with SMTP id b81so100680022lfe.1
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Oct 2016 19:25:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN05THSUtzUTXxKuQ7+fr7SDsbd0kGn8OGsXmkErS79Rh1ufLQ@mail.gmail.com>
References: <CAB9fVVH6S-Y0Li=6xyw2P23CEPwVRA6hRbjJNi+_3etHnqMh1w@mail.gmail.com>
 <CAKinxcWNP_tf77RkVAjE8C2Nd6LYDsAT2VJNM_m6QYmO7nVE9g@mail.gmail.com> <CAN05THSUtzUTXxKuQ7+fr7SDsbd0kGn8OGsXmkErS79Rh1ufLQ@mail.gmail.com>
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
Date: Mon, 10 Oct 2016 03:25:19 +0100
Message-ID: <CAKinxcUpjf1fD5__gd6XgmcyByFqz3JNgnk7z9iCAui+KWj2nA@mail.gmail.com>
Subject: Re: raid levels and NAS drives
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: Charles Zeitler <cfzeitler@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10 October 2016 at 02:01, ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
> (without html this time.)
>
> Nas drives are more expensive but also more durable than the normal consumer
> drives, but not as durable as enterprise drives.
> They are meant for near continous use, compared to consumer/backup drives
> that are meant for only occasional use and meant to spend the majority of
> time spinned down.
>
>
> They fall in-between consumer and enterprise gear.
>

Again, you read a marketing flyer ...

Historically enterprise drives did equal to a drive with SCSI, after
that it started to equal to a drive with more exotic interfaces like
SAS or FATA ... nowadays this means more in line "high [seak]
performance, for which you pay extra extra extra buck" (10k, 15k
arrays of 10 disks with databases on it that are serving plenty of
people ?).
Currently, customer = low end drive where you will not pay twice the
price for 10% performance increase.

There is nothing there about reliability !!!
Now every [sane] storage engineer will chose a "customer" 5.4k drives
for a cold storage / slow IO storage. In high demand, very random seek
patterns everybody will go for extreme fast disk that will die in 12
months, because cost * effort or replacing a failed disk is still less
than assembling a like array from 7.2k disk (extra controller, extra
bays, extra power, extra everything !).

So:
1.
Stop reading a marketing material that is designed to suck money out
of you pocket. Read technical datasheet.
Stop reading a paid for articles from so called "specialists", my
company pays those people to put in articles that I write to sound
more technical so I can tell you how much "horse" those are.

2.
hdd:
faster rpm = better seek + better sequential read write
slower rpm = survives longer + takes less power + better $ per GB

3.
what you need to use it for:
a remote nas box ? a single 5.1k hdd will saturate your gigabit lan, 7
will saturate your SFP+ - go for best $ per GB
local storage ? 4 x 7.1k hdd in raid10 and you're talking a good
performance ! putting more disks in and you can drop down to 5.1k
a high demand database with thousands of people punching milions of
queries a second ? 15k as many as you can!

4.
For time being on btrfs give raid 5 & 6 a wide berth for time being
... unless you back up your data [very] regularly than, have fun :)
