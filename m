Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41338 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753297AbdLKNya (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Dec 2017 08:54:30 -0500
Subject: Re: [PATCH RFC] btrfs: self heal from SB fail
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <20171208075705.23462-1-anand.jain@oracle.com>
 <ed75e747-4387-49a3-e62a-67e100dd4ea6@gmail.com>
 <474dfc45-1d77-35ec-66e1-5391592fccc0@oracle.com>
 <aeadd575-240c-f1d8-cf88-fe77a537265a@gmx.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <af568508-c2f2-d269-314a-5cf487e79d9a@oracle.com>
Date: Mon, 11 Dec 2017 21:49:58 +0800
MIME-Version: 1.0
In-Reply-To: <aeadd575-240c-f1d8-cf88-fe77a537265a@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




>>   If the old btrfs is over written with newer btrfs SB, and if mkfs.btrfs
>>   is not overwriting all the copies of SB then its a mkfs.btrfs bug.
> 
> Nope.
> 
> If the new btrfs is a smaller one than original btrfs, the 2nd super can
> still be there.

  Oh right, the mkfs.btrfs -b <SIZE> option, where we don't
  use entire device.

  Here the source of the problem is having the stale SB which is
  created by previous btrfs, and at the time of mkfs we do notice
  that there is a stale SB, so we already know how many copy of SB
  were there, but we are bit conservative not to clean all SBs.
  Its important to fix the problem end (mkfs), not the victim end
  (sb recovery).

  But looks like not everyone agrees to this view, and sb self heal
  will go wrong if mkfs does not clean all copy of SB, so now the
  only way to recover it is by user intervention, so I am ok to add
  mount -o sb_copy_num=<0|1|2>. Suggestions for any better name is
  welcome.

  Side check, any idea what's the use case around mkfs.btrfs -b option
  other than for testing ?

Thanks, Anand
