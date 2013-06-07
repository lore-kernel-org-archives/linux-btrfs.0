Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:59615 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab3FGBzE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Jun 2013 21:55:04 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 298A37C0428
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Jun 2013 19:55:03 -0600 (MDT)
Date: Thu, 6 Jun 2013 21:55:00 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Andrea Gelmini <andrea.gelmini@gmail.com>
CC: Linux BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfsck: free-space-cache.c:813: btrfs_add_free_space: Assertion
 `!(ret == -17)' failed
Message-ID: <20130607015500.GC29248@localhost.localdomain>
References: <CAK-xaQabh32xjmytaJXZqYicAaZivrPYx-LOSt+kZYc6q18WBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAK-xaQabh32xjmytaJXZqYicAaZivrPYx-LOSt+kZYc6q18WBQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 06, 2013 at 07:00:50PM -0600, Andrea Gelmini wrote:
> Hi everybody,
>    and thanks a lot for your support and work.
> 
>    I've an external hard drive formatted with BTRFS that sometimes
> goes readonly (no complains in logs or dmesg output).
> 
>    It happens with kernel v9.4 and latest vanilla kernel in dev, too.
> 
>    If I check it I got (git BTRFS progs):
> 
> ./btrfsck /dev/mapper/toshi
> Checking filesystem on /dev/mapper/toshi
> UUID: 35eb15cd-d7e3-4be8-92f1-7b210353e241
> checking extents
> checking free space cache
> btrfs: unable to add free space :-17
> btrfsck: free-space-cache.c:813: btrfs_add_free_space: Assertion
> `!(ret == -17)' failed.
>

Can you try my git tree?

git://github.com/josefbacik/btrfs-progs.git

and see if that works better?  Thanks,

Josef 
