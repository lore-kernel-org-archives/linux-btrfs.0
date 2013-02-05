Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:35335 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab3BENvv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2013 08:51:51 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 63F0D9A03EE
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Feb 2013 06:51:50 -0700 (MST)
Date: Tue, 5 Feb 2013 08:51:47 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: =?utf-8?B?IlBpb3RyIFBhd8WCb3ci?= <pp@siedziba.pl>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:1772
Message-ID: <20130205135147.GD2275@localhost.localdomain>
References: <55e4fbbdada4ee37bdccac2537683d83.squirrel@lampka.siedziba.pl>
 <20130204165825.GC2275@localhost.localdomain>
 <c70388910a26ddb79b9f358e0ccb78f5.squirrel@lampka.siedziba.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <c70388910a26ddb79b9f358e0ccb78f5.squirrel@lampka.siedziba.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 05, 2013 at 01:55:17AM -0700, "Piotr Pawłow" wrote:
> > mounts before it panics, can you capture all the output and reply to this
> > email
> > with it?  Thanks,
> 
> I'm sorry, I could not keep it longer in that state. I used btrfs-image to
> create metadata image from both disks, then let it run without space
> cache.
> 
> Unfortunately, when I run qemu with these images:
> 

Yeah you can't mount images, we clear out the chunk tree so nothing works.
Let me know if you run into any problems in the future.  Thanks,

Josef
