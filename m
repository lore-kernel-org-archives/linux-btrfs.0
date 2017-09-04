Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:33439 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751321AbdIDKXx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Sep 2017 06:23:53 -0400
Received: by mail-qk0-f178.google.com with SMTP id o129so281998qkd.0
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Sep 2017 03:23:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <710ec5d1-adbf-4ce5-50a5-8b8266ccb672@rqc.ru>
References: <710ec5d1-adbf-4ce5-50a5-8b8266ccb672@rqc.ru>
From: Henk Slager <eye1tm@gmail.com>
Date: Mon, 4 Sep 2017 12:23:51 +0200
Message-ID: <CAPmG0jaZRAQM_EHzEp96gC1TuaZHnqHcZ2VdiAz=ecJL5Yzs7A@mail.gmail.com>
Subject: Re: Is autodefrag recommended?
To: Marat Khalili <mkh@rqc.ru>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 4, 2017 at 11:31 AM, Marat Khalili <mkh@rqc.ru> wrote:
> Hello list,
> good time of the day,
>
> More than once I see mentioned in this list that autodefrag option solves
> problems with no apparent drawbacks, but it's not the default. Can you
> recommend to just switch it on indiscriminately on all installations?

Of course it has drawbacks, it depends on the use-cases on the
filesystem what your trade-off is. If the filesystem is created log
time ago and has 4k leafes the on HDD over time you get exessive
fragmentation and scattered 4k blocks all over the disk for a file
with a lot random writes (standard CoW for whole fs), like a 50G vm
image, easily 500k extents.

With autodefrag on from the beginning of fs creation, most
extent/blocksizes will be 128k or 256k in that order and then amount
of extents for the same vm image is roughly 50k. So statistically, the
average blocksize is not 4k but 128k, which is at least less free
space fragmentation (I use SSD caching of HDD otherwise also those 50k
extents result in totally unacceptable performance). But also for
newer standard 16k leafes, it is more or less the same story.

The drawbacks for me are:
1. I use nightly differential snapshotting for backup/replication over
a metered mobile network link, and this autodefrag causes a certain
amount of unnessccesaty fake content difference due to send|receive
based on CoW. But the amount of extra datavolume it causes is still
acceptable. If I would let the guest OS defragment its fs inside the
vm image for example, then the datavolume per day becomes
unacceptable.
2. It causes extra HDD activity, so noise, powerconsumption etc, which
might be unacceptable for some use-cases.

> I'm currently on kernel 4.4, can switch to 4.10 if necessary (it's Ubuntu
> that gives us this strange choice, no idea why it's not 4.9). Only spinning
> rust here, no SSDs.
Kernel 4.4 is new enough w.r.t. autodefrag, but if you can switch to
4.8 or newer, I would do so.
