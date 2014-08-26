Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41302 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329AbaHZLC2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Aug 2014 07:02:28 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 81F5BAB13
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Aug 2014 11:02:27 +0000 (UTC)
Date: Tue, 26 Aug 2014 13:02:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: shrink further sizeof(struct extent_buffer)
Message-ID: <20140826110226.GO29981@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1408015514-18021-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1408015514-18021-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 14, 2014 at 12:25:14PM +0100, Filipe Manana wrote:
> The map_start and map_len fields aren't used anywhere, so just remove
> them. On a x86_64 system, this reduced sizeof(struct extent_buffer)
> from 296 bytes to 280 bytes, and therefore 14 extent_buffer structs can
> now fit into a page instead of 13.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

Nice catch.
