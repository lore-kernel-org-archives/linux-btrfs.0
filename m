Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45782 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbaFWLfM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 07:35:12 -0400
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs on whole disk (no partitions)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>
	<2316027.LZEnVG8laK@xev>
	<CAPLrYETdzeT_Yia-nnbZBMvGxU3x7tCFiJSv3rNJezMsjce3Zw@mail.gmail.com>
	<6CA8020B-EB92-4A44-8AA5-3F69709F81F2@colorremedies.com>
	<CAK5rZE6gfmQsZz3W_8t=pkKEk_rzqUn5hQVv0sbt8p7qbdhSdQ@mail.gmail.com>
	<DE35C679-30FE-44DB-9FD7-FD6DCD6FD615@colorremedies.com>
Date: Mon, 23 Jun 2014 07:34:38 -0400
In-Reply-To: <DE35C679-30FE-44DB-9FD7-FD6DCD6FD615@colorremedies.com> (Chris
	Murphy's message of "Sun, 22 Jun 2014 12:31:44 -0600")
Message-ID: <yq1fvivj1v5.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "Chris" == Chris Murphy <lists@colorremedies.com> writes:

Chris> Does anyone know if blktrace will intercept the actual SCSI
Chris> commands sent to the drive? Or is there a better utility to use
Chris> for this? When I use it unfiltered, I'm not seeing SCSI write
Chris> commands at all.

# echo scsi:scsi_dispatch_cmd_start > /sys/kernel/debug/tracing/set_event 
# echo 1 > /sys/kernel/debug/tracing/tracing_on
[do stuff]
# cat /sys/kernel/debug/tracing/trace

-- 
Martin K. Petersen	Oracle Linux Engineering
