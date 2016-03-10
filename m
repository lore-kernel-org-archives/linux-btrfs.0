Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbcCJNVs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 08:21:48 -0500
Date: Thu, 10 Mar 2016 14:21:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Feifei Xu <xufeifei@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, chandan@linux.vnet.ibm.com
Subject: Re: [PATCH V2] btrfs-progs: Replace hardcoded PAGE_CACHE_SIZE with
 sectorsize.
Message-ID: <20160310132127.GE18908@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1457599400-10549-1-git-send-email-xufeifei@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1457599400-10549-1-git-send-email-xufeifei@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 10, 2016 at 04:43:20PM +0800, Feifei Xu wrote:
> PAGE_CACHE_SIZE is hardcoded to 4K in cmds-restore.c. Correct
> value should be sector size. Fix this through replacing
> hardcoded 4K to sectorsize.
> 
> Signed-off-by: Feifei Xu <xufeifei@linux.vnet.ibm.com>

Applied, thanks.
