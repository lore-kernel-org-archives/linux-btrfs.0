Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33.italiaonline.it ([212.48.25.161]:54896 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750765AbcBKOOQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 09:14:16 -0500
Reply-To: kreijack@inwind.it
Subject: Re: BTRFS RAM requirements, RAID 6 stability/write holes and
 expansion questions
References: <CAKr9ZMFwxZ01gw7SAyFReOfXFb=hVzUXNgYoGcUc2xzLuo+9mg@mail.gmail.com>
 <CAJCQCtQCadspcPie_f6nv=MvC=2=PxxpLbLqtkD3_hBjkBs-zw@mail.gmail.com>
 <56BB41E3.8050906@gmail.com>
 <CAJCQCtS8wDV93Eyb6pDaCJBY7_v8misn1p9e=4KVGdK6=CKL_A@mail.gmail.com>
 <56BB9698.5020203@gmail.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Cc: Mackenzie Meyer <snackmasterx@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <56BC9734.403@inwind.it>
Date: Thu, 11 Feb 2016 15:14:12 +0100
MIME-Version: 1.0
In-Reply-To: <56BB9698.5020203@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-10 20:59, Austin S. Hemmelgarn wrote:
[...]
> Again, a torn write to the metadata referencing the block (stripe in
> this case I believe) will result in loosing anything written by the
> update to the stripe. 

I think that the order matters: first the data block are written (in a new location, so the old data are untouched), then the metadata, from the leafs up to the upper node (again in a new location), then the superblock which references to the upper node of the tree(s).

If you interrupt the writes in any time, the filesystem can survive because the old superblock-metadata-tree and data-block are still valid until the last pieces (the new superblock) is written.

And if this last step fails, the checksum shows that the super-block is invalid and the old one is taken in consideration.


> There is no way that _any_ system can avoid
> this issue without having the ability to truly atomically write out
> the entire metadata tree after the block (stripe) update.  

It is not needed to atomically write the (meta)data in a COW filesystem, because the new data don't owerwrite the old one. The only thing that is needed is that before the last piece is written all the previous (mata)data are already written.

For not COW filesystem a journal is required to avoid this kind of problem.

> Doing so
> would require a degree of tight hardware level integration that's
> functionally impossible for any general purpose system (in essence,
> the filesystem would have to be implemented in the hardware, not
> software).

To solve the raid-write-hole problem, a checksum system (of data and metadata) is sufficient. However to protect with checksum the data, it seems that a COW filesystem is required.

The only critical thing, is that the hardware has to not lie about the fact that the data reached the platter. Most of the problem reported in the ML are related to external disk used in USB enclousure, which most of the time lie about this aspect.

GB



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
