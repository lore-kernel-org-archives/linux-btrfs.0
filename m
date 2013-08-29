Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:40616 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753478Ab3H2TNq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 15:13:46 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: "btrfs device delete missing" - why does it write on healthy device?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130830030132.0cfafc94@virtall.com>
Date: Thu, 29 Aug 2013 13:13:43 -0600
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <6CE01C1D-F25F-4728-B9D9-3E601B95CD0D@colorremedies.com>
References: <20130830030132.0cfafc94@virtall.com>
To: Tomasz Chmielewski <tch@virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 29, 2013, at 1:01 PM, Tomasz Chmielewski <tch@virtall.com> wrote:

> So I've removed a missing device, which took some time:
> 
> # time btrfs device delete missing /home
> 
> real    1512m33.763s
> user    0m0.000s
> sys     121m37.740s
> 
> OK, it needs time, fine.

25 hours seems like a long time … 

> And shifted quite large amounts of data:
> 
> Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
> sda             347.00         0.37        16.24      34050    1512249


… for ~1.5TB.


> 
> But why did it write so much on sdb (even more than on sda)? With
> software RAID-1, when replacing a failed device, the amount of reads
> from one drive is equal to the writes on the other drive; there is no
> writing on the healthy drive.

During the balance, chunks are read and re-written normally. Normal for raid1 means it will write two copies of each read chunk, therefore it writes to both devices. I don't know if it's possible, or planned, to optimize out the (seemingly) redundant write to the device that already has a legitimate copy.


Chris Murphy