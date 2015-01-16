Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38525 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbbAPLAb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Jan 2015 06:00:31 -0500
Date: Fri, 16 Jan 2015 12:00:28 +0100
From: David Sterba <dsterba@suse.cz>
To: clm@fb.com
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        miaoxie@huawei.com, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs: fix raid56 scrub failed in xfstests btrfs/072
Message-ID: <20150116110028.GO3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1420767580-19380-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1420767580-19380-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 09, 2015 at 09:39:40AM +0800, Gui Hecheng wrote:
> The xfstests btrfs/072 reports uncorrectable read errors in dmesg,
> because scrub forgets to use commit_root for parity scrub routine
> and scrub attempts to scrub those extents items whose contents are
> not fully on disk.
> 
> To fix it, we just add the @search_commit_root flag back.
> 
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Chris, please add this patch to 3.19-rc queue, followup to the new
raid56 scrub code.
