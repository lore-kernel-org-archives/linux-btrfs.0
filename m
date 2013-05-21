Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42565 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab3EUMTp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 May 2013 08:19:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UelXb-000771-Ch
	for linux-btrfs@vger.kernel.org; Tue, 21 May 2013 14:19:43 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 May 2013 14:19:43 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 May 2013 14:19:43 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Virtual Device Support ("N-way mirror code")
Date: Tue, 21 May 2013 13:19:31 +0100
Message-ID: <knfoof$u08$1@ger.gmane.org>
References: <518CFE3A.3080900@chinilu.com> <20130519171510.54897415@natsu> <262CC063-0DB4-45BD-A776-9FD1E8650E7C@colorremedies.com> <pan$d75cf$ec7daeb9$c2cc055b$98b478d0@cox.net> <519AD943.6060303@chinilu.com> <pan$9855$81c2d2df$c9aa1ca3$2451cc46@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <pan$9855$81c2d2df$c9aa1ca3$2451cc46@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan,

Thanks for quiet a historical summary.

Yep, ReiserFS has stood the test of time very well and I'm still using
and abusing it still on various servers all the way from something like
a decade ago!

More recently I've been putting newer systems on ext4 mainly to take
advantage of extents for large files on all disk types, and also
deferred allocation to hopefully reduce wear on SSDs.

Meanwhile, I've seen no need to change the ReiserFS on the existing
systems, even for the multi-Terabyte backups. The near unlimited file
linking is beautiful for creating in effect incremental backups spanning
years!

All on raid1 or raid5, and all remarkably robust.

Enough waffle! :-)


On 21/05/13 04:59, Duncan wrote:
> And hopefully, now that btrfs raid5/6 is in, in a few cycles the N-way 
> mirrored code will make it as well

I too am waiting for the "N-way mirrored code" for example to have 3
copies of data/metadata across 4 physical disks.

When might that hit? Or is there a stable patch that can be added into
kernel 3.8.13?


Regards,
Martin

