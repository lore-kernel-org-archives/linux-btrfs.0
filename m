Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42592 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbcCINEF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Mar 2016 08:04:05 -0500
Date: Wed, 9 Mar 2016 14:03:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: util: Fix a wrong unit of pretty_size
Message-ID: <20160309130344.GC738@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1457489455-9685-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1457489455-9685-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 09, 2016 at 10:10:55AM +0800, Qu Wenruo wrote:
> If parameter for pretty_size is smaller than default base(1024),
> pretty_size() will output wrong unit.
> For example, pretty_size(1008) will output '0.98B' not '1008B' or
> '0.98KiB'.
> 
> The cause is, for default base and auto-detect unit, base will be 1024
> but num_divs is still 0, last result will still be divided by base,
> causing the bug.
> 
> Fix it by checking num_divs in default case, and if num_divs is 0,
> change base to 1.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
