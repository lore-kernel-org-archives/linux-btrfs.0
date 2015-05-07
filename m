Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f43.google.com ([209.85.213.43]:33399 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbbEGDrR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 May 2015 23:47:17 -0400
Received: by yhcb70 with SMTP id b70so7909950yhc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 20:47:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <554AD962.5040707@oracle.com>
References: <1430384845-9666-1-git-send-email-xuw2015@gmail.com>
	<1430384845-9666-2-git-send-email-xuw2015@gmail.com>
	<20150505153816.GJ5099@twin.jikos.cz>
	<5549DB94.3050704@oracle.com>
	<5549DD61.8050502@oracle.com>
	<CAPBX1xLhRXPyEMy_Dqkmsr_T-GmOUdt5Dt8yH4CMRm0UdpFkYw@mail.gmail.com>
	<554AD962.5040707@oracle.com>
Date: Thu, 7 May 2015 11:47:16 +0800
Message-ID: <CAPBX1x+LPefj=T3LJHUPCkBhF+eZpRUzxi9esM6LQpju+c9_tw@mail.gmail.com>
Subject: Re: [PATCH 2/3] btrfs: support to find missing device by path
From: George Wang <xuw2015@gmail.com>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 7, 2015 at 11:17 AM, Anand Jain <Anand.Jain@oracle.com> wrote:
>
>
>>>>    Critically we don't need this patch. right ?
>>>>    Anyway user of replace cli can use devid if device read fails.
>
>
>> Yes, I agree it.
>
>>>>    I think David is talking about:
>>>>      [PATCH] device delete by devid
>>>>
>>>>    it was critical for device delete. since there wasn't device
>>>>    delete by devid. I used device delete by devid instead of
>>>>    device path strcmp mainly because to maintain consistency
>>>>    between device replace and delete.
>>>>    the above patch set also provides code cleanups between
>>>>    device replace and delete codes.
>
>
>> We can delete the device by devid on behalf of "btrfs_find_device".
>
>  yes. patch-set (above) uses btrfs_find_device for device delete now.
>  replace was already using it.
>
>> In my opinion, the dev path is easier and humanized to use.
>
>  yes. good to have. in the long run. But not a regression/critical.
>  this will conflict with my patch, can you rebase on top of
>  above path which has some cleanups in this area as well.
>
>> This was OK before, but now I can not replace offline device
>> by path.
>> So I consider it as a regression.

Oh, sorry, my fault. NOT regression, It should always be the
srcdevid.
I confused with another stuff.

Thanks,

George
>
>  You mean to say you could replace the offline device using the
>  device path before (not devid) and now you can't ?
>
>  Then what patch introduced the regression ? Do you see any
>  older version replace working with offline device using the
>  device path ?
>
> Thanks, Anand
