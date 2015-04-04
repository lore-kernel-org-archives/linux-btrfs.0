Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:50364 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbbDDMzN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Apr 2015 08:55:13 -0400
From: Russell Coker <russell@coker.com.au>
To: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs hangs 3.19-10
Date: Sat, 4 Apr 2015 12:55:08 +0000
Cc: linux-btrfs@vger.kernel.org
References: <CAGqmi74e_U5-UVUy+MHbxc2f-38pRyjK1Zo0Up-V9ndFpv-bXA@mail.gmail.com> <20150402191312.1ee31af3@natsu> <pan$a9ed6$bb1c7fdd$74534d5d$7b638441@cox.net>
In-Reply-To: <pan$a9ed6$bb1c7fdd$74534d5d$7b638441@cox.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201504041255.08052.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 3 Apr 2015 05:14:12 AM Duncan wrote:
> Well, btrfs itself isn't really stable yet...  Stable series should be 
> stable at least to the extent that whatever you're using in them is, but 
> with btrfs itself not yet entirely stable... 

Also for stable operation you want both forward and backward compatability.  
You could make an Ext3 filesystem and expect that any random ancient Linux box 
you are likely to encounter can read it.  Even Ext4 has been supported for a 
long time and most systems you are likely to encounter won't have any problems 
with it.

I recently made a BTRFS filesystem on a Debian/Jessie system (kernel 3.16.7) 
with default options and discovered that Debian/Wheezy (kernel 3.2.65) can't 
read it.  I think that one criteria for "stable" in a filesystem is that 
kernels from a couple of previous releases can mount it.  By that criteria 
BTRFS won't be "stable" for use in Debian for about 4 years.

As an aside are there options to mkfs.btrfs that would make a filesystem 
mountable by kernel 3.2.65?  If so I'll file a Debian/Jessie bug report 
requesting that a specific mention be added to the man page.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
