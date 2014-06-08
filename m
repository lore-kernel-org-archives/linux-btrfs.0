Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40606 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbaFHQv3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Jun 2014 12:51:29 -0400
To: Pavel Volkov <sailor@lists.xtsubasa.org>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: Using BTRFS on SSD now ?
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <2215647.hErg5R77lo@zafu> <20140605145632.GD14713@merlins.org>
	<FFF0E455-5905-47D4-A768-96CA2FEDF3B3@colorremedies.com>
	<20140605190526.GS7210@merlins.org>
	<pan$4b696$bb5c3db8$50f45a4e$fdad0f36@cox.net>
	<yq14mzyzz6l.fsf@sermon.lab.mkp.net>
	<62fc4c32-37c4-4c4e-b027-761859a12df4@lists.xtsubasa.org>
Date: Sun, 08 Jun 2014 12:51:22 -0400
In-Reply-To: <62fc4c32-37c4-4c4e-b027-761859a12df4@lists.xtsubasa.org> (Pavel
	Volkov's message of "Sun, 08 Jun 2014 18:48:35 +0400")
Message-ID: <yq1mwdnwdit.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "Pavel" == Pavel Volkov <sailor@lists.xtsubasa.org> writes:

Pavel> Is mine a dinosaur drive?
[...]
Pavel> General Purpose Log 0x13 does not exist (override with '-T
Pavel> permissive' option)

The only flags defined in general purpose log page 0x13 are the queued
trim ones. So there is no compelling reason for a drive vendor to
implement that page unless the drive actually supports queued trim. And
consequently it's perfectly normal for that page to be absent.

-- 
Martin K. Petersen	Oracle Linux Engineering
