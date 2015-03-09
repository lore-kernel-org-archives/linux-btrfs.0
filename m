Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671AbbCIQnu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Mar 2015 12:43:50 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 5F524AAC8
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Mar 2015 16:43:49 +0000 (UTC)
Date: Mon, 9 Mar 2015 17:43:49 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: send, add missing check for dead clone root
Message-ID: <20150309164348.GG5841@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1425329633-5059-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1425329633-5059-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 02, 2015 at 08:53:52PM +0000, Filipe Manana wrote:
> After we locked the root's root item, a concurrent snapshot deletion
> call might have set the dead flag on it. So check if the dead flag
> is set and abort if it is, just like we do for the parent root.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

Good catch.
