Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52876 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbcEPIpk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 04:45:40 -0400
Date: Mon, 16 May 2016 10:45:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/7] Btrfs: free sys_array eb as soon as possible
Message-ID: <20160516084514.GC511@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
 <1463184422-13584-4-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1463184422-13584-4-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 13, 2016 at 05:06:59PM -0700, Liu Bo wrote:
> While reading sys_chunk_array in superblock, btrfs creates a temporary
> extent buffer.  Since we don't use it after finishing reading
>  sys_chunk_array, we don't need to keep it in memory.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

This patch is independent of the rest, I'll add it to next.
