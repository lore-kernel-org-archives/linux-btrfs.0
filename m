Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:53998 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaKWHmM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Nov 2014 02:42:12 -0500
Received: from babycakes.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 7A3A42094C
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Nov 2014 18:42:09 +1100 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: Re: open_ctree problem
Date: Sun, 23 Nov 2014 18:42:07 +1100
References: <201411230220.05721.russell@coker.com.au>
In-Reply-To: <201411230220.05721.russell@coker.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201411231842.07259.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Strangely I repeated the same process on the same system (btrfs-zero-log and 
mount read-only) and it worked.  While it's a concern that repeating the same 
process gives different results it's nice that I'm getting all my data back.

On Sun, 23 Nov 2014, Russell Coker <russell@coker.com.au> wrote:
> I have a workstation running Linux 3.14.something on a 120G SSD.  It
> recently had a problem and now the root filesystem can't be mounted, here
> is the message I get when trying to mount it read-only on Debian kernel
> 3.16.2-3:
> 
> [4703937.784447] BTRFS info (device loop0): disk space caching is enabled
> [4703938.754247] BTRFS: log replay required on RO media
> [4703938.794148] BTRFS: open_ctree failed
> 
> When I tried to boot it normally it gave a lot of kernel messages and
> failed to mount it.
> 
> Here's the error I get from the btrfs-zero-log in btrfs-tools
> 0.19+20130501-1:
> 
> # btrfs-zero-log yayia-corrupt
> extent buffer leak: start 157263929344 len 4096
> *** Error in `btrfs-zero-log': corrupted double-linked list:
> 0x0000000001068960 ***
> Aborted
> 
> I installed btrfs-tools 3.17-1 and then btrfs-zero-log ran without error. 
> But when I tried to mount the filesystem I got the attached kernel error
> when trying to mount with Debian kernel 3.16.2-3.
> 
> Any suggestions on what I should do next?


-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
