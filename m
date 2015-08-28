Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35640 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbbH1R3E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 13:29:04 -0400
Date: Fri, 28 Aug 2015 19:28:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Byongho Lee <bhlee.kernel@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs-progs: add memory allocation fail check in
 btrfs_add_to_fsid()
Message-ID: <20150828172827.GI11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1440689898-35178-1-git-send-email-bhlee.kernel@gmail.com>
 <1440689898-35178-4-git-send-email-bhlee.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1440689898-35178-4-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 28, 2015 at 12:38:18AM +0900, Byongho Lee wrote:
> In btrfs_add_to_fsid(), strdup() allocates memory to device->name, but
> the return value is not checked.
> So add the return value check and error handling code.
> And clean-up error handling code for ENOMEM case.
> 
> Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>

Applied, thanks. Btw, the kmalloc/kfree functions come from the kernel
code and should not be used in the pure-userspace code, like utils.c,
but I don't mind for now.
