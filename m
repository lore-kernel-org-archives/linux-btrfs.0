Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33627 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932127AbdJZRSr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 13:18:47 -0400
Date: Thu, 26 Oct 2017 19:16:57 +0200
From: David Sterba <dsterba@suse.cz>
To: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
Cc: Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs-progs: convert: Open the fs readonly for rollback
Message-ID: <20171026171657.GB3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171026072837.27460-1-wqu@suse.com>
 <516DDBE5B1D92D42BCF7A2E37F045A5D01479E236E@G08CNEXMBPEKD02.g08.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <516DDBE5B1D92D42BCF7A2E37F045A5D01479E236E@G08CNEXMBPEKD02.g08.fujitsu.local>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 26, 2017 at 08:35:29AM +0000, Gu, Jinxiang wrote:
> > Cc: dsterba@suse.cz
> > Subject: [PATCH] btrfs-progs: convert: Open the fs readonly for rollback
> > 
> > For rollback, we only needs to open the fs to check if it meets the condition to rollback.
> > And this RW read makes us failed to rollback btrfs with v2 space cache.
> > 
> > In fact, we don't even start a transaction during rollback.
> > 
> > So open the fs RO for rollback, to avoid v2 space cache problem.
> > 
> > Reported-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> > Signed-off-by: Qu Wenruo <wqu@suse.com>

> Reviewed-by: Gu JinXiang <gujx@cn.fujitsu.com>
> Tested-by: Gu JinXiang <gujx@cn.fujitsu.com>

Applied, thanks.
