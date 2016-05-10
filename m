Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbcEJNkU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 09:40:20 -0400
Date: Tue, 10 May 2016 15:39:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@intel.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH] Btrfs: fix fspath error deallocation
Message-ID: <20160510133956.GT29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1462884980-10052-1-git-send-email-vincent.stehle@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1462884980-10052-1-git-send-email-vincent.stehle@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 10, 2016 at 02:56:20PM +0200, Vincent Stehlé wrote:
> Make sure to deallocate fspath with vfree() in case of error in
> init_ipath().
> 
> fspath is allocated with vmalloc() in init_data_container() since
> commit 425d17a290c0 ("Btrfs: use larger limit for translation of logical to
> inode").
> 
> Signed-off-by: Vincent Stehlé <vincent.stehle@intel.com>
> Cc: Chris Mason <clm@fb.com>
> Cc: Josef Bacik <jbacik@fb.com>
> Cc: David Sterba <dsterba@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
