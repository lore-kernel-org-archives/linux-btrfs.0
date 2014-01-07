Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw6a-209.wadns.net ([196.220.39.209]:10748 "EHLO fw6a.wadns.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751901AbaAGKXE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Jan 2014 05:23:04 -0500
Message-ID: <52CBD575.7060109@swiftspirit.co.za>
Date: Tue, 07 Jan 2014 12:22:45 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>
CC: Sulla <Sulla@gmx.at>, Chris Murphy <lists@colorremedies.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs-transaction blocked for more than 120 seconds
References: <52C2AE7C.5020601@gmx.at>	<64E70864-9830-4145-9EDF-F53A79977999@colorremedies.com>	<52C9CBEF.2000309@gmx.at>	<52C9DE66.8080706@swiftspirit.co.za> <20140106045704.7f20872f@natsu>
In-Reply-To: <20140106045704.7f20872f@natsu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/01/06 12:57 AM, Roman Mamedov wrote:
> Did you align your partitions to accommodate for the 4K sector of the EARS?
I had, yes. I had to do a lot of research to get the array working 
"optimally". I didn't need to repartition the spare so this carried over 
to its being used as an OS disk.

I actually lost the "Green" array twice - and learned some valuable lessons:

1. I had an 8-port SCSI card which was dropping the disks due to the 
timeout issue mentioned by Chris. That caused the first array failure. 
Technically all the data was on the disks - but temporarily 
irrecoverable as disks were constantly being dropped. I made a mistake 
during ddrescue which simultaneously destroyed two disks' data, meaning 
that the recovery operation was finally for nought. The only consolation 
was that I had very little data at the time and none of it was 
irreplaceable.

2. After replacing the SCSI card with two 4-port SATA cards, a few 
months later I still had a double-failure (the second failure being 
during the RAID5 rebuild). This time it was only due to bad disks and a 
lack of scrubbing/early warning - clearly my own fault.

Having learnt these lessons, I'm now a big fan of scrubbing and backups. ;)

I'm also pushing for RAID15 wherever data is mission-critical. I simply 
don't "trust" the reliability of disks any more and I also better 
understand how, by having more and/or larger disks in a RAID5/6 array, 
the overall reliability of that array array plummets.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

