Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:54463 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750792AbcIGFhf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Sep 2016 01:37:35 -0400
Date: Wed, 7 Sep 2016 15:37:32 +1000
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Eryu Guan <eguan@redhat.com>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH] fstests: common: Enhance _exclude_scratch_mount_option
 to handle multiply options and generic fs type
Message-ID: <20160907053732.GD22388@dastard>
References: <20160905071333.24688-1-quwenruo@cn.fujitsu.com>
 <20160906042039.GN27776@eguan.usersys.redhat.com>
 <1bdfe67d-17ca-c95b-a10d-f9ac072b1aca@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1bdfe67d-17ca-c95b-a10d-f9ac072b1aca@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 06, 2016 at 01:06:39PM +0800, Qu Wenruo wrote:
> Considering not every contributor will add comment about excluded
> mount options, and in case generic test cases needs to exclude one
> mount option for given fstype, it will be quite hard to find the
> reason.

That is why we review changes. If it's not obvious to the reviewer
why the mount option is excluded, or it's not documented in the
commit message, then the reviewer should be asking for it to be
added.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
