Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:40737 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaEFEl0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 00:41:26 -0400
From: Russell Coker <russell@coker.com.au>
To: Calvin Walton <calvin.walton@kepstin.ca>, linux-btrfs@vger.kernel.org
Reply-To: russell@coker.com.au
Subject: Re: Please review and comment, dealing with btrfs full issues
Date: Tue, 06 May 2014 14:41:16 +1000
Message-ID: <34134059.SEVPBPKYjM@russell.coker.com.au>
In-Reply-To: <1399314969.4155.1.camel@sasami>
References: <20140505121603.GO10159@merlins.org> <5367C551.6020604@swiftspirit.co.za> <1399314969.4155.1.camel@sasami>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 5 May 2014 14:36:09 Calvin Walton wrote:
> The standard response on the mailing list for this issue is to
> temporarily add an additional device to the filesystem (even e.g. a 4GB
> USB flash drive is often enough) - this will add space to allocate a few
> new chunks, allowing the balance to proceed. You can remove the extra
> device after the balance completes.

I once had a situation where adding a new device failed due to lack of space.  
That was after I had tried to balance without adding a new device and to 
remove snapshots.

http://etbe.coker.com.au/2014/04/26/btrfs-status-april-2014/

Recently kernel 3.14 allowed fixing a metadata space error that seemed to be 
impossible to solve with 3.13.  So it's possible that some of my other 
problems with a lack of metadata space could have been solved with kernel 3.14 
too.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

