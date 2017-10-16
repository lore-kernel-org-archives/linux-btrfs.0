Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:54881 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752312AbdJPLyE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 07:54:04 -0400
Received: by mail-it0-f52.google.com with SMTP id 72so805938itk.3
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 04:54:03 -0700 (PDT)
Subject: Re: Is it safe to use btrfs on top of different types of devices?
To: =?UTF-8?B?Wm9sdMOhbiBJdsOhbmZp?= <zoltan1980@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAGtRCvfkDnUBxqWNgEOXz+Gam0dPubatROQgqxE2D_uCAZhihQ@mail.gmail.com>
 <CAGtRCvfqUP_79cKC_Rzs6MD_uZiVbjt9QW0_BeOpACN_c3ev5w@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d27ec863-d4fb-3ffd-78a4-c12789054bd9@gmail.com>
Date: Mon, 16 Oct 2017 07:53:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAGtRCvfqUP_79cKC_Rzs6MD_uZiVbjt9QW0_BeOpACN_c3ev5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-15 04:30, Zoltán Ivánfi wrote:
> Hi,
> 
> Thanks for the replies.
> 
> As you both pointed out, I shouldn't have described the issue having
> to do with hotplugging. I got confused by this use-case being somewhat
> emphasized in the description of the bug I linked to. As for the
> question of why I think that I got bitten by that bug in particular:
> It matches my experiences as I can recall them (used RAID on SATA+USB,
> got bio too big device error messages, data got corrupted).
The actual issue isn't exactly just USB, but externally connected 
hot-pluggable devices on unreliable buses, which mostly consists of USB, 
but also includes things like IEEE 1394 and eSATA (although eSATA isn't 
always an issue, it depends on the cabling and the physical connections).
> 
> You assumed correctly that what I really wanted to ask about was btrfs
> on SATA+USB, thanks for answering that questions as well. Based on
> your replies I feel assured that btrfs should not be affected by this
> particular issue due to operating on the filesystem level and not on
> the block device level; but USB connectivity issues can still lead to
> problems.
Indeed, and I would in fact personally recommend against using USB for 
any kind of always connected persistent storage if at all possible. 
Even if the USB controller, storage controller, and cabling are 100% 
reliable, you still run a pretty significant risk of issues just from 
bumping the system because USB-A and USB-C connectors do not provide 
particularly solid connections from a mechanical perspective.
> 
> Do these USB connectivity issues lead to data corruption? Naturally
> for raid0 they will, but for raid1 I suppose they shouldn't as one
> copy of the data remains intact.
For raid1, they _normally_ won't cause data corruption with BTRFS, 
provided you ensure proper maintenance of the filesystem.  They will 
however cause performance issues, even if you're using USB 3.0 or 3.1, 
as you will end up re-writing bits and pieces of the filesystem 
regularly (because you will need to scrub regularly to avoid data 
corruption).

