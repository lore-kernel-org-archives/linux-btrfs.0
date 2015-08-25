Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46526 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246AbbHYPnM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 11:43:12 -0400
Date: Tue, 25 Aug 2015 17:42:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Add initialztion of rec->crossing_stripes
Message-ID: <20150825154237.GL10756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <3632be46c332732074edadc308bf0201b75cb6db.1440162456.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3632be46c332732074edadc308bf0201b75cb6db.1440162456.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 21, 2015 at 09:07:43PM +0800, Zhao Lei wrote:
> rec->crossing_stripes is not initialized in allocate place,
> and have possibility causing wrong report for normal tree block.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thanks.
