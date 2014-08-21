Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:60348 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbaHUQDs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 12:03:48 -0400
Date: Thu, 21 Aug 2014 09:03:47 -0700
From: Zach Brown <zab@zabbo.net>
To: Dave Chinner <david@fromorbit.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/15] xfstests: new btrfs stress test cases
Message-ID: <20140821160347.GP429@lenny.home.zabbo.net>
References: <1408556044-907-1-git-send-email-eguan@redhat.com>
 <20140820182437.GJ429@lenny.home.zabbo.net>
 <20140821093505.GM26465@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140821093505.GM26465@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> It's trivial to write this as a bunch of helper functions and then
> boiler-plate the actual tests themselves. There will be little
> difference in terms of run time, but we get much more fine-grained
> control of execution and reporting....

Sure, that's reasonable, given the xfstests infrastructure.

- z
