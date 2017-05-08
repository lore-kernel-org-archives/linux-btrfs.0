Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:33006 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753591AbdEHTJu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 May 2017 15:09:50 -0400
Received: by mail-yw0-f182.google.com with SMTP id 203so34215000ywe.0
        for <linux-btrfs@vger.kernel.org>; Mon, 08 May 2017 12:09:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPktuGtS-K9ZvXf_3G5UkS2Xrj-cWx+DaqrFDOu-Hi9r1HqUKw@mail.gmail.com>
References: <CAPktuGs4cJW6YBJ3GuGaXRLkud7VKvdH2P1U0hT+3AtDmHL5Yw@mail.gmail.com>
 <706980A2-DC62-45AA-B169-8A9D6E474D87@seangreenslade.com> <CAPktuGuyUBQF1=LKvmpZiS7vMSsu=LCfqA9PFa7ObK9ih=LoXg@mail.gmail.com>
 <20170508112617.7e33bed6@ad> <A9D2210F-3DC4-45BC-AA07-D4527279D40E@seangreenslade.com>
 <4aedf23f-2bc4-ce18-d5b0-13fa51496feb@gmail.com> <20170508170106.GA1699@fox> <CAPktuGtS-K9ZvXf_3G5UkS2Xrj-cWx+DaqrFDOu-Hi9r1HqUKw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 8 May 2017 13:09:48 -0600
Message-ID: <CAJCQCtRss+X1jnU4OTYit1d3QerpQhgbX2ASBijQ3mrPOC4qKQ@mail.gmail.com>
Subject: Re: BTRFS converted from EXT4 becomes read-only after reboot
To: Alexandru Guzu <alexguzu@gmail.com>
Cc: Sean Greenslade <sean@seangreenslade.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Sanidhya Solanki <lkml.page@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 8, 2017 at 12:22 PM, Alexandru Guzu <alexguzu@gmail.com> wrote:
> Getting a bit off-topic here, but were you able to boot from that fs
> with grub after a simple rsync?

I've done it with rsync as well as send/receive and both result in
bootable systems. I use rsync -pogAXtlHrDx because that's what
Fedora's installer is using when installing live systems, regardless
of file system. Of course you still have to fix up some things
afterthefact, like installing fixing fstab to have the correct volume
UUIDs, installing bootloader and making a new grub.cfg, and also
rebuild the initramfs.

-- 
Chris Murphy
