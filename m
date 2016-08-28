Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:36855 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932249AbcH1HL1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 03:11:27 -0400
Received: by mail-pf0-f181.google.com with SMTP id h186so41504550pfg.3
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Aug 2016 00:11:26 -0700 (PDT)
Subject: Re: Recommendation on raid5 drive error resolution
To: Gareth Pye <gareth@cerberos.id.au>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CA+WRLO8KuP8LS77NUbZLAs3e120oFudES_R3tYQjjYiCXH4BOA@mail.gmail.com>
From: DanglingPointer <danglingpointerexception@gmail.com>
Message-ID: <a9fe4047-5941-5cfe-cb73-95160d86126a@gmail.com>
Date: Sun, 28 Aug 2016 17:05:55 +1000
MIME-Version: 1.0
In-Reply-To: <CA+WRLO8KuP8LS77NUbZLAs3e120oFudES_R3tYQjjYiCXH4BOA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Gareth,

I'm interested in how you go with this as I'm somewhat similar with 
RAID5 with both.  Don't take this as advice as I have never done it; 
however if I were in your shoes, I would take out one of the disks that 
isn't playing nicely and rebuild the array.  Once it is running smooth 
then I would take the other disk that isn't playing nice and replace it 
and rebuild again.  The whole process will take a fair bit of time but 
better to be safe than sorry.

Like I said I have never done it so do so at your own risk.

DanglingPointer

On 25/08/16 17:23, Gareth Pye wrote:
> So I've been living on the reckless-side (meta RAID6, data RAID5) and
> I have a drive or two that isn't playing nicely any more.
>
> dmesg of the system running for a few minutes: http://pastebin.com/9pHBRQVe
>
> Everything of value is backed up, but I'd rather keep data than
> download it all again. When I only saw one disk having troubles I was
> concerned. Now I notice both sda and sdc having issues I'm thinking I
> might be about to have a bad time.
>
> What else should I provide?
>

