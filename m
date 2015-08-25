Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbbHYPgm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 11:36:42 -0400
Date: Tue, 25 Aug 2015 17:36:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Byongho Lee <bhlee.kernel@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix memory leaks in error path
Message-ID: <20150825153607.GI10756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1440126612-53381-1-git-send-email-bhlee.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1440126612-53381-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 21, 2015 at 12:10:12PM +0900, Byongho Lee wrote:
> This patch includes below fixes in error path:
> 1. fix memory leaks if realloc() fails
> 2. add missing call free_history() before return error in scrub_read_file()
> 
> Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>

Applied, thanks.
