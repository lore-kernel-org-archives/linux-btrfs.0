Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbbHERDG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Aug 2015 13:03:06 -0400
Date: Wed, 5 Aug 2015 19:02:44 +0200
From: David Sterba <dsterba@suse.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: Error handle for get_ref_objectid_v0() in
 relocate_block_group()
Message-ID: <20150805170244.GG31669@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <f6eb7359bee352cc27f91d26bcffa6c6f8b1a5fe.1438768766.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f6eb7359bee352cc27f91d26bcffa6c6f8b1a5fe.1438768766.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 05, 2015 at 06:00:02PM +0800, Zhao Lei wrote:
> We need error checking code for get_ref_objectid_v0() in
> relocate_block_group(), to avoid unpredictable result, especially
> for accessing uninitialized value(when function failed) after
> this line.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Are there even filesystems with v0 refs?
