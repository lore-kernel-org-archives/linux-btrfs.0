Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbbETM1Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 May 2015 08:27:24 -0400
Date: Wed, 20 May 2015 14:27:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: Fix a bug in chunk item extra check and
 allow degraded chunk.
Message-ID: <20150520122722.GI23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1431666674-23322-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431666674-23322-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 15, 2015 at 01:11:14PM +0800, Qu Wenruo wrote:
> For DUP profile, the num_stripes should be 2 not 1.
> This causes btrfs offline tool fails on valid image.
> 
> Also, num_stripes check is too restrict for btrfsck self test,
> as there is some image in degraded mode, so modify it to allow degraded
> chunk.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks. There relase of 4.0.1 is on the way.
