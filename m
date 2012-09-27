Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:63267 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756460Ab2I0HBU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Sep 2012 03:01:20 -0400
Date: Thu, 27 Sep 2012 17:01:17 +1000
From: Dave Chinner <david@fromorbit.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk, cmm@us.ibm.com,
        tytso@mit.edu, marco.stornelli@gmail.com, stroetmann@ontolinux.com,
        diegocg@gmail.com, chris@csamuel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [RFC v2 07/10] vfs: fork one kthread to update data temperature
Message-ID: <20120927070117.GR15236@dastard>
References: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
 <1348404995-14372-8-git-send-email-zwu.kernel@gmail.com>
 <20120927040357.GO15236@dastard>
 <CAEH94LgMXNZ_6Cs-YbhWVocO6jWb+Xq8=xgooimCFGnFbuEw5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEH94LgMXNZ_6Cs-YbhWVocO6jWb+Xq8=xgooimCFGnFbuEw5Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 27, 2012 at 02:54:22PM +0800, Zhi Yong Wu wrote:
> On Thu, Sep 27, 2012 at 12:03 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sun, Sep 23, 2012 at 08:56:32PM +0800, zwu.kernel@gmail.com wrote:
> >> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> >>
> >>   Fork and run one kernel kthread to calculate
> >> that temperature based on some metrics kept
> >> in custom frequency data structs, and store
> >> the info in the hash table.
> >
> > No new kthreads, please. Use a per-superblock workqueue and a struct
> > delayed_work to run periodic work on each superblock.
> If no new kthread is created, which kthread will work on these
> delayed_work tasks?

One of the kworker threads that service the workqueue
infrastructure.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
