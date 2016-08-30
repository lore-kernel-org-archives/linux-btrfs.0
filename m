Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54652 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752554AbcH3OUW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 10:20:22 -0400
Date: Tue, 30 Aug 2016 16:19:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Lukas Lueg <lukas.lueg@gmail.com>
Subject: Re: [PATCH 2/2] btrfs-progs: fuzz-test: Add image for unaligned tree
 block ptr
Message-ID: <20160830141902.GG16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160830032933.22194-1-quwenruo@cn.fujitsu.com>
 <20160830032933.22194-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160830032933.22194-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 30, 2016 at 11:29:33AM +0800, Qu Wenruo wrote:
> From: Lukas Lueg <lukas.lueg@gmail.com>
> 
> Add test case image for unaligned tree block ptr.
> It should lead to BUG_ON in free_extent_buffer().
> 
> Signed-off-by: Lukas Lueg <lukas.lueg@gmail.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Both applied, thanks.
