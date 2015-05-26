Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbbEZOkZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 10:40:25 -0400
Date: Tue, 26 May 2015 16:40:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add the ability to remove csums
Message-ID: <20150526144024.GK23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1432045264-5285-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1432045264-5285-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 19, 2015 at 10:21:04AM -0400, Josef Bacik wrote:
> Sometimes we need to test what happens when we're missing a csum for a range, so
> add an option to btrfs-corrupt-block to be able to remove a csum range.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Applied, thanks.
