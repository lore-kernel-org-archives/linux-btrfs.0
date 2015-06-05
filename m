Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37657 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbbFERAO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Jun 2015 13:00:14 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 83F64ABF2
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2015 17:00:13 +0000 (UTC)
Date: Fri, 5 Jun 2015 19:00:13 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: cleanup, stop casting for extent_map->lookup
 everywhere
Message-ID: <20150605170013.GX6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1433343348-8158-1-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433343348-8158-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 03, 2015 at 10:55:48AM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> Overloading extent_map->bdev to struct map_lookup * might have started out
> as a means to an end, but it's a pattern that's used all over the place
> now. Let's get rid of the casting and just add a union instead.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
