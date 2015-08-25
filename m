Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbbHYPl0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 11:41:26 -0400
Date: Tue, 25 Aug 2015 17:40:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Byongho Lee <bhlee.kernel@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: fix memory leaks in error path
Message-ID: <20150825154050.GK10756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1440147112-62543-1-git-send-email-bhlee.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1440147112-62543-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 21, 2015 at 05:51:52PM +0900, Byongho Lee wrote:
> This patch includes below fixes in error path:
> 1. fix memory leaks if realloc() fails
> 2. add missing call free_history() before return error in scrub_read_file()
> 
> Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
> ---
> changelog:
> v2:
>   Add one more fix for memory leak when realloc() fails by Zhao Lei's comment.

Sorry I missed the v2, patch updated with Zhao Lei's reviewed-by.
