Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:44993 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755830Ab2ISQuZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Sep 2012 12:50:25 -0400
Date: Wed, 19 Sep 2012 18:50:18 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix off-by-one in file clone
Message-ID: <20120919165018.GC17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1347961943-18185-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1347961943-18185-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 18, 2012 at 05:52:23PM +0800, Liu Bo wrote:
> Btrfs uses inclusive range end for lock_extent(), unlock_extent() and
> related functions, so we made off-by-one errors in file clone.

We're lucky that it's off-by-one in a way that it locks more than it
should. The function is full of such calculations, I didn't spot any
other instances, but another review round would not harm.

Reviewed-by: David Sterba <dsterba@suse.cz>
