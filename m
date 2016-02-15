Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbcBORxi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 12:53:38 -0500
Date: Mon, 15 Feb 2016 18:53:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Avoid BUG_ON()s because of ENOMEM caused by
 kmalloc() failure
Message-ID: <20160215175333.GO4374@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56C16441.5030000@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56C16441.5030000@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 15, 2016 at 02:38:09PM +0900, Satoru Takeuchi wrote:
> There are some BUG_ON()'s after kmalloc() as follows.
> 
> =====
> foo = kmalloc();
> BUG_ON(!foo);	/* -ENOMEM case */
> =====
> 
> A Docker + memory cgroup user hit these BUG_ON()s.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=112101
> 
> Since it's very hard to handle these ENOMEMs properly,
> preventing these kmalloc() failures to avoid these
> BUG_ON()s for now, are a bit better than the current
> implementation anyway.

Beware that the NOFAIL semantics is can cause deadlocks if it's on the
critical writeback path or and can be reentered from itself through the
reclaim. Unless you're sure that this is not the case, please do not add
them just because it would seemingly fix the allocation failures.

In the docker example, the memory is limited by cgroups so the NOFAIL
mode can exhaust all reserves and just loop endlessly waiting for the
OOM killer to get some memory or just waiting without any chance to
progress.
