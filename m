Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35912 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755326AbbGCQPn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jul 2015 12:15:43 -0400
Date: Fri, 3 Jul 2015 09:15:41 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org, ritter.marcel@gmail.com,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] Btrfs: fix memory leak in the extent_same ioctl
Message-ID: <20150703161541.GD7507@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1435909702-2094-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435909702-2094-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

That looks great, thanks for fixing this Filipe.

On Fri, Jul 03, 2015 at 08:48:22AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We were allocating memory with memdup_user() but we were never releasing
> that memory. This affected pretty much every call to the ioctl, whether
> it deduplicated extents or not.
> 
> This issue was reported on IRC by Julian Taylor and on the mailing list
> by Marcel Ritter, credit goes to them for finding the issue.
> 
> Reported-by: Julian Taylor (jtaylor@IRC)
> Reported-by: Marcel Ritter <ritter.marcel@gmail.com>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
