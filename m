Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53578 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbbG0NkW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 09:40:22 -0400
Date: Mon, 27 Jul 2015 15:40:10 +0200
From: David Sterba <dsterba@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] btrfs: convert: Avoid allocating metadata extent
 crossing stripe boundary
Message-ID: <20150727134010.GE6306@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <1437643090-13920-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1437643090-13920-5-git-send-email-quwenruo@cn.fujitsu.com>
 <20150724123447.GX6306@twin.jikos.cz>
 <55B2E3FE.5060706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55B2E3FE.5060706@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 25, 2015 at 09:18:54AM +0800, Qu Wenruo wrote:
> > This caught my attention and looking at possible values of num_bytes,
> > this can crash:
> >
> > 1291         for (last_byte = 0; last_byte < first_free; last_byte += sectorsize) {
> > 1292                 ret = custom_alloc_extent(root, sectorsize, 0, &key, 0);
> >
> > where sectorsize == num_bytes.
> For that case, the last 0 means that's a data block,
> and won't comes to the BUG_ON, as it is only designed for metadata.
> And for metadata allocation, the size will only be nodes/leafsize

Right, so it's an asseert in disguise. Applied, thanks.
