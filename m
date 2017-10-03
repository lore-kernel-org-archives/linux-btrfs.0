Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46037 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751740AbdJCQgt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Oct 2017 12:36:49 -0400
Date: Tue, 3 Oct 2017 18:35:13 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: misc-test: use raid1 for data to enable
 mount with -o degraded
Message-ID: <20171003163513.GC31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <8a2f2ee0-dda6-0a6d-ded2-a93a449013f4@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8a2f2ee0-dda6-0a6d-ded2-a93a449013f4@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 03, 2017 at 03:47:26PM +0900, Misono, Tomohiro wrote:
> kernel 4.14 introduces new function for checking if all chunks is ok for
> mount with -o degraded option.
> 
>   commit 21634a19f646 ("btrfs: Introduce a function to check if all
>   chunks a OK for degraded rw mount")
> 
> As a result, raid0 profile cannot be mounted with -o degraded on 4.14.
> This causes failure of the misc-test 011 "delete missing device". 
> 
> Fix this by using raid1 profile for both data and metadata.
> This also should work for kernel before 4.13.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Applied, thanks.
