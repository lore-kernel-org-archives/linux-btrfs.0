Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37162 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbcABL7w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jan 2016 06:59:52 -0500
Date: Sat, 2 Jan 2016 02:57:56 -0500
From: Sanidhya Solanki <jpage.lkml@gmail.com>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds the files and options needed for Hybrid
 Storage
Message-ID: <20160102025756.77c4a03b@gmail.com>
In-Reply-To: <3527511.yiKDscxFVa@merkaba>
References: <1451704112-25463-1-git-send-email-jpage.lkml@gmail.com>
	<3527511.yiKDscxFVa@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 02 Jan 2016 12:40:46 +0100
Martin Steigerwald <martin@lichtvoll.de> wrote:
> Or is this something different?
Yes, Martin this patch starts the implementation that I hope will lead
to the implementation of a Hybrid Cache to the BTRFS.

However, there is no need to limit ourselves to just Flash devices.
Depending on how the implementation for 3D X-point devices and NVDIMMs
work out, this can be used to cache on those layers as well.

Thanks.
