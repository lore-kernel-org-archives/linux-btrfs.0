Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34193 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751756AbeBHSE1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Feb 2018 13:04:27 -0500
Date: Thu, 8 Feb 2018 19:02:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v5 0/3] Add support for export testsuits
Message-ID: <20180208180211.GE3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1518071660-16878-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1518071660-16878-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 08, 2018 at 02:34:17PM +0800, Gu Jinxiang wrote:
> Achieved:
> 1. export testsuite by:
>  $ make testsuite
> files list in testsuites-list will be added into tarball btrfs-progs-tests.tar.gz.
> 
> 2. after decompress btrfs-progs-tests.tar.gz, run test by:
>  $ TEST=`MASK` ./tests/mkfs-tests.sh
> and, without MASK also be ok.
> replenish:
>  $ tar -xzvf ./btrfs-progs-tests.tar.gz
>  $ ls
>    btrfs-progs
> tests directory and other files is in btrfs-progs.
> 
> Changelog:
> v5->v4: modify patch2.
> 	make TEST_TOP to represent tests directory.
> 	and introduce INTERNAL_BIN for internal binaries.

Patches 1 and 2 applied. I reworked most of 1, my idea of the end result
of the testsutie is different. In patch 2, I've added quotes to all
lines that changed the variables on 'source ..' line. In such cases
please also look at the resulting code and do not just mechanically
apply the suggestion to rename a variable. Patch 3 does not bring much
information so I did not apply it and wrote the section myself.

The project idea lacked details, as the cards on the github Projects
page are supposed to be short. Not all of the tasks there are simple, so
if you'd want to work on something found there and see that's not clear
what to do, it would be better to open an issue so I can fill in.
