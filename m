Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40469 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751611AbeCVN0u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 09:26:50 -0400
Date: Thu, 22 Mar 2018 14:24:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/6] Fix long standing -EOPNOTSUPP problem caused by
 large inline extent
Message-ID: <20180322132424.GX6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180320064229.31493-1-wqu@suse.com>
 <20180321155115.GT6955@twin.jikos.cz>
 <74866cc8-788b-233c-e52f-9ac413e5e6af@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <74866cc8-788b-233c-e52f-9ac413e5e6af@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 22, 2018 at 08:12:31AM +0800, Qu Wenruo wrote:
> > Applied, thanks. I had to fix the test, fallocate may fail, so a file of
> > given size is created directly.
> 
> The fix looks good, and I learn a new trick.
> 
> But I'm wondering how could it fail.
> 
> Nowadays /tmp should be tmpfs created by systemd, which supports fallocate.
> Or is the CI things doesn't follow this?

Unless /tmp is not on tmpfs because this is not always the smartest
thing to do and also when /tmp is on ext3 for historical reasons.
