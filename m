Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54797 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbcFANkK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 09:40:10 -0400
Date: Wed, 1 Jun 2016 15:39:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: convert-tests: Add test for backup
 superblock migration
Message-ID: <20160601133931.GX29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160601015121.23944-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160601015121.23944-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 01, 2016 at 09:51:21AM +0800, Qu Wenruo wrote:
> New convert framework uses new and simpler chunk layout, while the cost
> is the more complex superblock range migration logical, compared to old
> convert.
> 
> Enhance the convert test script to create file which will takes up 2nd
> backup superblock space, to ensure the superblock migration is working
> as expected.
> 
> Suggested-by: David Sterba <dsterba@suse.cz>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
