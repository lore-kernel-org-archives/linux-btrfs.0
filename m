Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:55548 "EHLO
	mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2H0Oxa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Aug 2012 10:53:30 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail1.trendhosting.net (Postfix) with ESMTP id DD5D71511F
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Aug 2012 16:43:27 +0100 (BST)
Received: from mail1.trendhosting.net ([127.0.0.1])
	by localhost (thp003.trendhosting.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id h2hwoTGO8sB1 for <linux-btrfs@vger.kernel.org>;
	Mon, 27 Aug 2012 16:43:21 +0100 (BST)
Message-ID: <503B89E1.7030809@pocock.com.au>
Date: Mon, 27 Aug 2012 16:53:21 +0200
From: Daniel Pocock <daniel@pocock.com.au>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: interaction with hardware RAID?
References: <5034BD0D.8050706@pocock.com.au>
In-Reply-To: <5034BD0D.8050706@pocock.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Just following up on this... does anyone know if any of this is
technically feasible even if not implemented/supported today?

Also, do any hardware RAID1 implementations offer something like the
full btrfs checksum functionality?

I've seen HP promoting their `Advanced Data Mirroring' in new Smart
Array products, but I've got no idea if that is just a marketing
gimmick, like the way they use the name `Advanced Data Guard' as a
moniker for RAID6

Looking around in Google, I was pleasantly disturbed to find so many web
sites (including some vendors) using the term `checksum' to refer to a
parity bit

On 22/08/12 13:05, Daniel Pocock wrote:
> 
> 
> 
> It is well documented that btrfs data recovery (after silent corruption)
> is dependent on the use of btrfs's own RAID1.
> 
> However, I'm curious about whether any hardware RAID vendors are
> contemplating ways to integrate more closely with btrfs, for example,
> such that when btrfs detects a bad checksum, it would be able to ask the
> hardware RAID controller to return all alternate copies of the block.
> 
> Is this technically possible within any hardware RAID device today, even
> though not implemented in btrfs?
> 
> Has there been any suggestion that vendors would support this in future,
> presumably for the benefit of btrfs, ZFS and other checksumming filesystems?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
