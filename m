Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbaHRVmD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Aug 2014 17:42:03 -0400
Date: Mon, 18 Aug 2014 14:42:01 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix leak in qgroup_subtree_accounting() error
	path
Message-ID: <20140818214201.GC2203@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <53F10BF1.6070602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53F10BF1.6070602@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 17, 2014 at 03:09:21PM -0500, Eric Sandeen wrote:
> Coverity pointed this out; in the newly added
> qgroup_subtree_accounting(), if btrfs_find_all_roots()
> returns an error, we leak at least the parents pointer,
> and possibly the roots pointer, depending on what failure
> occurs.
> 
> If btrfs_find_all_roots() returns an error, we need to
> free up all allocations before we return.  "roots" is
> initialized to NULL, so it should be safe to free
> it unconditionally (ulist_free() handles that case).

Great, thanks for this Eric.

Reviewed-by: Mark Fasheh <mfasheh@suse.de>

--
Mark Fasheh
