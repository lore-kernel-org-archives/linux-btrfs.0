Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52021 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab2KLPhA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Nov 2012 10:37:00 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TXw4S-0002Ew-PO
	for linux-btrfs@vger.kernel.org; Mon, 12 Nov 2012 16:37:08 +0100
Received: from 83.244.169.150 ([83.244.169.150])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2012 16:37:08 +0100
Received: from smith_it2000 by 83.244.169.150 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2012 16:37:08 +0100
To: linux-btrfs@vger.kernel.org
From: Sem <smith_it2000@yahoo.com>
Subject: Re: Btrfsck repair, strange df numbers and cannot write
Date: Mon, 12 Nov 2012 15:36:49 +0000 (UTC)
Message-ID: <loom.20121112T163501-826@post.gmane.org>
References: <loom.20121112T142903-705@post.gmane.org> <20121112151034.GE6347@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Liu Bo <bo.li.liu <at> oracle.com> writes:

> 
> On Mon, Nov 12, 2012 at 01:34:09PM +0000, Sem wrote:
> > Hi,
> > 
> > After doing a btrfsck --repair on my file system, it now has very strange
> > numbers in df:
> > 
> > [root ~]# df -h | grep sdc
> > /dev/sdc         15T  -64Z   16E 101% /usr/data
> > 
> > Prior to this it was 81% used.
> > 
> > I can read the files, but i cannot write a file.
> > 
> > Does anyone have a clue as to what is going on?
> > 
> 
> Can you show here what 'btrfs fi df /usr/data' prints?
> 
> And also 'btrfs-debug-tree sdc'.
> 
> thanks,
> liubo
> 
> > Any idea how to fix?
> > 
> > Thanks.
> > 
> > ---
> > 
> > Details:
> > 
> > [root ~]# uname -a
> > Linux t1.localdomain 3.6.6-1.fc16.x86_64 #1 SMP Mon Nov 5 16:56:43 UTC 2012
> > x86_64 x86_64 x86_64 GNU/Linux
> > 
> > [root ~]# btrfs --version
> > Btrfs v0.20-rc1-37-g91d9eec
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo <at> vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

[root@ data]# btrfs-debug-tree /dev/sdc

warning, bad space info total_bytes 8589934592 used 17179541504
warning, bad space info total_bytes 12884901888 used 25768099840
warning, bad space info total_bytes 17179869184 used 34358034432
warning, bad space info total_bytes 21474836480 used 42947969024
warning, bad space info total_bytes 25769803776 used 51537903616
warning, bad space info total_bytes 30064771072 used 60109676544
warning, bad space info total_bytes 34359738368 used 68699611136
warning, bad space info total_bytes 38654705664 used 77289545728
warning, bad space info total_bytes 42949672960 used 85810184192
warning, bad space info total_bytes 47244640256 used 94400118784
warning, bad space info total_bytes 51539607552 used 102990053376
warning, bad space info total_bytes 55834574848 used 111552487424
And thousands more lines.

[root@ data]# btrfs fi df /usr/data

Data, RAID0: total=13.95TB, used=23.99TB
System, RAID1: total=64.00MB, used=1.63MB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=297.96GB, used=146.77GB


