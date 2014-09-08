Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:26911 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752823AbaIHJyg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Sep 2014 05:54:36 -0400
Date: Mon, 8 Sep 2014 19:54:21 +1000
From: Dave Chinner <david@fromorbit.com>
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/15 v2] xfstests: new btrfs stress test cases
Message-ID: <20140908095421.GE30012@dastard>
References: <1409233676-22787-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1409233676-22787-1-git-send-email-eguan@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 28, 2014 at 09:47:41PM +0800, Eryu Guan wrote:
> This patchset add new stress test cases for btrfs by running two
> different btrfs operations simultaneously under fsstress to ensure
> btrfs doesn't hang or oops in such situations. btrfs scrub and
> btrfs check will be run after each test.
> 
> The test matrix is the combination of 6 btrfs operations:
> 
> 	balance
> 	create/mount/umount/delete subvolume
> 	replace device
> 	scrub
> 	defrag
> 	remount with different compress algorithms
> 	
> Short descriptions:
> 
> 	059: balance-subvolume
> 	060: balance-scrub
> 	061: balance-defrag
> 	062: balance-remount
> 	063: balance-replace
> 	064: subvolume-replace
> 	065: subvolume-scrub
> 	066: subvolume-defrag
> 	067: subvolume-remount
> 	068: replace-scrub
> 	069: replace-defrag
> 	070: replace-remount
> 	071: scrub-defrag
> 	072: scrub-remount
> 	073: defrag-remount

Can I get some reviews for btrfs people for this series, please?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
