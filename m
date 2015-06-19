Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56418 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbbFSPKh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jun 2015 11:10:37 -0400
Date: Fri, 19 Jun 2015 17:10:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: pass unaligned length to btrfs_cmp_data()
Message-ID: <20150619151035.GO6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1434661803-31188-1-git-send-email-mfasheh@suse.de>
 <1434661803-31188-2-git-send-email-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434661803-31188-2-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 18, 2015 at 02:10:02PM -0700, Mark Fasheh wrote:
> In the case that we dedupe the tail of a file, we might expand the dedupe
> len out to the end of our last block. We don't want to compare data past
> i_size however, so pass the original length to btrfs_cmp_data().
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>

Reviewed-by: David Sterba <dsterba@suse.cz>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
