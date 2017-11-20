Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:35257 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751087AbdKTCab (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Nov 2017 21:30:31 -0500
Received: by mail-ot0-f181.google.com with SMTP id b17so6492876oth.2
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Nov 2017 18:30:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSZmRmeFUGPSiRLV4TCOjbD6uTqpoEqKD24Li8w1iO7qQ@mail.gmail.com>
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <d784d9a6-bc0e-e4c3-6633-043081ea800b@gmx.com> <CAJCQCtSZmRmeFUGPSiRLV4TCOjbD6uTqpoEqKD24Li8w1iO7qQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 19 Nov 2017 19:30:30 -0700
Message-ID: <CAJCQCtRXdOvP7p11ZS9J4G-M1hiZF25e644-T+hPToA2Y8VkrA@mail.gmail.com>
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
To: Chris Murphy <lists@colorremedies.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 19, 2017 at 7:24 PM, Chris Murphy <lists@colorremedies.com> wrote:


> $ sudo fstrim -v /
> /: 39 GiB (41841328128 bytes) trimmed

> And trim again:
>
> /: 39 GiB (41841328128 bytes) trimmed

Cute. The balance command claimed it balanced a chunk but it didn't.
btrfs-debug -b says that same 8% chunk is present...

block group offset   175275769856 len 1073741824 used   89206784
chunk_objectid 256 flags 1 usage 0.08

Fine. I'll do a -duage instead.

$ sudo btrfs balance start -dusage=11 /
Done, had to relocate 2 out of 32 chunks
$ sudo fstrim -v /
/: 40 GiB (42915069952 bytes) trimmed
$ sudo btrfs balance start -dusage=21 /
Done, had to relocate 2 out of 31 chunks
$ sudo fstrim -v /
/: 41 GiB (43988811776 bytes) trimmed


OK so a different bug is that it's claiming to balance two chunks but
it's really only balancing one. That same 8% used block group was not
rewritten, it's at the same address, so for whatever reason that tiny
one is pinned.



-- 
Chris Murphy
