Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:56465 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaETX3Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 19:29:25 -0400
Message-ID: <537BE54B.3060603@zytor.com>
Date: Tue, 20 May 2014 16:29:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: Chris Mason <clm@fb.com>
Subject: Re: Formalizing the use of Boot Area B
References: <537403E3.6090902@zytor.com>
In-Reply-To: <537403E3.6090902@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/14/2014 05:01 PM, H. Peter Anvin wrote:
> It turns out that the primary 64K "Boot Area A" is too small for some
> applications and/or some architectures.
> 
> When I discussed this with Chris Mason, he pointed out that the area
> beyond the superblock is also unused, up until at least the megabyte
> point (from my reading of the mkfs code, it is actually slightly more
> than a megabyte.)
> 
> This is present in all versions of mkfs.btrfs that has the superblock at
> 64K (some very early ones had the superblock at 16K, but that format is
> no longer supported), so all that is needed is formalizing the specs as
> to the use of this area.
> 
> My suggestion is that 64-128K is reserved for extension of the
> superblock and/or any other filesystem uses, and 128-1024K is defined as
> Boot Area B.  However, if there may be reason to reserve more, then we
> should do that.  Hence requesting a formal decision as to the extent and
> ownership of this area.
> 
> 	-hpa
> 

Ping on this?  If I don't hear back on this I will probably just go
ahead and use 128K-1024K.
	
	-hpa


