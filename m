Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:35239 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbbLNGnC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 01:43:02 -0500
From: Russell Coker <russell@coker.com.au>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Subject: Re: dear developers, can we have notdatacow + checksumming, plz?
Date: Mon, 14 Dec 2015 17:42:56 +1100
Cc: linux-btrfs@vger.kernel.org
References: <1450069158.2388.72.camel@scientia.net>
In-Reply-To: <1450069158.2388.72.camel@scientia.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201512141742.56891.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 14 Dec 2015 03:59:18 PM Christoph Anton Mitterer wrote:
> I've had some discussions on the list these days about not having
> checksumming with nodatacow (mostly with Hugo and Duncan).
> 
> They both basically told me it wouldn't be straight possible with CoW,
> and Duncan thinks it may not be so much necessary, but none of them
> could give me really hard arguments, why it cannot work (or perhaps I
> was just too stupid to understand them ^^)... while at the same time I
> think that it would be generally utmost important to have checksumming
> (real world examples below).

My understanding of BTRFS is that the metadata referencing data blocks has the 
checksums for those blocks, then the blocks which link to that metadata (EG 
directory entries referencing file metadata) has checksums of those.  For each 
metadata block there is a new version that is eventually linked from a new 
version of the tree root.

This means that the regular checksum mechanisms can't work with nocow data.  A 
filesystem can have checksums just pointing to data blocks but you need to 
cater for the case where a corrupt metadata block points to an old version of 
a data block and matching checksum.  The way that BTRFS works with an entire 
checksumed tree means that there's no possibility of pointing to an old 
version of a data block.

The NetApp published research into hard drive errors indicates that they are 
usually in small numbers and located in small areas of the disk.  So if BTRFS 
had a nocow file with any storage method other than dup you would have metadata 
and file data far enough apart that they are not likely to be hit by the same 
corruption (and the same thing would apply with most Ext4 Inode tables and 
data blocks).  I think that a file mode where there were checksums on data 
blocks with no checksums on the metadata tree would be useful.  But it would 
require a moderate amount of coding and there's lots of other things that the 
developers are working on.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
