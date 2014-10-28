Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47872 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932401AbaJ1D5V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 23:57:21 -0400
Message-ID: <1414468563.4117.10.camel@localhost.localdomain>
Subject: Re: Btrfs-progs release 3.17
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Petr Janecek <janecek@ucw.cz>
CC: Anand Jain <Anand.Jain@oracle.com>, <dsterba@suse.cz>,
        <linux-btrfs@vger.kernel.org>
Date: Tue, 28 Oct 2014 11:56:03 +0800
In-Reply-To: <20141023132357.GA15839@atrey.karlin.mff.cuni.cz>
References: <20141021212822.GA22009@atrey.karlin.mff.cuni.cz>
	 <54476F88.4040509@oracle.com>
	 <20141023065709.GA11511@atrey.karlin.mff.cuni.cz>
	 <5448B8A5.2010202@oracle.com>
	 <1414054345.12350.6.camel@localhost.localdomain>
	 <20141023132357.GA15839@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2014-10-23 at 15:23 +0200, Petr Janecek wrote:
> Hello Gui,
> 
> > Oh, it seems that there are btrfs with missing devs that are bringing
> > troubles to the @open_ctree_... function.
> 
>   what do you mean by "missing devs"? I have no degraded fs.

Ah, sorry, I'm too focused on the problem that Anand's script pointed
out. Ignore this "missing devs".

>   The time "btrfs fi sh" spends scanning disks of a filesystem seems to
> be proportional to the amount of data stored on them: on a completely
> idle system, of ~20s total time it spends 10s scanning each of /mnt/b
> and /mnt/b0, and almost no time on /mnt/b3 (which is the biggest)
> 
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sdm        5.5T  2.4T  2.1T  54% /mnt/b
> /dev/sda        5.5T  2.5T  3.1T  45% /mnt/b0
> /dev/sde        7.3T   90G  5.4T   2% /mnt/b3

For your original problems:
o error messages:
  The concurrency problem exists as Anand said. As you said, running
balance & cp lead to such messages, so I think there are some
unintentional redundency works over the mounted devices when dealing
with umounted ones. I'll try to 

o stalling:
  This may be due to concurrency problem either. After the first problem
handled, let's see what happens.

Thanks,
Gui
> 
> Thanks,
> 
> Petr
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


