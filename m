Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35607 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbbH1R0k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 13:26:40 -0400
Date: Fri, 28 Aug 2015 19:26:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Byongho Lee <bhlee.kernel@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs-progs: fix memory leak in btrfs-map-logical
 main()
Message-ID: <20150828172603.GH11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1440689898-35178-1-git-send-email-bhlee.kernel@gmail.com>
 <1440689898-35178-3-git-send-email-bhlee.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1440689898-35178-3-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 28, 2015 at 12:38:17AM +0900, Byongho Lee wrote:
> In btrfs-map-logical main(), strdup() allocates memory to output_file,
> but that memory is not freed.
> So add missing free() calls before return.
> 
> Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>

Applied, thanks.
