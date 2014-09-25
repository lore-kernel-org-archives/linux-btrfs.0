Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44172 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbaIYP2o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Sep 2014 11:28:44 -0400
Date: Thu, 25 Sep 2014 17:28:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove empty block groups automatically V3
Message-ID: <20140925152840.GD9715@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1411053602-17881-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1411053602-17881-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 18, 2014 at 11:20:02AM -0400, Josef Bacik wrote:
> This patch has the side effect of no
> longer having a bunch of BUG_ON()'s in the chunk delete code, which will be
> helpful for both this and relocate.  Thanks,

Would be better to split the unrelated error handling changes to a
separate patch, this is different from the patch subject and cannot be
backported to stable kernels easily. Also makes it easier for the
reviewers.
