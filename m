Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbcGDMgG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 08:36:06 -0400
Date: Mon, 4 Jul 2016 14:36:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V9 0/5] In-band de-duplication for btrfs-progs
Message-ID: <20160704123629.GH13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160630092431.27636-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160630092431.27636-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 30, 2016 at 05:24:26PM +0800, Qu Wenruo wrote:
> Patchset can be fetched from github:
> https://github.com/adam900710/btrfs-progs.git dedupe_20160630
> 
> Inband dedupe(in-memory backend only) ioctl support for btrfs-progs.
> 
> User/reviewer/tester can still use previous btrfs-progs patchset to test,
> this update is just cleanuping unsupported functions, like on-disk
> backend and any on-disk format change.
> 
> v7 changes:
>    Update ctree.h to follow kernel structure change
>    Update print-tree to follow kernel structure change
> V8 changes:
>    Move dedup props and on-disk backend support out of the patchset
>    Change command group name to "dedupe-inband", to avoid confusion with
>    possible out-of-band dedupe. Suggested by Mark.
>    Rebase to latest devel branch.
> V9 changes:
>    Follow kernels ioctl change to support FORCE flag, new reconf ioctl,
>    and more precious error reporting.

FYI, patchset updated in the integration branch.
