Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35054 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaFWMYK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 08:24:10 -0400
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs on whole disk (no partitions)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>
	<2316027.LZEnVG8laK@xev>
	<CAPLrYETdzeT_Yia-nnbZBMvGxU3x7tCFiJSv3rNJezMsjce3Zw@mail.gmail.com>
	<6CA8020B-EB92-4A44-8AA5-3F69709F81F2@colorremedies.com>
	<CAK5rZE6gfmQsZz3W_8t=pkKEk_rzqUn5hQVv0sbt8p7qbdhSdQ@mail.gmail.com>
	<53A6DDAD.8070804@chinilu.com>
	<99AD3EFE-AF9A-44A1-912E-07B1E934239B@colorremedies.com>
	<pan$600a2$3927cc39$ae007590$e90b8415@cox.net>
Date: Mon, 23 Jun 2014 08:24:04 -0400
In-Reply-To: <pan$600a2$3927cc39$ae007590$e90b8415@cox.net> (Duncan's message
	of "Mon, 23 Jun 2014 02:10:03 +0000 (UTC)")
Message-ID: <yq1bntjizkr.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "Duncan" == Duncan  <1i5t5.duncan@cox.net> writes:

Duncan> Tho as you point out elsewhere, levels under the filesystem
Duncan> layer may split the btrfs 4096 byte block size into 512 byte
Duncan> logical sector sizes if appropriate, but that has nothing to do
Duncan> with btrfs except that it operates on top of that.

The notion of "splitting into a different block size" is a bit
confusing. The filesystem submits an N-byte I/O. Whether the logical
block size is 512 or 4096 doesn't really matter. We're still
transferring N bytes of data. The only thing the logical block size
really affects is how we calculate the LBA and block counts in the
command we send to the device. If N is not a multiple of the device's
logical block size we'll simply reject the I/O. If we receive an I/O
that is misaligned or not a multiple of the physical block size we let
the drive do RMW. So there isn't any "splitting" going on.

An I/O may be split if MD or DM is involved and the request straddles a
stripe chunk boundary. Because Linux generally does all I/O in terms of
4K pages, sub-page size splits are rare. Pretty much all the other cases
that would force us to split an I/O (typically controller DMA
constraints) operate on a page boundary.

To avoid the drive being forced to do RMW on the head and tail of a
misaligned I/O it is imperative that the filesystems are aligned to the
physical block size of the underlying device. As has been pointed out
the partitioning utilities generally make sure that's the case. If there
are no partitions then you're by definition aligned unless the drive has
the infamous Windows XP jumper installed.

Anyway. The short answer is that Linux will pretty much always do I/O in
multiples of the system page size regardless of the logical block size
of the underlying device. There are a few exceptions to this such as
direct I/O, legacy filesystems using bufferheads and raw block device
access.

-- 
Martin K. Petersen	Oracle Linux Engineering
