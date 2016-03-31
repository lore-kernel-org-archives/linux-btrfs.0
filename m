Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53879 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbcCaQMh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 12:12:37 -0400
Date: Thu, 31 Mar 2016 18:12:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH v9 00/19] Btrfs dedupe framework
Message-ID: <20160331161201.GD6230@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1459324574-28063-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459324574-28063-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 30, 2016 at 03:55:55PM +0800, Qu Wenruo wrote:
> This March 30th patchset update mostly addresses the patchset structure
> comment from David:
> 1) Change the patchset sequence
>    Not If only apply the first 14 patches, it can provide the full
>    backward compatible in-memory only dedupe backend.
>
>    Only starts from patch 15, on-disk format will be changed.
> 
>    So patch 1~14 is going to be pushed for next merge window, while I'll
>    still submit them all for review purpose.

I'll buy 1-10 with the ioctl hidden under the BTRFS_DEBUG config option
until the interface is settled.
