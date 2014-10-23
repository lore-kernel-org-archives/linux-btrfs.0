Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41060 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbaJWG5M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 02:57:12 -0400
Date: Thu, 23 Oct 2014 08:57:09 +0200
From: Petr Janecek <janecek@ucw.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs-progs release 3.17
Message-ID: <20141023065709.GA11511@atrey.karlin.mff.cuni.cz>
References: <20141021212822.GA22009@atrey.karlin.mff.cuni.cz>
 <54476F88.4040509@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54476F88.4040509@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

>  You have mentioned two issues when balance and fi show running
>  concurrently

  my mail was a bit chaotic, but I get the stalls even on idle system.
Today I got

parent transid verify failed on 1559973888000 wanted 1819 found 1821
parent transid verify failed on 1559973888000 wanted 1819 found 1821
parent transid verify failed on 1559973888000 wanted 1819 found 1821
parent transid verify failed on 1559973888000 wanted 1819 found 1821
Ignoring transid failure
leaf parent key incorrect 1559973888000

from 'btrfs fi sh' while I was just copying something, no balance running.

[...]
> [PATCH 1/1] btrfs-progs: code optimize cmd_scan_dev() use
> btrfs_register_one_device()
> [PATCH 1/2] btrfs-progs: introduce btrfs_register_all_device()
> [PATCH 2/2] btrfs-progs: optimize btrfs_scan_lblkid() for multiple calls
> 
> If you could, pls..
>  Now on 3.17 apply above 3 patches and see if you see any better
>  performance for the stalling issue.

  no perceptible change: takes ~40 seconds both before and after
applying. Old version <1 sec.

>  can you do same steps on 3.16 and report what you observe

  So many rejects -- do you have older versions of these patches?


Thanks,

Petr
