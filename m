Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:38971 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaIXVJ3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Sep 2014 17:09:29 -0400
Received: by mail-ie0-f180.google.com with SMTP id ar1so9617435iec.39
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Sep 2014 14:09:28 -0700 (PDT)
Message-ID: <1411592964.22432.1.camel@kepstin.ca>
Subject: Re: Single disk parrallelization
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Jeb Thomson <jet00159@outlook.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Wed, 24 Sep 2014 17:09:24 -0400
In-Reply-To: <BLU406-EAS1974279D81BF03735D65B479AB40@phx.gbl>
References: <BLU406-EAS1974279D81BF03735D65B479AB40@phx.gbl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2014-09-19 at 13:10 -0500, Jeb Thomson wrote:
> With the advanced features of btrfs, it would be an additional 
> simple task to make different platters run in parallel.
> 
> In this case, say a disk has three platters, and so three seek heads 
> as well. If we can identify that much, and what offsets they are at, 
> it then becomes a trivial matter to place the reads and writes to 
> different platters at the same time.
> 
> In affect, this means each platter should be operating as a single 
> virtualized unit, instead of one single unit... 
> 

If you look at a disk benchmark of a modern multi-platter drive, e.g.
http://www.anandtech.com/show/8265/wd-red-pro-review-4-tb-drives-for-nas-systems-benchmarked/4
(All of the drives in this review have 4 or 5 platters)
You'll see that the performance is a fairly smooth curve down from max 
speed (outer edge of the platters) to min speed (inner edge of the 
platters).

Since this is a smooth curve, rather than starting high, going down, 
then starting high on the next platter and going down again, this 
means that the drive controller is already writing to all of the 
platters at the same time - or at the very least, writing in a striped 
pattern between platters without moving the seek heads. There's 
nothing you could do at the OS level which would make it faster 
(besides preferring to read and write at the lower LBAs of the drive).

-- 
Calvin Walton <calvin.walton@kepstin.ca>
