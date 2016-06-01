Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55837 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbcFANu2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 09:50:28 -0400
Date: Wed, 1 Jun 2016 15:49:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: convert: Insert needed holes for superblock
 migration
Message-ID: <20160601134949.GZ29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160601082943.10364-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160601082943.10364-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 01, 2016 at 04:29:43PM +0800, Qu Wenruo wrote:
> New convert doesn't insert holes for superblock migration range.
> 
> Unlike old design, which only relocate 4K(superblock size) to other
> places.
> In new design, to make sure convert can handle different page size and
> align chunk bytenr, we relocate the whole 64K range.

This looks like a potential backward compatibility problem. In the
unlikely scenario, mixing old and new convert to do conversion and
rollback. Did you try that?

> And if there is only a 4K used block inside 64K superblock migration range, it
> will make converted fs has discontinuous file extents.
> 
> This patch will fix it by inserting needed holes to avoid such
> discontinuous error.
> 
> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> David, I'm very sorry, all these recently exposed bugs are related to
> superblock migration range, and will only be triggered by special build
> ext* images(Needs special space range be allocated in ext*)
> 
> I'll try my best to create the minimal trigger e2image dump, our current
> image is too large for test cases.

Well, given the amount of last minute fixes I'm now hesitant to do 4.6
release with this patchset.
