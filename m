Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33576 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbbEGDUM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 May 2015 23:20:12 -0400
Message-ID: <554AD962.5040707@oracle.com>
Date: Thu, 07 May 2015 11:17:54 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: George Wang <xuw2015@gmail.com>
CC: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: support to find missing device by path
References: <1430384845-9666-1-git-send-email-xuw2015@gmail.com>	<1430384845-9666-2-git-send-email-xuw2015@gmail.com>	<20150505153816.GJ5099@twin.jikos.cz>	<5549DB94.3050704@oracle.com>	<5549DD61.8050502@oracle.com> <CAPBX1xLhRXPyEMy_Dqkmsr_T-GmOUdt5Dt8yH4CMRm0UdpFkYw@mail.gmail.com>
In-Reply-To: <CAPBX1xLhRXPyEMy_Dqkmsr_T-GmOUdt5Dt8yH4CMRm0UdpFkYw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>>>    Critically we don't need this patch. right ?
>>>    Anyway user of replace cli can use devid if device read fails.

 > Yes, I agree it.

>>>    I think David is talking about:
>>>      [PATCH] device delete by devid
>>>
>>>    it was critical for device delete. since there wasn't device
>>>    delete by devid. I used device delete by devid instead of
>>>    device path strcmp mainly because to maintain consistency
>>>    between device replace and delete.
>>>    the above patch set also provides code cleanups between
>>>    device replace and delete codes.

 > We can delete the device by devid on behalf of "btrfs_find_device".

  yes. patch-set (above) uses btrfs_find_device for device delete now.
  replace was already using it.

 > In my opinion, the dev path is easier and humanized to use.

  yes. good to have. in the long run. But not a regression/critical.
  this will conflict with my patch, can you rebase on top of
  above path which has some cleanups in this area as well.

 > This was OK before, but now I can not replace offline device
 > by path.
 > So I consider it as a regression.

  You mean to say you could replace the offline device using the
  device path before (not devid) and now you can't ?

  Then what patch introduced the regression ? Do you see any
  older version replace working with offline device using the
  device path ?

Thanks, Anand
