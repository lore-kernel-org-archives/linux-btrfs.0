Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390AbbGISA1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jul 2015 14:00:27 -0400
Date: Thu, 9 Jul 2015 20:00:26 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: fix list transaction->pending_ordered
 corruption
Message-ID: <20150709180025.GZ726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1435952800-23922-1-git-send-email-fdmanana@kernel.org>
 <1435958528-1047-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435958528-1047-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 03, 2015 at 10:22:08PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> Cc: stable@vger.kernel.org
> Fixes: 50d9aa99bd35 ("Btrfs: make sure logged extents complete in the current transaction V3"
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

... now for the right patch,

Reviewed-by: David Sterba <dsterba@suse.com>
