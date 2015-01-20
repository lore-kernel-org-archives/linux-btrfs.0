Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f47.google.com ([209.85.213.47]:62762 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbbATVlO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 16:41:14 -0500
Received: by mail-yh0-f47.google.com with SMTP id z6so6566675yhz.6
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jan 2015 13:41:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+WRLO-VnULLGOE1VkrOortCdQNCKPCwJ70FDJL3KQwru8TLhQ@mail.gmail.com>
References: <CA+WRLO9nCFgjHzY1F_xR5PpmgaSEemfmZ=MtiSpiaHcROQnq-A@mail.gmail.com>
	<CA+WRLO8gGUxxHhqQfgQWXyU0kT2=nf7u5oPFYJTWY=hSMNBj=w@mail.gmail.com>
	<CAJCQCtRe+0n84PUZuWKw0UUwK_RF_AhW4sMZ+07r96qaNvRWKg@mail.gmail.com>
	<CA+WRLO-VnULLGOE1VkrOortCdQNCKPCwJ70FDJL3KQwru8TLhQ@mail.gmail.com>
Date: Tue, 20 Jan 2015 14:41:13 -0700
Message-ID: <CAJCQCtQQnovS94fo-hRQa_O6Q7EM9KOCPFxC3FTkTC4=CT93sA@mail.gmail.com>
Subject: Re: btrfs convert running out of space
From: Chris Murphy <lists@colorremedies.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 20, 2015 at 2:25 PM, Gareth Pye <gareth@cerberos.id.au> wrote:
> Yeah, I have updated btrfs-progs to 3.18. While it is plausible that
> the bug was created by using 3.12, none of the behavior has changed
> now I'm using 3.18.
>
> I was experimenting with -dusage values to try and process the blocks
> in a different order to see if that made any difference. It did let me
> get through more of the file system before erroring but now it errors
> on the first block it tries.
>
> Using "btrfs balance start -v -dusage=2 /data" cleans up all the empty
> block groups that "btrfs balance start -v
> -dconvert=raid1,soft,limit=10 /data" creates. I'm using limit=10 to
> speed up testing, I have tried without it and it just takes longer to
> complete and the whole time the RAID1 total sky rockets while the
> RAID1 used doesn't move.

Sounds like during the conversion, no longer needed raid1 chunks
aren't quickly deallocated so they can be used as raid10 chunks.
There's been some work on this in the 3.19 kernel, it might be worth
testing.

I'm not sure if the significance of the change from flags 17 to flags
65 right before the enospc errors. The spacing between flags 17 chunks
is exactly 1GB whereas the spacing between the values reported for
flags 65 vary a lot, one is a 12GB gap.


-- 
Chris Murphy
