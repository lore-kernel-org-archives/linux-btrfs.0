Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:38438 "EHLO
        cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755400AbdEHTDF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 May 2017 15:03:05 -0400
Date: Mon, 8 May 2017 15:02:57 -0400
From: Sean Greenslade <sean@seangreenslade.com>
To: Alexandru Guzu <alexguzu@gmail.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Sanidhya Solanki <lkml.page@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: BTRFS converted from EXT4 becomes read-only after reboot
Message-ID: <20170508190257.GB1699@fox>
References: <CAPktuGs4cJW6YBJ3GuGaXRLkud7VKvdH2P1U0hT+3AtDmHL5Yw@mail.gmail.com>
 <706980A2-DC62-45AA-B169-8A9D6E474D87@seangreenslade.com>
 <CAPktuGuyUBQF1=LKvmpZiS7vMSsu=LCfqA9PFa7ObK9ih=LoXg@mail.gmail.com>
 <20170508112617.7e33bed6@ad>
 <A9D2210F-3DC4-45BC-AA07-D4527279D40E@seangreenslade.com>
 <4aedf23f-2bc4-ce18-d5b0-13fa51496feb@gmail.com>
 <20170508170106.GA1699@fox>
 <CAPktuGtS-K9ZvXf_3G5UkS2Xrj-cWx+DaqrFDOu-Hi9r1HqUKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPktuGtS-K9ZvXf_3G5UkS2Xrj-cWx+DaqrFDOu-Hi9r1HqUKw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 08, 2017 at 02:22:52PM -0400, Alexandru Guzu wrote:
> Getting a bit off-topic here, but were you able to boot from that fs
> with grub after a simple rsync?

Grub was installed to the MBR, and /boot was a separate partition, so I
didn't have to re-install grub. I did have to edit the root partition
UUID in /etc/fstab and in the kernel command line in grub.cfg, though.

--Sean

