Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33429 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751408AbdJEQzi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Oct 2017 12:55:38 -0400
Date: Thu, 5 Oct 2017 18:53:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: tests: arg override in command line
Message-ID: <20171005165353.GL3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170928072919.13610-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170928072919.13610-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 28, 2017 at 03:29:19PM +0800, Su Yue wrote:
> Lowmem mode only repairs few cases which has a beacon file
> ".lowmem_repairable" in the case' directory.
> 
> However, defining TEST_ENABLE_OVERRIDE=true in command line does work
> in above strategy.
> Because _skip_spec() in tests/common.local isn't interpreted by shell
> in that case.

Given that we don't have other major user of the overriding
functionality, I think we can let the _skip_spec do the lowmem + repair
workaround, but otherwise I'd like to keep the _skip_spec function
check. Just in case, as is't supposed to be user-defined. I'll drop the
first hunk and commit the patch. Thanks.
