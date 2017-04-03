Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:35000 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752141AbdDCMXa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Apr 2017 08:23:30 -0400
Received: by mail-it0-f44.google.com with SMTP id y18so45104854itc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Apr 2017 05:23:30 -0700 (PDT)
Subject: Re: mix ssd and hdd in single volume
To: matianfu@gmail.com, linux-btrfs@vger.kernel.org
References: <CAEgruXvAEBfpQaAxCi42Vq6v8w7v1dqthpn9TpE3FDDHoTWRcw@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d35eb3bd-02f7-c6be-e3de-2ebbb911a378@gmail.com>
Date: Mon, 3 Apr 2017 08:23:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAEgruXvAEBfpQaAxCi42Vq6v8w7v1dqthpn9TpE3FDDHoTWRcw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-01 02:06, UGlee wrote:
> We are working on a small NAS server for home user. The product is
> equipped with a small fast SSD (around 60-120GB) and a large HDD (2T
> to 4T).
>
> We have two choices:
>
> 1. using bcache to accelerate io operation
> 2. combining SSD and HDD into a single btrfs volume.
>
> Bcache is certainly designed for our purpose. But bcache requires
> complex configuration and can only start from clean disk. Also in our
> test in Ubuntu 16.04, data inconsistence was observed at least once,
> resulting total HDD data lost.
>
> So we wonder if simply putting SSD and HDD into a single btrfs volume,
> in whatever mode, the general read operation (mostly readdir and
> getxattr) will also be significantly faster than a single HDD without
> SSD.

Have you tried dm-cache?  The general idea is similar to bcache, but 
it's been much more reliable in my experience, and it's possible to add 
it to an existing device without any need for reprovisioning  (although 
the existing device can't have any pending writes, otherwise you might 
get some data corruption).

Additionally, given what you've said, write-through mode should cover 
what you need in terms of performance, and may be more reliable on 
bcache than writeback mode.

