Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54020 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaJWNX7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 09:23:59 -0400
Date: Thu, 23 Oct 2014 15:23:57 +0200
From: Petr Janecek <janecek@ucw.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: Anand Jain <Anand.Jain@oracle.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Subject: Re: Btrfs-progs release 3.17
Message-ID: <20141023132357.GA15839@atrey.karlin.mff.cuni.cz>
References: <20141021212822.GA22009@atrey.karlin.mff.cuni.cz>
 <54476F88.4040509@oracle.com>
 <20141023065709.GA11511@atrey.karlin.mff.cuni.cz>
 <5448B8A5.2010202@oracle.com>
 <1414054345.12350.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1414054345.12350.6.camel@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Gui,

> Oh, it seems that there are btrfs with missing devs that are bringing
> troubles to the @open_ctree_... function.

  what do you mean by "missing devs"? I have no degraded fs.

  The time "btrfs fi sh" spends scanning disks of a filesystem seems to
be proportional to the amount of data stored on them: on a completely
idle system, of ~20s total time it spends 10s scanning each of /mnt/b
and /mnt/b0, and almost no time on /mnt/b3 (which is the biggest)

Filesystem      Size  Used Avail Use% Mounted on
/dev/sdm        5.5T  2.4T  2.1T  54% /mnt/b
/dev/sda        5.5T  2.5T  3.1T  45% /mnt/b0
/dev/sde        7.3T   90G  5.4T   2% /mnt/b3


Thanks,

Petr
