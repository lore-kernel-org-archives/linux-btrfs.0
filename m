Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56758 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807AbcGHO2P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jul 2016 10:28:15 -0400
Date: Fri, 8 Jul 2016 16:28:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: fix free space calculation in
 dump_space_info()
Message-ID: <20160708142832.GJ13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160629051216.16876-1-wangxg.fnst@cn.fujitsu.com>
 <20160704171025.GL13336@twin.jikos.cz>
 <577CDA66.1050309@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <577CDA66.1050309@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 06, 2016 at 06:16:06PM +0800, Wang Xiaoguang wrote:
> hello,
> 
> On 07/05/2016 01:10 AM, David Sterba wrote:
> > On Wed, Jun 29, 2016 at 01:12:16PM +0800, Wang Xiaoguang wrote:
> >
> > Can you please describe in more detail what is this patch fixing?
> In original dump_space_info(), free space info is calculated by
> info->total_bytes - info->bytes_used - info->bytes_pinned - 
> info->bytes_reserved - info->bytes_readonly,
> but I think free space info should also minus info->bytes_may_use :)

Not really what I expected. The change is correct but the changelog
should say something "the 'used space' formula is missing the
bytes_may_used, that is used elsewhere eg. __reserve_metadata_bytes or
space_info_add_old_bytes". That way I have something to verify during
the review.
