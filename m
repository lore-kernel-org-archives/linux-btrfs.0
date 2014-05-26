Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:38012 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaEZQTw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 May 2014 12:19:52 -0400
From: Russell Coker <russell@coker.com.au>
To: Martin <m_btrfs@ml1.co.uk>
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs filesystem freezing during snapshots
Date: Tue, 27 May 2014 02:19:47 +1000
Message-ID: <1597628.qMVRAlqGPk@xev>
In-Reply-To: <llvm4o$9uv$1@ger.gmane.org>
References: <CA+3u+RcGa2Xr+mzwGL-V89A7DEa05B_NS+cgS-Es1b3d8b5xKg@mail.gmail.com> <llvm4o$9uv$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 26 May 2014 16:20:55 Martin wrote:
> That looks to be running on top of drbd which will add a network write
> overhead (unless you are dangerously running asynchronously!). Hence you
> will see IO speed related limits a little sooner...

http://etbe.coker.com.au/2012/01/05/drbd-benchmarking/

Last time I did DRBD performance testing I found that the synchronous option 
was FASTER.  My theory is that no-one does much work on the options that 
aren't recommended.
 
-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

