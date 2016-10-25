Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35377 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750813AbcJYOfw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Oct 2016 10:35:52 -0400
Date: Tue, 25 Oct 2016 16:35:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/4] btrfs-progs: Fix memory leak in
 write_raid56_with_parity
Message-ID: <20161025143545.GS22935@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161024024335.6770-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161024024335.6770-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 24, 2016 at 10:43:32AM +0800, Qu Wenruo wrote:
> Ebs and pointers are allocated, but if any of the allocation failed, we
> should free the allocated memory.
> 
> Reported-by: David Sterba <dsterba@suse.cz>
> Resolves-Coverity-CID: 1296749
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

1-4 applied, thanks. Please don't put my reported-by there.
