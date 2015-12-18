Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46070 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091AbbLRSDN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Dec 2015 13:03:13 -0500
Date: Fri, 18 Dec 2015 19:01:06 +0100
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, chandan@mykolab.com
Subject: Re: [PATCH] Btrfs-progs: ftw_add_entry_size: Round up file size to
 sectorsize
Message-ID: <20151218180106.GZ4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1450173720-25543-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1450173720-25543-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 15, 2015 at 03:32:00PM +0530, Chandan Rajendra wrote:
> ftw_add_entry_size() assumes 4k as the block size of the underlying filesystem
> and hence the file sizes computed is incorrect for non-4k sectorsized
> filesystems. Fix this by rounding up file sizes to sectorsize.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Applied, thanks.
