Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbbFZOIZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jun 2015 10:08:25 -0400
Date: Fri, 26 Jun 2015 16:08:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Davide Italiano <dccitaliano@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: Improve FL_KEEP_SIZE handling in fallocate.
Message-ID: <20150626140823.GU726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1428383355-1686-1-git-send-email-dccitaliano@gmail.com>
 <1428383355-1686-2-git-send-email-dccitaliano@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1428383355-1686-2-git-send-email-dccitaliano@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 06, 2015 at 10:09:15PM -0700, Davide Italiano wrote:
> - We call inode_size_ok() only if FL_KEEP_SIZE isn't specified.
> - As an optimisation we can skip the call if (off + len)
>   isn't greater than the current size of the file. This operation
>   is called under the lock so the less work we do, the better.
> - If we call inode_size_ok() pass to it the correct value rather
>   than a more conservative estimation.
> 
> Signed-off-by: Davide Italiano <dccitaliano@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
