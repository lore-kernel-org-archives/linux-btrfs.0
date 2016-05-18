Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39502 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbcERNzF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 May 2016 09:55:05 -0400
Date: Wed, 18 May 2016 15:54:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/7] Btrfs: replace BUG_ON with WARN in merge_bio
Message-ID: <20160518135437.GA511@suse.cz>
Reply-To: dsterba@suse.cz
References: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
 <1463184422-13584-5-git-send-email-bo.li.liu@oracle.com>
 <20160516084438.GB511@twin.jikos.cz>
 <20160516172400.GA11100@localhost.localdomain>
 <20160517095519.GI511@twin.jikos.cz>
 <20160517173047.GA8522@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160517173047.GA8522@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 17, 2016 at 10:30:47AM -0700, Liu Bo wrote:
> > If merge_bio gets rid of the BUG_ON, the calles must explicitly handle
> > 'ret < 0' unless it's provably not a problem.
> 
> If merge_bio() returns < 0, then it must be __btrfs_map_block() returns < 0,
> so even if we continue with submiting this bio, it'd fail at
> __btrfs_map_block() again because merge_bio and submit_bio are using the
> same bio.  Because of that we don't bother to submit it, instead we can
> just return in case of (ret < 0), this applies to both
> submit_extent_page() and btrfs_submit_compressed_read/write().
> 
> What do you think?

Makes sense to me. All the partial processing (allocations and bios)
need to be cleaned up, which does not seem trivial from the first look.
