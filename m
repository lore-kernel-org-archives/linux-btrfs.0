Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60807 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab3HDNFE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 4 Aug 2013 09:05:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V5xzb-0001Kn-GL
	for linux-btrfs@vger.kernel.org; Sun, 04 Aug 2013 15:05:03 +0200
Received: from 0117200107.0.fullrate.dk ([90.185.200.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Aug 2013 15:05:03 +0200
Received: from jesper.utoft by 0117200107.0.fullrate.dk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Aug 2013 15:05:03 +0200
To: linux-btrfs@vger.kernel.org
From: jesper <jesper.utoft@gmail.com>
Subject: Re: Btrfsck repair, strange df numbers and cannot write
Date: Sun, 4 Aug 2013 12:59:52 +0000 (UTC)
Message-ID: <loom.20130804T120828-873@post.gmane.org>
References: <loom.20121112T142903-705@post.gmane.org> <20121112151034.GE6347@gmail.com> <loom.20121112T163501-826@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sem <smith_it2000 <at> yahoo.com> writes:
> Liu Bo <bo.li.liu <at> oracle.com> writes:
> > > After doing a btrfsck --repair on my file system, it now has very strange
> > > numbers in df:
> > > 
> > > [root ~]# df -h | grep sdc
> > > /dev/sdc         15T  -64Z   16E 101% /usr/data
> > > 
> > > Prior to this it was 81% used.
> > > 
> > > I can read the files, but i cannot write a file.
> > > 
> > > Does anyone have a clue as to what is going on?
...
> [root <at>  data]# btrfs-debug-tree /dev/sdc
> 
> warning, bad space info total_bytes 8589934592 used 17179541504
> warning, bad space info total_bytes 12884901888 used 25768099840
...
> warning, bad space info total_bytes 51539607552 used 102990053376
> warning, bad space info total_bytes 55834574848 used 111552487424
> And thousands more lines.
> 
> [root <at>  data]# btrfs fi df /usr/data
> 
> Data, RAID0: total=13.95TB, used=23.99TB
> System, RAID1: total=64.00MB, used=1.63MB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=297.96GB, used=146.77GB

Hello.

Did you find a solution for the issue below?
Cause i have run into the same problem.

I thought adding two disks to the array would help, but it only ended up as
showing up ad filled.

After doing another btrfsck i can not mount the volume at all.

Cheers
Jesper

