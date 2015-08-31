Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59571 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbbHaPHW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 11:07:22 -0400
Date: Mon, 31 Aug 2015 17:06:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Byongho Lee <bhlee.kernel@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs-progs: fix memory leak in btrfs-convert main()
Message-ID: <20150831150642.GW11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1440689898-35178-1-git-send-email-bhlee.kernel@gmail.com>
 <1440689898-35178-2-git-send-email-bhlee.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1440689898-35178-2-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 28, 2015 at 12:38:16AM +0900, Byongho Lee wrote:
> In btrfs-convert main(), strdup() allocates memory to fslabel but that
> memory is not freed. We could fix it by adding free() calls to every
> return point, but that would make the code messy because there are
> several return paths.
> So I fix it by changing the code using strdup() with local array and
> strncpy().
> 
> And btrfs-convert main() guarantees that string length of fslabel is not
> to exceed 'BTRFS_LABEL_SIZE', so it's enough to use strcpy() instead of
> strncpy() to copy fslabel in do_convert().
> 
> Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>

Applied, thanks.
