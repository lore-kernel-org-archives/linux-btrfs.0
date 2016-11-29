Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33701 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751494AbcK2MTF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 07:19:05 -0500
Received: by mail-io0-f193.google.com with SMTP id j92so29072667ioi.0
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 04:19:04 -0800 (PST)
Subject: Re: [Not TLS] Re: mount option nodatacow for VMs on SSD?
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <20161125082840.GA32711@rus.uni-stuttgart.de>
 <20161126112710.6aca8bac@jupiter.sol.kaishome.de>
 <20161128003829.GD15348@rus.uni-stuttgart.de>
 <pan$1eaab$d4d4facd$e2735d04$2fc4a8e@cox.net>
 <2df2e8e6-5ac4-a9c0-70bc-406fd84e9784@cobb.uk.net>
 <pan$a292d$fa229462$80743716$b85be0fd@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <c655b303-685c-e1ea-2ff6-31672ba0f5d2@gmail.com>
Date: Tue, 29 Nov 2016 07:18:57 -0500
MIME-Version: 1.0
In-Reply-To: <pan$a292d$fa229462$80743716$b85be0fd@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-29 00:14, Duncan wrote:
> Graham Cobb posted on Mon, 28 Nov 2016 09:49:33 +0000 as excerpted:
>
>> On 28/11/16 02:56, Duncan wrote:
>>> It should still be worth turning on autodefrag on an existing somewhat
>>> fragmented filesystem.  It just might take some time to defrag files
>>> you do modify, and won't touch those you don't, which in some cases
>>> might make it worth defragging those manually.  Or simply create new
>>> filesystems, mount them with autodefrag, and copy everything over so
>>> you're starting fresh, as I do.
>>
>> Could that "copy" be (a series of) send/receive, so that snapshots and
>> reflinks are preserved?  Does autodefrag work in that case or does the
>> send/receive somehow override that and end up preserving the original
>> (fragmented) extent structure?
>
> Very good question that I don't know the answer to as I've not seen it
> discussed previously.  (I'm not a dev, just a list regular and user of
> btrfs myself, and my personal use-case involves neither snapshots nor
> send/receive, so on those topics if I've not seen it covered previously
> either here or on the wiki, I won't know.)
>
> Someone else know?
>
Autodefrag does work in that case, but not because there's any special 
handling for it.  In the case of send/receive, the receiving side is 
doing nothing that couldn't be done as a normal user (except possibly a 
few ioctls to set subvolume UUID's), so any data it writes will be 
subject to all processing done by the FS (so sending from an 
uncompressed volume to one with compress=X will result in the data being 
compressed on the receiving end too).
