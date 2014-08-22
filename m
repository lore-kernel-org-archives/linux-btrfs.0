Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38835 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013AbaHVNFU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 09:05:20 -0400
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: mkfs.btrfs vs fstrim on an SD Card (not SSD)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <3CE6F328-8757-4B7F-858F-E820DFDF97E8@colorremedies.com>
	<F5912FA1-9B5B-4E22-A9A8-EB09461F2BD4@colorremedies.com>
Date: Fri, 22 Aug 2014 09:04:45 -0400
In-Reply-To: <F5912FA1-9B5B-4E22-A9A8-EB09461F2BD4@colorremedies.com> (Chris
	Murphy's message of "Thu, 21 Aug 2014 21:19:00 -0600")
Message-ID: <yq1y4ugptea.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "Chris" == Chris Murphy <lists@colorremedies.com> writes:

Chris> Since the SD Card spec references a completely different command
Chris> than the ATA spec (TRIM), I don't think either one of these are
Chris> TRIM, even if functionally equivalent. Instead the SD Card
Chris> ERASE_* commands are probably being used,

Indeed. Discard is our generic block layer abstraction that gets
translated into whichever command is appropriate for the device in
question (ACS DSM TRIM, SBC WRITE SAME/UNMAP, etc.).

Chris> but I can't confirm this because writes to /dev/mmcblk0 aren't
Chris> showing up with:

Chris> echo scsi:scsi_dispatch_cmd_start >
Chris> /sys/kernel/debug/tracing/set_event echo 1 >
Chris> /sys/kernel/debug/tracing/tracing_on cat
Chris> /sys/kernel/debug/tracing/trace_pipe

MMC doesn't go through SCSI like ATA does. 

-- 
Martin K. Petersen	Oracle Linux Engineering
