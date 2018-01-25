Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43618 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750994AbeAYS1Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jan 2018 13:27:25 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 220A7ACF9
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 18:27:24 +0000 (UTC)
Date: Thu, 25 Jan 2018 19:25:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/2] btrfs-progs: mkfs: Fix minimal device size
 calculation for new temporary chunk layout
Message-ID: <20180125182512.GA19355@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180124023830.26184-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180124023830.26184-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 24, 2018 at 10:38:29AM +0800, Qu Wenruo wrote:
> Commit 0b2161becf8e ("btrfs-progs: mkfs: Prevent temporary system chunk
> to use space in reserved 1M range") changed the hard-coded temporary
> chunk layout to avoid the first 1M.
> 
> However this also affects btrfs_min_dev_size() which still assume
> temporary chunks starts at device offset 0.
> 
> This patch will fix it.
> 
> Fixes: 0b2161becf8e ("btrfs-progs: mkfs: Prevent temporary system chunk
> to use space in reserved 1M range")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

As this would break bisection and the fix is short I've folded it to the
patch that fixed th 0-1M range. Thanks.
