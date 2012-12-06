Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45747 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab2LFHA5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Dec 2012 02:00:57 -0500
Date: Thu, 6 Dec 2012 14:59:15 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Thorn Roby <Thorn.Roby@harlandfs.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Mounted compress-force=zlib, compresses when files copied in,
 but not when written directly by application
Message-ID: <20121206065914.GA5294@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <loom.20121204T201625-335@post.gmane.org>
 <20121205020131.GA5204@liubo>
 <6726B0D4C83B3047A636A714BAB0B92306C5A4@DSM-SRV-MBX2.harlandfs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6726B0D4C83B3047A636A714BAB0B92306C5A4@DSM-SRV-MBX2.harlandfs.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 05, 2012 at 05:42:51PM +0000, Thorn Roby wrote:
> My previous reply was incorrect in one point - the data is never copied from the transaction log into the sparse datafiles, instead the application writes the same data independently to both locations.
> Also, I failed to mention that the files are memmapped, and it's possible that the write operations attempt to use DIRECT_IO, which I believe is disabled by btrfs with compression - is it possible that an attempt to use DIRECT_IO or memmapped files would prevent compression?
> 

Actually, writting with DIRECT_IO will fall back to buffer write for
safety, and mmap files just dirty pages, should be same with buffer
write, so it might be other reasons.

thanks,
liubo
