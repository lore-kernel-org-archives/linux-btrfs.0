Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33833 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751529AbdEHQlR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 May 2017 12:41:17 -0400
Received: by mail-it0-f67.google.com with SMTP id c26so7895660itd.1
        for <linux-btrfs@vger.kernel.org>; Mon, 08 May 2017 09:41:17 -0700 (PDT)
Subject: Re: BTRFS converted from EXT4 becomes read-only after reboot
To: Sean Greenslade <sean@seangreenslade.com>,
        Sanidhya Solanki <lkml.page@gmail.com>,
        Alexandru Guzu <alexguzu@gmail.com>
References: <CAPktuGs4cJW6YBJ3GuGaXRLkud7VKvdH2P1U0hT+3AtDmHL5Yw@mail.gmail.com>
 <706980A2-DC62-45AA-B169-8A9D6E474D87@seangreenslade.com>
 <CAPktuGuyUBQF1=LKvmpZiS7vMSsu=LCfqA9PFa7ObK9ih=LoXg@mail.gmail.com>
 <20170508112617.7e33bed6@ad>
 <A9D2210F-3DC4-45BC-AA07-D4527279D40E@seangreenslade.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <4aedf23f-2bc4-ce18-d5b0-13fa51496feb@gmail.com>
Date: Mon, 8 May 2017 12:41:11 -0400
MIME-Version: 1.0
In-Reply-To: <A9D2210F-3DC4-45BC-AA07-D4527279D40E@seangreenslade.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-05-08 12:22, Sean Greenslade wrote:
> On May 8, 2017 11:28:42 AM EDT, Sanidhya Solanki <lkml.page@gmail.com> wrote:
>> On Mon, 8 May 2017 10:16:44 -0400
>> Alexandru Guzu <alexguzu@gmail.com> wrote:
>>
>>> Sean, how would you approach the copy of the data back and forth if
>>> the OS is on it? Would a Send-receive and then back work?
>>
>> You could use a Live-USB and then just dd it to remote or attached
>> storage, if
>> you want to be absolutely sure the data is not affected.
>
> I would not suggest either of those. Send / receive might work, but since we don't know the source of the problem, it risks transferring the problem. DD would not solve the problem at all, since we're trying to rebuild the partition, not clone it.
Send/receive is not likely to transfer the problem unless it has 
something to do with how things are reflinked.  Receive operates by 
recreating the sent subvolume from userspace using regular commands and 
the clone ioctls, so it won't replicate any low-level structural issues 
in the filesystem unless they directly involve the way extents are being 
shared (or are a side effect of that).  On top of that, if there is an 
issue on the sending side, send itself will probably not send that data, 
so it's actually only marginally more dangerous than using something 
like rsync to copy the data.
