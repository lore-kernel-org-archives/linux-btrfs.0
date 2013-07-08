Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37374 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3GHQOB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Jul 2013 12:14:01 -0400
Date: Mon, 8 Jul 2013 18:14:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs-progs: remove incorrect slot decrement
Message-ID: <20130708161400.GB18204@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130705202718.GE2260@localhost.localdomain>
 <1373057014-1424-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1373057014-1424-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 05, 2013 at 09:43:34PM +0100, Filipe David Borba Manana wrote:
> In btrfs_set_block_flags() we want to check if the slot
> in the leaf points to the first item in the leaf - if it
> doesn't check if the previous item in the leaf is an extent
> item. By removing this extra slot decrement we are indeed
> checking the item right before the slot, and not the second
> item before.
> 
> V2: Added Josef Bacik's review mention.

Please don't do that. It's ok to increase version if you update code or
changelog/subject, but not just the tags.

thanks,
david
