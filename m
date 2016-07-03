Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:35368 "EHLO
	mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbcGCOPE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Jul 2016 10:15:04 -0400
Received: by mail-vk0-f46.google.com with SMTP id i63so35491009vkb.2
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jul 2016 07:15:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160703123341.7c297efa@jupiter.sol.kaishome.de>
References: <5776CF08.5040601@mail.ru> <20160703123341.7c297efa@jupiter.sol.kaishome.de>
From: Henk Slager <eye1tm@gmail.com>
Date: Sun, 3 Jul 2016 16:15:02 +0200
Message-ID: <CAPmG0jZ3RMuDX-fzK7WyuNH+NeSyZw8zhWerTo7ve-CgTADSPw@mail.gmail.com>
Subject: Re: btrfs defrag questions
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 3, 2016 at 12:33 PM, Kai Krakow <hurikhan77@gmail.com> wrote:
> Am Fri, 1 Jul 2016 22:14:00 +0200
> schrieb Dmitry Katsubo <dma_k@mail.ru>:
>
>> Hello everyone,
>>
>> Question #1:
>>
>> While doing defrag I got the following message:
>>
>> # btrfs fi defrag -r /home
>> ERROR: defrag failed on /home/user/.dropbox-dist/dropbox: Success
>> total 1 failures
>>
>> I feel that something went wrong, but the message is a bit misleading.
>>
>> Provided that Dropbox is running in the system, does it mean that it
>> cannot be defagmented?
>
> That is probably true. Files that are mapped into memory (like running
> executables) cannot be changed on disk. You could make a copy of that
> file, remove the original, and rename the new into place. As long as
> the executable is running it will stay on disk but you can now
> defragment the file and next time dropbox is started it will use the
> new one.

I get:
ERROR: cannot open ./dropbox: Text file busy

when I run:
btrfs fi defrag -v ./dropbox

This is with kernel 4.6.2 and progs 4.6.1, dropbox running and mount
option compress=lzo
