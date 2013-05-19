Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:31811 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752179Ab3ESTeK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 May 2013 15:34:10 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: btrfs (general) raid for other filesystems?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <knb7di$8ee$1@ger.gmane.org>
Date: Sun, 19 May 2013 13:34:07 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <C773E07F-F3BE-4C1A-8FAE-D72968F475B2@colorremedies.com>
References: <knb28t$p9p$1@ger.gmane.org> <CAFvQSYQObGsKCf3iPtErfFvdQv6vqwc_KNAm5wt763ChrZWtUA@mail.gmail.com> <knb7di$8ee$1@ger.gmane.org>
To: Martin <m_btrfs@ml1.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 19, 2013, at 12:59 PM, Martin <m_btrfs@ml1.co.uk> wrote:
> 
> btrfs-raid offers a greater variety and far greater flexibility of raid
> options individually for filedata and metadata at the filesystem level.

Well it really doesn't. The btrfs raid advantages leverage prior work that makes btrfs what it is.


> OK... So we make all of lvm, md-raid, and drbd all redundant!

No they are different things for different use cases. What you seem to be asking for is for a ZFS-like feature that allows other file systems to exist on ZFS, and thereby gaining some of the advantage of the underlying file system.


Chris Murphy