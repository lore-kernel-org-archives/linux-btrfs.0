Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37291 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbaFWCKS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jun 2014 22:10:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wyti3-0002hK-Ja
	for linux-btrfs@vger.kernel.org; Mon, 23 Jun 2014 04:10:15 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jun 2014 04:10:15 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jun 2014 04:10:15 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs on whole disk (no partitions)
Date: Mon, 23 Jun 2014 02:10:03 +0000 (UTC)
Message-ID: <pan$600a2$3927cc39$ae007590$e90b8415@cox.net>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>
	<2316027.LZEnVG8laK@xev>
	<CAPLrYETdzeT_Yia-nnbZBMvGxU3x7tCFiJSv3rNJezMsjce3Zw@mail.gmail.com>
	<6CA8020B-EB92-4A44-8AA5-3F69709F81F2@colorremedies.com>
	<CAK5rZE6gfmQsZz3W_8t=pkKEk_rzqUn5hQVv0sbt8p7qbdhSdQ@mail.gmail.com>
	<53A6DDAD.8070804@chinilu.com>
	<99AD3EFE-AF9A-44A1-912E-07B1E934239B@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sun, 22 Jun 2014 12:47:10 -0600 as excerpted:

>> As far as I know, btrfs defaults to 4K UNLESS you specify 512B
> 
> I'm not sure what this means. The Btrfs sector size minimum is 4096
> bytes.
> I can use -s to make it bigger, but not less than 4096 on 512/512 or
> 512/4096 byte drives. I actually don't know what Btrfs sector size is
> but it's not the same thing as drive logical or physical sector size.

FWIW, for btrfs I prefer the terms block size or page size, which on x86 
(both 32-bit and 64-bit) and arm is 4096 bytes (tho on other archs it can 
range from 2048 byte to 64 KiB), reserving the "sector" term for actual 
hardware.

Btrfs is copy-on-write, and AFAIK sends no operations to the lower levels 
at smaller than this block size, so on x86 (32-bit or 64-bit), all btrfs 
level operations should be in 4096-byte increments, regardless of the 
underlying ATA/SCSI hardware.

Tho as you point out elsewhere, levels under the filesystem layer may 
split the btrfs 4096 byte block size into 512 byte logical sector sizes 
if appropriate, but that has nothing to do with btrfs except that it 
operates on top of that.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

