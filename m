Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:49565 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab2IPSNA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Sep 2012 14:13:00 -0400
Date: Sun, 16 Sep 2012 20:12:47 +0200
From: David Sterba <dave@jikos.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, bo.li.liu@oracle.co
Subject: Re: [PATCH] Btrfs: use vfree instead of kfree
Message-ID: <20120916181247.GP17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1347642309-29242-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1347642309-29242-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2012 at 01:05:09PM -0400, Josef Bacik wrote:
> We are vmalloc()'ing the fspath now so we should be vfree'ing it and not
> kfreeing it.  Thanks,
> 
> Reported-by: Dave Sterba <dave@jikos.cz>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

IMO better to fold this change into the patch that introduced it, as
it's not merged anywhere else than btrfs-next:

  [PATCH v2 6/6] Btrfs: use larger limit for translation of logical to inode
  From: Liu Bo <bo.li.liu@oracle.com>

plus add the missing #include <linux/vmalloc.h> that Fengguang Wu
encountered.


david
