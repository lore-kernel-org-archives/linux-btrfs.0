Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:42646 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaESKl2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 06:41:28 -0400
Received: by mail-qc0-f179.google.com with SMTP id x3so8559326qcv.24
        for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 03:41:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAF_AmaOyqgxn8rPs4rKugUz9ZkGoc4mt+Q8Q-nLJF_hPxUufZw@mail.gmail.com>
References: <CAF_AmaOyqgxn8rPs4rKugUz9ZkGoc4mt+Q8Q-nLJF_hPxUufZw@mail.gmail.com>
Date: Mon, 19 May 2014 17:41:26 +0700
Message-ID: <CAG1y0sf9tW+151DMvihWgRFnbUs3Q=uKyL3W4_heU7rYBQz0=w@mail.gmail.com>
Subject: Re: Convert btrfs software code to ASIC
From: "Fajar A. Nugraha" <list@fajar.net>
To: Le Nguyen Tran <lntran.de@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 19, 2014 at 3:40 PM, Le Nguyen Tran <lntran.de@gmail.com> wrote:
> Hi,
>
> I am Nguyen. I am not a software development engineer but an IC (chip)
> development engineer. I have a plan to develop an IC controller for
> Network Attached Storage (NAS). The main idea is converting software
> code into hardware implementation. Because the chip is customized for
> NAS, its performance is high, and its cost is lower than using micro
> processor like Atom or Xeon (for servers).
>
> I plan to use btrfs as the file system specification for my NAS. The
> main point is that I need to understand the btrfs sofware code in
> order to covert them into hardware implementation. I am wandering if
> any of you can help me. If we can make the chip in a good shape, we
> can start up a company and have our own business.

I'm not sure if that's a good idea.

AFAIK btrfs depends a lot on other linux subsystems (e.g. vfs, block,
etc). Rather than converting/reimplementing everything, if your aim is
lower cost, you might have easier time using something like a mediatek
SOC (the ones used on smartphones) and run a custom-built linux with
btrfs support on it.

For documentation,
https://btrfs.wiki.kernel.org/index.php/Main_Page#Developer_documentation
is probably the best place to start

-- 
Fajar
