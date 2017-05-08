Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:33821 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751876AbdEHSWy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 May 2017 14:22:54 -0400
Received: by mail-pg0-f47.google.com with SMTP id u28so27192682pgn.1
        for <linux-btrfs@vger.kernel.org>; Mon, 08 May 2017 11:22:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170508170106.GA1699@fox>
References: <CAPktuGs4cJW6YBJ3GuGaXRLkud7VKvdH2P1U0hT+3AtDmHL5Yw@mail.gmail.com>
 <706980A2-DC62-45AA-B169-8A9D6E474D87@seangreenslade.com> <CAPktuGuyUBQF1=LKvmpZiS7vMSsu=LCfqA9PFa7ObK9ih=LoXg@mail.gmail.com>
 <20170508112617.7e33bed6@ad> <A9D2210F-3DC4-45BC-AA07-D4527279D40E@seangreenslade.com>
 <4aedf23f-2bc4-ce18-d5b0-13fa51496feb@gmail.com> <20170508170106.GA1699@fox>
From: Alexandru Guzu <alexguzu@gmail.com>
Date: Mon, 8 May 2017 14:22:52 -0400
Message-ID: <CAPktuGtS-K9ZvXf_3G5UkS2Xrj-cWx+DaqrFDOu-Hi9r1HqUKw@mail.gmail.com>
Subject: Re: BTRFS converted from EXT4 becomes read-only after reboot
To: Sean Greenslade <sean@seangreenslade.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Sanidhya Solanki <lkml.page@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Getting a bit off-topic here, but were you able to boot from that fs
with grub after a simple rsync?

On Mon, May 8, 2017 at 1:01 PM, Sean Greenslade <sean@seangreenslade.com> wrote:
> On Mon, May 08, 2017 at 12:41:11PM -0400, Austin S. Hemmelgarn wrote:
>> Send/receive is not likely to transfer the problem unless it has something
>> to do with how things are reflinked.  Receive operates by recreating the
>> sent subvolume from userspace using regular commands and the clone ioctls,
>> so it won't replicate any low-level structural issues in the filesystem
>> unless they directly involve the way extents are being shared (or are a side
>> effect of that).  On top of that, if there is an issue on the sending side,
>> send itself will probably not send that data, so it's actually only
>> marginally more dangerous than using something like rsync to copy the data.
>
> True, but my goal was to eliminate as many btrfs variables as I could.
> To answer the original question, I used rsync to copy the data and
> attributes (something like rsync -aHXp --numeric-ids) from a live CD to
> an external hard drive (formatted ext4), then ran mkfs.btrfs on the
> original partition, then re-ran the rsync in the opposite direction. It
> worked quite well for me, and the problem hasn't resurfaced.
>
> --Sean
>
