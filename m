Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:5871 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755664AbcB1XDJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Feb 2016 18:03:09 -0500
Date: Mon, 29 Feb 2016 10:02:14 +1100
From: Dave Chinner <david@fromorbit.com>
To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] fstests: btrfs/011 use replace_options
Message-ID: <20160228230214.GE29057@dastard>
References: <1455888329-16981-1-git-send-email-anand.jain@oracle.com>
 <20160224124208.GD23746@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160224124208.GD23746@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 24, 2016 at 01:42:08PM +0100, David Sterba wrote:
> On Fri, Feb 19, 2016 at 09:25:28PM +0800, Anand Jain wrote:
> > This patch fixes test btrfs/011 which intended to use -r option
> > but was never used since its associated args 'replace_options'
> > didn't make it to the cli.
> 
> After this patch the tests fails due to extra output. I've tested
> several kernels (4.5 rcs), HDD and SSD so it's not caused by my testing
> setup.

I'll use this as an opportunity to point out that nobody is
reviewing most btrfs test changes. I'll commit the changes if no-one
says anything about them, they look sane to me and don't cause me
any problems, but that doesn't mean they will work. Mostly I'm
concerned about changes to the common code and code patterns, not
what the test does or whether it is even a valid test.

IOWs, it is up to the developers who use xfstests to make sure the
tests relevant to their areas of expertise work correctly and are
valid/viable tests, not me. To avoid this sort of issue in
future, please review changes promptly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
