Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbcGLQRL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 12:17:11 -0400
Date: Tue, 12 Jul 2016 18:17:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: change BUG_ON()'s to ASSERT()'s in
 backref_cache_cleanup()
Message-ID: <20160712161721.GG10595@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1468288377-10971-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1468288377-10971-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 11, 2016 at 06:52:57PM -0700, Liu Bo wrote:
> Since it is just an in-memory building of the backrefs of several
> btree blocks, nothing is fatal other than memory leaks, so this
> changes BUG_ON()'s to ASSERT()'s.

Agreed, this a good justification. Sometimes the BUG_ON serves as a
last-resort sanity check so it's not like changing all BUG_ON to ASSERT.

> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
