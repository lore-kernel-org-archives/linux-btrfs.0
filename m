Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:37600 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752263AbcKPLAf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 06:00:35 -0500
Date: Wed, 16 Nov 2016 16:00:31 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Martin Steigerwald <martin.steigerwald@teamix.de>
Cc: <linux-btrfs@vger.kernel.org>, Martin <martin@lichtvoll.de>
Subject: Re: degraded BTRFS RAID 1 not mountable: open_ctree failed, unable
 to find block group for 0
Message-ID: <20161116160031.59041b46@natsu>
In-Reply-To: <3374757.aMVjisyVFB@merkaba>
References: <18970348.FUMEOFOSb3@merkaba>
        <20161116154336.543a326b@natsu>
        <3374757.aMVjisyVFB@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 16 Nov 2016 11:55:32 +0100
Martin Steigerwald <martin.steigerwald@teamix.de> wrote:

> I do think that above kernel messages invite such a kind of interpretation
> tough. I took the "BTRFS: open_ctree failed" message as indicative to some
> structural issue with the filesystem.

For the reason as to why the writable mount didn't work, check "btrfs fi df"
for the filesystem to see if you have any "single" profile chunks on it: quite
likely you did already mount it "degraded,rw" in the past *once*, after which
those "single" chunks get created, and consequently it won't mount r/w anymore
(without lifting the restriction on the number of missing devices as proposed).

-- 
With respect,
Roman
