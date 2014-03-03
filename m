Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:54789 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754878AbaCCWfi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Mar 2014 17:35:38 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfsck does not fix
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <53137AD1.50504@friedels.name>
Date: Mon, 3 Mar 2014 15:35:36 -0700
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Message-Id: <0548C4C7-1664-48F9-9DA3-DB1CC35DB9E6@colorremedies.com>
References: <52C7127F.3060902@friedels.name>	<0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com>	<52D317CF.2070007@friedels.name> <6210673.6TYUkLGl6b@merkaba>	<52DED1C2.60103@friedels.name> <52F6A955.5020808@friedels.name>	<A0A6914C-DDA5-4904-83FA-B59AA420C9C6@colorremedies.com>	<52F73E2B.9080103@friedels.name>	<837FAEE6-9A8E-4A88-AEDF-B9B2B3C3B618@colorremedies.com>	<82A12D91-416E-4B2F-80ED-23ACFD466633@colorremedies.com>	<53010EF9.60805@friedels.name>	<21AD6EBC-FDDA-4BDE-B0B4-D6A8BBAD58F0@colorremedies.com> <pan$475be$cb0c1165$a3d91acc$c206709@cox.net> <5303D6C8.80103@friedels.name> <9583F3D2-78BB-40C3-A1CD-E2D8DE4CA89E@colorremedies.com> <53137AD1.50504@friedels.name>
To: Hendrik Friedel <hendrik@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 2, 2014, at 11:39 AM, Hendrik Friedel <hendrik@friedels.name> wrote:
> 
> I am lacking space why I did the balance (to free one of the two discs).
> So, unless the above helps, it seems, I need to buy another HDD?

It might be worth finding large files to defragment. See the ENOSPC errors during raid1 rebalance thread. It sounds like it might be possible for some fragmented files to be stuck across multiple chunks, preventing conversion.

Otherwise, I'd like to believe for anything semi-important you have a way to back it up, and if not well you probably need another HDD anyway. As they say, raid is not a backup.

> 
> Davids itegration-branch btrfsck tells me:
> 
> ./btrfsck /dev/sda1
> Checking filesystem on /dev/sda1
> UUID: 989306aa-d291-4752-8477-0baf94f8c42f
> checking extents
> checking free space cache
> checking fs roots
> root 256 inode 9579 errors 100, file extent discount
> root 256 inode 9580 errors 100, file extent discount
> root 256 inode 14258 errors 100, file extent discount
> root 256 inode 14259 errors 100, file extent discount
> root 14155 inode 9579 errors 100, file extent discount
> root 14155 inode 9580 errors 100, file extent discount
> root 14155 inode 14258 errors 100, file extent discount
> root 14155 inode 14259 errors 100, file extent discount
> root 14251 inode 9579 errors 100, file extent discount
> root 14251 inode 9580 errors 100, file extent discount

I don't know what this means, even whether it's a significant problem or just noise. 


Chris Murphy

