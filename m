Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46415 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752123AbeAIQ7V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Jan 2018 11:59:21 -0500
Date: Tue, 9 Jan 2018 17:57:13 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, wqu@suse.com
Subject: Re: [PATCH 3/3] btrfs: fail mount when sb flag is not in
 BTRFS_SUPER_FLAG_SUPP
Message-ID: <20180109165712.GQ13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180109010543.16053-1-anand.jain@oracle.com>
 <20180109010543.16053-4-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180109010543.16053-4-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 09, 2018 at 09:05:43AM +0800, Anand Jain wrote:
> It appear from the original commit [1] that there isn't any design
> specific reason not to fail the mount instead of just warning. This
> patch will change it to fail.
> 
> [1]
>  commit 319e4d0661e5323c9f9945f0f8fb5905e5fe74c3
>     btrfs: Enhance super validation check
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>  cc: wqu@suse.com
> Reviewed-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
