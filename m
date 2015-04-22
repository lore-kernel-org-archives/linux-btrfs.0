Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53140 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757132AbbDVQNh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Apr 2015 12:13:37 -0400
Date: Wed, 22 Apr 2015 18:13:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2] Btrfs-progs: check for matchin free space in cache
Message-ID: <20150422161335.GD4996@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1429293735-31351-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1429293735-31351-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 17, 2015 at 02:02:15PM -0400, Josef Bacik wrote:
> We have this check in the kernel but not in userspace, which makes fsck fail
> when we wouldn't have a problem in the kernel.  This was meant to catch this
> case because it really isn't good, unfortunately it will require a design change
> to fix in the kernel so in the meantime add this check so we can be sure our
> tests only catch real problems.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Applied, thanks.
