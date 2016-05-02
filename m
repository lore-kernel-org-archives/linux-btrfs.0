Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40647 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbcEBBcm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 May 2016 21:32:42 -0400
Subject: Re: [PATCH v5 00/13] Introduce device state 'failed', spare device
 and auto replace
To: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
References: <1460979104-27497-1-git-send-email-anand.jain@oracle.com>
 <20160428121010.GA19558@jeknote.loshitsa1.net>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <5726AE33.9030201@oracle.com>
Date: Mon, 2 May 2016 09:32:35 +0800
MIME-Version: 1.0
In-Reply-To: <20160428121010.GA19558@jeknote.loshitsa1.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Thanks!  for report.

> Sequense was:
> 1) create FS (RAID5), mount, write 40 MB file, sync
> 2) detach drive
> 3) start replace detached (but still not closed) drive by another
> 4) touch mount point, call 'btrfs fi sync' (I use udev script to initiate write immediately after drive removal)
> 4) <device is closed here> -> oops.

  Right. It didn't handle this case. Now I have fixed this locally.
  But not sent yet, as I am also waiting to base this patch set on
  top of my recent patches.
    [PATCH 0/2] [RFC] btrfs: create degraded-RAID1 chunks

- Anand
