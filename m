Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:44993 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755322Ab3EUDh2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 May 2013 23:37:28 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: Virtual Device Support
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$d75cf$ec7daeb9$c2cc055b$98b478d0@cox.net>
Date: Mon, 20 May 2013 21:37:22 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <9BA35EA6-D116-4223-B2C0-CE4FEA3D4010@colorremedies.com>
References: <518CFE3A.3080900@chinilu.com> <20130519171510.54897415@natsu> <262CC063-0DB4-45BD-A776-9FD1E8650E7C@colorremedies.com> <pan$d75cf$ec7daeb9$c2cc055b$98b478d0@cox.net>
To: Duncan <1i5t5.duncan@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 20, 2013, at 7:08 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> Chris Murphy posted on Sun, 19 May 2013 12:18:19 -0600 as excerpted:
> 
>> It seems inconsistent that mount and unmount allows a /dev/ designation,
>> but only mount honors label and UUID.
> 
> Yes.  

I'm going to contradict myself and point out that mount with label or UUID is made unambiguous via either the default subvolume being mounted, or the -o subvol= option being specified. The volume label and UUID doesn't apply to umount because it's an ambiguous command. You'd have to umount a mountpoint, or possibly a subvolume specific UUID.


Chris Murphy