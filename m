Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:54568 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845AbaHTXI7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 19:08:59 -0400
Date: Thu, 21 Aug 2014 09:08:38 +1000
From: Dave Chinner <david@fromorbit.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstest: add tests/btrfs/059 to test seed operations
Message-ID: <20140820230838.GH26465@dastard>
References: <1408115781-4876-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1408115781-4876-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 15, 2014 at 11:16:21PM +0800, Anand Jain wrote:
> This test contains a set of 5 sub test cases which will tests
> the device add and replacement on a seed FS. The kernel messages
> are checked at the end of the each of the 5 test cases to see
> if there are any kernel warnings or bugs reported. As in general
> btrfs do report warning when device counts such as num_devices
> and rw_devices appears to be wrong.
> 
> Since the tests has to deal with the replace, it would need
> up to five scratch device with same size.

Please separate this out into 5 tests using shared infrastructure.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
