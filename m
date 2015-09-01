Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58229 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbbIAMzw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Sep 2015 08:55:52 -0400
Date: Tue, 1 Sep 2015 14:55:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs-progs: tests: Fix mount fail of
 013-extent-tree-rebuild
Message-ID: <20150901125511.GJ11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1441101420.git.zhaolei@cn.fujitsu.com>
 <899dfa2f9238ab5905eeeb3613ade2549a5a1f6a.1441101420.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <899dfa2f9238ab5905eeeb3613ade2549a5a1f6a.1441101420.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 01, 2015 at 06:03:27PM +0800, Zhao Lei wrote:
> mount command in old system can not add "-o loop" option automatically
> for loop device, and make following test failed:
>   # ./fsck-tests.sh
>   ...
>     [TEST]   013-extent-tree-rebuild
>   failed: mount /data/btrfsprogs/tests/test.img /data/btrfsprogs/tests/mnt
>   test failed for case 013-extent-tree-rebuild
> 
> Considering that $TEST_DEV can be block or loop device, we need determine
> our mount option in a condition for both case.
> 
> This patch create a wrapper function for above request, to solve current
> problem in 013-extent-tree-rebuild, and support similar request in future.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thanks.

FYI, I've separated this patch into two, one adding the helpers and the
other one using them. Changelogs contents was mostly reused.
