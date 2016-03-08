Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:39996 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbcCHMe5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Mar 2016 07:34:57 -0500
Subject: Re: [PATCH 1/2] Btrfs: make mapping->writeback_index point to the
 last written page
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <1457398582-12606-1-git-send-email-bo.li.liu@oracle.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <56DEC6EE.9000002@googlemail.com>
Date: Tue, 8 Mar 2016 13:34:54 +0100
MIME-Version: 1.0
In-Reply-To: <1457398582-12606-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/08/16 01:56, Liu Bo wrote:
> If sequential writer is writing in the middle of the page and it just redirties
> the last written page by continuing from it.
> 
> In the above case this can end up with seeking back to that firstly redirtied
> page after writing all the pages at the end of file because btrfs updates
> mapping->writeback_index to 1 past the current one.
> 
> For non-cow filesystems, the cost is only about extra seek, while for cow 
> filesystems such as btrfs, it means unnecessary fragments.
> 
> To avoid it, we just need to continue writeback from the last written page.
> 
> This also updates btrfs to behave like what write_cache_pages() does, ie, bail
>  out immediately if there is an error in writepage().
> 
> <Ref: https://www.spinics.net/lists/linux-btrfs/msg52628.html>
> 
> Reported-by: Holger Hoffstätte <holger.hoffstaette@googlemail.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Very nice, seems to work as advertised. Can't speak for the data integrity
implications, but for the functionality of both patches:

Tested-by: Holger Hoffstätte <holger.hoffstaette@googlemail.com>

Thank you!
Holger

