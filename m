Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:61486 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbaHWIit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Aug 2014 04:38:49 -0400
Message-ID: <53F85317.8060900@floga.de>
Date: Sat, 23 Aug 2014 10:38:47 +0200
From: =?UTF-8?B?RmxvcmlhbiBHYW1iw7Zjaw==?= <mail@floga.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: superblock checksum mismatch after crash, cannot mount
References: <53F7BD8E.10308@floga.de> <pan$a4556$243aa48a$bd2898a8$c2006893@cox.net>
In-Reply-To: <pan$a4556$243aa48a$bd2898a8$c2006893@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Duncan,

thank you for your detailed explanations!

Am 23.08.2014 07:27, schrieb Duncan:
> btrfs-show-super is your tool for inspecting the superblocks.  See the
> manpage for the details.
>
> Then use btrfs rescue super-recover to overwrite the bad superblock with
> one that checks out as good (csum match).  See the btrfs-rescue manpage
> for the details there.

Yes, show-super told me, that the first super block did "NOT MATCH", but 
the second one seemed to be in order ("MATCHED"). The SD card is 16 GiB 
big, so there was no third super block.

Rescue also listed the first one as bad and the second one as good and 
it seemed to run successfully, no errors whatsoever.

However, after "recovering", every single partition on the card broke. 
There were three partitions: 1 = fat32 ("/boot"), 2 = swap, 3 = btrfs 
("/"). Naturally I ran the rescue command on partition 3, I hope that 
was not a mistake. Afterwards, as I said, none of the partitions were 
recognized anymore. Not even btrfs recognized the third partition.

Since I've thought I messed up entirely, I just gave up, re-formatted 
the card and let my backups do the job.

It's quite annoying though, how often I get those problems. May it be 
that the Raspberry Pi is too slow to let btrfs do its background magic, 
may it be that btrfs is not that suitable for SD cards (in my case it's 
a class 10 microSDHC, 16GiB), or may it be that btrfs is still not that 
reliable when it comes to "unclean" shutdowns.

Nevertheless, I will keep your explanations around for future reference, 
they were really helpful! Thanks again!

--
Best wishes
FloGa
