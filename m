Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:41343 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752028AbdKTTW5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 14:22:57 -0500
Received: by mail-oi0-f52.google.com with SMTP id h81so6889798oib.8
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2017 11:22:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1511196626.1657.29.camel@gmail.com>
References: <1511196626.1657.29.camel@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 20 Nov 2017 12:22:56 -0700
Message-ID: <CAJCQCtQhkQUOmt-NJVrp3nTRNTSTXL9=d9p66GyUUK-Gh8FuUA@mail.gmail.com>
Subject: Re: test btrfs scrubbing/get system's total capacity
To: ST <smntov@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 20, 2017 at 9:50 AM, ST <smntov@gmail.com> wrote:
> Hello,
>
> 1. is there a tool that I can use to test btrfs scrubbing? Namely I need
> to "damage" a file, i.e. change it without changing its meta
> information, so I can see how scrubbing performs... Is there something
> like this?


btrfs-corrupt-block.c

It's part of btrfs-progs but many distributions do not include it by
default, but is easy to build it stand alone.



> 2. I want to use Ansible to set btrfs quota on a /home subvolume as say
> 0.8*TotalCapacityOfRoot and then assign to it individual users'
> subvolumes with certain (smaller) quatos.
> 2.1 Is it OK to rely on ansible_facts? Does it has correct information
> about btrfs-based "/" total capacity?
> 2.2 If not, is there a raw command to get TotalCapacityOfRoot in -TB so
> I can set it? Is there something like btrfs filesystem usage / -t
> --device_size? to get only the total Device Size information?

No idea how ansible is manipulating quotas on Btrfs.


-- 
Chris Murphy
