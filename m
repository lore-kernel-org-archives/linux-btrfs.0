Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:54924 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968491Ab3HJJTc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Aug 2013 05:19:32 -0400
Received: from bluebottle.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 5D19D2192F
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Aug 2013 19:19:29 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: error count
Date: Sat, 10 Aug 2013 19:19:27 +1000
References: <201308042142.12310.russell@coker.com.au> <CAGy7UtjvPHbC0zSvXNAV+LYAr=QX-ePXKCXCx-VKTDD2O9fLMw@mail.gmail.com> <10123682.SXiMQfqCrF@quad>
In-Reply-To: <10123682.SXiMQfqCrF@quad>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201308101919.27987.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 10 Aug 2013, Chris Samuel <chris@csamuel.org> wrote:
> On Sun, 4 Aug 2013 03:37:22 PM Bart Noordervliet wrote:
> > a sufficiently up-to-date kernel and btrfs tool will provide the
> > 'btrfs device stats' command, which should give you the info you want.
> 
> This is what it looks like:
> 
> chris@quad:~/Downloads/Linux/FileSystems/BtrFS/btrfs-progs$ sudo ./btrfs
> device stats /srv/DR
> [/dev/sdb3].write_io_errs   0
> [/dev/sdb3].read_io_errs    0
> [/dev/sdb3].flush_io_errs   0
> [/dev/sdb3].corruption_errs 0
> [/dev/sdb3].generation_errs 0

Thanks Chris and Bart.

Would it be possible to get the man page updated to include a brief 
description of those errors?  The first three are somewhat obvious in meaning 
(although not obvious in how they would happen) and the fourth is very 
obvious.  But what does generation_errs mean?  I'm seeing some on one system.  
Should I be concerned?  If I write a Nagios check which ones should be 
warnings and which ones errors?

Also why does it give the following errors about trying to open /dev/sr0 when 
using a BTRFS RAID-1 filesystem?  Below is for a RAID-1 over /dev/sdb and 
/dev/sdc.

# btrfs device stats /dev/sdb
failed to open /dev/sr0: No medium found
failed to open /dev/sr0: No medium found
[/dev/sdb].write_io_errs   0
[/dev/sdb].read_io_errs    0
[/dev/sdb].flush_io_errs   0
[/dev/sdb].corruption_errs 0
[/dev/sdb].generation_errs 0
# btrfs device stats /dev/sdc
failed to open /dev/sr0: No medium found
failed to open /dev/sr0: No medium found
[/dev/sdc].write_io_errs   0
[/dev/sdc].read_io_errs    0
[/dev/sdc].flush_io_errs   0
[/dev/sdc].corruption_errs 0
[/dev/sdc].generation_errs 0

Why is it even searching for the other part when only a single device is 
specified and why can't it give stats without checking /dev/sr0 when checking 
a single device when it can do so while checking all devices?

# btrfs device stats /dev/sdd1
failed to open /dev/sr0: No medium found
failed to open /dev/sr0: No medium found
[/dev/sdd1].write_io_errs   0
[/dev/sdd1].read_io_errs    136
[/dev/sdd1].flush_io_errs   0
[/dev/sdd1].corruption_errs 0
[/dev/sdd1].generation_errs 0
# btrfs device stats /dev/sdd2
failed to open /dev/sr0: No medium found
failed to open /dev/sr0: No medium found
[/dev/sdd2].write_io_errs   0
[/dev/sdd2].read_io_errs    0
[/dev/sdd2].flush_io_errs   0
[/dev/sdd2].corruption_errs 0
[/dev/sdd2].generation_errs 0
# btrfs device stats /mnt/backup/
[/dev/sdd1].write_io_errs   0
[/dev/sdd1].read_io_errs    136
[/dev/sdd1].flush_io_errs   0
[/dev/sdd1].corruption_errs 0
[/dev/sdd1].generation_errs 0
[/dev/sdd2].write_io_errs   0
[/dev/sdd2].read_io_errs    0
[/dev/sdd2].flush_io_errs   0
[/dev/sdd2].corruption_errs 0
[/dev/sdd2].generation_errs 0


Thanks.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
