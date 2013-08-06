Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab3HFNs5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Aug 2013 09:48:57 -0400
Date: Tue, 6 Aug 2013 15:48:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 09/10] btrfs-progs: Fix the return value of
 btrfs-map-logical
Message-ID: <20130806134851.GJ5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1375335334-32540-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1375335334-32540-9-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375335334-32540-9-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 01, 2013 at 01:35:33PM +0800, Wang Shilong wrote:
> From: Qu Wenruo <quwenruo@cn.fujitsu.com>
> 
> The ret variant in the main function is not changed so even problems
> happen, return value is still 0.
> The patch fixs the minor bug and return 1 if any problems happen.

Please don't mix code fixes into documentation updates next time (unless
you're testing my attention).

david
