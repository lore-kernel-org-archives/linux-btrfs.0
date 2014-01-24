Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:60886 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaAXX5y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jan 2014 18:57:54 -0500
From: Russell Coker <russell@coker.com.au>
To: george@chinilu.com
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs and ECC RAM
Date: Sat, 25 Jan 2014 10:57:43 +1100
Message-ID: <126421479.FuRWa26fOs@russell.coker.com.au>
In-Reply-To: <52DC3386.7020502@chinilu.com>
References: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de> <1420240.1BEopi7BrR@merkaba> <52DC3386.7020502@chinilu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 19 Jan 2014 12:20:22 George Mitchell wrote:
> I can easily imagine btrfs 
> taking a system down due to memory error, but not btrfs causing data 
> corruption due to a memory error.

I had a system which had apparently worked OK on Ext4 but had some memory 
errors.  After twice having a serious BTRFS corruption (needed backup-format-
restore) I ran memtest and found that a DIMM was broken.

In that sort of situation it seems that BTRFS is likely to be more fragile due 
to the more complex data structures and due to the fact that it's a newer 
filesystem with less corner cases handled.

That said, it's working well for me on a few systems without ECC RAM.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

