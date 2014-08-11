Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:54558 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaHKIqV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 04:46:21 -0400
Received: by mail-lb0-f175.google.com with SMTP id 10so5712703lbg.34
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 01:46:20 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <16C9BBD0-FD7B-488B-A77F-E937007F292F@colorremedies.com>
References: <2BBB0EBF-DD55-45B4-8BF5-F8DAA9398A4F@colorremedies.com>
	<CF539008-5930-447D-B26C-2A2BBE9337EA@colorremedies.com>
	<CAL3q7H591BbVenxFn_EiBDyqmJEcwgOKjw0Xv2J+jkgic+3dxQ@mail.gmail.com>
	<16C9BBD0-FD7B-488B-A77F-E937007F292F@colorremedies.com>
Date: Mon, 11 Aug 2014 09:46:20 +0100
Message-ID: <CAL3q7H5rpoPFBKjLD9F0_4UdBcG8BgzKUQGGTzbmBmdkG2_Jwg@mail.gmail.com>
Subject: Re: [BUG] btrfs send/receive, page allocation failure
From: Filipe David Manana <fdmanana@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 11, 2014 at 4:07 AM, Chris Murphy <lists@colorremedies.com> wrote:
>>
>>
>> Can you try the following patch and confirm if it helps?
>> https://patchwork.kernel.org/patch/4705171/
>
> This one applies without problems, I didn't build it because I saw v4. The v4 patch I get:
>
> + patch -p1 -F1 -s
> 4 out of 4 hunks FAILED -- saving rejects to file fs/btrfs/send.c.rej
>
> Should v4 alone be applied over 3.16.0? Or each version in succession?

Alone. How did you try to apply it to 3.16? Try "cd source_dir && git
am patchfile" if you didn't (e.g. you used patch command directly).

thanks

>
>
> Chris Murphy



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
