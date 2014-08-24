Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:36727 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753522AbaHXU3W convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Aug 2014 16:29:22 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49618 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XLePi-004MBp-0c
	for linux-btrfs@vger.kernel.org; Sun, 24 Aug 2014 14:29:22 -0600
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: superblock checksum mismatch after crash, cannot mount
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <53F8A1CC.80906@floga.de>
Date: Sun, 24 Aug 2014 14:29:20 -0600
Message-Id: <2432ED31-C827-446E-82E9-E0BFA44051CB@colorremedies.com>
References: <53F7BD8E.10308@floga.de>	<pan$a4556$243aa48a$bd2898a8$c2006893@cox.net> <53F85317.8060900@floga.de> <pan$16219$d960b649$52ed1e6$33540704@cox.net> <53F8A1CC.80906@floga.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 23, 2014, at 8:14 AM, Florian Gamböck <mail@floga.de> wrote:

> 
> I haven't run any tests on that, so to be safe, I use a MBR table. And yes, the table was still in order, all three partitions were there, but none of the filesystems were recognized. Sorry if I confused you. But still I think it's a big deal if a rescue on partition 3 breaks the filesystems on each partition of the device. It's like every single superblock was deleted.

This is on 32-bit ARM, so it is possible there's a bug no one else has run into yet. It's worth trying to reproduce the conditions. Maybe someone has a suggestion on how to corrupt just the first Btrfs superblock, it should be really straightforward. Then you can try to repair it again: both ways, with the partition specified and not specified to see if there are different results.


> So, I am almost absolutely sure that the table is in order, since there are no other problems regarding that. And like you said, rescue showed me the right superblocks and also here I am sure that I didn't forget the 3 when typing in the command.

Well it's a question then whether that should matter, and if it does then maybe that's a bug or feature request. You chose superblock 2 to overwrite superblock 1, which is a fixed LBA distance, so it should only be overwriting sectors inside the Btrfs partition in any case unless there isn't a check for this. In which case it should only affect some sectors starting 64KB offset from the start of the whole block device. That would only adversely affect one of the filesystems, not two. So it seems something else is going on here.

If you haven't changed anything on this SD Card you could look at a couple sectors 64KB offset from each /dev/sdX and /dev/sdX[12] - so three checks. And see what's there. Is it a Btrfs superblock? If none of them have a Btrfs superblock then definitely something else is going on.

> 
> I don't want to believe that the SD firmware or the driver or whatever would redirect calls on certain partitions to the main device. So it seems more plausible to think that there is something wrong in the rescue command, like the calculation of the offset or something.

It's possible. See the other thread about this "btrfs receive problem on ARM kirkwood NAS" in particular the reply from Hugo Mills.



Chris Murphy

