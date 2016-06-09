Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:33319 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbcFIPaw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jun 2016 11:30:52 -0400
Received: by mail-qg0-f41.google.com with SMTP id l44so20884468qgd.0
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jun 2016 08:30:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$282ab$fbadc095$ca288943$dfa7a0b@cox.net>
References: <CAO8gOzMt2Wgb2jZ-eq-an-RqHPgssMgZ+O1jOxmZ4GPc-MdDYw@mail.gmail.com>
 <pan$282ab$fbadc095$ca288943$dfa7a0b@cox.net>
From: Noah Massey <noah.massey@gmail.com>
Date: Thu, 9 Jun 2016 11:30:11 -0400
Message-ID: <CADfjVrhQ2y--mLoVgzbNce3dS2EVa=XAR=QR-MdmQTYNHKOqQQ@mail.gmail.com>
Subject: Re: WARNING: at /home/kernel/COD/linux/fs/btrfs/inode.c:9261
 btrfs_destroy_inode+0x247/0x2c0 [btrfs]
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 9, 2016 at 10:52 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Fugou Nashi posted on Sun, 05 Jun 2016 10:12:31 +0900 as excerpted:
>
>> Hi,
>>
>> Do I need to worry about this?
>>
>> Thanks.
>>
>> Linux nakku 4.6.0-040600-generic #201605151930 SMP Sun May 15 23:32:59
>> UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
>
> There's a patch for it that didn't quite make 4.6.0, but is in 4.7-rc1
> and should appear in later 4.6.x stable releases (tho I don't track
> stable myself so couldn't tell you if it's there yet or not).
>

It's in 4.6.1

https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=4704fa547224fd49041c26f7fca3710a47fc449f
