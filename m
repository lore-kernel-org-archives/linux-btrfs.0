Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54376 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751917AbdATS0D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jan 2017 13:26:03 -0500
Date: Fri, 20 Jan 2017 19:24:50 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: raid56: Remove unused variant in lock_stripe_add
Message-ID: <20170120182450.GG11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170116022306.32446-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170116022306.32446-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 16, 2017 at 10:23:06AM +0800, Qu Wenruo wrote:
> Variant 'walk' in lock_stripe_add() is never used.
> Remove it.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Added to 4.11 queue, thaks. Changelog and subject edited.
