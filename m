Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37379 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaEBCOg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 May 2014 22:14:36 -0400
Message-ID: <53630013.8030803@oracle.com>
Date: Fri, 02 May 2014 10:16:51 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Saran Neti <sarannmr@gmail.com>, linux-btrfs@vger.kernel.org
CC: David Sterba <dsterba@suse.cz>
Subject: Re: Unable to rebuild a 3 drive raid1 - blocked for more than 120
 seconds.
References: <CAE6A3M0zmzDmLKzRDALNeLsqx72ttC8CA74-GfuSXN1TwJW-0A@mail.gmail.com>
In-Reply-To: <CAE6A3M0zmzDmLKzRDALNeLsqx72ttC8CA74-GfuSXN1TwJW-0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> I had 3 x 3 TB drives in an almost full btrfs raid1 setup containing
> only large (~20 GB) files linearly written and not modified after.
> Then one of the drives got busted.
 > Mounting the fs in degraded mode
> and adding a new fresh drive to rebuild raid1, generated several
> "...blocked for more than 120 seconds." messages. I left it running
> for a couple of days, but "btrfs device add..." command wouldn't
> return. I did a hard reboot, and after a degraded mount, am unable to
> unmount, or add a drive or delete missing without getting stuck with
> the same error. iostat shows no disk activity. When attempting an
> unmount, both "umount" and "[btrfs-transacti]" processes become
> defunct. Tried -o skip_balance as well to no avail.


> # btrfs fi show
> Label: 'cohenraid1'  uuid: 288723c3-2e98-4a6c-87d3-058451d87d26
>          Total devices 3 FS bytes used 3.44TiB
>          devid    1 size 2.73TiB used 2.19TiB path /dev/sdg1
>          devid    2 size 2.73TiB used 2.46TiB path /dev/sdf1
>          *** Some devices missing

  the below patch would add ambiguity in the situation like this,
  We would not know a critical info - whether the btrfs kernel
  knows about the missing device...

    http://marc.info/?l=linux-btrfs&m=139175679431525&w=2
