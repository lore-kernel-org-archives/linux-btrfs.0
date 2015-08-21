Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:59878 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbbHUDek (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 23:34:40 -0400
From: Russell Coker <russell@coker.com.au>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Questions on use of NOCOW impact to subvolumes and snapshots
Date: Fri, 21 Aug 2015 13:34:35 +1000
References: <D3CC3E72-929E-4ADF-826F-62DCB6BD827C@lime-technology.com> <540B3004-C250-4C21-9E53-C38E20258DA9@lime-technology.com> <55D5C376.9090809@gmail.com>
In-Reply-To: <55D5C376.9090809@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201508211334.35570.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 20 Aug 2015 10:09:26 PM Austin S Hemmelgarn wrote:
> > 2:  Out of curiosity, why is data checksumming tied to COW?
> 
> There's no safe way to sanely handle checksumming without COW, because
> there is no way (at least on current hardware) to ensure that the data
> block and the checksums both get written at the exact same time, and
> that one of the writes aborting will cause the other too do so as well.
>   In-place compression is disabled for nodatasum files for essentially
> the same reason (although compression can cause much worse data loss
> than a failed checksum).

A journaling filesystem could have checksums on data blocks.  If Ext4 was 
modified to have checksums it would do that.

But given that a major feature of BTRFS is snapshots it doesn't make much 
sense to implement a separate way of managing checksums.  I think that ZIL is 
the correct way of solving these problems.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
