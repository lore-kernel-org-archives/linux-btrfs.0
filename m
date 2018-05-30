Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58129 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750914AbeE3Oz3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 10:55:29 -0400
Date: Wed, 30 May 2018 16:52:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: return error value if create_io_em() failed in
 cow_file_range()
Message-ID: <20180530145244.GD3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180530084856.17264-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180530084856.17264-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 30, 2018 at 04:48:56PM +0800, Su Yue wrote:
> In cow_file_range(), create_io_em() may fail, but its return value is
> not recorded.
> Then return value may be 0 even it failed which is a wrong behavior.
> 
> Let cow_file_range() return PTR_ERR(em) if create_io_em() failed.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Added to queue, thanks.
