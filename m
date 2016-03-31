Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55552 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbcCaQhy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 12:37:54 -0400
Date: Thu, 31 Mar 2016 18:37:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: don't use src fd for printk
Message-ID: <20160331163718.GF6230@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458914561-4638-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458914561-4638-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 25, 2016 at 10:02:41AM -0400, Josef Bacik wrote:
> The fd we pass in may not be on a btrfs file system, so don't try to do
> BTRFS_I() on it.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>
