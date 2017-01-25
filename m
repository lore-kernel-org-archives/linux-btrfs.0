Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-02.prod.phx3.secureserver.net ([184.168.200.140]:36132
        "EHLO p3nlsmtpcp01-02.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751042AbdAYTxQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2017 14:53:16 -0500
Date: Thu, 26 Jan 2017 01:22:04 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fsck-tests: missing csum test script
Message-ID: <20170125195204.GB10888@giis.co.in>
References: <20170105192636.GA11297@fedori>
 <20170117150627.GR12081@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170117150627.GR12081@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 17, 2017 at 04:06:27PM +0100, David Sterba wrote:
> It's not clear from the test what's the purpose. There's one corrupted
> csum but the whole csum tree rebuild option is used. This is a pretty
> basic check that the --init-csum-tree works, so it should be mentioned
> somewhere in the test script.

I'll rename directory to 027-verify-init-csum-tree instead of current one.

Is it possible, to fix only the corrupted csum instead of re-building the 
csum-tree?

> 
> Please don't use btrfs-debug-tree, it's been obsoleted by the dump-tree
> subcommand. And you can use the '-t csum' option to dump just the csum
> tree.

> 
> This can be simplified to one sed command.
> 

> 
> Here we want to capture the output from 'check' for analysis in case of
> problems.
> 
Will fix above three issues with next patch.
