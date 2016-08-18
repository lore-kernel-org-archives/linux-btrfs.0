Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbcHRMbr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Aug 2016 08:31:47 -0400
Date: Thu, 18 Aug 2016 14:30:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v4] btrfs: fix fsfreeze hang caused by delayed iputs deal
Message-ID: <20160818123049.GB16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160801052808.7331-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160801052808.7331-1-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 01, 2016 at 01:28:08PM +0800, Wang Xiaoguang wrote:
> v3: we introduce a atomic_t fs_frozen, and if fs_frozen is 1, we can not
>     handle delayed iputs.
> v4: change atomic_t fs_frozen to be int.

As it is now, I think the barriers are not needed. The freeze callback
sets it and then does transaction barrier. Ie. either there's no
transaction, or it waits for the commit. At this point any of the
committing threads will notice fs_fozen == 1.

In the worst case, when the check happens between setting to 1 and
barrier:

CPU1                         CPU2

fs_frozen = 1
(no barrier, other threads
 might still see 0)
                             if ("is fs_frozen?")
			         do delay iputs
transaction barrier
    wait for the cpu2
    transaction

That's not the classic barrier scheme, we don't care if there are other
threads in the middle of a transaction, we'll wait anyway. I'll add a
comment of similar wording.

Reviewed-by: David Sterba <dsterba@suse.com>
