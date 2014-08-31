Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:42219 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751429AbaHaRBH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Aug 2014 13:01:07 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: 3.17: Yay! New sizes in df -h
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <2090485.596Ci4qveW@merkaba>
Date: Sun, 31 Aug 2014 11:01:08 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <894C7EA0-D587-4058-B7F8-ECD4933A4C79@colorremedies.com>
References: <1940832.0FjNKhTY79@merkaba> <B16D2447-74E8-44CD-BC56-BB3AA7E8A99C@colorremedies.com> <2090485.596Ci4qveW@merkaba>
To: Martin Steigerwald <Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 31, 2014, at 4:34 AM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> 
> I also use compress=lzo on it, although it I wonder whether its necessary as I 
> think the Crucial m500 mSATA SSD firmware compresses itself while the Intel
> SSD 320 SATA SSD firmware does not. But still even with compression in the
> firmware, it BTRFS compresses I can use more of the capacity. I wonder
> whether this can harm the reliability of the SSD, if its firmware relies on
> at least partly compressible data.

Seems unlikely because application binaries aren't very compressible, and user videos/images aren't compressible at all because they're already highly compressed.

> Hmmm, I see. Then it might not be compression at all what explains the 
> differences I see?

I don't know. At the very least I'd repost with bug in caps in your subject, and point out the Used+Avail≠Size discrepancy, and include strace df results. I think your results are sufficiently confusing to consider it a bug.


Chris Murphy

