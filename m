Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50999 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbaFID0n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Jun 2014 23:26:43 -0400
Message-ID: <53952A02.30705@oracle.com>
Date: Mon, 09 Jun 2014 11:29:06 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
CC: dsterba@suse.cz, wangsl.fnst@cn.fujitsu.com, clm@fb.com, jbacik@fb.com
Subject: Re: [PATCH V3] Btrfs: device_list_add() should not update list when
 mounted
References: <1402025201-17140-1-git-send-email-anand.jain@oracle.com> <53951371.9010608@cn.fujitsu.com> <539519BC.7060109@oracle.com> <53951D70.6040303@cn.fujitsu.com>
In-Reply-To: <53951D70.6040303@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>>  As mentioned in the other thread.. we expect user to check the devices
>>  before / after mount and wipefs the disks which should not belong to
>>  the fsid.

  my bad. I just realized that unmount and wipefs may not be an
  viable choice in case of btrfs as root fs.

> For the case you mentioned, I think the behavior is OK,
> always use the device with *current* largest generation is a acceptable
> strategy, since the only things we can depend on the devices we
> *current* see...

  Yeah. let me do that approach as well to take care of picking
  the correct disk when FS is _unmounted_.

  And, when FS is mounted we should NOT kick out device paths
  invariably. which means we still need the patch.

    Btrfs: device_list_add() should not update list when mounted

Thanks, Anand


