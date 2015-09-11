Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbbIKPGP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Sep 2015 11:06:15 -0400
Date: Fri, 11 Sep 2015 17:05:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs-progs: Fix infinite loop of btrfs-image
Message-ID: <20150911150528.GQ8891@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1cb14fe54e546b530d0f3991062ff8bca5cc3394.1441805445.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1cb14fe54e546b530d0f3991062ff8bca5cc3394.1441805445.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 09, 2015 at 09:32:21PM +0800, Zhao Lei wrote:
> Bug:
>  # btrfs-image -t0 -c9 /dev/sda6 /tmp/btrfs_image.img
>  (hang)
>  # btrfs-image -r -t0 /tmp/btrfs_image.img /dev/sda6
>  (hang)
> 
> Reason:
>  Program need to create at least 1 thread for compress/decompress.
>  but if user specify -t0 in argument, it overwrite the default value
>  of 1, then the program really created 0 thread, and caused above
>  error.
> 
> Fix:
>  We can add a check, to make program not allow -t0 argument,
>  but there are still exist another problem.
>  for ex, in node with 4 cpus:
>  btrfs-image -c9 -t1: 4 threads (1 means use nr_cpus)
>              -c9 -t2: 2 threads
>              -c9 -t3: 3 threads
>              ...
>  (-t1 have more threads than -t2 and -t3)
> 
>  So we change to use value of 0 as "use nr_cpus threads", then:
>  btrfs-image [no -t arg]: use nr_cpus threads
>              -t0:         use nr_cpus threads
>              -t val:      use val threads.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

All 3 patches applied, thanks.
