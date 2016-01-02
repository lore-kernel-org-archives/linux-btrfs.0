Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52431 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751501AbcABT6u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Jan 2016 14:58:50 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id 44958202BF
	for <linux-btrfs@vger.kernel.org>; Sat,  2 Jan 2016 14:58:50 -0500 (EST)
Message-Id: <1451764729.3016753.481194250.0BE48A69@webmail.messagingengine.com>
From: Rasmus Abrahamsen <btrfs@rasmusa.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Rasmus Abrahamsen <btrfs@rasmusa.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: Add big device, remove small device, read-only
Date: Sat, 02 Jan 2016 20:58:49 +0100
In-Reply-To: <CAJCQCtTn1xZ3KLQoPqjDowu__f5AAAXHNye2vU4ceEb6VFK--w@mail.gmail.com>
References: <9E462AAE-481A-4A0D-9918-FF56A73D6F6D@rasmusa.net>
 <CAJCQCtSCJ91FaJ20g-+TKMwGkXeQdEkn1yDf6w+H3=V_8_xshA@mail.gmail.com>
 <1451679613.2761176.480641362.3ADA17DB@webmail.messagingengine.com>
 <CAJCQCtTn1xZ3KLQoPqjDowu__f5AAAXHNye2vU4ceEb6VFK--w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What do you recommend I do? Everything is redundant across disks.
Perhaps I can disconnect the one you mentioned and delete missing.

On Sat, Jan 2, 2016, at 08:56 PM, Chris Murphy wrote:
> On Fri, Jan 1, 2016 at 1:20 PM, Rasmus Abrahamsen <me@rasmusa.net> wrote:
> > [ralle@rasmusahome ~]$ sudo btrfs fi usage /mnt/fortune/
> [snip]
> > Unallocated:
> >    /dev/sda1     137.48GiB
> >    /dev/sdb1      16.00EiB
> >    /dev/sdc1     135.76GiB
> >    /dev/sdd1       3.14TiB
> 
> Another phantom 16.00EiB, this time it appears as unallocated space on
> a devices, rather than free space as it is in a bug I recently filed.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=110111
> 
> 
> -- 
> Chris Murphy
