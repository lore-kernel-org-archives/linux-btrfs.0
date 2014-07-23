Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:57300 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755747AbaGWD2y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 23:28:54 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: BUGS: bogus out of space reported when mounted raid1 degraded, btrfs replace failure, then oops
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <53CF235D.1040703@redhat.com>
Date: Tue, 22 Jul 2014 21:28:52 -0600
Cc: "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Message-Id: <FE022C52-674C-491B-AAC1-2A5B4576D8B3@colorremedies.com>
References: <3823A5F4-169B-4EAC-A548-B0E4FE782F0E@colorremedies.com> <53CF235D.1040703@redhat.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jul 22, 2014, at 8:52 PM, Eric Sandeen <sandeen@redhat.com> wrote:

> This one (your bug #4) was likely caused by:
> 
> commit 99994cde9c59c2b8bb67d46d531b26cc73e39747
> Author: Anand Jain <Anand.Jain@oracle.com>
> Date:   Tue Jun 3 11:36:00 2014 +0800
> 
>    btrfs: dev delete should remove sysfs entry
> 
> and hopefully fixed by:
> 
> commit 0bfaa9c5cb479cebc24979b384374fe47500b4c9
> Author: Eric Sandeen <sandeen@redhat.com>
> Date:   Mon Jul 7 12:34:49 2014 -0500
> 
>    btrfs: test for valid bdev before kobj removal in btrfs_rm_device

OK good. Hopefully the first one is reverted or the second one is accepted before 3.16 is released, replace appears to be broken at the moment.


Chris Murphy