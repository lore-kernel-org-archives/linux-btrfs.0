Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:53022 "EHLO
        cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751766AbdEHQWH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 May 2017 12:22:07 -0400
Date: Mon, 08 May 2017 12:22:02 -0400
In-Reply-To: <20170508112617.7e33bed6@ad>
References: <CAPktuGs4cJW6YBJ3GuGaXRLkud7VKvdH2P1U0hT+3AtDmHL5Yw@mail.gmail.com> <706980A2-DC62-45AA-B169-8A9D6E474D87@seangreenslade.com> <CAPktuGuyUBQF1=LKvmpZiS7vMSsu=LCfqA9PFa7ObK9ih=LoXg@mail.gmail.com> <20170508112617.7e33bed6@ad>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: BTRFS converted from EXT4 becomes read-only after reboot
To: Sanidhya Solanki <lkml.page@gmail.com>,
        Alexandru Guzu <alexguzu@gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
From: Sean Greenslade <sean@seangreenslade.com>
Message-ID: <A9D2210F-3DC4-45BC-AA07-D4527279D40E@seangreenslade.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On May 8, 2017 11:28:42 AM EDT, Sanidhya Solanki <lkml.page@gmail.com> wrote:
>On Mon, 8 May 2017 10:16:44 -0400
>Alexandru Guzu <alexguzu@gmail.com> wrote:
> 
>> Sean, how would you approach the copy of the data back and forth if
>> the OS is on it? Would a Send-receive and then back work?
>
>You could use a Live-USB and then just dd it to remote or attached
>storage, if
>you want to be absolutely sure the data is not affected.

I would not suggest either of those. Send / receive might work, but since we don't know the source of the problem, it risks transferring the problem. DD would not solve the problem at all, since we're trying to rebuild the partition, not clone it.

--Sean


