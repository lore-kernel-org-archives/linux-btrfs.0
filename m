Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:60242 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbbATWx6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 17:53:58 -0500
Received: by mail-yk0-f178.google.com with SMTP id 20so18259109yks.9
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jan 2015 14:53:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+WRLO89nFArYhRgjqPBruW0avExOZcf9iZgvusLAr_+4ddxoQ@mail.gmail.com>
References: <CA+WRLO9nCFgjHzY1F_xR5PpmgaSEemfmZ=MtiSpiaHcROQnq-A@mail.gmail.com>
	<CA+WRLO8gGUxxHhqQfgQWXyU0kT2=nf7u5oPFYJTWY=hSMNBj=w@mail.gmail.com>
	<CAJCQCtRe+0n84PUZuWKw0UUwK_RF_AhW4sMZ+07r96qaNvRWKg@mail.gmail.com>
	<CA+WRLO-VnULLGOE1VkrOortCdQNCKPCwJ70FDJL3KQwru8TLhQ@mail.gmail.com>
	<CAJCQCtQQnovS94fo-hRQa_O6Q7EM9KOCPFxC3FTkTC4=CT93sA@mail.gmail.com>
	<CA+WRLO89nFArYhRgjqPBruW0avExOZcf9iZgvusLAr_+4ddxoQ@mail.gmail.com>
Date: Tue, 20 Jan 2015 15:53:57 -0700
Message-ID: <CAJCQCtTiboWRVkZLE2Te9Kb00SXxUk0_AwE5xv-vTHxrpaDCqA@mail.gmail.com>
Subject: Re: btrfs convert running out of space
From: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 20, 2015 at 2:49 PM, Gareth Pye <gareth@cerberos.id.au> wrote:
> The conversion is going the other way (raid10->raid1), but I expect
> the analysis is going to be the same. I'll wait on 3.19 kernel then
> (or probably 3.19.1) as this system is slightly more production than
> use of btrfs would suggest.
>
> The flags 17 messages are from the non-converting balance to clear up
> the empty blocks, the flags 65 messages are from the RAID10->RAID1
> balance

Makes sense.

Are there any particularly large files? File bigger than 1GB? Are any
of those nocow (xattr +C)? I'm just throwing spaghetti to see what
might be different with this volume than others which have
successfully converted between raid10 and raid1. The file system was
created with btrfs-progs 3.12? Defaults? (Other than data raid 10.)

It looks to be a large file but it might be worth grabbing a
btrfs-image per the wiki in case the fs behavior changes while doing
anything else to it (even normal operation might free up whatever's
stuck and then the problem isn't reproducible).

Another option, if you have the space, is to create two more drbd
devices of the same size (as each other, they don't have to be the
same size as what's already in the array), and add them to this
volume, and then attempt to complete the conversion (with soft option
as you have been).

Also, those three block values reported with flags 65 can be plugged
into btrfs-debug-tree or btrfs inspect internal to find out what file
is involved, and maybe there's something about them that's instigating
the problem.

I would consider the file system suspect at this point, just being
conservative about it. The reason is that it's in the middle of a
conversion to raid1, so anything newly allocated will be raid1, and
anything old is raid10 and being in this state long term I think is
sufficiently non-deterministic in that who knows what could happen in
three weeks. It might be OK. So if you have the space to create a new
raid1 volume, and btrfs send old to new, it gets you where you
ultimately want to be much sooner. And then you can throw 3.19rc5 at
the problemed fs and see how it behaves.

-- 
Chris Murphy
