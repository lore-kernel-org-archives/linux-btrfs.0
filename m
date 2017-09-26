Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:50334 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031574AbdIZSfw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 14:35:52 -0400
Date: Tue, 26 Sep 2017 23:33:19 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Ferry Toth <ftoth@telfort.nl>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Give up on bcache?
Message-ID: <20170926233319.6324764d@natsu>
In-Reply-To: <oqe0fo$keo$1@blaine.gmane.org>
References: <oqe0fo$keo$1@blaine.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 26 Sep 2017 16:50:00 +0000 (UTC)
Ferry Toth <ftoth@telfort.nl> wrote:

> https://www.phoronix.com/scan.php?page=article&item=linux414-bcache-
> raid&num=2
> 
> I think it might be idle hopes to think bcache can be used as a ssd cache 
> for btrfs to significantly improve performance..

My personal real-world experience shows that SSD caching -- with lvmcache --
does indeed significantly improve performance of a large Btrfs filesystem with
slowish base storage.

And that article, sadly, only demonstrates once again the general mediocre
quality of Phoronix content: it is an astonishing oversight to not check out
lvmcache in the same setup, to at least try to draw some useful conclusion, is
it Bcache that is strangely deficient, or SSD caching as a general concept
does not work well in the hardware setup utilized.

-- 
With respect,
Roman
