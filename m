Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37103 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750942AbdE2Qom (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 12:44:42 -0400
Date: Mon, 29 May 2017 18:43:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: tests: remove variable quotation from
 convert-tests
Message-ID: <20170529164341.GQ14523@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201705160301.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201705160301.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 16, 2017 at 12:01:53PM +0900, Tsutomu Itoh wrote:
> In btrfs-progs-v4.11-rc1, the following convert-tests failed.
> 
>     [TEST/conv]   008-readonly-image
>     [TEST/conv]     readonly image test, btrfs defaults
> failed: mke2fs -t ext4 -b 4096 -F /Build/btrfs-progs-v4.11-rc1/tests/test.img
> test failed for case 008-readonly-image
> Makefile:271: recipe for target 'test-convert' failed
> make: *** [test-convert] Error 1
>     [TEST/conv]   009-common-inode-flags
>     [TEST/conv]     common inode flags test, btrfs defaults
> failed: mke2fs -t ext4 -b 4096 -F /Build/btrfs-progs-v4.11-rc1/tests/test.img
> test failed for case 009-common-inode-flags
> Makefile:271: recipe for target 'test-convert' failed
> make: *** [test-convert] Error 1
> 
> So, remove quotes from $default_mke2fs.
> 
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

Applied, thanks.
