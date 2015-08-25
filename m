Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46575 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbbHYPoa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 11:44:30 -0400
Date: Tue, 25 Aug 2015 17:43:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: add missing free operation of raid_map for
 raid56
Message-ID: <20150825154354.GM10756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <8cbfc51dba83890b0e7e22ef2f9985674294c41f.1440483058.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8cbfc51dba83890b0e7e22ef2f9985674294c41f.1440483058.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 25, 2015 at 02:11:07PM +0800, Zhao Lei wrote:
> We forgot free raid_map for raid56's map_bio.
> This patch add it.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thanks.
