Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:38824 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab3JWRVe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Oct 2013 13:21:34 -0400
Message-ID: <5268059E.707@giantdisaster.de>
Date: Wed, 23 Oct 2013 19:21:34 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Bob Marley <bobmarley@shiftmail.org>
CC: Wang Shilong <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix race condition between writting and scrubing
 supers
References: <1382156250-2336-1-git-send-email-wangshilong1991@gmail.com>	<526247E3.9000804@giantdisaster.de> <CAP9B-Qncw5aCJzbQapy6i4iRrJ-mYh_yhkorY7+p9wZtzJodTQ@mail.gmail.com> <5262914D.7030306@giantdisaster.de> <B9B7D38F-3E92-4347-A41F-FA4D80D31745@gmail.com> <52663960.4060905@giantdisaster.de> <5266AE1F.6030304@shiftmail.org>
In-Reply-To: <5266AE1F.6030304@shiftmail.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 22 Oct 2013 18:55:59 +0200, Bob Marley wrote:
> On 22/10/2013 10:37, Stefan Behrens wrote:
>> I don't believe that this issue can ever happen. I don't believe that
>> somewhere on the path to the flash memory, to the magnetic disc or to
>> the drive's cache memory, someone interrupts a 4KB write in the middle
>> of operation to read from this 4KB area. This is not an issue IMHO.
> 
> I think I have read that unfortunately it can happen.
> SAS and SATA specs for disks do not mandate that if a write is in-flight
> but still not completed, reads from the same sector should return the
> value it is being written; they can return the old value.
> I also think that Linux does not check either.

If the _old_ 4KB block is returned, that's fine and won't cause a
checksum error.

The patch in question addresses the case that Btrfs submits a write
request for a 4KB block, and a concurrent read request for that 4KB
block reads partially the old block and partially the new block,
resulting in a checksum error reported in the scrub statistic counters.


> Much worse, I think I have even read that two simultaneous in-flight
> writes to the same sector can be completed in any order by the disk, and
> since the write which wins is the latter being completed, this results
> in an indeterminate value persisting on that sector at the end. One
> needs to synchronize cache between the two writes to guarantee the
> outcome. Way worse is when the drives also cheat on synchronize cache,
> and that one is impossible to fix I believe.

Two simultaneous in-flight writes to the same superblock cannot happen
in Btrfs.


