Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbbIVOqP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 10:46:15 -0400
Date: Tue, 22 Sep 2015 16:45:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Justin Maggard <jmaggard10@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Justin Maggard <jmaggard@netgear.com>
Subject: Re: [PATCH v2] btrfs: qgroup: exit the rescan worker during umount
Message-ID: <20150922144518.GM12815@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1441242317-16547-1-git-send-email-jmaggard@netgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1441242317-16547-1-git-send-email-jmaggard@netgear.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 02, 2015 at 06:05:17PM -0700, Justin Maggard wrote:
> v2: Fix stupid error while making formatting changes...

I haven't noticed any difference between the patches, what exactly did
you change?

> I was hitting a consistent NULL pointer dereference during shutdown that
> showed the trace running through end_workqueue_bio().  I traced it back to
> the endio_meta_workers workqueue being poked after it had already been
> destroyed.
> 
> Eventually I found that the root cause was a qgroup rescan that was still
> in progress while we were stopping all the btrfs workers.
> 
> Currently we explicitly pause balance and scrub operations in
> close_ctree(), but we do nothing to stop the qgroup rescan.  We should
> probably be doing the same for qgroup rescan, but that's a much larger
> change.  This small change is good enough to allow me to unmount without
> crashing.
> 
> Signed-off-by: Justin Maggard <jmaggard@netgear.com>

Can you please submit the test you've used to trigger the crash to
fstests?

Reviewed-by: David Sterba <dsterba@suse.com>
