Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59920 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754651AbbIIN0b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Sep 2015 09:26:31 -0400
Date: Wed, 9 Sep 2015 15:25:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: Btrfs progs release 4.1
Message-ID: <20150909132544.GH8891@suse.cz>
Reply-To: dsterba@suse.cz
References: <20150622150023.GX6761@twin.jikos.cz>
 <55EF8CBD.3020105@cn.fujitsu.com>
 <55EFA661.2050102@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55EFA661.2050102@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 09, 2015 at 11:24:17AM +0800, Qu Wenruo wrote:
> The problem is that, for converted image, it's quite possible that data 
> and metadata extent are stored in one chunk even the chunk is not mixed.
> 
> I'll add fsck support for it soon.

That would be great, I have no idea how the data/metadata can get mixed.
Does this involve inlied file data that come from ext4?
