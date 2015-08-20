Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:49259 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbbHTDnM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 23:43:12 -0400
From: Russell Coker <russell@coker.com.au>
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Questions on use of NOCOW impact to subvolumes and snapshots
Date: Thu, 20 Aug 2015 13:43:07 +1000
References: <D3CC3E72-929E-4ADF-826F-62DCB6BD827C@lime-technology.com> <CAJCQCtSVn7BSYY=Ofq6OsKfHyv_PTKGOg7uP=tUC4XTNQ42v0w@mail.gmail.com>
In-Reply-To: <CAJCQCtSVn7BSYY=Ofq6OsKfHyv_PTKGOg7uP=tUC4XTNQ42v0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201508201343.07618.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 20 Aug 2015 11:55:43 AM Chris Murphy wrote:
> > Question 1:  If I apply the NOCOW attribute to a file or directory, how
> > does that affect my ability to run btrfs scrub?
> 
> nodatacow includes nodatasum and no compression. So it means these
> files are presently immune from scrub check and repair so long as it's
> based on checksums. I don't know if raid56 scrub compares to parity
> and recomputes parity (assumes data is correct), absent checksums,
> which would be similar to how md raid 56 does it.

Linux Software RAID could recreate a mismatched block from RAID-6 parity but 
doesn't do so.  It could be that a block was changed correctly but didn't get 
the parity data written so such "correction" would be reverting a change.  So 
Linux Software RAID only regenerates parity for a scrub and makes both disks 
have the same data for RAID-1.

There's no good solution to these problems without doing the sorts of things 
that WAFL, ZFS, and BTRFS do.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
