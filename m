Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39483 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbaCPQWL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 12:22:11 -0400
To: Chris Samuel <chris@csamuel.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: discard synchronous on most SSDs?
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <1756989.4ep0Vdupld@tethys> <20140314192605.GD6143@merlins.org>
	<yq1bnx8y2mi.fsf@sermon.lab.mkp.net> <4448214.x9oPWjPhdL@quad>
Date: Sun, 16 Mar 2014 12:22:05 -0400
In-Reply-To: <4448214.x9oPWjPhdL@quad> (Chris Samuel's message of "Sat, 15 Mar
	2014 16:25:05 +1100")
Message-ID: <yq1a9cqw1ua.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "Chris" == Chris Samuel <chris@csamuel.org> writes:

Chris> It looks like drives that do support it can be detected with the
Chris> kernel helper function ata_fpdma_dsm_supported() defined in
Chris> include/linux/libata.h.

Chris> I wonder if it would be possible to use that knowledge to extend
Chris> the smartctl's --identify functionality to report this?

Queued trim support is indicated in a log page and not the identify
information. However, we can get to the information we want using
smartctl's ability to look at log pages.

I don't have a single drive from any vendor in the lab that supports
queued trim, not even a prototype. I went out and bought a 840 EVO this
morning because the general lazyweb opinion seemed to indicate that this
drive supports queued trim. Well, it doesn't. At least not in the 120GB
version:

# smartctl -l gplog,0x13 /dev/sda
smartctl 5.43 2012-06-30 r3573 [x86_64-linux-3.14.0-rc6+] (local build)
Copyright (C) 2002-12 by Bruce Allen, http://smartmontools.sourceforge.net

General Purpose Log 0x13 does not exist (override with '-T permissive' option)

If there's a drive with a working queued trim implementation out there,
I'd like to know about it...

-- 
Martin K. Petersen	Oracle Linux Engineering
