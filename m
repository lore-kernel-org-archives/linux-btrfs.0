Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43462 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbaCPRuQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 13:50:16 -0400
Date: Sun, 16 Mar 2014 10:50:04 -0700
From: Marc MERLIN <marc@merlins.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org
Message-ID: <20140316175004.GP16946@merlins.org>
References: <1756989.4ep0Vdupld@tethys>
 <20140314192605.GD6143@merlins.org>
 <yq1bnx8y2mi.fsf@sermon.lab.mkp.net>
 <4448214.x9oPWjPhdL@quad>
 <yq1a9cqw1ua.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <yq1a9cqw1ua.fsf@sermon.lab.mkp.net>
Subject: Re: discard synchronous on most SSDs?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 16, 2014 at 12:22:05PM -0400, Martin K. Petersen wrote:
> queued trim, not even a prototype. I went out and bought a 840 EVO this
> morning because the general lazyweb opinion seemed to indicate that this
> drive supports queued trim. Well, it doesn't. At least not in the 120GB
> version:
> 
> # smartctl -l gplog,0x13 /dev/sda
> smartctl 5.43 2012-06-30 r3573 [x86_64-linux-3.14.0-rc6+] (local build)
> Copyright (C) 2002-12 by Bruce Allen, http://smartmontools.sourceforge.net
> 
> General Purpose Log 0x13 does not exist (override with '-T permissive' option)
> 
> If there's a drive with a working queued trim implementation out there,
> I'd like to know about it...

I tried that for you on my 840 EVO 1TB and go the same as you:
legolas:/usr/src# smartctl -l gplog,0x13 /dev/sda
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.14.0-rc5-amd64-i915-preempt-20140216c] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

General Purpose Log 0x13 does not exist (override with '-T permissive' option)

Now, back to the fact that it takes 1.5sec to delete a kernel tree with
discard on, and it doesn't seem faster with discard off on either that
drive or my very old intel SSD, I'm starting to think that this is kind
of a non problem and/or that something else makes rm of a kernel tree
take around 1.5sec

Is is it much faster on an ssd for someone else?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
