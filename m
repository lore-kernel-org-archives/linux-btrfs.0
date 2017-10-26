Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35674 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932291AbdJZRxw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 13:53:52 -0400
Date: Thu, 26 Oct 2017 19:52:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 1/3] btrfs-progs: Refactor test_minimum_size to use
 calculated minimal device size
Message-ID: <20171026175203.GD3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171016082258.27815-1-wqu@suse.com>
 <20171016083112.GC495@fnst.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171016083112.GC495@fnst.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 16, 2017 at 04:31:12PM +0800, Lu Fengqi wrote:
> On Mon, Oct 16, 2017 at 04:22:56PM +0800, Qu Wenruo wrote:
> >test_minimum_size() function is only called to check if provided device
> >is large enough.
> >
> >However the minimal device size only needs to be calculated once, and
> >can be reused everywhere.
> >
> >Refactor that function to make later modification easier.
> >
> >Signed-off-by: Qu Wenruo <wqu@suse.com>
> 
> Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Applied, thanks.
