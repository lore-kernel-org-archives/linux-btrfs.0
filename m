Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:32776 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752988AbdEHTFc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 May 2017 15:05:32 -0400
Received: by mail-yw0-f181.google.com with SMTP id 203so34156644ywe.0
        for <linux-btrfs@vger.kernel.org>; Mon, 08 May 2017 12:05:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPktuGuyUBQF1=LKvmpZiS7vMSsu=LCfqA9PFa7ObK9ih=LoXg@mail.gmail.com>
References: <CAPktuGs4cJW6YBJ3GuGaXRLkud7VKvdH2P1U0hT+3AtDmHL5Yw@mail.gmail.com>
 <706980A2-DC62-45AA-B169-8A9D6E474D87@seangreenslade.com> <CAPktuGuyUBQF1=LKvmpZiS7vMSsu=LCfqA9PFa7ObK9ih=LoXg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 8 May 2017 13:05:30 -0600
Message-ID: <CAJCQCtRv74Xd0dz--D1G4MKXekDuoWbvuQ6kpxizv0XLbNb2gg@mail.gmail.com>
Subject: Re: BTRFS converted from EXT4 becomes read-only after reboot
To: Alexandru Guzu <alexguzu@gmail.com>
Cc: Sean Greenslade <sean@seangreenslade.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 8, 2017 at 8:16 AM, Alexandru Guzu <alexguzu@gmail.com> wrote:
> Deleting the Firefox cache with the LiveCD resolved the issue where
> the FS would become read-only when opening Firefox, however, the
> lowmem check still reports errors. There are probably some other files
> that would cause the FS to become read-only again, but I'm not sure
> how to find them.
> I took a snapshot of the Virtual disk before deleting the FF profile,
> so I can reproduce the issue if you guys want to track down this
> potential bug, otherwise I will delete the VM by the end of this week.
>
> Sean, how would you approach the copy of the data back and forth if
> the OS is on it? Would a Send-receive and then back work?

Btrfs send receive. Optionally you can send to a file; and then
receive from a file. In that case the file can be on any filesystem.

The one thing not to use is dd.


-- 
Chris Murphy
