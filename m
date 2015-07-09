Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043AbbGIR5M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jul 2015 13:57:12 -0400
Date: Thu, 9 Jul 2015 19:57:10 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix list transaction->pending_ordered corruption
Message-ID: <20150709175709.GY726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1435952800-23922-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435952800-23922-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 03, 2015 at 08:46:40PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
...
> 
> Cc: stable@vger.kernel.org
> Fixes: 50d9aa99bd35 ("Btrfs: make sure logged extents complete in the current transaction V3"
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Good catch and thanks for looking up the offending commit.

Reviewed-by: David Sterba <dsterba@suse.com>
