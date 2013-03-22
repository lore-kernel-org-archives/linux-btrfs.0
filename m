Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44096 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab3CVDFg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 23:05:36 -0400
Message-ID: <514BCAB1.6040608@oracle.com>
Date: Fri, 22 Mar 2013 11:06:25 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: Jon Nelson <jnelson@jamponi.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-show vs. btrfs different output
References: <CAKuK5J05iXaDd7Q4fLby9vJyPXBURx06xb0_--WmgTpJ0j2RoA@mail.gmail.com> <514B232E.2050705@redhat.com> <CAKuK5J3Fd+ya3SOwQPZohJArE+cPNZKchzH3UkvpvoAnK-6Hng@mail.gmail.com> <514B346D.1010403@redhat.com>
In-Reply-To: <514B346D.1010403@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> What we really need is the right bits in the right places
> to let the administrator know if a device looks like it might
> be corrupt & in need of fixing, vs. ignoring it altogether.


--
 > 2. the current git btrfs-show and btrfs fi show both output
 > *different* devices for device with UUID
 > b5dc52bd-21bf-4173-8049-d54d88c82240, and they're both wrong.
--

  here per Jon experience showing stale btrfs on /dev/sdb (note
  that good btrfs is on /dev/sdb3) is wrong.

  More over when we show something like /dev/sdb and /dev/sdb3
  both have two different btrfs, its a bit scary.

  I would vote for ignoring it altogether since we have
  btrfs-find-root and btrfs-select-super to help find the
  backup SB for recovery if needed.

Thanks.

-Anand
