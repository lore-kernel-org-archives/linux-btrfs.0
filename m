Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56293 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab3ISNac (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Sep 2013 09:30:32 -0400
Date: Thu, 19 Sep 2013 15:30:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: fix set-default test in btrfs/001
Message-ID: <20130919133029.GG6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1379537307-21681-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1379537307-21681-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 18, 2013 at 04:48:27PM -0400, Josef Bacik wrote:
> We were actually testing this improperly, there was a bug in the set default
> code so we weren't actually honoring the 0 subvolid properly.  To fix this we
> need to get the subvolid for the subvol we want to set as the default and use
> that in the command.  With this patch we now pass again with the fix for the 0
> subvolid.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Tested-by: David Sterba <dsterba@suse.cz>
