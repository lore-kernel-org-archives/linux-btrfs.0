Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54947 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235AbbDGPnt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Apr 2015 11:43:49 -0400
Date: Tue, 7 Apr 2015 17:43:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] New test case for btrfs-convert and serval minor
 updates on framework/test cases
Message-ID: <20150407154348.GC25622@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1428044477-18485-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1428044477-18485-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 03, 2015 at 03:01:11PM +0800, Qu Wenruo wrote:
> The patchset do the following things:
> 1) Test framework variant naming update
>    Change some lower case variant name to upper case.
>    Provides a unified naming scheme.
> 
> 2) Remove duplicated TEST_MNT check
>    Fsck test case 012 has duplicated TEST_MNT, just remove it.
> 
> 3) Update test cases to use more test framework infrastructure.
>    Update fsck test case 013 and convert test case.
> 
> 4) Add regular file extent in convert test
>    Now btrfs-progs test case can detect odd csum error in btrfs-convert.
> 
> Qu Wenruo (6):
>   btrfs-progs: test-frame: Update variant names
>   btrfs-progs: fsck-tests: Remove duplicatesd TEST_MNT setup.
>   btrfs-progs: fsck-tests: Update 013-extent-tree-rebuild to use more
>     test     framework infrastructure.
>   btrfs-progs: fsck-tests: Add fallback TEST_DEV for test case 013
>   btrfs-progs: convert-tests: Update to use test framework
>     infrastructure.
>   btrfs-progs: convert-tests: Add check for converted btrfs with regular
>         file extent.

Applied, thanks!
