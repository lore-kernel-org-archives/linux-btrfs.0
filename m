Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:33953 "EHLO
        cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750990AbdEHRBJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 May 2017 13:01:09 -0400
Date: Mon, 8 May 2017 13:01:07 -0400
From: Sean Greenslade <sean@seangreenslade.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Sanidhya Solanki <lkml.page@gmail.com>,
        Alexandru Guzu <alexguzu@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: BTRFS converted from EXT4 becomes read-only after reboot
Message-ID: <20170508170106.GA1699@fox>
References: <CAPktuGs4cJW6YBJ3GuGaXRLkud7VKvdH2P1U0hT+3AtDmHL5Yw@mail.gmail.com>
 <706980A2-DC62-45AA-B169-8A9D6E474D87@seangreenslade.com>
 <CAPktuGuyUBQF1=LKvmpZiS7vMSsu=LCfqA9PFa7ObK9ih=LoXg@mail.gmail.com>
 <20170508112617.7e33bed6@ad>
 <A9D2210F-3DC4-45BC-AA07-D4527279D40E@seangreenslade.com>
 <4aedf23f-2bc4-ce18-d5b0-13fa51496feb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4aedf23f-2bc4-ce18-d5b0-13fa51496feb@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 08, 2017 at 12:41:11PM -0400, Austin S. Hemmelgarn wrote:
> Send/receive is not likely to transfer the problem unless it has something
> to do with how things are reflinked.  Receive operates by recreating the
> sent subvolume from userspace using regular commands and the clone ioctls,
> so it won't replicate any low-level structural issues in the filesystem
> unless they directly involve the way extents are being shared (or are a side
> effect of that).  On top of that, if there is an issue on the sending side,
> send itself will probably not send that data, so it's actually only
> marginally more dangerous than using something like rsync to copy the data.

True, but my goal was to eliminate as many btrfs variables as I could.
To answer the original question, I used rsync to copy the data and
attributes (something like rsync -aHXp --numeric-ids) from a live CD to
an external hard drive (formatted ext4), then ran mkfs.btrfs on the
original partition, then re-ran the rsync in the opposite direction. It
worked quite well for me, and the problem hasn't resurfaced.

--Sean

