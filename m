Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbcEBJjm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 May 2016 05:39:42 -0400
Date: Mon, 2 May 2016 11:39:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Ashish Samant <ashish.samant@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix BUG_ON condition in
 scrub_setup_recheck_block()
Message-ID: <20160502093924.GG29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1461980039-25200-1-git-send-email-ashish.samant@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1461980039-25200-1-git-send-email-ashish.samant@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 29, 2016 at 06:33:59PM -0700, Ashish Samant wrote:
> pagev array in scrub_block{} is of size SCRUB_MAX_PAGES_PER_BLOCK.
> page_index should be checked with the same to trigger BUG_ON().
> 
> Signed-off-by: Ashish Samant <ashish.samant@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
