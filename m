Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932166AbcEKM41 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 08:56:27 -0400
Date: Wed, 11 May 2016 14:56:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: fsck: Fix found bytes accounting error
Message-ID: <20160511125604.GC29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1461638989-5048-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1461638989-5048-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 26, 2016 at 10:49:49AM +0800, Qu Wenruo wrote:
> In the new add_extent_rec_nolookup() function, we add bytes_used to
> update found bytes accounting.
> 
> However there is a typo that we used tmpl->nr, which should be rec->nr.
> This will make us to add 1 for data backref, instead the correct size.
> 
> Reported-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
