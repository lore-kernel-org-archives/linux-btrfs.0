Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55525 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbcDDOtU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Apr 2016 10:49:20 -0400
Date: Mon, 4 Apr 2016 16:45:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, clm@fb.com,
        jbacik@fb.com, dsterba@suse.com
Subject: Re: [PATCH v4] btrfs: fix typo in btrfs_statfs()
Message-ID: <20160404144547.GC3412@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1459780282-6381-1-git-send-email-luisbg@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459780282-6381-1-git-send-email-luisbg@osg.samsung.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 04, 2016 at 03:31:22PM +0100, Luis de Bethencourt wrote:
> Correct a typo in the chunk_mutex name to make it grepable.
> 
> Since it is better to fix several typos at once, fixing the 2 more in the
> same file.
> 
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>

Now the subject does not match the patch contents, but I can fix that so
you don't have to resend it again.
