Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40946 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbaJPJSl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Oct 2014 05:18:41 -0400
Date: Thu, 16 Oct 2014 11:18:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: properly clean up btrfs_end_io_wq_cache
Message-ID: <20141016091839.GY22943@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1413407999-1154-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1413407999-1154-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 15, 2014 at 05:19:59PM -0400, Josef Bacik wrote:
> In one of Dave's cleanup commits he forgot to call btrfs_end_io_wq_exit on
> unload, which makes us unable to unload and then re-load the btrfs module.  This
> fixes the problem.  Thanks,

Oh crap, sorry.

Reviewed-by: David Sterba <dsterba@suse.cz>
