Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:41273 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750810AbeBHC7Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Feb 2018 21:59:16 -0500
Received: by mail-ot0-f196.google.com with SMTP id r23so2849795ote.8
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Feb 2018 18:59:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA3ktqnd8_kmiVNq_7L6G0ekiqGzSrfVbzTTc_5aUU9AygE02A@mail.gmail.com>
References: <CAA3ktqnd8_kmiVNq_7L6G0ekiqGzSrfVbzTTc_5aUU9AygE02A@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 7 Feb 2018 19:59:15 -0700
Message-ID: <CAJCQCtT9=Bgnjqdxx8Vi7-k_xF7oQHxsc98VXxuk5D78iY9xoA@mail.gmail.com>
Subject: Re: Crash when unraring large archives on btrfs-filesystem
To: Stefan Malte Schumacher <s.schumacher@netcologne.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 7, 2018 at 12:57 PM, Stefan Malte Schumacher <
s.schumacher@netcologne.de> wrote:

>
>
> Feb 5 21:25:12 mars kernel: [250116.605471] Node 0 active_anon:176kB
> inactive_anon:276kB active_file:14228752kB inactive_file:1631728kB
> unevictable:0kB isolated(anon):0kB isolated(file):4096kB mapped:9316kB
> dirty:1636856kB writeback:248kB shmem:84kB shmem_thp: 0kB
> shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB
> pages_scanned:13631918 all_unreclaimable? no
>

How much RAM on the machine and how much swap available? This looks like a
lot of dirty data has accumulated, and then also there's swapping
happening. Both swap out and swap in.

>4.9.0-5-amd64 #1 SMP Debian 4.9.65-3+deb9u2 (2018-01-04) x86_64 GNU/Linux

I don't know if this bears any relation to the upstream longterm 4.9.65,
but there are definitely many memory and btrfs changes between 4.9.66 and
4.9.80, including a deadlock when writing out freespace cache fix. I don't
know that this is related to your particular problem, there might be more
than one thing going on. But the easiest thing to until someone who
actually knows for sure (a developer with time to respond) is to just
upgrade the kernel and see if the problem goes away.

I did also find a similar problem related to the first problem, unclear if
it's the instigator, page allocation stalls for 12104ms, order:0,
mode:0x24200ca(GFP_HIGHUSER_MOVABLE), happening along with Btrfs. That
thread:

https://lkml.org/lkml/2016/12/13/529


---
Chris Murphy
