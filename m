Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34368 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751288AbdC0RYK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 13:24:10 -0400
Date: Mon, 27 Mar 2017 19:23:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, chris@colorremedies.com
Subject: Re: [PATCH 1/2] btrfs-progs: lowmeme check: Fix false alert about
 backref lost for SHARED_DATA_REF
Message-ID: <20170327172326.GP4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170317020634.29287-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170317020634.29287-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 17, 2017 at 10:06:33AM +0800, Qu Wenruo wrote:
> In check_extent_data_item(), after checking extent item of one data
> extent, we search inlined data backref, then EXTENT_DATA_REF_KEY.
> 
> But we didn't search SHARED_DATA_REF, so if the backref is
> SHARED_DATA_REF, then we will raise a false alert about backref lost.
> 
> Fix by also checking SHARED_DATA_REF_KEY in check_extent_data_item().
> 
> Reported-by: Chris Murphy <chris@colorremedies.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Both applied, thanks.
