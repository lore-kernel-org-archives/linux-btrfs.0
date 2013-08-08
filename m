Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:60263 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965103Ab3HHK4J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 06:56:09 -0400
Received: by mail-bk0-f53.google.com with SMTP id d7so927994bkh.40
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Aug 2013 03:56:07 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <5203786A.3000306@giantdisaster.de>
References: <1372593106-6593-1-git-send-email-fdmanana@gmail.com>
	<1372931320-8340-1-git-send-email-fdmanana@gmail.com>
	<1372931320-8340-2-git-send-email-fdmanana@gmail.com>
	<5203786A.3000306@giantdisaster.de>
Date: Thu, 8 Aug 2013 11:56:07 +0100
Message-ID: <CAL3q7H6MsUZygwuv_nyu2PJLP5fRPtGSeGknDAXXmQRFXJiCrg@mail.gmail.com>
Subject: Re: [PATCH 4/5] Btrfs-progs: return error on write failure in make_btrfs()
From: Filipe David Manana <fdmanana@gmail.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 8, 2013 at 11:52 AM, Stefan Behrens
<sbehrens@giantdisaster.de> wrote:
> On Thu,  4 Jul 2013 10:48:39 +0100, Filipe David Borba Manana wrote:
>> Instead of aborting with a BUG_ON() statement, return a
>> negated errno code. Also updated mkfs and convert tools
>> to print a nicer error message when make_btrfs() returns
>> an error.
>>
>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> [...]
>>       ret = pwrite(fd, buf->data, sectorsize, blocks[0]);
>> -     BUG_ON(ret != sectorsize);
>> -
>> +     if (ret < 0)
>> +             return -errno;
>> +     else if (ret != leafsize)
>> +             return -EIO;
>
> mkfs.btrfs with leafsize != sectorsize fails. I've sent a patch for it.

Copy paste error :(
Thanks for catching and fixing it.

>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
