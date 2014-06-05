Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46001 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbaFEX6b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 19:58:31 -0400
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Using BTRFS on SSD now ?
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <2215647.hErg5R77lo@zafu> <20140605145632.GD14713@merlins.org>
	<FFF0E455-5905-47D4-A768-96CA2FEDF3B3@colorremedies.com>
	<20140605190526.GS7210@merlins.org>
	<pan$4b696$bb5c3db8$50f45a4e$fdad0f36@cox.net>
Date: Thu, 05 Jun 2014 19:58:26 -0400
In-Reply-To: <pan$4b696$bb5c3db8$50f45a4e$fdad0f36@cox.net> (Duncan's message
	of "Thu, 5 Jun 2014 22:25:26 +0000 (UTC)")
Message-ID: <yq14mzyzz6l.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "Duncan" == Duncan  <1i5t5.duncan@cox.net> writes:

Duncan> OTOH, certain high-performance hardware goes beyond the current
Duncan> standard and does a queued trim, without forcing a flush of the
Duncan> queue in the process.  But this hardware tends to be rather rare
Duncan> and expensive,

Queued trim has started to appear in consumer SSDs. However, since we're
the only OS that supports it the feature has come off to a bumpy start.
We tried to enable it on a drive model that passed testing here but we
had to revert to unqueued when bug reports started rolling in this week.

Duncan> (FWIW, in new enough versions of smartctl, smartctl -i will have
Duncan> a "SATA Version is:" line, but even my newer Corsair Neutrons
Duncan> report only SATA 2.5, so obviously they don't support queued
Duncan> trim by the standard, tho it's still possible they implement it
Duncan> beyond the standard, I simply don't know.)

The reported SATA version is in no way indicative of whether a drive
supports queued trim. The capability flag was put a highly unusual place
in the protocol. I posted a patch that makes this information available
in sysfs a while back. However, the patch is currently being reworked to
support a debug override...

Until then, the following command will give you the answer:

# smartctl -l gplog,0x13 /dev/sda | grep 0000:
0000000: 01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 |................|
         ^^          ^^
These two 01 fields indicate that the drive supports queued trim.

-- 
Martin K. Petersen	Oracle Linux Engineering
