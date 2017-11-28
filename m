Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54201 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752394AbdK1TEh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 14:04:37 -0500
Date: Tue, 28 Nov 2017 20:02:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, lakshmipathi.g@gmail.com
Subject: Re: [PATCH 1/5] btrfs-progs: Add location check when process
 share_data_ref item
Message-ID: <20171128190239.GC3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1511520092-37101-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1511520092-37101-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 24, 2017 at 06:41:28PM +0800, Gu Jinxiang wrote:
> The following test failed becasuse share_data_ref be added into
> extent_cache when deal with root tree node.

The whole function run_next_block would need to be revisited with
respect to error handling and sanity checks. Adding them only when a
fuzzed image hits the particular code path is not IMHO the best
approach.

If there's some fuzzed test case, we should try to find all similar
missing checks and fix them before moving to another type. Addressing
only the failed tests gives a false sense of fixing, there are usally
more similar bugs.
