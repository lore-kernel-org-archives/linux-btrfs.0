Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12522 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752334AbdGCCzh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Jul 2017 22:55:37 -0400
Date: Mon, 3 Jul 2017 10:55:28 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Henk Slager <eye1tm@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 2/4] btrfs-progs: lowmem check: Fix false alert about
 referencer count mismatch
Message-ID: <20170703025528.GA9646@lufq.5F>
References: <20170626103727.8945-1-lufq.fnst@cn.fujitsu.com>
 <20170626103727.8945-2-lufq.fnst@cn.fujitsu.com>
 <CAPmG0jaR89wz3GcBNxKN9-BF=QogiZo8uPi0VK2iVD8cN4Smpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAPmG0jaR89wz3GcBNxKN9-BF=QogiZo8uPi0VK2iVD8cN4Smpg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 02, 2017 at 03:50:31PM +0200, Henk Slager wrote:
>
>With this patch applied to v4.11, I ran:
># btrfs check -p --mode lowmem /dev/mapper/smr
>
>no 'referencer count mismatch' anymore, but likely due to other hidden
>corruption, the check took more time than I had planned, so after 5
>days, I cancelled it.
>
>As a summary, both kernel and lowmem check mention the same issue as
>it looks like; for the lowmem check it is this, (repeating):
>[...]
>parent transid verify failed on 6350669414400 wanted 24678 found 24184
>parent transid verify failed on 6350645837824 wanted 24678 found 23277
>Ignoring transid failure
>leaf parent key incorrect 6350645837824
>ERROR: extent[6349151535104 16384] backref lost (owner: 2, level: 0)
>ERROR: check leaf failed root 2 bytenr 6349151535104 level 0, force
>continue check
>parent transid verify failed on 6350645837824 wanted 24678 found 23277
>Ignoring transid failure
>leaf parent key incorrect 6350645837824
>ERROR: extent[6349150486528 16384] backref lost (owner: 2, level: 0)
>ERROR: check leaf failed root 2 bytenr 6349150486528 level 0, force
>continue check

This looks like the extent tree has some problems. I would appreciate it
if you could run the following command to dump the extent tree for me?

# btrfs-debug-tree -t 2 /dev/mapper/smr | grep -C 10 -e 6349151535104 -e 6349150486528

>My plan is now to image the whole 8TB fs to extra/new storage hardware
>with dd and then see if I can get the copy fixed. But it might take a
>year before I do so (it is not critical w.r.t. data-loss, it's cold
>storage, multi-year btrfs features test).
>
>

-- 
Thanks,
Lu


